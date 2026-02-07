// Unit tests for BackupService - critical security component
//
// Tests data validation and merge strategies through public API

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
              'date': '2024-01-01',
              'created_at': DateTime.now().toIso8601String(),
              'responses': [
                {
                  'question': 'Test question',
                  'answer': 'Test answer',
                }
              ],
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

      test('rejects entries missing required fields', () {
        final invalidData = {
          'entries': [
            {'id': '1'}  // missing required fields
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
            {'id': '1', 'date': '2024-01-01', 'data': 'current'}
          ],
        };
        final imported = {
          'entries': [
            {'id': '2', 'date': '2024-01-02', 'data': 'imported'}
          ],
        };

        final merged = backupService.mergeJournals(
          current,
          imported,
          ImportStrategy.completeOverwrite,
        );

        expect(merged['entries'].length, equals(1));
        expect(merged['entries'][0]['id'], equals('2'));
      });

      test('addNewOnly preserves existing entries', () {
        final current = {
          'entries': [
            {'id': '1', 'date': '2024-01-01', 'data': 'current'}
          ],
        };
        final imported = {
          'entries': [
            {'id': '1', 'date': '2024-01-01', 'data': 'imported'},
            {'id': '2', 'date': '2024-01-02', 'data': 'new'}
          ],
        };

        final merged = backupService.mergeJournals(
          current,
          imported,
          ImportStrategy.addNewOnly,
        );

        expect(merged['entries'].length, equals(2));

        // Should keep current version of 2024-01-01
        final entry1 = (merged['entries'] as List)
            .firstWhere((e) => e['date'] == '2024-01-01');
        expect(entry1['data'], equals('current'));

        // Should add new entry for 2024-01-02
        final entry2 = (merged['entries'] as List)
            .firstWhere((e) => e['date'] == '2024-01-02');
        expect(entry2['data'], equals('new'));
      });

      test('smartMerge keeps most recent version by created_at', () {
        final older = DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
        final newer = DateTime.now().toIso8601String();

        final current = {
          'entries': [
            {'id': '1', 'date': '2024-01-01', 'created_at': older, 'data': 'older'}
          ],
        };
        final imported = {
          'entries': [
            {'id': '1', 'date': '2024-01-01', 'created_at': newer, 'data': 'newer'}
          ],
        };

        final merged = backupService.mergeJournals(
          current,
          imported,
          ImportStrategy.smartMerge,
        );

        expect(merged['entries'].length, equals(1));
        expect(merged['entries'][0]['data'], equals('newer'));
      });

      test('smartMerge adds new entries and updates existing', () {
        final current = {
          'entries': [
            {
              'id': '1',
              'date': '2024-01-01',
              'created_at': '2024-01-01T10:00:00Z',
              'data': 'current1'
            },
          ],
        };
        final imported = {
          'entries': [
            {
              'id': '1',
              'date': '2024-01-01',
              'created_at': '2024-01-01T12:00:00Z',
              'data': 'imported1'
            },
            {
              'id': '2',
              'date': '2024-01-02',
              'created_at': '2024-01-02T10:00:00Z',
              'data': 'imported2'
            },
          ],
        };

        final merged = backupService.mergeJournals(
          current,
          imported,
          ImportStrategy.smartMerge,
        );

        expect(merged['entries'].length, equals(2));

        // Should have newer version of first entry
        final entry1 = (merged['entries'] as List)
            .firstWhere((e) => e['date'] == '2024-01-01');
        expect(entry1['data'], equals('imported1'));

        // Should have new entry
        final entry2 = (merged['entries'] as List)
            .firstWhere((e) => e['date'] == '2024-01-02');
        expect(entry2['data'], equals('imported2'));
      });
    });

    group('Security Properties', () {
      test('InvalidBackupPasswordException is defined', () {
        expect(InvalidBackupPasswordException, isNotNull);
        expect(
          InvalidBackupPasswordException().toString(),
          contains('Invalid password or corrupted backup file'),
        );
      });
    });
  });
}
