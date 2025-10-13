import 'package:flutter_test/flutter_test.dart';
import 'package:focus_journal/services/backup_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([FlutterSecureStorage, DeviceInfoPlugin])
class _MockUuid implements Uuid {
  final String fixedValue;

  _MockUuid(this.fixedValue);

  @override
  String v4({Map<String, dynamic>? options}) => fixedValue;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('BackupService Tests', () {
    late BackupService backupService;
    late MockFlutterSecureStorage mockSecureStorage;
    late MockDeviceInfoPlugin mockDeviceInfo;
    const testUuid = '12345678-1234-1234-1234-123456789012';

    setUp(() {
      mockSecureStorage = MockFlutterSecureStorage();
      mockDeviceInfo = MockDeviceInfoPlugin();
      backupService = BackupService(
        secureStorage: mockSecureStorage,
        deviceInfo: mockDeviceInfo,
        uuid: fixedUuid,
      );
    });

    test(
      'mergeJournals with completeOverwrite strategy should replace all data',
      () {
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
      },
    );

    test(
      'mergeJournals with addNewOnly strategy should only add new entries',
      () {
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

        expect(result['entries'].length, equals(2));
        expect(
          (result['entries'] as List).any(
            (e) => e['id'] == '1' && e['content'] == 'entry 1',
          ),
          isTrue,
        );
        expect((result['entries'] as List).any((e) => e['id'] == '2'), isTrue);
      },
    );

    test(
      'mergeJournals with smartMerge strategy should keep newest versions',
      () {
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

        expect(result['entries'].length, equals(3));
        expect(
          (result['entries'] as List).any(
            (e) => e['id'] == '1' && e['content'] == 'newer entry 1',
          ),
          isTrue,
        );
        expect(
          (result['entries'] as List).any(
            (e) => e['id'] == '2' && e['content'] == 'newer entry 2',
          ),
          isTrue,
        );
        expect((result['entries'] as List).any((e) => e['id'] == '3'), isTrue);
      },
    );
  });
}

class MockUuid extends Uuid {
  final String fixedUuid;

  MockUuid(this.fixedUuid);

  @override
  String v4() => fixedUuid;
}
