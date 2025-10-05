import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../l10n/app_localizations.dart';
import '../services/backup_service.dart';
import '../services/journal_service.dart';
import '../models/import_strategy.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  ImportStrategy _selectedImportStrategy = ImportStrategy.smartMerge;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  late final Future<JournalService> _journalService = JournalService.create();

  Future<void> _exportJournal() async {
    try {
      final service = await _journalService;
      final journalData = await service.exportData();
      await BackupService().exportJournal(journalData, _passwordController.text);
      
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
      
      final mergedData = BackupService().mergeJournals(
        currentData,
        importedData['data'] as Map<String, dynamic>,
        _selectedImportStrategy,
      );
      
      await service.importData(mergedData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Journal imported successfully')),
        );
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
                          const SnackBar(content: Text('Could not get file path')),
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
                      SnackBar(content: Text('Failed to pick file: ${e.toString()}')),
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
              // Security Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.securitySettings ?? 'Security Settings',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: Text(AppLocalizations.of(context)?.currentAuthMethod ?? 'Current Authentication Method'),
                        subtitle: Text('Pattern'), // Replace with actual current method
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pushNamed(context, '/security');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.fingerprint),
                        title: Text(AppLocalizations.of(context)?.enableBiometrics ?? 'Enable Biometric Authentication'),
                        trailing: Switch(
                          value: false, // Replace with actual biometrics state
                          onChanged: (bool value) {
                            // Handle biometrics toggle
                          },
                        ),
                      ),
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
                        title: Text(AppLocalizations.of(context)?.password ?? 'Backup Password'),
                        subtitle: const Text('Set a password to secure your backups'),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.password ?? 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
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
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.confirmPin ?? 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                          ),
                        ),
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
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
              // Journal Preferences Section
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
                          // Open view selector
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.sort),
                        title: const Text('Entry Sorting'),
                        subtitle: const Text('Newest First'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Open sorting options
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.text_fields),
                        title: const Text('Default Font Size'),
                        subtitle: const Text('Medium'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Open font size selector
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Notifications & Reminders Section
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
                          // Handle reminder toggle
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.access_time),
                        title: const Text('Reminder Time'),
                        subtitle: const Text('8:00 PM'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Open time picker
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Weekly Summary'),
                        subtitle: const Text('Get a weekly review of your entries'),
                        secondary: const Icon(Icons.summarize),
                        value: false, // Replace with actual state
                        onChanged: (bool value) {
                          // Handle weekly summary toggle
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Customization Section
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
                          // Open theme selector
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text('Language'),
                        subtitle: const Text('English'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Open language selector
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.format_paint),
                        title: const Text('Accent Color'),
                        subtitle: const Text('Blue'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Open accent color selector
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Privacy & Data Section
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
                          // Open data retention settings
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Analytics'),
                        subtitle: const Text('Help improve the app by sharing usage data'),
                        secondary: const Icon(Icons.analytics),
                        value: false, // Replace with actual state
                        onChanged: (bool value) {
                          // Handle analytics toggle
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.folder_delete),
                        title: const Text('Clear App Data'),
                        subtitle: const Text('Remove all app data and settings'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Show clear data confirmation dialog
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