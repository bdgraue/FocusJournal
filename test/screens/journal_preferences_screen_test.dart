import 'package:flutter_test/flutter_test.dart';
import 'package:focus_journal/screens/settings/journal_preferences_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('JournalPreferencesScreen', () {
    test('can be instantiated', () {
      const screen = JournalPreferencesScreen();
      expect(screen, isA<JournalPreferencesScreen>());
    });
  });
}
