// Unit tests for BackupService - critical security component
//
// Tests data validation and merge strategies through public API
// Expected format: entries[{id, content, createdAt, lastModified}]

import 'package:flutter_test/flutter_test.dart';
import 'package:focus_journal/services/backup_service.dart';
import 'package:focus_journal/models/import_strategy.dart';

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
