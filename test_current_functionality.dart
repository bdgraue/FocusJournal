import 'package:flutter_test/flutter_test.dart';
import 'lib/services/authentication_service.dart';

void main() {
  group('Current Authentication Functionality Tests', () {
    late AuthenticationService authService;

    setUp(() {
      authService = AuthenticationService();
    });

    test('Should detect biometric availability', () async {
      final canUseBiometrics = await authService.canUseBiometrics();
      print('Biometrics available: $canUseBiometrics');
      expect(canUseBiometrics, isA<bool>());
    });

    test('Should handle authentication setup check', () async {
      final isSetup = await authService.isAuthenticationSetup();
      print('Authentication setup: $isSetup');
      expect(isSetup, isA<bool>());
    });

    test('Should get current auth method', () async {
      final method = await authService.getCurrentAuthMethod();
      print('Current auth method: $method');
      expect(method, isA<String>());
    });

    test('Should validate PIN format', () {
      expect(authService.isValidPin('1234'), isTrue);
      expect(authService.isValidPin('123'), isFalse);
      expect(authService.isValidPin('abcd'), isFalse);
    });
  });
}
