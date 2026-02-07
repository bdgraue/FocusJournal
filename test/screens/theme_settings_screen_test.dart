import 'package:flutter_test/flutter_test.dart';
import 'package:focus_journal/screens/theme_settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ThemeSettingsScreen', () {
    test('can be instantiated', () {
      const screen = ThemeSettingsScreen();
      expect(screen, isA<ThemeSettingsScreen>());
    });
  });
}
