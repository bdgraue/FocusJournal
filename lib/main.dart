import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Focus Journal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
      home: AuthenticationWrapper(key: AuthenticationWrapper.globalKey),
    );
  }
}

class AuthenticationWrapper extends StatefulWidget {
  static GlobalKey<_AuthenticationWrapperState> globalKey = GlobalKey();
  
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  final _authService = AuthenticationService();
  bool? _isAuthSetup;
  bool _isAuthenticated = false;

  void logout() {
    setState(() {
      _isAuthenticated = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkAuthSetup();
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
    });
  }

  void _onSetupComplete() {
    setState(() {
      _isAuthSetup = true;
      _isAuthenticated = true;
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

    if (!_isAuthSetup!) {
      return PasswordSetupScreen(
        onSetupComplete: _onSetupComplete,
        isChange: false,
      );
    }

    if (!_isAuthenticated) {
      return AuthenticationScreen(onAuthenticationSuccess: _onAuthenticationSuccess);
    }

    return const MainNavigationScreen();
  }
}
