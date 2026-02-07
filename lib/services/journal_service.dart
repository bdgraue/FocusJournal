import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class JournalEntry {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime lastModified;

  JournalEntry({
    String? id,
    required this.content,
    DateTime? createdAt,
    DateTime? lastModified,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       lastModified = lastModified ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
    );
  }

  JournalEntry copyWith({String? content}) {
    return JournalEntry(
      id: id,
      content: content ?? this.content,
      createdAt: createdAt,
      lastModified: DateTime.now(),
    );
  }
}

class JournalService {
  static const String _storageKey = 'journal_entries';
  static const String _dekKey = 'journal_dek';
  static const int _keySize = 32; // 256 bits
  static const int _ivSize = 16; // 128 bits
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;

  JournalService._({
    required SharedPreferences prefs,
    FlutterSecureStorage? secureStorage,
  })  : _prefs = prefs,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static Future<JournalService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return JournalService._(prefs: prefs);
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
    final iv = enc.IV.fromSecureRandom(_ivSize);
    final encrypter = enc.Encrypter(enc.AES(key));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  Future<String> _decrypt(String ciphertext) async {
    final dek = await _getOrCreateDEK();
    final key = enc.Key(dek);
    final parts = ciphertext.split(':');
    if (parts.length != 2) throw Exception('Invalid encrypted format');
    final iv = enc.IV.fromBase64(parts[0]);
    final encrypter = enc.Encrypter(enc.AES(key));
    return encrypter.decrypt64(parts[1], iv: iv);
  }

  /// Detects if stored data is plaintext JSON (starts with '[') and needs migration.
  bool _isPlaintext(String data) {
    final trimmed = data.trimLeft();
    return trimmed.startsWith('[') || trimmed.startsWith('{');
  }

  Future<List<JournalEntry>> getAllEntries() async {
    final storedData = _prefs.getString(_storageKey);
    if (storedData == null) return [];

    try {
      String jsonString;
      if (_isPlaintext(storedData)) {
        // Legacy plaintext format - decrypt not needed, but migrate
        jsonString = storedData;
        // Migrate to encrypted format in background
        final entries = _parseEntries(jsonString);
        await _saveEncrypted(entries);
        return entries;
      } else {
        // Encrypted format
        jsonString = await _decrypt(storedData);
      }
      return _parseEntries(jsonString);
    } catch (e) {
      debugPrint('Error loading journal entries: $e');
      return [];
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
}
