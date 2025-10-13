import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'lib/main.dart';

void main() {
  group('Auto Logout Tests', () {
    testWidgets('Should logout when app goes to background (paused)', (
      WidgetTester tester,
    ) async {
      // Build the app
      await tester.pumpWidget(const MyApp());

      // Wait for initial authentication check
      await tester.pumpAndSettle();

      // Find the authentication wrapper
      final authWrapperFinder = find.byType(AuthenticationWrapper);
      expect(authWrapperFinder, findsOneWidget);

      // Get the state to access private members
      final AuthenticationWrapper authWrapper = tester.widget(
        authWrapperFinder,
      );
      final _AuthenticationWrapperState? state =
          tester.state(authWrapperFinder) as _AuthenticationWrapperState?;

      if (state != null) {
        // Simulate user being authenticated
        state.setState(() {
          state._isAuthenticated = true;
        });
        await tester.pumpAndSettle();

        // Simulate app going to background
        state.didChangeAppLifecycleState(AppLifecycleState.paused);
        await tester.pumpAndSettle();

        // Verify user is logged out
        expect(state._isAuthenticated, false);
      }
    });

    testWidgets('Should logout when app becomes inactive', (
      WidgetTester tester,
    ) async {
      // Build the app
      await tester.pumpWidget(const MyApp());

      // Wait for initial authentication check
      await tester.pumpAndSettle();

      // Find the authentication wrapper
      final authWrapperFinder = find.byType(AuthenticationWrapper);
      expect(authWrapperFinder, findsOneWidget);

      // Get the state to access private members
      final _AuthenticationWrapperState? state =
          tester.state(authWrapperFinder) as _AuthenticationWrapperState?;

      if (state != null) {
        // Simulate user being authenticated
        state.setState(() {
          state._isAuthenticated = true;
        });
        await tester.pumpAndSettle();

        // Simulate app becoming inactive
        state.didChangeAppLifecycleState(AppLifecycleState.inactive);
        await tester.pumpAndSettle();

        // Verify user is logged out
        expect(state._isAuthenticated, false);
      }
    });

    testWidgets('Should NOT logout when app is resumed or detached', (
      WidgetTester tester,
    ) async {
      // Build the app
      await tester.pumpWidget(const MyApp());

      // Wait for initial authentication check
      await tester.pumpAndSettle();

      // Find the authentication wrapper
      final authWrapperFinder = find.byType(AuthenticationWrapper);
      expect(authWrapperFinder, findsOneWidget);

      // Get the state to access private members
      final _AuthenticationWrapperState? state =
          tester.state(authWrapperFinder) as _AuthenticationWrapperState?;

      if (state != null) {
        // Simulate user being authenticated
        state.setState(() {
          state._isAuthenticated = true;
        });
        await tester.pumpAndSettle();

        // Simulate app being resumed
        state.didChangeAppLifecycleState(AppLifecycleState.resumed);
        await tester.pumpAndSettle();

        // Verify user is still authenticated
        expect(state._isAuthenticated, true);

        // Simulate app being detached
        state.didChangeAppLifecycleState(AppLifecycleState.detached);
        await tester.pumpAndSettle();

        // Verify user is still authenticated (detached doesn't trigger logout)
        expect(state._isAuthenticated, true);
      }
    });
  });
}
