import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthenticationScreen extends StatefulWidget {
  final VoidCallback onAuthenticationSuccess;

  const AuthenticationScreen({super.key, required this.onAuthenticationSuccess});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
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
      widget.onAuthenticationSuccess();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _authenticateWithPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await _authService.verifyPassword(_passwordController.text);
    
    if (success) {
      widget.onAuthenticationSuccess();
    } else {
      setState(() {
        _errorMessage = 'Incorrect password';
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
        title: const Text('Authentication Required'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please authenticate to access your journal',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                errorText: _errorMessage,
              ),
              onSubmitted: (_) => _authenticateWithPassword(),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _authenticateWithPassword,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Unlock'),
            ),
            const SizedBox(height: 16),
            FutureBuilder<bool>(
              future: _authService.canUseBiometrics(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == true) {
                  return TextButton.icon(
                    onPressed: _isLoading ? null : _authenticateWithBiometrics,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Use Biometrics'),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
