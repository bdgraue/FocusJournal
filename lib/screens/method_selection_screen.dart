import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import '../services/authentication_service.dart';
import 'password_setup_screen.dart';
import 'pin_setup_screen.dart';
import 'pattern_setup_screen.dart';

class MethodSelectionScreen extends StatefulWidget {
  final VoidCallback? onSetupComplete;

  const MethodSelectionScreen({
    super.key,
    this.onSetupComplete,
  });

  @override
  State<MethodSelectionScreen> createState() => _MethodSelectionScreenState();
}

class _MethodSelectionScreenState extends State<MethodSelectionScreen> {
  final _authService = AuthenticationService();
  bool _canUseBiometrics = false;
  bool _enableBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    final canUse = await _authService.canUseBiometrics();
    setState(() {
      _canUseBiometrics = canUse;
    });
  }

  void _selectMethod(String method) async {
    // Set biometric preference if enabled
    if (_enableBiometrics && _canUseBiometrics) {
      await _authService.setBiometricsEnabled(true);
    }

    switch (method) {
      case AuthenticationService.authMethodPassword:
        _navigateToPasswordSetup();
        break;
      case AuthenticationService.authMethodPin:
        _navigateToPinSetup();
        break;
      case AuthenticationService.authMethodPattern:
        _navigateToPatternSetup();
        break;
    }
  }

  void _navigateToPasswordSetup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PasswordSetupScreen(
          onSetupComplete: widget.onSetupComplete,
          isFirstTimeSetup: true,
        ),
      ),
    );
  }

  void _navigateToPinSetup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PinSetupScreen(
          onSetupComplete: widget.onSetupComplete,
          isFirstTimeSetup: true,
        ),
      ),
    );
  }

  void _navigateToPatternSetup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PatternSetupScreen(
          onSetupComplete: widget.onSetupComplete,
          isFirstTimeSetup: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setupSecurity),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.chooseAuthMethod,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Password Option
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(AppLocalizations.of(context)!.password),
                subtitle: Text(AppLocalizations.of(context)!.passwordDescription),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _selectMethod(AuthenticationService.authMethodPassword),
              ),
            ),
            const SizedBox(height: 16),
            
            // PIN Option
            Card(
              child: ListTile(
                leading: const Icon(Icons.pin_outlined),
                title: Text(AppLocalizations.of(context)!.pin),
                subtitle: Text(AppLocalizations.of(context)!.pinDescription),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _selectMethod(AuthenticationService.authMethodPin),
              ),
            ),
            const SizedBox(height: 16),
            
            // Pattern Option
            Card(
              child: ListTile(
                leading: const Icon(Icons.grid_3x3_outlined),
                title: Text(AppLocalizations.of(context)!.pattern),
                subtitle: Text(AppLocalizations.of(context)!.patternDescription),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _selectMethod(AuthenticationService.authMethodPattern),
              ),
            ),
            
            if (_canUseBiometrics) ...[
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.enableBiometrics),
                subtitle: Text(AppLocalizations.of(context)!.biometricsDescription),
                secondary: const Icon(Icons.fingerprint),
                value: _enableBiometrics,
                onChanged: (value) {
                  setState(() {
                    _enableBiometrics = value;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}