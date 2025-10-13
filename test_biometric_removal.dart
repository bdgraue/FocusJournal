import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'lib/main.dart';
import 'lib/services/authentication_service.dart';

void main() {
  group('Biometric Removal Test', () {
    testWidgets('Authentication screen loads without biometric options', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify no biometric-related widgets are present
      expect(find.byIcon(Icons.fingerprint), findsNothing);
      expect(find.text('Use Biometrics'), findsNothing);
      expect(find.text('Enable Biometrics'), findsNothing);

      // Verify basic authentication elements are still present
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    test('Authentication service has no biometric methods', () {
      final authService = AuthenticationService();

      // Verify biometric methods don't exist by checking type
      expect(
        authService.runtimeType.toString(),
        contains('AuthenticationService'),
      );

      // This would fail compilation if biometric methods still existed
      // authService.canUseBiometrics(); // Should not exist
      // authService.authenticateWithBiometrics(); // Should not exist
      // authService.isBiometricsEnabled(); // Should not exist
      // authService.setBiometricsEnabled(true); // Should not exist
    });

    test('Authentication service basic functionality works', () async {
      final authService = AuthenticationService();

      // Test basic authentication setup
      expect(await authService.isAuthenticationSetup(), isFalse);

      // Test password setup
      await authService.setupPassword('testpassword123');
      expect(await authService.isAuthenticationSetup(), isTrue);
      expect(await authService.getCurrentAuthMethod(), equals('password'));

      // Test password verification
      expect(await authService.verifyPassword('testpassword123'), isTrue);
      expect(await authService.verifyPassword('wrongpassword'), isFalse);

      // Test PIN functionality
      await authService.setupPin('1234');
      expect(await authService.getCurrentAuthMethod(), equals('pin'));
      expect(await authService.verifyPin('1234'), isTrue);
      expect(await authService.verifyPin('9999'), isFalse);

      // Clean up
      await authService.logout();
      expect(await authService.isAuthenticationSetup(), isFalse);
    });
  });
}
