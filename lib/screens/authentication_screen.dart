import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import '../services/authentication_service.dart';
import 'pattern_setup_screen.dart';

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
  final _authService = AuthenticationService();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSetup = false;
  String _authMethod = AuthenticationService.authMethodPassword;
  bool _showBackupPassword = false;
  bool _hasBackupPassword = false;

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
    final hasBackup = await _authService.hasBackupPassword();
    setState(() {
      _isSetup = isSetup;
      _authMethod = currentMethod;
      _hasBackupPassword = hasBackup;
    });
  }


  Future<void> _authenticateWithPattern(List<int> pattern) async {
    if (pattern.length < 4) {
      setState(() {
        _errorMessage = 'Please draw your pattern';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await _authService.verifyPattern(pattern.join());
    
    if (success) {
      widget.onAuthenticationSuccess?.call();
    } else {
      setState(() {
        _errorMessage = 'Incorrect pattern';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _authenticate() async {
    if (_authMethod == AuthenticationService.authMethodPattern) {
      // Pattern authentication will be handled by the pattern input widget
      return;
    }
    
    if (_credentialController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your ${_showBackupPassword ? 'backup password' : _authMethod == AuthenticationService.authMethodPassword ? 'password' : 'PIN'}';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool success;
    if (_showBackupPassword) {
      success = await _authService.authenticateWithBackupPassword(_credentialController.text);
    } else {
      success = await _authService.authenticateWithCredentials(_credentialController.text);
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
        _errorMessage = 'Incorrect ${_showBackupPassword ? 'backup password' : _authMethod == AuthenticationService.authMethodPassword ? 'password' : 'PIN'}';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _toggleBackupPassword() {
    setState(() {
      _showBackupPassword = !_showBackupPassword;
      _credentialController.clear();
      _errorMessage = null;
    });
  }

  Future<void> _setupCredential() async {
    if (_authMethod == AuthenticationService.authMethodPin && !_authService.isValidPin(_credentialController.text)) {
      setState(() {
        _errorMessage = 'PIN must be at least ${AuthenticationService.minPinLength} digits';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_authMethod == AuthenticationService.authMethodPassword) {
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
                ? (_showBackupPassword 
                    ? AppLocalizations.of(context)!.enterPasswordPrompt
                    : _authMethod == AuthenticationService.authMethodPassword 
                        ? AppLocalizations.of(context)!.enterPasswordPrompt
                        : _authMethod == AuthenticationService.authMethodPin
                            ? AppLocalizations.of(context)!.enterPinPrompt
                            : AppLocalizations.of(context)!.drawPattern)
                : (_authMethod == AuthenticationService.authMethodPassword 
                    ? AppLocalizations.of(context)!.setupPasswordPrompt
                    : _authMethod == AuthenticationService.authMethodPin
                        ? AppLocalizations.of(context)!.setupPinPrompt(AuthenticationService.minPinLength)
                        : AppLocalizations.of(context)!.drawPattern),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (_authMethod == AuthenticationService.authMethodPattern) ...[
              PatternGrid(
                onPatternDrawn: _isSetup ? _authenticateWithPattern : (pattern) => _setupCredential(),
                currentPattern: [],
                enabled: !_isLoading,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ] else ...[
              TextField(
                controller: _credentialController,
                obscureText: true,
                keyboardType: (_showBackupPassword || _authMethod == AuthenticationService.authMethodPassword) ? TextInputType.text : TextInputType.number,
                maxLength: (_showBackupPassword || _authMethod == AuthenticationService.authMethodPassword) ? null : 8,
                decoration: InputDecoration(
                  labelText: _showBackupPassword 
                    ? AppLocalizations.of(context)!.password
                    : _authMethod == AuthenticationService.authMethodPassword
                        ? AppLocalizations.of(context)!.password 
                        : AppLocalizations.of(context)!.pin,
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                ),
                onSubmitted: (_) => _isSetup ? _authenticate() : _setupCredential(),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : (_isSetup ? _authenticate : _setupCredential),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(_isSetup 
                      ? AppLocalizations.of(context)!.unlock 
                      : _authMethod == AuthenticationService.authMethodPassword 
                          ? AppLocalizations.of(context)!.setPassword
                          : AppLocalizations.of(context)!.setPin),
            ),
            if (_isSetup && _hasBackupPassword && _authMethod != AuthenticationService.authMethodPattern) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _isLoading ? null : _toggleBackupPassword,
                icon: Icon(_showBackupPassword ? Icons.lock_open : Icons.lock),
                label: Text(_showBackupPassword 
                  ? 'Use ${_authMethod == AuthenticationService.authMethodPin ? 'PIN' : 'Pattern'}'
                  : 'Use backup password'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
