import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../main.dart' show LockSuppression;
import '../services/backup_service.dart';
import '../services/export_service.dart';
import '../services/journal_service.dart';
import '../models/import_strategy.dart';
import '../services/event_bus.dart';
import '../widgets/material3_card.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  ImportStrategy _selectedImportStrategy = ImportStrategy.smartMerge;
  late final Future<JournalService> _journalService = JournalService.create();
  ExportService? _exportService;

  static const _minBackupPasswordLength = 6;

  Future<ExportService> get _getExportService async {
    if (_exportService != null) return _exportService!;
    final journalService = await _journalService;
    _exportService = ExportService(journalService: journalService);
    return _exportService!;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _passwordController.dispose();
    // Ensure lock suppression is reset when leaving the screen
    try {
      context.read<LockSuppression>().value = false;
    } catch (_) {
      // Context might not be available during dispose
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Clear password when app goes to background for security
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      _passwordController.clear();
      setState(() => _isPasswordVisible = false);
    }
  }

  Future<void> _exportJournal() async {
    if (!_formKey.currentState!.validate()) return;

    final lockSuppression = context.read<LockSuppression>();

    try {
      lockSuppression.value = true; // Prevent lock during file operations
      final exportService = await _getExportService;
      await exportService.exportData(_passwordController.text);
      lockSuppression.value = false;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.journalExportedSuccessfully)),
        );
        _passwordController.clear();
        setState(() => _isPasswordVisible = false);
      }
    } catch (e) {
      lockSuppression.value = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.exportFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _saveJournalLocally() async {
    if (!_formKey.currentState!.validate()) return;

    final lockSuppression = context.read<LockSuppression>();

    try {
      lockSuppression.value = true; // Prevent lock during file picker
      final exportService = await _getExportService;
      final savedPath = await exportService.exportDataToLocal(_passwordController.text);
      lockSuppression.value = false;

      if (mounted) {
        if (savedPath != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.backupSavedTo(savedPath))),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.noFileSelected)),
          );
        }
        _passwordController.clear();
        setState(() => _isPasswordVisible = false);
      }
    } catch (e) {
      lockSuppression.value = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.exportFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _importJournal(String filePath) async {
    try {
      final service = await _journalService;
      final exportService = await _getExportService;

      final currentData = await service.exportData();

      // Auto-detect backup format and import
      final importedData = await exportService.importDataAuto(
        _passwordController.text,
        filePath,
      );

      final mergedData = BackupService().mergeJournals(
        currentData,
        importedData['data'] as Map<String, dynamic>,
        _selectedImportStrategy,
      );

      int currentCount = (currentData['entries'] as List?)?.length ?? 0;
      int importedCount = ((importedData['data'] as Map<String, dynamic>)['entries'] as List?)?.length ?? 0;
      int mergedCount = (mergedData['entries'] as List?)?.length ?? 0;

      final added = mergedCount - currentCount;
      final possiblyUpdated = (importedCount - (added > 0 ? added : 0)).clamp(0, importedCount);

      await service.importData(mergedData);

      AppEventBus().emit(AppEvents.journalChanged);

      if (mounted) {
        final msg = AppLocalizations.of(context)!.importSuccessMessage(added, possiblyUpdated, mergedCount);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        _passwordController.clear();
        setState(() => _isPasswordVisible = false);
      }
    } on InvalidBackupPasswordException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.importFailed('Invalid password or corrupted backup file')),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.importFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _showImportStrategyDialog() async {
    if (!_formKey.currentState!.validate()) return;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.importStrategy),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return RadioGroup<ImportStrategy>(
                groupValue: _selectedImportStrategy,
                onChanged: (ImportStrategy? value) {
                  setState(() => _selectedImportStrategy = value!);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(l10n.completeOverwrite),
                      subtitle: Text(l10n.replaceAllData),
                      leading: Radio<ImportStrategy>(
                        value: ImportStrategy.completeOverwrite,
                      ),
                      onTap: () {
                        setState(() => _selectedImportStrategy = ImportStrategy.completeOverwrite);
                      },
                    ),
                    ListTile(
                      title: Text(l10n.smartMerge),
                      subtitle: Text(l10n.mergeWithConflicts),
                      leading: Radio<ImportStrategy>(
                        value: ImportStrategy.smartMerge,
                      ),
                      onTap: () {
                        setState(() => _selectedImportStrategy = ImportStrategy.smartMerge);
                      },
                    ),
                    ListTile(
                      title: Text(l10n.addNewOnly),
                      subtitle: Text(l10n.onlyImportNew),
                      leading: Radio<ImportStrategy>(
                        value: ImportStrategy.addNewOnly,
                      ),
                      onTap: () {
                        setState(() => _selectedImportStrategy = ImportStrategy.addNewOnly);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(l10n.proceed),
              onPressed: () async {
                final lockSuppression = context.read<LockSuppression>();

                // CRITICAL: Save password BEFORE dialog closes and lifecycle clears it
                final savedPassword = _passwordController.text;

                Navigator.of(context).pop();

                try {
                  lockSuppression.value = true; // Prevent lock during file picker
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['fjb'],
                    allowMultiple: false,
                  );
                  lockSuppression.value = false;

                  if (result != null && result.files.isNotEmpty) {
                    final file = result.files.first;
                    if (file.path != null) {
                      // Restore password before import
                      _passwordController.text = savedPassword;
                      await _importJournal(file.path!);
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.couldNotGetFilePath),
                          ),
                        );
                      }
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.noFileSelected)),
                      );
                    }
                  }
                } catch (e) {
                  lockSuppression.value = false;
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.filePickFailed(e.toString())),
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
        title: Text(AppLocalizations.of(context)!.backupAndRecovery),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Material3Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: Text(AppLocalizations.of(context)!.backupPasswordLabel),
                    subtitle: Text(
                      AppLocalizations.of(context)!.backupPasswordHint,
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.password,
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
                        return AppLocalizations.of(context)!.passwordRequired;
                      }
                      if (value.length < _minBackupPasswordLength) {
                        return 'Password must be at least $_minBackupPasswordLength characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton.icon(
                        onPressed: _saveJournalLocally,
                        icon: const Icon(Icons.save),
                        label: Text(AppLocalizations.of(context)!.saveBackupLocally),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _exportJournal,
                        icon: const Icon(Icons.share),
                        label: Text(AppLocalizations.of(context)!.createAndShareBackup),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _showImportStrategyDialog,
                        icon: const Icon(Icons.download),
                        label: Text(AppLocalizations.of(context)!.restoreBackup),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
