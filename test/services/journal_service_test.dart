// Unit tests for JournalService — the at-rest encryption of journal entries.
//
// Two properties matter here and neither had a test before:
//   * entries written by older builds (AES-256-CTR, no format prefix) must stay
//     readable after the move to authenticated encryption,
//   * stored-but-unreadable data must raise, never quietly look like an empty
//     journal, because the next write would persist that emptiness over it.

import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_journal/services/journal_service.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/mock_helpers.mocks.dart';

const _storageKey = 'journal_entries';
const _dekKey = 'journal_dek';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFlutterSecureStorage secureStorage;
  late Map<String, String> secureStore;

  /// A secure storage that just remembers things in a map, so the data
  /// encryption key survives within a test but nothing touches a platform.
  MockFlutterSecureStorage buildSecureStorage() {
    final mock = MockFlutterSecureStorage();
    when(mock.read(key: anyNamed('key'))).thenAnswer(
      (invocation) async => secureStore[invocation.namedArguments[#key]],
    );
    when(mock.write(key: anyNamed('key'), value: anyNamed('value')))
        .thenAnswer((invocation) async {
      secureStore[invocation.namedArguments[#key] as String] =
          invocation.namedArguments[#value] as String;
    });
    return mock;
  }

  /// The 256-bit key the service uses; created on first use, so this seeds it
  /// up front when a test needs to write a record by hand.
  Uint8List seedDek() {
    final dek = Uint8List.fromList(List<int>.generate(32, (i) => (i * 7) % 256));
    secureStore[_dekKey] = base64.encode(dek);
    return dek;
  }

  setUp(() {
    secureStore = <String, String>{};
    secureStorage = buildSecureStorage();
  });

  Future<JournalService> serviceWith(Map<String, Object> prefs) async {
    SharedPreferences.setMockInitialValues(prefs);
    return JournalService.create(secureStorage: secureStorage);
  }

  group('JournalService', () {
    test('returns an empty list when nothing has ever been written', () async {
      final service = await serviceWith({});

      expect(await service.getAllEntries(), isEmpty);
    });

    test('round-trips entries through encryption', () async {
      final service = await serviceWith({});
      final entry = JournalEntry(
        content: 'Ohne Handy, ohne Nachrichten.',
        createdAt: DateTime(2026, 8, 20, 20, 40),
      );

      await service.saveEntries([entry]);
      final loaded = await service.getAllEntries();

      expect(loaded, hasLength(1));
      expect(loaded.single.content, equals(entry.content));
      expect(loaded.single.id, equals(entry.id));
    });

    test('does not leave the content readable in stored preferences', () async {
      final service = await serviceWith({});
      await service.saveEntries([
        JournalEntry(content: 'Ohne Handy, ohne Nachrichten.'),
      ]);

      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_storageKey)!;

      expect(stored, isNot(contains('Ohne Handy')));
      expect(stored, startsWith('v2:'));
    });

    test('reads entries written in the legacy CTR format', () async {
      // Exactly how older builds wrote a record: no version prefix, a 16-byte
      // IV and AES in the library's default mode. Written by hand rather than
      // by today's code, otherwise it would prove nothing.
      final dek = seedDek();
      final iv = enc.IV.fromLength(16);
      final payload = json.encode([
        {
          'id': 'legacy-1',
          'content': 'Erste Seite im neuen Notizbuch.',
          'createdAt': '2026-08-08T20:40:00.000',
          'lastModified': '2026-08-08T20:40:00.000',
          'isHighlighted': true,
        },
      ]);
      final legacy =
          enc.Encrypter(enc.AES(enc.Key(dek))).encrypt(payload, iv: iv);

      final service =
          await serviceWith({_storageKey: '${iv.base64}:${legacy.base64}'});
      final loaded = await service.getAllEntries();

      expect(loaded, hasLength(1));
      expect(loaded.single.content, equals('Erste Seite im neuen Notizbuch.'));
      expect(loaded.single.isHighlighted, isTrue);
    });

    test('lifts legacy records to the authenticated format on the next write',
        () async {
      final dek = seedDek();
      final iv = enc.IV.fromLength(16);
      final payload = json.encode([
        {
          'id': 'legacy-1',
          'content': 'Erste Seite im neuen Notizbuch.',
          'createdAt': '2026-08-08T20:40:00.000',
          'lastModified': '2026-08-08T20:40:00.000',
          'isHighlighted': false,
        },
      ]);
      final legacy =
          enc.Encrypter(enc.AES(enc.Key(dek))).encrypt(payload, iv: iv);

      final service =
          await serviceWith({_storageKey: '${iv.base64}:${legacy.base64}'});
      await service.addEntry(JournalEntry(content: 'Ein neuer Tag.'));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(_storageKey), startsWith('v2:'));
      expect(await service.getAllEntries(), hasLength(2));
    });

    test('throws instead of reporting an empty journal when data is corrupt',
        () async {
      seedDek();
      final service = await serviceWith({_storageKey: 'v2:not-base64:garbage'});

      expect(
        () => service.getAllEntries(),
        throwsA(isA<JournalDecryptionException>()),
      );
    });

    test('throws when an authenticated record has been tampered with',
        () async {
      final service = await serviceWith({});
      await service.saveEntries([JournalEntry(content: 'unverändert')]);

      final prefs = await SharedPreferences.getInstance();
      final parts = prefs.getString(_storageKey)!.split(':');
      final bytes = base64.decode(parts[2]);
      bytes[bytes.length ~/ 2] ^= 0x01;
      await prefs.setString(
        _storageKey,
        '${parts[0]}:${parts[1]}:${base64.encode(bytes)}',
      );

      expect(
        () => service.getAllEntries(),
        throwsA(isA<JournalDecryptionException>()),
      );
    });

    test('leaves corrupt data untouched because writes read first', () async {
      seedDek();
      const corrupt = 'v2:not-base64:garbage';
      final service = await serviceWith({_storageKey: corrupt});

      await expectLater(
        service.addEntry(JournalEntry(content: 'darf nichts überschreiben')),
        throwsA(isA<JournalDecryptionException>()),
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(_storageKey), equals(corrupt));
    });

    test('still migrates plaintext data written before any encryption',
        () async {
      final plaintext = json.encode([
        {
          'id': 'plain-1',
          'content': 'Ganz alter Eintrag.',
          'createdAt': '2026-01-01T10:00:00.000',
          'lastModified': '2026-01-01T10:00:00.000',
        },
      ]);
      final service = await serviceWith({_storageKey: plaintext});

      final loaded = await service.getAllEntries();
      expect(loaded.single.content, equals('Ganz alter Eintrag.'));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(_storageKey), startsWith('v2:'));
    });
  });
}
