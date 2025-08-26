import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
  static const String _passwordKey = 'password';
  static const String _pinKey = 'pin';
  static const String _patternKey = 'pattern';
  static const String _hasSetupKey = 'hasSetupAuth';
  static const String _screenLockKey = 'screenLock';
  static const String _authMethodKey = 'authMethod';
  static const int minPinLength = 4;
  
  final FlutterSecureStorage _secureStorage;

  // Available authentication methods
  static const String authMethodPassword = 'password';
  static const String authMethodPin = 'pin';
  static const String authMethodPattern = 'pattern';
  
  AuthenticationService()
      : _secureStorage = const FlutterSecureStorage();

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
    // Keep password as backup - don't delete it when switching to PIN
  }

  Future<bool> verifyPin(String pin) async {
    if (!isValidPin(pin)) return false;
    final storedPin = await _secureStorage.read(key: _pinKey);
    return storedPin == pin;
  }

  bool isValidPattern(String pattern) {
    if (pattern.isEmpty) return false;
    // Pattern should be a sequence of numbers (0-8) representing dots in a 3x3 grid
    return RegExp(r'^[0-8]+$').hasMatch(pattern) && pattern.length >= 4;
  }

  Future<void> setupPattern(String pattern) async {
    if (!isValidPattern(pattern)) {
      throw Exception('Pattern must connect at least 4 dots');
    }
    await _secureStorage.write(key: _patternKey, value: pattern);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authMethodKey, authMethodPattern);
    // Keep password as backup - don't delete it when switching to pattern
  }

  Future<bool> verifyPattern(String pattern) async {
    if (!isValidPattern(pattern)) return false;
    final storedPattern = await _secureStorage.read(key: _patternKey);
    return storedPattern == pattern;
  }

  Future<String> getCurrentAuthMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authMethodKey) ?? authMethodPassword;
  }



  Future<bool> isScreenLockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_screenLockKey) ?? true; // Default to true for security
  }

  Future<void> setScreenLockEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_screenLockKey, enabled);
  }


  Future<void> logout() async {
    await _secureStorage.delete(key: _passwordKey);
    await _secureStorage.delete(key: _pinKey);
    await _secureStorage.delete(key: _patternKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSetupKey, false);
    await prefs.setString(_authMethodKey, authMethodPassword);
  }

  Future<bool> authenticateWithCredentials(String credentials) async {
    final method = await getCurrentAuthMethod();
    switch (method) {
      case authMethodPassword:
        return await verifyPassword(credentials);
      case authMethodPin:
        return await verifyPin(credentials);
      case authMethodPattern:
        return await verifyPattern(credentials);
      default:
        return false;
    }
  }

  Future<bool> authenticateWithBackupPassword(String password) async {
    // Always authenticate with password regardless of current method
    // This allows password as backup for PIN/pattern
    return await verifyPassword(password);
  }

  Future<bool> hasBackupPassword() async {
    final method = await getCurrentAuthMethod();
    if (method == authMethodPassword) return false;
    
    // Check if password exists as backup for PIN/pattern methods
    final storedPassword = await _secureStorage.read(key: _passwordKey);
    return storedPassword != null && storedPassword.isNotEmpty;
  }
}