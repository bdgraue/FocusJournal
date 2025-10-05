import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:share_plus/share_plus.dart';
import '../models/import_strategy.dart';

class BackupService {
  static const _algorithm = 'AES-256-GCM';
  static const _keySize = 32; // 256 bits
  static const _ivSize = 16; // 128 bits
  final FlutterSecureStorage _secureStorage;
  final Uuid _uuid;

  BackupService({
    FlutterSecureStorage? secureStorage,
    Uuid? uuid,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
       _uuid = uuid ?? const Uuid();

  Future<String> _getDeviceId() async {
    const deviceIdKey = 'device_id';
    String? deviceId = await _secureStorage.read(key: deviceIdKey);
    
    if (deviceId == null) {
      deviceId = _uuid.v4();
      await _secureStorage.write(key: deviceIdKey, value: deviceId);
    }
    
    return deviceId;
  }

  Future<Map<String, dynamic>> _prepareMetadata() async {
    final deviceId = await _getDeviceId();
    return {
      'version': '1.0',
      'exportDate': DateTime.now().toUtc().toIso8601String(),
      'encryptionMethod': _algorithm,
      'deviceId': deviceId,
      'exportId': _uuid.v4(),
    };
  }

  Key _deriveKey(String password) {
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

  Future<void> exportJournal(Map<String, dynamic> journalData, String password) async {
    try {
      final metadata = await _prepareMetadata();
      final key = _deriveKey(password);
      final iv = _generateIV();
      final encrypter = Encrypter(AES(key));

      final jsonData = json.encode(journalData);
      final encrypted = encrypter.encrypt(jsonData, iv: iv);

      final exportData = {
        'metadata': metadata,
        'data': {
          'content': encrypted.base64,
          'iv': iv.base64,
        },
      };

      final tempDir = await Directory.systemTemp.createTemp('journal_backup');
      final file = File('${tempDir.path}/journal_backup_${DateTime.now().toIso8601String()}.fjb');
      await file.writeAsString(json.encode(exportData));

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Journal Backup',
        text: 'FocusJournal Backup File',
      );

      // Clean up temp file
      await tempDir.delete(recursive: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> importJournal(String password, String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final importData = json.decode(content) as Map<String, dynamic>;

      final metadata = importData['metadata'] as Map<String, dynamic>;
      final encryptedData = importData['data'] as Map<String, dynamic>;

      final key = _deriveKey(password);
      final iv = IV.fromBase64(encryptedData['iv'] as String);
      final encrypter = Encrypter(AES(key));

      try {
        final decrypted = encrypter.decrypt64(
          encryptedData['content'] as String,
          iv: iv,
        );

        return {
          'metadata': metadata,
          'data': json.decode(decrypted),
        };
      } catch (e) {
        throw Exception('Invalid password or corrupted backup file');
      }
    } catch (e) {
      rethrow;
    }
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
    final currentEntries = (current['entries'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final importedEntries = (imported['entries'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final currentIds = currentEntries.map((e) => e['id'] as String).toSet();

    final newEntries = [
      ...currentEntries,
      ...importedEntries.where((entry) => !currentIds.contains(entry['id'])),
    ];

    return {
      ...current,
      'entries': newEntries,
    };
  }

  Map<String, dynamic> _mergeSmartStrategy(
    Map<String, dynamic> current,
    Map<String, dynamic> imported,
  ) {
    final currentEntries = (current['entries'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final importedEntries = (imported['entries'] as List?)?.cast<Map<String, dynamic>>() ?? [];

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
        final currentTimestamp = DateTime.parse(currentEntry['lastModified'] as String);
        final importedTimestamp = DateTime.parse(entry['lastModified'] as String);

        if (importedTimestamp.isAfter(currentTimestamp)) {
          entriesById[id] = entry;
        }
      }
    }

    return {
      ...current,
      'entries': entriesById.values.toList(),
    };
  }
}