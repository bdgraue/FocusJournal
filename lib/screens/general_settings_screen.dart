import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../l10n/app_localizations.dart';
import '../services/backup_service.dart';
import '../services/journal_service.dart';
import '../models/import_strategy.dart';
import '../services/event_bus.dart';

class GeneralSettingsScreen extends StatefulWidget {
  final VoidCallback? onSetupComplete;
  final bool isChange;
  final bool isFirstTimeSetup;

  const GeneralSettingsScreen({
    super.key,
    this.onSetupComplete,
    this.isChange = false,
    this.isFirstTimeSetup = false,
  });

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  ImportStrategy _selectedImportStrategy = ImportStrategy.smartMerge;

  // Feature flags to temporarily hide inactive settings until implemented.
  // TODO(settings): Re-enable security section when implemented
  //  - Show current auth method from AuthenticationService.getCurrentAuthMethod()
  //  - Implement navigation to a functional security screen (change method, change PIN/password)
  //  - Remove hardcoded 'Pattern' subtitle
  final bool _showSecuritySection = false;

  // TODO(settings): Implement journal preferences (default view, sorting, font size)
  final bool _showJournalPreferencesSection = false;

  // TODO(settings): Implement notifications & reminders (scheduling, time picker, storage)
  final bool _showNotificationsSection = false;

  // TODO(settings): Implement customization (theme mode, language via localization, accent color)
  final bool _showCustomizationSection = false;

  // TODO(settings): Implement privacy & data (retention policy, analytics toggle, clear data flow)
  final bool _showPrivacySection = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  late final Future<JournalService> _journalService = JournalService.create();

