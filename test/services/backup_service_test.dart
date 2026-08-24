// Unit tests for BackupService - critical security component
//
// Tests data validation and merge strategies through public API
// Expected format: entries[{id, content, createdAt, lastModified}]

import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_journal/services/backup_service.dart';
import 'package:focus_journal/models/import_strategy.dart';

/// Rebuilds a backup exactly the way the app wrote them before authenticated
/// encryption: PBKDF2 for the key, but AES in the library's default mode
/// (`AESMode.sic`, i.e. CTR) and metadata that claims GCM although it is not.
///
/// This is the fixture the compatibility test rests on — it must mirror the old
/// code rather than call today's, otherwise it would prove nothing.
Map<String, dynamic> buildLegacyCtrBackup(
  Map<String, dynamic> journalData,
  String password,
) {
  final salt = Uint8List.fromList(List<int>.generate(32, (i) => i));
  final passwordBytes = utf8.encode(password);
  final hmac = Hmac(sha256, passwordBytes);
  final blockIndex = Uint8List(4)..[3] = 1;
  var u = Uint8List.fromList(hmac.convert([...salt, ...blockIndex]).bytes);
  var derived = Uint8List.fromList(u);
  for (var i = 1; i < 100000; i++) {
    u = Uint8List.fromList(hmac.convert(u).bytes);
    for (var j = 0; j < derived.length; j++) {
      derived[j] ^= u[j];
    }
  }

  final iv = IV.fromLength(16);
  final encrypter = Encrypter(AES(Key(derived))); // default mode: CTR
  final encrypted = encrypter.encrypt(json.encode(journalData), iv: iv);

  return {
    'metadata': {
      'version': '1.1',
      'encryptionMethod': 'AES-256-GCM', // the old, untrue claim
      'keyDerivation': 'PBKDF2-HMAC-SHA256',
      'pbkdf2Iterations': 100000,
    },
    'data': {
      'content': encrypted.base64,
      'iv': iv.base64,
      'salt': base64.encode(salt),
    },
  };
}

