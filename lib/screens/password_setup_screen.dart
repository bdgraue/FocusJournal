import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'package:focus_journal/widgets/app_header.dart';
import '../services/authentication_service.dart';

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
      final authService = AuthenticationService();
      await authService.setupPassword(_passwordController.text);

      if (widget.isChange) {
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        await _offerBiometrics(authService);
        widget.onSetupComplete?.call();
      }
    }
  }

  Future<void> _offerBiometrics(AuthenticationService authService) async {
    final canUse = await authService.canUseBiometrics();
    if (!canUse || !mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final enable = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.fingerprint, size: 48),
        title: Text(l10n.enableBiometrics),
        content: Text(l10n.enableBiometricsQuestion),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.skip),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (enable == true) {
      await authService.setBiometricsEnabled(true);
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
              if (widget.isFirstTimeSetup) const AppHeader(),
              if (widget.isFirstTimeSetup) const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.setupPasswordPrompt,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.pleaseEnterAPassword;
                  }
                  if (value.length < 8) {
                    return AppLocalizations.of(context)!.passwordMinLength(8);
                  }
                  if (!AuthenticationService().isValidPassword(value)) {
                    return AppLocalizations.of(context)!.passwordComplexityError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.confirmPassword,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return AppLocalizations.of(context)!.passwordsDoNotMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _setupPassword,
                child: Text(AppLocalizations.of(context)!.setPassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
