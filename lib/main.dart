import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:provider/provider.dart';
import 'screens/authentication_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/method_selection_screen.dart';
import 'services/authentication_service.dart';
import 'services/theme_service.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:focus_journal/l10n/app_localizations.dart';

/// ValueNotifier to suppress automatic screen locking during sensitive operations
/// like file picker dialogs, to prevent UX issues where lock screen appears over
/// native system dialogs.
class LockSuppression extends ValueNotifier<bool> {
  LockSuppression() : super(false);
}

/// Shared authentication state between _AuthGate and _LockOverlay.
class AppAuthState extends ChangeNotifier {
  bool? _isAuthSetup;
  bool _isAuthenticated = false;

  bool? get isAuthSetup => _isAuthSetup;
  bool get isAuthenticated => _isAuthenticated;

  void setAuthSetup(bool value) {
    _isAuthSetup = value;
    notifyListeners();
  }

  void authenticate() {
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThemeService>(
      future: ThemeService.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<LockSuppression>(
              create: (_) => LockSuppression(),
            ),
            ChangeNotifierProvider<ThemeService>.value(
              value: snapshot.data!,
            ),
            ChangeNotifierProvider<AppAuthState>(
              create: (_) => AppAuthState(),
            ),
          ],
          child: const _ThemedApp(),
        );
      },
    );
  }
}

class _ThemedApp extends StatelessWidget {
  const _ThemedApp();

  @override
  Widget build(BuildContext context) {
    final themeService = context.watch<ThemeService>();
    final useDynamic = themeService.useDynamicTheming;
    final themeMode = themeService.getThemeMode();

    if (useDynamic) {
      return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          if (lightDynamic != null && darkDynamic != null) {
            lightColorScheme = lightDynamic.harmonized();
            darkColorScheme = darkDynamic.harmonized();
          } else {
            lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
            darkColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            );
          }

          return MaterialApp(
            title: 'Focus Journal',
            theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
            darkTheme: ThemeData(
              colorScheme: darkColorScheme,
              useMaterial3: true,
            ),
            themeMode: themeMode,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('de', 'DE'),
              Locale('fr', 'FR'),
              Locale('es', 'ES'),
              Locale('it', 'IT'),
              Locale('nl', 'NL'),
              Locale('pl', 'PL'),
            ],
            home: const _AuthGate(),
            builder: (context, child) => LockOverlay(child: child!),
          );
        },
      );
    } else {
      final lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
      final darkColorScheme = ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      );

      return MaterialApp(
        title: 'Focus Journal',
        theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme,
          useMaterial3: true,
        ),
        themeMode: themeMode,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('de'),
          Locale('fr'),
          Locale('es'),
          Locale('it'),
          Locale('nl'),
          Locale('pl'),
        ],
        home: const _AuthGate(),
        builder: (context, child) => LockOverlay(child: child!),
      );
    }
  }
}

/// Manages the authentication flow: setup, login, or main app.
/// This is the home route of the Navigator.
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  final _authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _checkAuthSetup();
  }

  Future<void> _checkAuthSetup() async {
    final isSetup = await _authService.isAuthenticationSetup();
    if (mounted) {
      context.read<AppAuthState>().setAuthSetup(isSetup);
    }
  }

  void _onAuthenticationSuccess() {
    context.read<AppAuthState>().authenticate();
  }

  void _onSetupComplete() {
    final authState = context.read<AppAuthState>();
    authState.setAuthSetup(true);
    authState.authenticate();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AppAuthState>();

    if (authState.isAuthSetup == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!authState.isAuthSetup!) {
      return MethodSelectionScreen(onSetupComplete: _onSetupComplete);
    }

    if (!authState.isAuthenticated) {
      return AuthenticationScreen(
        onAuthenticationSuccess: _onAuthenticationSuccess,
      );
    }

    return MainNavigationScreen(
      onLogout: () => context.read<AppAuthState>().logout(),
    );
  }
}

/// Lock overlay that sits ABOVE the Navigator via MaterialApp.builder.
/// Covers all pushed routes when the app is locked.
class LockOverlay extends StatefulWidget {
  final Widget child;

  const LockOverlay({super.key, required this.child});

  @override
  State<LockOverlay> createState() => _LockOverlayState();
}

class _LockOverlayState extends State<LockOverlay>
    with WidgetsBindingObserver {
  bool _isLocked = false;
  Orientation? _lastOrientation;
  DateTime? _lastMetricsChange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _lastOrientation = MediaQuery.of(context).orientation;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Don't lock during sensitive operations like file picker
      final lockSuppression = context.read<LockSuppression>();
      if (lockSuppression.value) return;

      // Common case: orientation already applied before lifecycle fires
      final currentOrientation = MediaQuery.of(context).orientation;
      if (_lastOrientation != null && _lastOrientation != currentOrientation) {
        _lastOrientation = currentOrientation;
        return;
      }
      _lastOrientation = currentOrientation;

      // Edge case: lifecycle fires before metrics are applied (rotation pending)
      if (_lastMetricsChange != null &&
          DateTime.now().difference(_lastMetricsChange!) <
              const Duration(milliseconds: 500)) {
        return;
      }

      final authState = context.read<AppAuthState>();
      if (authState.isAuthenticated) {
        setState(() => _isLocked = true);
      }
    } else if (state == AppLifecycleState.resumed) {
      _lastOrientation = MediaQuery.of(context).orientation;
      _lastMetricsChange = null;
    }
  }

  @override
  void didChangeMetrics() {
    _lastMetricsChange = DateTime.now();
  }

  void _onUnlock() {
    setState(() => _isLocked = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_isLocked)
          AuthenticationScreen(
            onAuthenticationSuccess: _onUnlock,
          ),
      ],
    );
  }
}
