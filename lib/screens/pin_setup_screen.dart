import 'package:flutter/material.dart';
import 'package:focus_journal/l10n/app_localizations.dart';
import 'package:focus_journal/widgets/app_header.dart';
import '../services/authentication_service.dart';

class PinSetupScreen extends StatefulWidget {
  final VoidCallback? onSetupComplete;
  final bool isChange;
  final bool isFirstTimeSetup;

  const PinSetupScreen({
    super.key,
    this.onSetupComplete,
    this.isChange = false,
    this.isFirstTimeSetup = false,
  });

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _setupPin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final authService = AuthenticationService();
        await authService.setupPin(_pinController.text);

        if (widget.isChange) {
          if (!mounted) return;
          Navigator.pop(context);
        } else {
          await _offerBiometrics(authService);
          widget.onSetupComplete?.call();
        }
      } catch (_) {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.unexpectedError;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
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
          ? AppLocalizations.of(context)!.changePin
          : AppLocalizations.of(context)!.setupPin),
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
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.setupPinPrompt(AuthenticationService.minPinLength),
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _pinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.pin,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterPinPrompt;
                  }
                  if (value.length < AuthenticationService.minPinLength) {
                    return AppLocalizations.of(context)!.pinTooShort(AuthenticationService.minPinLength);
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return AppLocalizations.of(context)!.pinOnlyNumbers;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPinController,
                obscureText: true,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.confirmPin,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  errorText: _errorMessage,
                ),
                validator: (value) {
                  if (value != _pinController.text) {
                    return AppLocalizations.of(context)!.pinsDoNotMatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _setupPin,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(AppLocalizations.of(context)!.setPin),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}