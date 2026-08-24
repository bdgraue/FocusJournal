import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Thrown when stored entries exist but cannot be decrypted or parsed.
///
/// Deliberately distinct from "there is nothing stored yet": an empty journal
/// and an unreadable one look the same to the user but mean opposite things.
/// Callers must surface this instead of showing an empty list — otherwise the
/// next write would persist that empty list over data that is still there.
class JournalDecryptionException implements Exception {
  final Object cause;

  JournalDecryptionException(this.cause);

  @override
  String toString() =>
      'Stored journal entries could not be decrypted or parsed: $cause';
}

/// Represents a single journal entry with content and timestamps.
///
/// Each entry has a unique ID (UUID), creation timestamp, and last modified
/// timestamp. Entries are immutable after creation (use copyWith for updates).
///
/// The `isEditableToday` property restricts editing to entries created today,
/// preserving historical journal integrity.
class JournalEntry {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime lastModified;
  final bool isHighlighted;

  JournalEntry({
    String? id,
    required this.content,
    DateTime? createdAt,
    DateTime? lastModified,
    this.isHighlighted = false,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'isHighlighted': isHighlighted,
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      isHighlighted: json['isHighlighted'] as bool? ?? false,
    );
  }

  bool get isEditableToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  JournalEntry copyWith({String? content, bool? isHighlighted}) {
    return JournalEntry(
      id: id,
      content: content ?? this.content,
      createdAt: createdAt,
      lastModified: DateTime.now(),
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }
}

/// Manages journal entry storage with AES-256-GCM encryption.
///
/// Provides CRUD operations for journal entries with automatic encryption/decryption.
/// Uses a Data Encryption Key (DEK) stored in flutter_secure_storage, with entry
/// data encrypted and stored in SharedPreferences.
///
/// Security features:
/// - AES-256-GCM (authenticated) encryption for all entry content
/// - Fresh random 96-bit nonce per write, stored alongside the ciphertext
/// - DEK generated once with `Random.secure()` and stored securely
/// - Tampered or truncated ciphertext is rejected by the GCM tag rather than
///   decrypting to garbage
///
/// Storage format: `v2:<base64 nonce>:<base64 ciphertext+tag>`. Records written
/// before authenticated encryption was introduced carry no prefix and are
/// AES-256-CTR; [_decrypt] still reads them, and the next write lifts the whole
/// store to v2.
class JournalService {
  static const String _storageKey = 'journal_entries';
  static const String _dekKey = 'journal_dek';
  static const int _keySize = 32; // 256 bits

  /// 96-bit nonce — the size GCM is specified for (NIST SP 800-38D). Other
  /// lengths work but take the slower GHASH derivation path.
  static const int _nonceSize = 12;

  /// Marks a record as AES-256-GCM. Records without it predate authenticated
  /// encryption and are AES-256-CTR.
  static const String _formatPrefix = 'v2';
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  JournalService._({
    required SharedPreferences prefs,
    FlutterSecureStorage? secureStorage,
  })  : _prefs = prefs,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// [secureStorage] exists so tests can supply a fake; production callers pass
  /// nothing and get the real platform-backed store.
  static Future<JournalService> create({
    FlutterSecureStorage? secureStorage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return JournalService._(prefs: prefs, secureStorage: secureStorage);
  }

  // --- Encryption helpers ---

  Future<Uint8List> _getOrCreateDEK() async {
    final existing = await _secureStorage.read(key: _dekKey);
    if (existing != null) {
      return Uint8List.fromList(base64.decode(existing));
    }
    final random = Random.secure();
    final dek = Uint8List.fromList(
      List.generate(_keySize, (_) => random.nextInt(256)),
    );
    await _secureStorage.write(key: _dekKey, value: base64.encode(dek));
    return dek;
  }

  Future<String> _encrypt(String plaintext) async {
    final dek = await _getOrCreateDEK();
    final key = enc.Key(dek);
    final nonce = enc.IV.fromSecureRandom(_nonceSize);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
    final encrypted = encrypter.encrypt(plaintext, iv: nonce);
    return '$_formatPrefix:${nonce.base64}:${encrypted.base64}';
  }

  Future<String> _decrypt(String stored) async {
    final dek = await _getOrCreateDEK();
    final key = enc.Key(dek);
    final parts = stored.split(':');

    // v2 carries the prefix and is authenticated; a wrong key or a tampered
    // record fails on the GCM tag instead of yielding plausible garbage.
    if (parts.length == 3 && parts[0] == _formatPrefix) {
      final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.gcm));
      return encrypter.decrypt64(parts[2], iv: enc.IV.fromBase64(parts[1]));
    }

    // Legacy: written before authenticated encryption, AES-256-CTR. Kept so
    // existing installs keep their entries; the next save rewrites them as v2.
    if (parts.length == 2) {
      final encrypter = enc.Encrypter(enc.AES(key));
      return encrypter.decrypt64(parts[1], iv: enc.IV.fromBase64(parts[0]));
    }