void main() {
  group('BackupService', () {
    late BackupService backupService;

    setUp(() {
      backupService = BackupService();
    });

    group('Data Validation', () {
      test('validates correct journal data structure', () {
        final validData = {
          'version': 1,
          'exported_at': DateTime.now().toIso8601String(),
          'entries': [
            {
              'id': '1',
              'content': 'Test content',
              'createdAt': DateTime.now().toIso8601String(),
              'lastModified': DateTime.now().toIso8601String(),
            }
          ],
        };

        expect(() => backupService.validateJournalData(validData), returnsNormally);
      });

      test('rejects data without entries key', () {
        final invalidData = {'version': 1};

        expect(
          () => backupService.validateJournalData(invalidData),
          throwsException,
        );
      });

      test('rejects data with non-list entries', () {
        final invalidData = {'entries': 'not a list'};

        expect(
          () => backupService.validateJournalData(invalidData),
          throwsException,
        );
      });

      test('rejects entries missing id field', () {
        final invalidData = {
          'entries': [
            {
              'content': 'test',
              'createdAt': DateTime.now().toIso8601String(),
              'lastModified': DateTime.now().toIso8601String(),
            }
          ],
        };

        expect(
          () => backupService.validateJournalData(invalidData),
          throwsException,
        );
      });

      test('rejects entries missing content field', () {
        final invalidData = {
          'entries': [
            {
              'id': '1',
              'createdAt': DateTime.now().toIso8601String(),
              'lastModified': DateTime.now().toIso8601String(),
            }
          ],
        };

        expect(
          () => backupService.validateJournalData(invalidData),
          throwsException,
        );
      });

      test('rejects entries with invalid timestamp format', () {
        final invalidData = {
          'entries': [
            {
              'id': '1',
              'content': 'test',
              'createdAt': 'invalid-date',
              'lastModified': DateTime.now().toIso8601String(),
            }
          ],
        };

        expect(
          () => backupService.validateJournalData(invalidData),
          throwsException,
        );
      });
    });

    group('Merge Strategies', () {
      test('complete overwrite replaces all data', () {
        final current = {
          'entries': [
            {
              'id': '1',
              'content': 'current content',
              'createdAt': '2024-01-01T10:00:00Z',
              'lastModified': '2024-01-01T10:00:00Z',
            }
          ],
        };
        final imported = {
          'entries': [
            {
              'id': '2',
              'content': 'imported content',
              'createdAt': '2024-01-02T10:00:00Z',
              'lastModified': '2024-01-02T10:00:00Z',
            }
          ],
        };

        final merged = backupService.mergeJournals(
          current,
          imported,
          ImportStrategy.completeOverwrite,
        );

        expect(merged['entries'].length, equals(1));
        expect(merged['entries'][0]['id'], equals('2'));
        expect(merged['entries'][0]['content'], equals('imported content'));
      });

      test('addNewOnly preserves existing entries by ID', () {
        final current = {
          'entries': [
            {
              'id': '1',
              'content': 'current content',
              'createdAt': '2024-01-01T10:00:00Z',
              'lastModified': '2024-01-01T10:00:00Z',
            }
          ],
        };
        final imported = {
          'entries': [
            {
              'id': '1',
              'content': 'imported content',
              'createdAt': '2024-01-01T12:00:00Z',
              'lastModified': '2024-01-01T12:00:00Z',
            },
            {
              'id': '2',
              'content': 'new content',
              'createdAt': '2024-01-02T10:00:00Z',
              'lastModified': '2024-01-02T10:00:00Z',
            }
          ],
        };

        final merged = backupService.mergeJournals(
          current,
          imported,
          ImportStrategy.addNewOnly,
        );

        expect(merged['entries'].length, equals(2));

        // Should keep current version of ID 1
        final entry1 = (merged['entries'] as List)
            .firstWhere((e) => e['id'] == '1');
        expect(entry1['content'], equals('current content'));

        // Should add new entry ID 2
        final entry2 = (merged['entries'] as List)
            .firstWhere((e) => e['id'] == '2');
        expect(entry2['content'], equals('new content'));
      });

      test('smartMerge keeps most recent version by lastModified', () {
        final current = {
          'entries': [
            {
              'id': '1',
              'content': 'older content',
              'createdAt': '2024-01-01T10:00:00Z',
              'lastModified': '2024-01-01T10:00:00Z',
            }
          ],
        };
        final imported = {
          'entries': [
            {
              'id': '1',
              'content': 'newer content',
              'createdAt': '2024-01-01T10:00:00Z',
              'lastModified': '2024-01-01T12:00:00Z',
            }
          ],
        };

        final merged = backupService.mergeJournals(
          current,
          imported,
          ImportStrategy.smartMerge,
        );

        expect(merged['entries'].length, equals(1));
        expect(merged['entries'][0]['content'], equals('newer content'));
      });

      test('smartMerge adds new entries and updates existing', () {
        final current = {
          'entries': [
            {
              'id': '1',
              'content': 'current1',
              'createdAt': '2024-01-01T10:00:00Z',
              'lastModified': '2024-01-01T10:00:00Z',
            },
          ],
        };
        final imported = {
          'entries': [
            {
              'id': '1',
              'content': 'imported1',
              'createdAt': '2024-01-01T10:00:00Z',
              'lastModified': '2024-01-01T12:00:00Z',
            },
            {
              'id': '2',
              'content': 'imported2',
              'createdAt': '2024-01-02T10:00:00Z',
              'lastModified': '2024-01-02T10:00:00Z',
            },
          ],
        };

        final merged = backupService.mergeJournals(
          current,
          imported,
          ImportStrategy.smartMerge,
        );

        expect(merged['entries'].length, equals(2));

        // Should have newer version of entry 1
        final entry1 = (merged['entries'] as List)
            .firstWhere((e) => e['id'] == '1');
        expect(entry1['content'], equals('imported1'));

        // Should have new entry 2
        final entry2 = (merged['entries'] as List)
            .firstWhere((e) => e['id'] == '2');
        expect(entry2['content'], equals('imported2'));
      });

      test('smartMerge keeps current when lastModified is older in import', () {
        final current = {
          'entries': [
            {
              'id': '1',
              'content': 'newer content',
              'createdAt': '2024-01-01T10:00:00Z',
              'lastModified': '2024-01-01T12:00:00Z',
            }
          ],
        };
        final imported = {
          'entries': [
            {
              'id': '1',
              'content': 'older content',
              'createdAt': '2024-01-01T10:00:00Z',
              'lastModified': '2024-01-01T10:00:00Z',
            }
          ],
        };

        final merged = backupService.mergeJournals(
          current,
          imported,
          ImportStrategy.smartMerge,
        );

        expect(merged['entries'].length, equals(1));
        expect(merged['entries'][0]['content'], equals('newer content'));
      });
    });

    group('Encryption Round Trip', () {
      final journalData = {
        'entries': [
          {
            'id': 'entry-1',
            'content': 'Der Morgen war zäh. Danach war der Kopf leicht.',
            'createdAt': '2026-08-20T20:40:00.000',
            'lastModified': '2026-08-20T20:40:00.000',
          },
        ],
      };
      const password = 'correct horse battery staple';

      test('encrypts and decrypts back to the same data', () {
        final encrypted =
            backupService.encryptBackup(journalData, password, {'version': '2.0'});
        final decrypted = backupService.decryptBackup(encrypted, password);

        expect(decrypted['data'], equals(journalData));
      });

      test('does not leave the content readable in the document', () {
        final encrypted =
            backupService.encryptBackup(journalData, password, {'version': '2.0'});

        expect(json.encode(encrypted), isNot(contains('Der Morgen war zäh')));
      });

      test('rejects a wrong password', () {
        final encrypted =
            backupService.encryptBackup(journalData, password, {'version': '2.0'});

        expect(
          () => backupService.decryptBackup(encrypted, 'wrong password'),
          throwsA(isA<InvalidBackupPasswordException>()),
        );
      });

      test('rejects a tampered ciphertext', () {
        // The guarantee authenticated encryption buys us: before this change a
        // flipped bit decrypted to silently altered plaintext.
        final encrypted =
            backupService.encryptBackup(journalData, password, {'version': '2.0'});
        final content = encrypted['data']['content'] as String;
        final bytes = base64.decode(content);
        bytes[bytes.length ~/ 2] ^= 0x01;
        encrypted['data']['content'] = base64.encode(bytes);

        expect(
          () => backupService.decryptBackup(encrypted, password),
          throwsA(isA<InvalidBackupPasswordException>()),
        );
      });

      test('still reads a backup written in the legacy CTR format', () {
        final legacy = buildLegacyCtrBackup(journalData, password);
        final decrypted = backupService.decryptBackup(legacy, password);

        expect(decrypted['data'], equals(journalData));
      });

      test('rejects a wrong password on a legacy CTR backup as well', () {
        final legacy = buildLegacyCtrBackup(journalData, password);

        expect(
          () => backupService.decryptBackup(legacy, 'wrong password'),
          throwsA(isA<InvalidBackupPasswordException>()),
        );
      });
    });

    group('Security Properties', () {
      test('InvalidBackupPasswordException is defined and has correct message', () {
        expect(InvalidBackupPasswordException, isNotNull);

        final exception = InvalidBackupPasswordException();
        expect(
          exception.toString(),
          equals('Invalid password or corrupted backup file'),
        );
      });

      test('InvalidBackupPasswordException can be thrown and caught', () {
        expect(
          () => throw InvalidBackupPasswordException(),
          throwsA(isA<InvalidBackupPasswordException>()),
        );
      });
    });
  });
}
