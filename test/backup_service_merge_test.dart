import 'package:flutter_test/flutter_test.dart';
import 'package:focus_journal/services/backup_service.dart';

void main() {
  group('BackupService - Merge Strategies', () {
    test('completeOverwrite strategy should replace all data', () {
      final backupService = BackupService();
      
      final currentData = {
        'entries': [
          {
            'id': '1',
            'content': 'old entry 1',
            'lastModified': '2025-10-04T10:00:00Z',
          },
        ],
      };

      final importedData = {
        'entries': [
          {
            'id': '2',
            'content': 'new entry 1',
            'lastModified': '2025-10-05T10:00:00Z',
          },
        ],
      };

      final result = backupService.mergeJournals(
        currentData,
        importedData,
        ImportStrategy.completeOverwrite,
      );

      expect(result, equals(importedData));
    });

    test('addNewOnly strategy should only add new entries', () {
      final backupService = BackupService();
      
      final currentData = {
        'entries': [
          {
            'id': '1',
            'content': 'entry 1',
            'lastModified': '2025-10-04T10:00:00Z',
          },
        ],
      };

      final importedData = {
        'entries': [
          {
            'id': '1',
            'content': 'modified entry 1',
            'lastModified': '2025-10-05T10:00:00Z',
          },
          {
            'id': '2',
            'content': 'entry 2',
            'lastModified': '2025-10-05T10:00:00Z',
          },
        ],
      };

      final result = backupService.mergeJournals(
        currentData,
        importedData,
        ImportStrategy.addNewOnly,
      );

      expect((result['entries'] as List).length, equals(2));
      expect(
        (result['entries'] as List).any((e) => e['id'] == '1' && e['content'] == 'entry 1'),
        isTrue,
        reason: 'Should keep original version of existing entry',
      );
      expect(
        (result['entries'] as List).any((e) => e['id'] == '2'),
        isTrue,
        reason: 'Should add new entry',
      );
    });

    test('smartMerge strategy should keep newest versions', () {
      final backupService = BackupService();
      
      final currentData = {
        'entries': [
          {
            'id': '1',
            'content': 'old entry 1',
            'lastModified': '2025-10-04T10:00:00Z',
          },
          {
            'id': '2',
            'content': 'newer entry 2',
            'lastModified': '2025-10-05T10:00:00Z',
          },
        ],
      };

      final importedData = {
        'entries': [
          {
            'id': '1',
            'content': 'newer entry 1',
            'lastModified': '2025-10-05T11:00:00Z',
          },
          {
            'id': '2',
            'content': 'older entry 2',
            'lastModified': '2025-10-04T10:00:00Z',
          },
          {
            'id': '3',
            'content': 'new entry 3',
            'lastModified': '2025-10-05T10:00:00Z',
          },
        ],
      };

      final result = backupService.mergeJournals(
        currentData,
        importedData,
        ImportStrategy.smartMerge,
      );

      expect((result['entries'] as List).length, equals(3));
      expect(
        (result['entries'] as List).any((e) => e['id'] == '1' && e['content'] == 'newer entry 1'),
        isTrue,
        reason: 'Should keep newer version of entry 1',
      );
      expect(
        (result['entries'] as List).any((e) => e['id'] == '2' && e['content'] == 'newer entry 2'),
        isTrue,
        reason: 'Should keep newer version of entry 2',
      );
      expect(
        (result['entries'] as List).any((e) => e['id'] == '3'),
        isTrue,
        reason: 'Should add new entry 3',
      );
    });
  });
}