import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mock generators for testing.
///
/// Run `flutter pub run build_runner build` to generate mocks.
/// Generated file: mock_helpers.mocks.dart
@GenerateMocks([
  SharedPreferences,
  FlutterSecureStorage,
  LocalAuthentication,
  FlutterLocalNotificationsPlugin,
])
void main() {}

/// Sets up a mock SharedPreferences with empty initial values.
///
/// Call before tests that use services relying on SharedPreferences.
void setupMockSharedPreferences() {
  SharedPreferences.setMockInitialValues({});
}