    throw const FormatException('Unrecognised encrypted record layout');
  }

  /// Detects if stored data is plaintext JSON (starts with '[') and needs migration.
  bool _isPlaintext(String data) {
    final trimmed = data.trimLeft();
    return trimmed.startsWith('[') || trimmed.startsWith('{');
  }

  /// Loads all entries.
  ///
  /// Returns an empty list only when nothing has ever been written. If stored
  /// data exists but cannot be read, this throws [JournalDecryptionException]
  /// rather than returning `[]` — the two are indistinguishable to the caller
  /// but mean opposite things, and returning `[]` here would let the next write
  /// persist an empty list over entries that are still on disk.
  Future<List<JournalEntry>> getAllEntries() async {
    final storedData = _prefs.getString(_storageKey);
    if (storedData == null) return [];

    try {
      if (_isPlaintext(storedData)) {
        // Written before any encryption existed. Read as-is, then migrate.
        final entries = _parseEntries(storedData);
        await _saveEncrypted(entries);
        return entries;
      }
      return _parseEntries(await _decrypt(storedData));
    } catch (e) {
      debugPrint('Error loading journal entries: $e');
      throw JournalDecryptionException(e);
    }
  }

  List<JournalEntry> _parseEntries(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((j) => JournalEntry.fromJson(j)).toList()
      ..sort((a, b) => b.lastModified.compareTo(a.lastModified));
  }

  Future<void> _saveEncrypted(List<JournalEntry> entries) async {
    final jsonList = entries.map((entry) => entry.toJson()).toList();
    final plaintext = json.encode(jsonList);
    final encrypted = await _encrypt(plaintext);
    await _prefs.setString(_storageKey, encrypted);
  }

  Future<void> saveEntries(List<JournalEntry> entries) async {
    await _saveEncrypted(entries);
  }

  Future<void> addEntry(JournalEntry entry) async {
    final entries = await getAllEntries();
    entries.add(entry);
    await saveEntries(entries);
  }

  Future<void> updateEntry(JournalEntry updatedEntry) async {
    final entries = await getAllEntries();
    final index = entries.indexWhere((e) => e.id == updatedEntry.id);
    if (index != -1) {
      entries[index] = updatedEntry;
      await saveEntries(entries);
    }
  }

  Future<void> deleteEntry(String id) async {
    final entries = await getAllEntries();
    entries.removeWhere((e) => e.id == id);
    await saveEntries(entries);
  }

  Future<List<JournalEntry>> searchEntries(String query) async {
    if (query.trim().isEmpty) return [];
    final entries = await getAllEntries();
    final lowerQuery = query.toLowerCase();
    return entries
        .where((e) => e.content.toLowerCase().contains(lowerQuery))
        .toList();
  }

  Future<Map<DateTime, List<JournalEntry>>> getEntriesGroupedByDay() async {
    final entries = await getAllEntries();
    final Map<DateTime, List<JournalEntry>> grouped = {};
    for (final entry in entries) {
      final day = DateTime(
        entry.createdAt.year,
        entry.createdAt.month,
        entry.createdAt.day,
      );
      grouped.putIfAbsent(day, () => []).add(entry);
    }
    return grouped;
  }

  Future<Map<String, dynamic>> exportData() async {
    final entries = await getAllEntries();
    return {
      'entries': entries.map((e) => e.toJson()).toList(),
      'metadata': {
        'version': '1.0',
        'exportDate': DateTime.now().toIso8601String(),
        'entryCount': entries.length,
      },
    };
  }

  Future<void> importData(Map<String, dynamic> data) async {
    try {
      final entriesList = (data['entries'] as List<dynamic>)
          .map((json) => JournalEntry.fromJson(json as Map<String, dynamic>))
          .toList();
      await saveEntries(entriesList);
    } catch (e) {
      throw Exception('Invalid journal data format: $e');
    }
  }

  Future<void> toggleHighlight(String id) async {
    final entries = await getAllEntries();
    final index = entries.indexWhere((e) => e.id == id);
    if (index != -1) {
      entries[index] = entries[index].copyWith(
        isHighlighted: !entries[index].isHighlighted,
      );
      await saveEntries(entries);
    }
  }

  Future<List<JournalEntry>> getHighlightedEntries() async {
    final entries = await getAllEntries();
    return entries.where((e) => e.isHighlighted).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Returns the total count of journal entries
  Future<int> getEntryCount() async {
    final entries = await getAllEntries();
    return entries.length;
  }

  /// Deletes ALL journal entries permanently. Cannot be undone.
  ///
  /// This is a destructive operation used for clearing app data.
  /// Use with caution and always show confirmation to the user.
  Future<void> clearAllEntries() async {
    await saveEntries([]);
  }
}
