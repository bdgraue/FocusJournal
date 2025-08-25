import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import '../services/auth_service.dart';

class AuthenticationScreen extends StatefulWidget {
  final VoidCallback? onAuthenticationSuccess;
  final bool isChangingPin;

  const AuthenticationScreen({
    super.key, 
    this.onAuthenticationSuccess,
    this.isChangingPin = false,
  });

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _credentialController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSetup = false;
  String _authMethod = AuthService.authMethodPassword;

  @override
  void initState() {
    super.initState();
    _checkAuthSetup();
  }

  @override
  void dispose() {
    _credentialController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthSetup() async {
    final isSetup = await _authService.isAuthenticationSetup();
    final currentMethod = await _authService.getCurrentAuthMethod();
    setState(() {
      _isSetup = isSetup;
      _authMethod = currentMethod;
    });
    if (isSetup) {
      _checkBiometrics();
    }
  }

  Future<void> _checkBiometrics() async {
    if (await _authService.canUseBiometrics()) {
      _authenticateWithBiometrics();
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await _authService.authenticateWithBiometrics();
    
    if (success) {
      widget.onAuthenticationSuccess?.call();
      if (widget.isChangingPin) {
        setState(() {
          _isSetup = false;
        });
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _authenticate() async {
    if (_credentialController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your ${_authMethod == AuthService.authMethodPassword ? 'password' : 'PIN'}';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool success;
    if (_authMethod == AuthService.authMethodPassword) {
      success = await _authService.verifyPassword(_credentialController.text);
    } else {
      success = await _authService.verifyPin(_credentialController.text);
    }
    
    if (success) {
      widget.onAuthenticationSuccess?.call();
      if (widget.isChangingPin) {
        setState(() {
          _isSetup = false;
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Incorrect ${_authMethod == AuthService.authMethodPassword ? 'password' : 'PIN'}';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _setupCredential() async {
    if (_authMethod == AuthService.authMethodPin && !_authService.isValidPin(_credentialController.text)) {
      setState(() {
        _errorMessage = 'PIN must be at least ${AuthService.minPinLength} digits';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_authMethod == AuthService.authMethodPassword) {
        await _authService.setupPassword(_credentialController.text);
      } else {
        await _authService.setupPin(_credentialController.text);
      }
      widget.onAuthenticationSuccess?.call();
      if (widget.isChangingPin) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSetup 
          ? AppLocalizations.of(context)!.authenticationRequired 
          : AppLocalizations.of(context)!.setupPin),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isSetup
                ? (_authMethod == AuthService.authMethodPassword 
                    ? AppLocalizations.of(context)!.enterPasswordPrompt
                    : AppLocalizations.of(context)!.enterPinPrompt)
                : (_authMethod == AuthService.authMethodPassword 
                    ? AppLocalizations.of(context)!.setupPasswordPrompt
                    : AppLocalizations.of(context)!.setupPinPrompt(AuthService.minPinLength)),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _credentialController,
              obscureText: true,
              keyboardType: _authMethod == AuthService.authMethodPin ? TextInputType.number : TextInputType.text,
              maxLength: _authMethod == AuthService.authMethodPin ? 8 : null,
              decoration: InputDecoration(
                labelText: _authMethod == AuthService.authMethodPassword 
                  ? AppLocalizations.of(context)!.password 
                  : AppLocalizations.of(context)!.pin,
                border: const OutlineInputBorder(),
                errorText: _errorMessage,
              ),
              onSubmitted: (_) => _isSetup ? _authenticate() : _setupCredential(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : (_isSetup ? _authenticate : _setupCredential),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(_isSetup 
                      ? AppLocalizations.of(context)!.unlock 
                      : _authMethod == AuthService.authMethodPassword 
                          ? AppLocalizations.of(context)!.setPassword
                          : AppLocalizations.of(context)!.setPin),
            ),
            if (_isSetup) ...[
              const SizedBox(height: 16),
              FutureBuilder<bool>(
                future: _authService.canUseBiometrics(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data == true) {
                    return TextButton.icon(
                      onPressed: _isLoading ? null : _authenticateWithBiometrics,
                      icon: const Icon(Icons.fingerprint),
                      label: Text(AppLocalizations.of(context)!.useBiometrics),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
