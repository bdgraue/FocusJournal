import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
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
  static const String _failedAttemptsKey = 'failedAttempts';
  static const String _lockoutUntilKey = 'lockoutUntil';
  static const int minPinLength = 6;
  static const int _maxAttempts = 5;
  static const int _pbkdf2Iterations = 100000;

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

  // --- PBKDF2 key derivation ---

  static const _pbkdf2Prefix = 'pbkdf2';
  static const _separator = r'$';

  /// Derives a 256-bit hash using PBKDF2-HMAC-SHA256.
  Uint8List _pbkdf2(String credential, Uint8List salt) {
    final credentialBytes = utf8.encode(credential);
    final hmac = Hmac(sha256, credentialBytes);

    // PBKDF2 single block (SHA-256 output = 32 bytes)
    final blockIndex = Uint8List(4)..[3] = 1;
    var u = Uint8List.fromList(
      hmac.convert([...salt, ...blockIndex]).bytes,
    );
    var result = Uint8List.fromList(u);

    for (var i = 1; i < _pbkdf2Iterations; i++) {
      u = Uint8List.fromList(hmac.convert(u).bytes);
      for (var j = 0; j < result.length; j++) {
        result[j] ^= u[j];
      }
    }

    return result;
  }

  /// Hashes a credential with PBKDF2-HMAC-SHA256.
  /// Returns `pbkdf2$base64(salt)$base64(hash)`.
  String _hashCredential(String credential) {
    final random = Random.secure();
    final salt = Uint8List.fromList(
      List.generate(32, (_) => random.nextInt(256)),
    );
    final hash = _pbkdf2(credential, salt);
    return '$_pbkdf2Prefix$_separator${base64.encode(salt)}$_separator${base64.encode(hash)}';
  }

  /// Legacy HMAC-SHA256 hash (single iteration) for backward compatibility.
  String _computeHashLegacy(String credential, Uint8List salt) {
    final hmac = Hmac(sha256, salt);
    return hmac.convert(utf8.encode(credential)).toString();
  }

  /// Verifies a credential against a stored value.
  /// Supports: PBKDF2 format, legacy HMAC format, and legacy plaintext.
  bool _verifyCredential(String credential, String stored) {
    if (stored.startsWith('$_pbkdf2Prefix$_separator')) {
      // New PBKDF2 format: pbkdf2$base64(salt)$base64(hash)
      final parts = stored.split(_separator);
      if (parts.length != 3) return false;
      final salt = Uint8List.fromList(base64.decode(parts[1]));
      final expectedHash = base64.decode(parts[2]);
      final computedHash = _pbkdf2(credential, salt);
      // Constant-time comparison
      if (computedHash.length != expectedHash.length) return false;
      var result = 0;
      for (var i = 0; i < computedHash.length; i++) {
        result |= computedHash[i] ^ expectedHash[i];
      }
      return result == 0;
    }

    if (stored.contains(_separator)) {
      // Legacy HMAC format: base64(salt)$hex(hash)
      final parts = stored.split(_separator);
      if (parts.length != 2) return false;
      final salt = Uint8List.fromList(base64.decode(parts[0]));
      final expectedHash = parts[1];
      return _computeHashLegacy(credential, salt) == expectedHash;
    }

    // Legacy plaintext format
    return stored == credential;
  }

  /// Migrates a credential to PBKDF2 format if stored in legacy format.
  Future<void> _migrateToCurrentFormat(String key, String credential) async {
    final stored = await _secureStorage.read(key: key);
    if (stored != null && !stored.startsWith('$_pbkdf2Prefix$_separator')) {
      await _secureStorage.write(key: key, value: _hashCredential(credential));
    }
  }

  // --- Brute-force protection ---

  /// Returns remaining lockout seconds (0 if not locked out).
  Future<int> getLockoutRemaining() async {
    final prefs = await SharedPreferences.getInstance();
    final lockoutStr = prefs.getString(_lockoutUntilKey);
    if (lockoutStr == null) return 0;
    final lockoutUntil = DateTime.tryParse(lockoutStr);
    if (lockoutUntil == null) return 0;
    final remaining = lockoutUntil.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  Future<int> getFailedAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_failedAttemptsKey) ?? 0;
  }

  Future<void> _recordFailedAttempt() async {
    final prefs = await SharedPreferences.getInstance();
    final attempts = (prefs.getInt(_failedAttemptsKey) ?? 0) + 1;
    await prefs.setInt(_failedAttemptsKey, attempts);

    if (attempts >= _maxAttempts) {
      // Exponential backoff: 30s, 60s, 120s, 300s
      final lockoutRounds = attempts - _maxAttempts;
      final lockoutSeconds = [30, 60, 120, 300][lockoutRounds.clamp(0, 3)];
      final lockoutUntil = DateTime.now().add(Duration(seconds: lockoutSeconds));
      await prefs.setString(_lockoutUntilKey, lockoutUntil.toIso8601String());
    }
  }

  Future<void> _resetFailedAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_failedAttemptsKey);
    await prefs.remove(_lockoutUntilKey);
  }

  // --- Password complexity validation ---

  /// Validates password complexity: min 8 chars, upper, lower, digit, special.
  bool isValidPassword(String password) {
    if (password.length < 8) return false;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    if (!RegExp(r'[0-9]').hasMatch(password)) return false;
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(password)) return false;
    return true;
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
    final lockout = await getLockoutRemaining();
    if (lockout > 0) return false;

    final stored = await _secureStorage.read(key: _passwordKey);
    if (stored == null) return false;
    final matches = _verifyCredential(password, stored);
    if (matches) {
      await _resetFailedAttempts();
      await _migrateToCurrentFormat(_passwordKey, password);
    } else {
      await _recordFailedAttempt();
    }
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
    final lockout = await getLockoutRemaining();
    if (lockout > 0) return false;

    if (!isValidPin(pin)) return false;
    final stored = await _secureStorage.read(key: _pinKey);
    if (stored == null) return false;
    final matches = _verifyCredential(pin, stored);
    if (matches) {
      await _resetFailedAttempts();
      await _migrateToCurrentFormat(_pinKey, pin);
    } else {
      await _recordFailedAttempt();
    }
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
    final lockout = await getLockoutRemaining();
    if (lockout > 0) return false;

    if (!isValidPattern(pattern)) return false;
    final stored = await _secureStorage.read(key: _patternKey);
    if (stored == null) return false;
    final matches = _verifyCredential(pattern, stored);
    if (matches) {
      await _resetFailedAttempts();
      await _migrateToCurrentFormat(_patternKey, pattern);
    } else {
      await _recordFailedAttempt();
    }
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
    await _secureStorage.delete(key: _biometricsKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSetupKey, false);
    await prefs.setString(_authMethodKey, authMethodPassword);
    await _resetFailedAttempts();
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
    // Try secure storage first (new location)
    final secureValue = await _secureStorage.read(key: _biometricsKey);
    if (secureValue != null) return secureValue == 'true';

    // Migrate from SharedPreferences if present
    final prefs = await SharedPreferences.getInstance();
    final legacyValue = prefs.getBool(_biometricsKey);
    if (legacyValue != null) {
      await _secureStorage.write(
        key: _biometricsKey,
        value: legacyValue.toString(),
      );
      await prefs.remove(_biometricsKey);
      return legacyValue;
    }

    return false;
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    await _secureStorage.write(
      key: _biometricsKey,
      value: enabled.toString(),
    );
    // Clean up legacy SharedPreferences entry if present
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_biometricsKey);
  }

  Future<bool> authenticateWithBiometrics({String? localizedReason}) async {
    if (!await isBiometricsEnabled()) return false;

    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason ?? 'Please authenticate to access your journal',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(),
          IOSAuthMessages(),
        ],
        biometricOnly: false,
        sensitiveTransaction: true,
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}
