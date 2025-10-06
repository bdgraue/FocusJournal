import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'screens/authentication_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/password_setup_screen.dart';
import 'services/authentication_service.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:focus_journal/l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // Fallback colors if dynamic color is not available.
          lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
          darkColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.dark);
        }

        return MaterialApp(
          title: 'Focus Journal',
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
          ),
          // Add localization support
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

  void logout() {
    setState(() {
      _isAuthenticated = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    if (state == AppLifecycleState.inactive) {
      setState(() {
        if (_isAuthenticated) {
          _isLocked = true;
        }
      });
    }
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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Widget mainContent;
    if (!_isAuthSetup!) {
      mainContent = PasswordSetupScreen(
        onSetupComplete: _onSetupComplete,
        isFirstTimeSetup: true,
      );
    } else if (!_isAuthenticated) {
      mainContent = AuthenticationScreen(onAuthenticationSuccess: _onAuthenticationSuccess);
    } else {
      mainContent = MainNavigationScreen(onLogout: logout);
    }

    return Stack(
      children: [
        mainContent,
        if (_isLocked)
          AuthenticationScreen(onAuthenticationSuccess: _onAuthenticationSuccess),
      ],
    );
  }
}
