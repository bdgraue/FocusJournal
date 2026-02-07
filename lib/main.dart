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
  bool _orientationJustChanged = false;

  void logout() {
    setState(() {
      _isAuthenticated = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize orientation after first frame so MediaQuery is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _lastOrientation = MediaQuery.of(context).orientation;
      }
    });
    _checkAuthSetup();
    _checkInitialLock();
  }

  Future<void> _checkInitialLock() async {
    final shouldLock = await _authService.shouldRequireAuth(context);
    if (shouldLock) {
      setState(() {
        _isLocked = true;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Lock when app goes to background (inactive or paused)
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      // Check if lock suppression is active (e.g., during file picker operations)
      final lockSuppression = context.read<LockSuppression>();
      if (lockSuppression.value) {
        // Don't lock during sensitive operations like file picker
        return;
      }

      // In some cases, inactive may arrive before didChangeMetrics on rotation.
      // Detect orientation change here as well and skip locking if it changed.
      final currentOrientation = MediaQuery.of(context).orientation;
      if (_lastOrientation != null && _lastOrientation != currentOrientation) {
        _orientationJustChanged = true;
      }
      _lastOrientation = currentOrientation;

      if (_orientationJustChanged) {
        // Reset the flag and skip locking/unlocking on rotation
        _orientationJustChanged = false;
        return;
      }
      setState(() {
        if (_isAuthenticated) {
          _isLocked = true;
        }
      });
    }
  }

  @override
  void didChangeMetrics() {
    // Triggered on orientation changes and other metrics updates
    final currentOrientation = MediaQuery.of(context).orientation;
    if (_lastOrientation != null && _lastOrientation != currentOrientation) {
      _orientationJustChanged = true;
    }
    _lastOrientation = currentOrientation;
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
