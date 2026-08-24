// Proves on a real device that the move to authenticated encryption does not
// strand data written by older builds.
//
// The unit tests cover the format logic with a fake secure storage. What they
// cannot cover is the part that only exists on a device: the platform-backed
// FlutterSecureStorage holding the data encryption key, and the real
// SharedPreferences behind it. This test plants a record in exactly the shape
// an older build left behind and then reads it through the current service.
//
//   flutter test integration_test/legacy_encryption_test.dart -d emulator-5554

import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:focus_journal/services/journal_service.dart';

const _storageKey = 'journal_entries';
const _dekKey = 'journal_dek';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const secureStorage = FlutterSecureStorage();

  setUp(() async {
    await secureStorage.delete(key: _dekKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  });

  testWidgets('reads and migrates a record left by an older build',
      (tester) async {
    // A data encryption key as an older install would have stored it, in the
    // real platform keystore.
    final dek = Uint8List.fromList(List<int>.generate(32, (i) => (i * 11) % 256));
    await secureStorage.write(key: _dekKey, value: base64.encode(dek));

    // The old on-disk shape: no version prefix, 16-byte IV, AES in the
    // library's default mode (CTR). Written the way the old code wrote it, not
    // by calling today's encryption.
    final iv = enc.IV.fromSecureRandom(16);
    final payload = json.encode([
      {
        'id': 'legacy-device-1',
        'content': 'Vor dem Update geschrieben.',
        'createdAt': '2026-08-10T20:40:00.000',
        'lastModified': '2026-08-10T20:40:00.000',
        'isHighlighted': true,
      },
    ]);
    final legacy = enc.Encrypter(enc.AES(enc.Key(dek))).encrypt(payload, iv: iv);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, '${iv.base64}:${legacy.base64}');

    // The entry must survive the upgrade — not turn into an empty journal.
    final service = await JournalService.create();
    final loaded = await service.getAllEntries();

    expect(loaded, hasLength(1), reason: 'legacy entry was lost');
    expect(loaded.single.content, equals('Vor dem Update geschrieben.'));
    expect(loaded.single.isHighlighted, isTrue);

    // And the next write lifts the store to authenticated encryption.
    await service.addEntry(JournalEntry(content: 'Nach dem Update.'));

    final stored = (await SharedPreferences.getInstance())
        .getString(_storageKey)!;
    expect(stored, startsWith('v2:'), reason: 'store was not lifted to v2');

    final after = await service.getAllEntries();
    expect(after, hasLength(2));
    expect(
      after.map((e) => e.content),
      containsAll(<String>['Vor dem Update geschrieben.', 'Nach dem Update.']),
    );
  });

  testWidgets('round-trips through the real keystore', (tester) async {
    final service = await JournalService.create();
    await service.addEntry(JournalEntry(content: 'Mit echtem Schlüsselspeicher.'));

    // A second service instance reads the key back out of the platform store,
    // which is the part a unit test with a fake cannot exercise.
    final wieder = await JournalService.create();
    final loaded = await wieder.getAllEntries();

    expect(loaded.single.content, equals('Mit echtem Schlüsselspeicher.'));
  });

  testWidgets('refuses to read a tampered record instead of emptying', (tester) async {
    final service = await JournalService.create();
    await service.addEntry(JournalEntry(content: 'unverändert'));

    final prefs = await SharedPreferences.getInstance();
    final parts = prefs.getString(_storageKey)!.split(':');
    final bytes = base64.decode(parts[2]);
    bytes[bytes.length ~/ 2] ^= 0x01;
    await prefs.setString(
      _storageKey,
      '${parts[0]}:${parts[1]}:${base64.encode(bytes)}',
    );

    await expectLater(
      (await JournalService.create()).getAllEntries(),
      throwsA(isA<JournalDecryptionException>()),
    );

    // The damaged record is still on disk — nothing overwrote it.
    expect(prefs.getString(_storageKey), isNot(startsWith('v2:not')));
  });
}
