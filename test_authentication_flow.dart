import 'package:flutter_test/flutter_test.dart';
import 'package:focus_journal/main.dart';
import 'package:focus_journal/services/authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  group('Authentication Flow Tests', () {
    setUp(() async {
      // Clear all stored authentication data before each test
      SharedPreferences.setMockInitialValues({});
      const FlutterSecureStorage().deleteAll();
    });

    testWidgets('First app start should show method selection screen', (WidgetTester tester) async {
      // Clear preferences to simulate first app start
      SharedPreferences.setMockInitialValues({});
      
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Should show method selection screen on first start
      expect(find.text('Choose Authentication Method'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('PIN'), findsOneWidget); 
      expect(find.text('Pattern'), findsOneWidget);
    });

    testWidgets('User can select any authentication method on first setup', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Test that PIN can be selected (should not be allowed per requirements)
      await tester.tap(find.text('PIN'));
      await tester.pumpAndSettle();
      
      // Should navigate to PIN setup screen
      expect(find.text('Setup PIN'), findsOneWidget);
    });

    test('Authentication service allows switching methods without keeping password backup', () async {
      final authService = AuthenticationService();
      
      // Setup password first
      await authService.setupPassword('testpassword123');
      expect(await authService.getCurrentAuthMethod(), equals(AuthenticationService.authMethodPassword));
      
      // Switch to PIN - this should keep password as backup per requirements
      await authService.setupPin('1234');
      expect(await authService.getCurrentAuthMethod(), equals(AuthenticationService.authMethodPin));
      
      // Current implementation doesn't keep password as backup
      // This test demonstrates the issue
      final canAuthWithPassword = await authService.verifyPassword('testpassword123');
      print('Can still authenticate with original password after PIN setup: $canAuthWithPassword');
    });
  });
}