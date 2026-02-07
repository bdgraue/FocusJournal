import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../l10n/app_localizations.dart';
import '../services/backup_service.dart';
import '../services/journal_service.dart';
import '../models/import_strategy.dart';
import '../services/event_bus.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  ImportStrategy _selectedImportStrategy = ImportStrategy.smartMerge;
  late final Future<JournalService> _journalService = JournalService.create();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _exportJournal() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final service = await _journalService;
      final journalData = await service.exportData();
      await BackupService().exportJournal(
        journalData,
        _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.journalExportedSuccessfully)),
        );
      }
    } catch (e) {
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
      final currentData = await service.exportData();
      final importedData = await BackupService().importJournal(
        _passwordController.text,
        filePath,
      );

      BackupService().validateJournalData(importedData['data'] as Map<String, dynamic>);

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
        _isPasswordVisible = false;
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
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RadioListTile<ImportStrategy>(
                    title: Text(l10n.completeOverwrite),
                    subtitle: Text(l10n.replaceAllData),
                    value: ImportStrategy.completeOverwrite,
                    groupValue: _selectedImportStrategy,
                    onChanged: (ImportStrategy? value) {
                      setState(() => _selectedImportStrategy = value!);
                    },
                  ),
                  RadioListTile<ImportStrategy>(
                    title: Text(l10n.smartMerge),
                    subtitle: Text(l10n.mergeWithConflicts),
                    value: ImportStrategy.smartMerge,
                    groupValue: _selectedImportStrategy,
                    onChanged: (ImportStrategy? value) {
                      setState(() => _selectedImportStrategy = value!);
                    },
                  ),
                  RadioListTile<ImportStrategy>(
                    title: Text(l10n.addNewOnly),
                    subtitle: Text(l10n.onlyImportNew),
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
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(l10n.proceed),
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
          child: Card(
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
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton.icon(
                        onPressed: _exportJournal,
                        icon: const Icon(Icons.upload),
                        label: Text(AppLocalizations.of(context)!.createBackup),
                      ),
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
