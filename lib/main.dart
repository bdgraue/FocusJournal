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
      // Use dynamic colors when enabled
      return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          if (lightDynamic != null && darkDynamic != null) {
            lightColorScheme = lightDynamic.harmonized();
            darkColorScheme = darkDynamic.harmonized();
          } else {
            // Fallback colors if dynamic color is not available
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
              Locale('en', 'US'), // English (United States)
              Locale('de', 'DE'), // Deutsch (Deutschland)
              Locale('fr', 'FR'), // Français (France)
              Locale('es', 'ES'), // Español (España)
              Locale('it', 'IT'), // Italiano (Italia)
              Locale('nl', 'NL'), // Nederlands (Nederland)
              Locale('pl', 'PL'), // Polski (Polska)
            ],
            home: const AuthenticationWrapper(),
          );
        },
      );
    } else {
      // Use static Material Design 3 colors when dynamic theming is disabled
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
          Locale('en'), // English
          Locale('de'), // German
          Locale('fr'), // French
          Locale('es'), // Spanish
          Locale('it'), // Italian
          Locale('nl'), // Dutch
          Locale('pl'), // Polish
        ],
        home: const AuthenticationWrapper(),
      );
    }
  }
}

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper>
    with WidgetsBindingObserver {
  final _authService = AuthenticationService();
  bool? _isAuthSetup;
  bool _isAuthenticated = false;
  bool _isLocked = false;
  Orientation? _lastOrientation;
  DateTime? _lastMetricsChange;

  void logout() {
    setState(() {
      _isAuthenticated = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _lastOrientation = MediaQuery.of(context).orientation;
      }
    });
    _checkAuthSetup();
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

      setState(() {
        if (_isAuthenticated) {
          _isLocked = true;
        }
      });
    } else if (state == AppLifecycleState.resumed) {
      _lastOrientation = MediaQuery.of(context).orientation;
      _lastMetricsChange = null;
    }
  }

  @override
  void didChangeMetrics() {
    _lastMetricsChange = DateTime.now();
  }

  Future<void> _checkAuthSetup() async {
    final isSetup = await _authService.isAuthenticationSetup();
    setState(() {
      _isAuthSetup = isSetup;
    });
  }

  void _onAuthenticationSuccess() {
    setState(() {
      _isAuthenticated = true;
      _isLocked = false;
    });
  }

  void _onSetupComplete() {
    setState(() {
      _isAuthSetup = true;
      _isAuthenticated = true;
      _isLocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthSetup == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Widget mainContent;
    if (!_isAuthSetup!) {
      mainContent = MethodSelectionScreen(
        onSetupComplete: _onSetupComplete,
      );
    } else if (!_isAuthenticated) {
      mainContent = AuthenticationScreen(
        onAuthenticationSuccess: _onAuthenticationSuccess,
      );
    } else {
      mainContent = MainNavigationScreen(onLogout: logout);
    }

    return Stack(
      children: [
        mainContent,
        if (_isLocked)
          AuthenticationScreen(
            onAuthenticationSuccess: _onAuthenticationSuccess,
          ),
      ],
    );
  }
}
