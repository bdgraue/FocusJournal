import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  static const String _passwordKey = 'password';
  static const String _pinKey = 'pin';
  static const String _patternKey = 'pattern';
  static const String _hasSetupKey = 'hasSetupAuth';
  static const String _screenLockKey = 'screenLock';
  static const String _authMethodKey = 'authMethod';
  static const String _biometricsKey = 'biometrics';
  static const int minPinLength = 4;

  final FlutterSecureStorage _secureStorage;

  // Available authentication methods
  static const String authMethodPassword = 'password';
  static const String authMethodPin = 'pin';
  static const String authMethodPattern = 'pattern';

  static final AuthenticationService _instance =
      AuthenticationService._internal();
  bool _isLocked = false;

  factory AuthenticationService() {
    return _instance;
  }

  AuthenticationService._internal()
    : _secureStorage = const FlutterSecureStorage();

  // --- Credential hashing helpers ---

  static const _saltSeparator = r'$';

  /// Hashes a credential with a random salt using HMAC-SHA256.
  /// Returns `base64(salt)$hex(hash)`.
  String _hashCredential(String credential) {
    final random = Random.secure();
    final salt = Uint8List.fromList(
      List.generate(32, (_) => random.nextInt(256)),
    );
    final hash = _computeHash(credential, salt);
    return '${base64.encode(salt)}$_saltSeparator$hash';
  }

  String _computeHash(String credential, Uint8List salt) {
    final hmac = Hmac(sha256, salt);
    return hmac.convert(utf8.encode(credential)).toString();
  }

  /// Verifies a credential against a stored value.
  /// Supports both legacy plaintext and new hashed format.
  bool _verifyCredential(String credential, String stored) {
    if (!stored.contains(_saltSeparator)) {
      // Legacy plaintext format
      return stored == credential;
    }
    final parts = stored.split(_saltSeparator);
    if (parts.length != 2) return false;
    final salt = Uint8List.fromList(base64.decode(parts[0]));
    final expectedHash = parts[1];
    return _computeHash(credential, salt) == expectedHash;
  }

  /// Migrates a legacy plaintext credential to hashed format.
  Future<void> _migrateIfLegacy(String key, String credential) async {
    final stored = await _secureStorage.read(key: key);
    if (stored != null && !stored.contains(_saltSeparator)) {
      await _secureStorage.write(key: key, value: _hashCredential(credential));
    }
  }

  void lockApp() {
    _isLocked = true;
  }

  Future<bool> shouldRequireAuth(BuildContext context) async {
    // Require auth only if app was explicitly locked by app logic
    if (_isLocked) {
      _isLocked = false; // Reset lock state after checking
      return true;
    }
    // Do not tie auth requirement to orientation changes
    return false;
  }

  Future<bool> isAuthenticationSetup() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSetupKey) ?? false;
  }

  Future<void> setupPassword(String password) async {
    await _secureStorage.write(
      key: _passwordKey,
      value: _hashCredential(password),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSetupKey, true);
    await prefs.setString(_authMethodKey, authMethodPassword);
  }

  Future<bool> verifyPassword(String password) async {
    final stored = await _secureStorage.read(key: _passwordKey);
    if (stored == null) return false;
    final matches = _verifyCredential(password, stored);
    if (matches) await _migrateIfLegacy(_passwordKey, password);
    return matches;
  }

  bool isValidPin(String pin) {
    if (pin.length < minPinLength) return false;
    return RegExp(r'^\d+$').hasMatch(pin);
  }

  Future<void> setupPin(String pin) async {
    if (!isValidPin(pin)) {
      throw Exception('PIN must be at least $minPinLength digits');
    }
    await _secureStorage.write(key: _pinKey, value: _hashCredential(pin));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authMethodKey, authMethodPin);
    // Keep password as backup - don't delete it when switching to PIN
  }

  Future<bool> verifyPin(String pin) async {
    if (!isValidPin(pin)) return false;
    final stored = await _secureStorage.read(key: _pinKey);
    if (stored == null) return false;
    final matches = _verifyCredential(pin, stored);
    if (matches) await _migrateIfLegacy(_pinKey, pin);
    return matches;
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
    await _secureStorage.write(
      key: _patternKey,
      value: _hashCredential(pattern),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authMethodKey, authMethodPattern);
    // Keep password as backup - don't delete it when switching to pattern
  }

  Future<bool> verifyPattern(String pattern) async {
    if (!isValidPattern(pattern)) return false;
    final stored = await _secureStorage.read(key: _patternKey);
    if (stored == null) return false;
    final matches = _verifyCredential(pattern, stored);
    if (matches) await _migrateIfLegacy(_patternKey, pattern);
    return matches;
  }

  Future<String> getCurrentAuthMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authMethodKey) ?? authMethodPassword;
  }

  Future<bool> isScreenLockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_screenLockKey) ??
        true; // Default to true for security
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

  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> canUseBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics &&
          await _localAuth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  Future<bool> isBiometricsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricsKey) ?? false;
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricsKey, enabled);
  }

  Future<bool> authenticateWithBiometrics() async {
    if (!await isBiometricsEnabled()) return false;

    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your journal',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}
