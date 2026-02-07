import 'package:flutter_test/flutter_test.dart';
import 'package:focus_journal/screens/settings/privacy_settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('PrivacySettingsScreen', () {
    test('can be instantiated', () {
      const screen = PrivacySettingsScreen();
      expect(screen, isA<PrivacySettingsScreen>());
    });
  });
}
