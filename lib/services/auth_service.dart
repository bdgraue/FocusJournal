import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _passwordKey = 'password';
  static const String _pinKey = 'pin';
  static const String _hasSetupKey = 'hasSetupAuth';
  static const String _useBiometricsKey = 'useBiometrics';
  static const String _screenLockKey = 'screenLock';
  static const String _authMethodKey = 'authMethod';
  static const int minPinLength = 4;
  
  final FlutterSecureStorage _secureStorage;
  final LocalAuthentication _localAuth;

  // Available authentication methods
  static const String authMethodPassword = 'password';
  static const String authMethodPin = 'pin';
  static const String authMethodPattern = 'pattern';
  
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
    await prefs.setString(_authMethodKey, authMethodPassword);
  }

  Future<bool> verifyPassword(String password) async {
    final storedPassword = await _secureStorage.read(key: _passwordKey);
    return storedPassword == password;
  }

  bool isValidPin(String pin) {
    if (pin.length < minPinLength) return false;
    return RegExp(r'^\d+$').hasMatch(pin);
  }

  Future<void> setupPin(String pin) async {
    if (!isValidPin(pin)) {
      throw Exception('PIN must be at least $minPinLength digits');
    }
    await _secureStorage.write(key: _pinKey, value: pin);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authMethodKey, authMethodPin);
  }

  Future<bool> verifyPin(String pin) async {
    if (!isValidPin(pin)) return false;
    final storedPin = await _secureStorage.read(key: _pinKey);
    return storedPin == pin;
  }

  Future<String> getCurrentAuthMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authMethodKey) ?? authMethodPassword;
  }

  Future<bool> canUseBiometrics() async {
    try {
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final canAuthenticate = await _localAuth.isDeviceSupported();
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return canAuthenticateWithBiometrics && canAuthenticate && availableBiometrics.isNotEmpty;
    } catch (e) {
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

  Future<bool> isBiometricsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_useBiometricsKey) ?? false;
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_useBiometricsKey, enabled);
  }

  Future<bool> isScreenLockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_screenLockKey) ?? true; // Default to true for security
  }

  Future<void> setScreenLockEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_screenLockKey, enabled);
  }

  Future<bool> authenticate(String reason) async {
    if (await isBiometricsEnabled() && await canUseBiometrics()) {
      return await authenticateWithBiometrics();
    }
    // PIN authentication will be handled by the UI
    return false;
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: _passwordKey);
    await _secureStorage.delete(key: _pinKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSetupKey, false);
    await prefs.setBool(_useBiometricsKey, false);
    await prefs.setString(_authMethodKey, authMethodPassword);
  }
}
