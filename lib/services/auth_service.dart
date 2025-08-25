import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _passwordKey = 'password';
  static const String _hasSetupKey = 'hasSetupAuth';
  
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;
  
  AuthService()
      : _secureStorage = const FlutterSecureStorage(),
        _localAuth = LocalAuthentication();

  Future<bool> isAuthenticationSetup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSetupKey) ?? false;
  }

  Future<void> setupPassword(String password) async {
    await _secureStorage.write(key: _passwordKey, value: password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSetupKey, true);
  }

  Future<bool> verifyPassword(String password) async {
    final storedPassword = await _secureStorage.read(key: _passwordKey);
    return storedPassword == password;
  }

  Future<bool> canUseBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics &&
          await _localAuth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your journal',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
