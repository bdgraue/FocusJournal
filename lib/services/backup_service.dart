import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../models/import_strategy.dart';

/// Thrown when backup decryption fails due to wrong password or corrupted data.
class InvalidBackupPasswordException implements Exception {
  @override
  String toString() => 'Invalid password or corrupted backup file';
}

class BackupService {
  static const _algorithm = 'AES-256-GCM';
  static const _backupVersion = '1.1';
  static const _keySize = 32; // 256 bits
  static const _ivSize = 16; // 128 bits
  static const _saltSize = 32; // 256-bit salt
  static const _pbkdf2Iterations = 100000;
  final FlutterSecureStorage _secureStorage;
  final Uuid _uuid;

  BackupService({FlutterSecureStorage? secureStorage, Uuid? uuid})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
      _uuid = uuid ?? const Uuid();

  Future<String> _getDeviceId() async {
    const deviceIdKey = 'device_id';
    String? deviceId = await _secureStorage.read(key: deviceIdKey);
    if (deviceId == null || deviceId.isEmpty) {
      final newId = _uuid.v4();
      await _secureStorage.write(key: deviceIdKey, value: newId);
      deviceId = newId;
    }
    return deviceId;
  }

  Future<Map<String, dynamic>> _prepareMetadata() async {
    final deviceId = await _getDeviceId();
    return {
      'version': _backupVersion,
      'exportDate': DateTime.now().toUtc().toIso8601String(),
      'encryptionMethod': _algorithm,
      'keyDerivation': 'PBKDF2-HMAC-SHA256',
      'pbkdf2Iterations': _pbkdf2Iterations,
      'deviceId': deviceId,
      'exportId': _uuid.v4(),
    };
  }

  Uint8List _generateSalt() {
    final random = Random.secure();
    return Uint8List.fromList(
      List.generate(_saltSize, (_) => random.nextInt(256)),
    );
  }

  /// Derives a 256-bit key using PBKDF2-HMAC-SHA256.
  Key _deriveKey(String password, Uint8List salt) {
    final passwordBytes = utf8.encode(password);
    final hmac = Hmac(sha256, passwordBytes);

    // PBKDF2 single block (SHA-256 output = 32 bytes = our key size)
    final blockIndex = Uint8List(4)..[3] = 1;
    var u = Uint8List.fromList(
      hmac.convert([...salt, ...blockIndex]).bytes,
    );
    var result = Uint8List.fromList(u);

    for (var i = 1; i < _pbkdf2Iterations; i++) {
      u = Uint8List.fromList(hmac.convert(u).bytes);
      for (var j = 0; j < result.length; j++) {
        result[j] ^= u[j];
      }
    }

    return Key(result);
  }

  /// Legacy key derivation for v1.0 backup compatibility.
  Key _deriveKeyLegacy(String password) {
    final bytes = utf8.encode(password);
    final list = Uint8List(_keySize);
    for (var i = 0; i < _keySize; i++) {
      list[i] = i < bytes.length ? bytes[i] : 0;
    }
    return Key(list);
  }

  IV _generateIV() {
    return IV.fromSecureRandom(_ivSize);
  }

  Map<String, dynamic> _prepareEncryptedBackup(
    Map<String, dynamic> journalData,
    String password,
    Map<String, dynamic> metadata,
  ) {
    final salt = _generateSalt();
    final key = _deriveKey(password, salt);
    final iv = _generateIV();
    final encrypter = Encrypter(AES(key));

    final jsonData = json.encode(journalData);
    final encrypted = encrypter.encrypt(jsonData, iv: iv);

    return {
      'metadata': metadata,
      'data': {
        'content': encrypted.base64,
        'iv': iv.base64,
        'salt': base64.encode(salt),
      },
    };
  }

