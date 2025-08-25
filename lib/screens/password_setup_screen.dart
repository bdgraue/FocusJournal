import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import '../services/auth_service.dart';

class PasswordSetupScreen extends StatefulWidget {
  final VoidCallback? onSetupComplete;
  final bool isChange;
  final bool isFirstTimeSetup;

  const PasswordSetupScreen({
    super.key, 
    this.onSetupComplete,
    this.isChange = false,
    this.isFirstTimeSetup = false,
  });

  @override
  State<PasswordSetupScreen> createState() => _PasswordSetupScreenState();
}

class _PasswordSetupScreenState extends State<PasswordSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _setupPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authService = AuthService();
      await authService.setupPassword(_passwordController.text);
      
      if (widget.isChange) {
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        widget.onSetupComplete?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isChange 
          ? AppLocalizations.of(context)!.changePassword 
          : AppLocalizations.of(context)!.setupPassword),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.setupPasswordPrompt,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _setupPassword,
                child: const Text('Set Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
