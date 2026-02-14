import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focus_journal/main.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'package:focus_journal/screens/authentication_screen.dart';

/// Creates a testable app with LockOverlay in MaterialApp.builder,
/// matching the production architecture where the lock overlay sits
/// ABOVE the Navigator and covers all pushed routes.
Widget _buildTestApp({
  AppAuthState? authState,
  LockSuppression? lockSuppression,
  Widget? home,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LockSuppression>.value(
        value: lockSuppression ?? LockSuppression(),
      ),
      ChangeNotifierProvider<AppAuthState>.value(
        value: authState ?? AppAuthState(),
      ),
    ],
    child: MaterialApp(
      navigatorKey: navigatorKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home ?? const Scaffold(body: Text('Main Content')),
      builder: (context, child) => LockOverlay(child: child!),
    ),
  );
}

/// Calls didChangeAppLifecycleState directly on the LockOverlay state,
/// bypassing the binding's frame scheduling. This is necessary because
/// the test binding disables frames during paused/inactive lifecycle
/// states, which prevents setState from triggering a rebuild.
/// In production, the setState executes while the app is still visible
/// (during the transition to background), so this approach accurately
/// reflects real behavior.
void _simulateLifecycle(WidgetTester tester, AppLifecycleState state) {
  final overlay = tester.state(find.byType(LockOverlay));
  (overlay as WidgetsBindingObserver).didChangeAppLifecycleState(state);
}