  Future<void> exportJournal(
    Map<String, dynamic> journalData,
    String password,
  ) async {
    final metadata = await _prepareMetadata();
    final exportData = _prepareEncryptedBackup(journalData, password, metadata);

    final tempDir = await Directory.systemTemp.createTemp('journal_backup');
    final file = File(
      '${tempDir.path}/journal_backup_${DateTime.now().toIso8601String()}.fjb',
    );
    await file.writeAsString(json.encode(exportData));

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'Journal Backup',
        text: 'FocusJournal Backup File',
      ),
    );

    // Clean up temp file
    await tempDir.delete(recursive: true);
  }

  Future<String?> saveJournalLocally(
    Map<String, dynamic> journalData,
    String password,
  ) async {
    final metadata = await _prepareMetadata();
    final exportData = _prepareEncryptedBackup(journalData, password, metadata);

    // Encode to JSON string and convert to bytes
    final jsonString = json.encode(exportData);
    final bytes = Uint8List.fromList(utf8.encode(jsonString));

    // Let user choose save location with bytes for mobile compatibility
    final fileName = 'journal_backup_${DateTime.now().toIso8601String()}.fjb';
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Backup',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['fjb'],
      bytes: bytes,
    );

    return result;
  }

  Future<Map<String, dynamic>> importJournal(
    String password,
    String filePath,
  ) async {
    final file = File(filePath);
    final content = await file.readAsString();
    final importData = json.decode(content) as Map<String, dynamic>;

    final metadata = importData['metadata'] as Map<String, dynamic>;
    final encryptedData = importData['data'] as Map<String, dynamic>;

    // Detect format: v1.1+ includes a salt for PBKDF2, v1.0 does not
    final saltBase64 = encryptedData['salt'] as String?;
    final iv = IV.fromBase64(encryptedData['iv'] as String);
    final encryptedContent = encryptedData['content'] as String;

    // Build ordered list of keys to try: primary method first, then fallback
    final keysToTry = <Key>[];
    if (saltBase64 != null) {
      final salt = Uint8List.fromList(base64.decode(saltBase64));
      keysToTry.add(_deriveKey(password, salt));
      keysToTry.add(_deriveKeyLegacy(password)); // fallback
    } else {
      keysToTry.add(_deriveKeyLegacy(password));
    }

    for (final key in keysToTry) {
      try {
        final encrypter = Encrypter(AES(key));
        final decrypted = encrypter.decrypt64(encryptedContent, iv: iv);
        return {'metadata': metadata, 'data': json.decode(decrypted)};
      } catch (_) {
        // Try next key derivation method
      }
    }

    throw InvalidBackupPasswordException();
  }

  Map<String, dynamic> mergeJournals(
    Map<String, dynamic> currentData,
    Map<String, dynamic> importedData,
    ImportStrategy strategy,
  ) {
    switch (strategy) {
      case ImportStrategy.completeOverwrite:
        return importedData;

      case ImportStrategy.addNewOnly:
        return _mergeAddNewOnly(currentData, importedData);

      case ImportStrategy.smartMerge:
        return _mergeSmartStrategy(currentData, importedData);
    }
  }

  Map<String, dynamic> _mergeAddNewOnly(
    Map<String, dynamic> current,
    Map<String, dynamic> imported,
  ) {
    final currentEntries =
        (current['entries'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final importedEntries =
        (imported['entries'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final currentIds = currentEntries.map((e) => e['id'] as String).toSet();

    final newEntries = [
      ...currentEntries,
      ...importedEntries.where((entry) => !currentIds.contains(entry['id'])),
    ];

    return {...current, 'entries': newEntries};
  }

  Map<String, dynamic> _mergeSmartStrategy(
    Map<String, dynamic> current,
    Map<String, dynamic> imported,
  ) {
    final currentEntries =
        (current['entries'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final importedEntries =
        (imported['entries'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    final entriesById = <String, Map<String, dynamic>>{};

    // First, add all current entries
    for (final entry in currentEntries) {
      entriesById[entry['id'] as String] = entry;
    }

    // Then, merge imported entries based on last modified timestamp
    for (final entry in importedEntries) {
      final id = entry['id'] as String;
      final currentEntry = entriesById[id];

      if (currentEntry == null) {
        // New entry, add it
        entriesById[id] = entry;
      } else {
        // Compare timestamps and keep the most recent version
        final currentTimestamp = DateTime.parse(
          currentEntry['lastModified'] as String,
        );
        final importedTimestamp = DateTime.parse(
          entry['lastModified'] as String,
        );

        if (importedTimestamp.isAfter(currentTimestamp)) {
          entriesById[id] = entry;
        }
      }
    }

    return {...current, 'entries': entriesById.values.toList()};
  }

  // Validate the inner decrypted journal data map structure
  // Expected keys: 'entries' as List<Map<String, dynamic>> with keys
  //   id:String, content:String, createdAt:String(ISO), lastModified:String(ISO)
  void validateJournalData(Map<String, dynamic> data) {
    if (!data.containsKey('entries')) {
      throw Exception("Invalid backup format: missing 'entries' key");
    }
    final entries = data['entries'];
    if (entries is! List) {
      throw Exception("Invalid backup format: 'entries' is not a list");
    }
    for (final e in entries) {
      if (e is! Map) {
        throw Exception('Invalid backup format: entry is not an object');
      }
      for (final key in ['id', 'content', 'createdAt', 'lastModified']) {
        if (!e.containsKey(key)) {
          throw Exception("Invalid backup format: entry missing '$key'");
        }
      }
      if (e['id'] is! String || e['content'] is! String ||
          e['createdAt'] is! String || e['lastModified'] is! String) {
        throw Exception('Invalid backup format: wrong entry field types');
      }
      // Check date parseability
      try {
        DateTime.parse(e['createdAt'] as String);
        DateTime.parse(e['lastModified'] as String);
      } catch (_) {
        throw Exception('Invalid backup format: invalid date strings');
      }
    }
  }
}
