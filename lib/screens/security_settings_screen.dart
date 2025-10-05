import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import '../services/authentication_service.dart';
import 'password_setup_screen.dart';
import 'pin_setup_screen.dart';
import 'pattern_setup_screen.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final _authService = AuthenticationService();
  String _currentAuthMethod = AuthenticationService.authMethodPassword;
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final method = await _authService.getCurrentAuthMethod();
    
    setState(() {
      _currentAuthMethod = method;
    });
  }

  Future<void> _changeAuthMethod(String newMethod) async {
    if (newMethod == _currentAuthMethod) return;

    switch (newMethod) {
      case AuthenticationService.authMethodPassword:
        _navigateToPasswordChange();
        break;
      case AuthenticationService.authMethodPin:
        _navigateToPinChange();
        break;
      case AuthenticationService.authMethodPattern:
        _navigateToPatternChange();
        break;
    }
  }

  void _navigateToPasswordChange() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PasswordSetupScreen(
          isChange: true,
          onSetupComplete: () {
            Navigator.of(context).pop();
            _loadSettings();
          },
        ),
      ),
    );
  }

  void _navigateToPinChange() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PinSetupScreen(
          isChange: true,
          onSetupComplete: () {
            Navigator.of(context).pop();
            _loadSettings();
          },
        ),
      ),
    );
  }

  void _navigateToPatternChange() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PatternSetupScreen(
          isChange: true,
          onSetupComplete: () {
            Navigator.of(context).pop();
            _loadSettings();
          },
        ),
      ),
    );
  }


  String _getAuthMethodDisplayName(String method) {
    switch (method) {
      case AuthenticationService.authMethodPassword:
        return AppLocalizations.of(context)!.password;
      case AuthenticationService.authMethodPin:
        return AppLocalizations.of(context)!.pin;
      case AuthenticationService.authMethodPattern:
        return AppLocalizations.of(context)!.pattern;
      default:
        return AppLocalizations.of(context)!.password;
    }
  }

  IconData _getAuthMethodIcon(String method) {
    switch (method) {
      case AuthenticationService.authMethodPassword:
        return Icons.lock_outline;
      case AuthenticationService.authMethodPin:
        return Icons.pin_outlined;
      case AuthenticationService.authMethodPattern:
        return Icons.grid_3x3_outlined;
      default:
        return Icons.lock_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.securitySettings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Current Authentication Method
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.currentAuthMethod,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(_getAuthMethodIcon(_currentAuthMethod)),
                      const SizedBox(width: 8),
                      Text(_getAuthMethodDisplayName(_currentAuthMethod)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Change Authentication Method
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.changeAuthMethod),
                  subtitle: Text(AppLocalizations.of(context)!.selectNewAuthMethod),
                ),
                const Divider(height: 1),
                
                // Password Option
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: Text(AppLocalizations.of(context)!.password),
                  subtitle: Text(AppLocalizations.of(context)!.passwordDescription),
                  trailing: _currentAuthMethod == AuthenticationService.authMethodPassword
                      ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                      : const Icon(Icons.arrow_forward_ios),
                  onTap: () => _changeAuthMethod(AuthenticationService.authMethodPassword),
                ),
                
                // PIN Option
                ListTile(
                  leading: const Icon(Icons.pin_outlined),
                  title: Text(AppLocalizations.of(context)!.pin),
                  subtitle: Text(AppLocalizations.of(context)!.pinDescription),
                  trailing: _currentAuthMethod == AuthenticationService.authMethodPin
                      ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                      : const Icon(Icons.arrow_forward_ios),
                  onTap: () => _changeAuthMethod(AuthenticationService.authMethodPin),
                ),
                
                // Pattern Option
                ListTile(
                  leading: const Icon(Icons.grid_3x3_outlined),
                  title: Text(AppLocalizations.of(context)!.pattern),
                  subtitle: Text(AppLocalizations.of(context)!.patternDescription),
                  trailing: _currentAuthMethod == AuthenticationService.authMethodPattern
                      ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                      : const Icon(Icons.arrow_forward_ios),
                  onTap: () => _changeAuthMethod(AuthenticationService.authMethodPattern),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}