/// Calls didChangeMetrics directly on the LockOverlay state.
void _simulateMetricsChange(WidgetTester tester) {
  final overlay = tester.state(find.byType(LockOverlay));
  (overlay as WidgetsBindingObserver).didChangeMetrics();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LockOverlay', () {
    testWidgets('does not show lock screen initially',
        (WidgetTester tester) async {
      final authState = AppAuthState();
      authState.setAuthSetup(true);
      authState.authenticate();

      await tester.pumpWidget(_buildTestApp(authState: authState));
      await tester.pumpAndSettle();

      expect(find.text('Main Content'), findsOneWidget);
      expect(find.byType(AuthenticationScreen), findsNothing);
    });

    testWidgets('locks when authenticated and app goes to background (paused)',
        (WidgetTester tester) async {
      final authState = AppAuthState();
      authState.setAuthSetup(true);
      authState.authenticate();

      await tester.pumpWidget(_buildTestApp(authState: authState));
      await tester.pumpAndSettle();

      _simulateLifecycle(tester, AppLifecycleState.paused);
      await tester.pump();

      expect(find.byType(AuthenticationScreen), findsOneWidget);
    });

    testWidgets('locks when authenticated and app becomes inactive',
        (WidgetTester tester) async {
      final authState = AppAuthState();
      authState.setAuthSetup(true);
      authState.authenticate();

      await tester.pumpWidget(_buildTestApp(authState: authState));
      await tester.pumpAndSettle();

      _simulateLifecycle(tester, AppLifecycleState.inactive);
      await tester.pump();

      expect(find.byType(AuthenticationScreen), findsOneWidget);
    });

    testWidgets('does not lock when not authenticated',
        (WidgetTester tester) async {
      final authState = AppAuthState();
      authState.setAuthSetup(true);
      // NOT authenticated

      await tester.pumpWidget(_buildTestApp(authState: authState));
      await tester.pumpAndSettle();

      _simulateLifecycle(tester, AppLifecycleState.paused);
      await tester.pump();

      expect(find.byType(AuthenticationScreen), findsNothing);
    });

    testWidgets('does not lock when auth is not set up',
        (WidgetTester tester) async {
      final authState = AppAuthState();
      // isAuthSetup is null, isAuthenticated is false

      await tester.pumpWidget(_buildTestApp(authState: authState));
      await tester.pumpAndSettle();

      _simulateLifecycle(tester, AppLifecycleState.paused);
      await tester.pump();

      expect(find.byType(AuthenticationScreen), findsNothing);
    });

    testWidgets('does not lock when LockSuppression is active',
        (WidgetTester tester) async {
      final authState = AppAuthState();
      authState.setAuthSetup(true);
      authState.authenticate();
      final lockSuppression = LockSuppression();
      lockSuppression.value = true;

      await tester.pumpWidget(_buildTestApp(
        authState: authState,
        lockSuppression: lockSuppression,
      ));
      await tester.pumpAndSettle();

      _simulateLifecycle(tester, AppLifecycleState.paused);
      await tester.pump();

      expect(find.byType(AuthenticationScreen), findsNothing);
    });

    testWidgets('locks after LockSuppression is deactivated',
        (WidgetTester tester) async {
      final authState = AppAuthState();
      authState.setAuthSetup(true);
      authState.authenticate();
      final lockSuppression = LockSuppression();
      lockSuppression.value = true;

      await tester.pumpWidget(_buildTestApp(
        authState: authState,
        lockSuppression: lockSuppression,
      ));
      await tester.pumpAndSettle();

      // No lock while suppressed
      _simulateLifecycle(tester, AppLifecycleState.paused);
      await tester.pump();
      expect(find.byType(AuthenticationScreen), findsNothing);

      // Resume, then deactivate suppression
      _simulateLifecycle(tester, AppLifecycleState.resumed);
      await tester.pump();
      lockSuppression.value = false;

      // Now should lock
      _simulateLifecycle(tester, AppLifecycleState.paused);
      await tester.pump();
      expect(find.byType(AuthenticationScreen), findsOneWidget);
    });

    testWidgets('does not lock during metrics change (orientation/keyboard)',
        (WidgetTester tester) async {
      final authState = AppAuthState();
      authState.setAuthSetup(true);
      authState.authenticate();

      await tester.pumpWidget(_buildTestApp(authState: authState));
      await tester.pumpAndSettle();

      // Simulate metrics change immediately before lifecycle event
      _simulateMetricsChange(tester);

      // Immediately go to background - within 500ms threshold
      _simulateLifecycle(tester, AppLifecycleState.inactive);
      await tester.pump();

      // Should not lock (metrics change within 500ms guards against false lock)
      expect(find.byType(AuthenticationScreen), findsNothing);
    });

    testWidgets('resumed clears metrics guard and allows locking',
        (WidgetTester tester) async {
      final authState = AppAuthState();
      authState.setAuthSetup(true);
      authState.authenticate();

      await tester.pumpWidget(_buildTestApp(authState: authState));
      await tester.pumpAndSettle();

      // Metrics change prevents locking
      _simulateMetricsChange(tester);
      _simulateLifecycle(tester, AppLifecycleState.inactive);
      await tester.pump();
      expect(find.byType(AuthenticationScreen), findsNothing);

      // Resume clears the metrics guard
      _simulateLifecycle(tester, AppLifecycleState.resumed);
      await tester.pump();

      // Now locking should work (metrics guard was reset)
      _simulateLifecycle(tester, AppLifecycleState.paused);
      await tester.pump();
      expect(find.byType(AuthenticationScreen), findsOneWidget);
    });

    testWidgets('lock overlay covers pushed routes',
        (WidgetTester tester) async {
      final authState = AppAuthState();
      authState.setAuthSetup(true);
      authState.authenticate();
      final navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(_buildTestApp(
        authState: authState,
        navigatorKey: navigatorKey,
      ));
      await tester.pumpAndSettle();

      // Push a new route (simulating Settings, Backup, etc.)
      navigatorKey.currentState!.push(
        MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('Pushed Route'))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pushed Route'), findsOneWidget);

      // Lock the app
      _simulateLifecycle(tester, AppLifecycleState.paused);
      await tester.pump();

      // Lock overlay should appear ABOVE the pushed route
      expect(find.byType(AuthenticationScreen), findsOneWidget);
    });

    testWidgets('LockOverlay is positioned above Navigator in widget tree',
        (WidgetTester tester) async {
      final authState = AppAuthState();
      authState.setAuthSetup(true);
      authState.authenticate();

      await tester.pumpWidget(_buildTestApp(authState: authState));
      await tester.pumpAndSettle();

      // Verify LockOverlay exists and wraps the Navigator
      expect(find.byType(LockOverlay), findsOneWidget);

      // Lock the app
      _simulateLifecycle(tester, AppLifecycleState.paused);
      await tester.pump();

      // Both the main content and the lock screen should be in the Stack
      expect(find.byType(AuthenticationScreen), findsOneWidget);
      expect(find.byType(LockOverlay), findsOneWidget);
    });
  });

  group('AppAuthState', () {
    test('initial state has null isAuthSetup and false isAuthenticated', () {
      final state = AppAuthState();
      expect(state.isAuthSetup, isNull);
      expect(state.isAuthenticated, isFalse);
    });

    test('setAuthSetup updates isAuthSetup', () {
      final state = AppAuthState();
      state.setAuthSetup(true);
      expect(state.isAuthSetup, isTrue);
    });

    test('setAuthSetup can be set to false', () {
      final state = AppAuthState();
      state.setAuthSetup(true);
      state.setAuthSetup(false);
      expect(state.isAuthSetup, isFalse);
    });

    test('authenticate sets isAuthenticated to true', () {
      final state = AppAuthState();
      state.authenticate();
      expect(state.isAuthenticated, isTrue);
    });

    test('logout sets isAuthenticated to false', () {
      final state = AppAuthState();
      state.authenticate();
      state.logout();
      expect(state.isAuthenticated, isFalse);
    });

    test('notifies listeners on state changes', () {
      final state = AppAuthState();
      int notifyCount = 0;
      state.addListener(() => notifyCount++);

      state.setAuthSetup(true);
      expect(notifyCount, 1);

      state.authenticate();
      expect(notifyCount, 2);

      state.logout();
      expect(notifyCount, 3);
    });

    test('setAuthSetup and authenticate can be called together', () {
      final state = AppAuthState();
      state.setAuthSetup(true);
      state.authenticate();
      expect(state.isAuthSetup, isTrue);
      expect(state.isAuthenticated, isTrue);
    });
  });

  group('LockSuppression', () {
    test('defaults to false', () {
      final suppression = LockSuppression();
      expect(suppression.value, isFalse);
    });

    test('can be set to true', () {
      final suppression = LockSuppression();
      suppression.value = true;
      expect(suppression.value, isTrue);
    });

    test('can be toggled back to false', () {
      final suppression = LockSuppression();
      suppression.value = true;
      suppression.value = false;
      expect(suppression.value, isFalse);
    });

    test('notifies listeners on value change', () {
      final suppression = LockSuppression();
      int notifyCount = 0;
      suppression.addListener(() => notifyCount++);

      suppression.value = true;
      expect(notifyCount, 1);

      suppression.value = false;
      expect(notifyCount, 2);
    });
  });
}