  Future<void> _exportJournal() async {
    try {
      final service = await _journalService;
      final journalData = await service.exportData();
      await BackupService().exportJournal(
        journalData,
        _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Journal exported successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export journal: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _importJournal(String filePath) async {
    try {
      final service = await _journalService;
      final currentData = await service.exportData();
      final importedData = await BackupService().importJournal(
        _passwordController.text,
        filePath,
      );

      // Validate shape of decrypted data before proceeding
      BackupService().validateJournalData(importedData['data'] as Map<String, dynamic>);

      final mergedData = BackupService().mergeJournals(
        currentData,
        importedData['data'] as Map<String, dynamic>,
        _selectedImportStrategy,
      );

      // Compute a small summary for user feedback
      int currentCount = (currentData['entries'] as List?)?.length ?? 0;
      int importedCount = ((importedData['data'] as Map<String, dynamic>)['entries'] as List?)?.length ?? 0;
      int mergedCount = (mergedData['entries'] as List?)?.length ?? 0;

      // Heuristics for deltas
      final added = mergedCount - currentCount;
      final possiblyUpdated = (importedCount - (added > 0 ? added : 0)).clamp(0, importedCount);

      await service.importData(mergedData);

  // Notify app that journal data changed so UI can refresh
  AppEventBus().emit(AppEvents.journalChanged);

      if (mounted) {
        final msg = 'Import erfolgreich: +$added neue, ~$possiblyUpdated aktualisiert, gesamt $mergedCount.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        // Clear password field after import for security
        _passwordController.clear();
        _isPasswordVisible = false;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to import journal: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _showImportStrategyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Import Strategy'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<ImportStrategy>(
                    title: const Text('Complete Overwrite'),
                    subtitle: const Text('Replace all existing data'),
                    value: ImportStrategy.completeOverwrite,
                    groupValue: _selectedImportStrategy,
                    onChanged: (ImportStrategy? value) {
                      setState(() => _selectedImportStrategy = value!);
                    },
                  ),
                  RadioListTile<ImportStrategy>(
                    title: const Text('Smart Merge (Recommended)'),
                    subtitle: const Text('Merge with conflict resolution'),
                    value: ImportStrategy.smartMerge,
                    groupValue: _selectedImportStrategy,
                    onChanged: (ImportStrategy? value) {
                      setState(() => _selectedImportStrategy = value!);
                    },
                  ),
                  RadioListTile<ImportStrategy>(
                    title: const Text('Add New Only'),
                    subtitle: const Text('Only import new entries'),
                    value: ImportStrategy.addNewOnly,
                    groupValue: _selectedImportStrategy,
                    onChanged: (ImportStrategy? value) {
                      setState(() => _selectedImportStrategy = value!);
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Proceed'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['fjb'],
                    allowMultiple: false,
                  );

                  if (result != null && result.files.isNotEmpty) {
                    final file = result.files.first;
                    if (file.path != null) {
                      await _importJournal(file.path!);
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not get file path'),
                          ),
                        );
                      }
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No file selected')),
                      );
                    }
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to pick file: ${e.toString()}'),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.settings ?? 'Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Security Section (hidden until implemented)
              if (_showSecuritySection)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.securitySettings ??
                              'Security Settings',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.lock_outline),
                          title: Text(
                            AppLocalizations.of(context)?.currentAuthMethod ??
                                'Current Authentication Method',
                          ),
                          subtitle: const Text(
                            'Pattern',
                          ), // TODO: wire actual current method
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Implement security screen navigation
                            // Navigator.pushNamed(context, '/security');
                          },
                        ),
                        // TODO: Implement biometrics or remove if not planned
                        // ListTile(
                        //   leading: const Icon(Icons.fingerprint),
                        //   title: Text(
                        //     AppLocalizations.of(context)?.enableBiometrics ??
                        //         'Enable Biometric Authentication',
                        //   ),
                        //   trailing: Switch(
                        //     value: false,
                        //     onChanged: (bool value) {},
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Data Backup & Recovery Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Backup & Recovery',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.security),
                        title: const Text('Backup Password'),
                        subtitle: const Text(
                          'Set a password to secure your backups',
                        ),
                      ),
                      // Password used for encryption/decryption of backups
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
              labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _exportJournal,
                            icon: const Icon(Icons.upload),
                            label: const Text('Create Backup'),
                          ),
                          ElevatedButton.icon(
                            onPressed: _showImportStrategyDialog,
                            icon: const Icon(Icons.download),
                            label: const Text('Restore Backup'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Journal Preferences Section (hidden until implemented)
              if (_showJournalPreferencesSection)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Journal Preferences',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.view_agenda),
                          title: const Text('Default View'),
                          subtitle: const Text('Calendar View'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Open view selector
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.sort),
                          title: const Text('Entry Sorting'),
                          subtitle: const Text('Newest First'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Open sorting options
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.text_fields),
                          title: const Text('Default Font Size'),
                          subtitle: const Text('Medium'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Open font size selector
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Notifications & Reminders Section (hidden until implemented)
              if (_showNotificationsSection)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notifications & Reminders',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Daily Reminders'),
                          subtitle: const Text('Remind me to write daily'),
                          secondary: const Icon(Icons.notifications_active),
                          value: false, // Replace with actual state
                          onChanged: (bool value) {
                            // TODO: Handle reminder toggle
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.access_time),
                          title: const Text('Reminder Time'),
                          subtitle: const Text('8:00 PM'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Open time picker
                          },
                        ),
                        SwitchListTile(
                          title: const Text('Weekly Summary'),
                          subtitle: const Text(
                            'Get a weekly review of your entries',
                          ),
                          secondary: const Icon(Icons.summarize),
                          value: false, // Replace with actual state
                          onChanged: (bool value) {
                            // TODO: Handle weekly summary toggle
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Customization Section (hidden until implemented)
              if (_showCustomizationSection)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customization',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.color_lens),
                          title: const Text('Theme'),
                          subtitle: const Text('Light'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Open theme selector
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.language),
                          title: const Text('Language'),
                          subtitle: const Text('English'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Open language selector
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.format_paint),
                          title: const Text('Accent Color'),
                          subtitle: const Text('Blue'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Open accent color selector
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Privacy & Data Section (hidden until implemented)
              if (_showPrivacySection)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy & Data',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.auto_delete),
                          title: const Text('Data Retention'),
                          subtitle: const Text('Keep entries forever'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Open data retention settings
                          },
                        ),
                        SwitchListTile(
                          title: const Text('Analytics'),
                          subtitle: const Text(
                            'Help improve the app by sharing usage data',
                          ),
                          secondary: const Icon(Icons.analytics),
                          value: false, // Replace with actual state
                          onChanged: (bool value) {
                            // TODO: Handle analytics toggle
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.folder_delete),
                          title: const Text('Clear App Data'),
                          subtitle: const Text(
                            'Remove all app data and settings',
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Show clear data confirmation dialog
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
