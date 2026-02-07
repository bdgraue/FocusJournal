import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../services/journal_service.dart';
import '../../services/privacy_service.dart';

/// Screen for managing privacy and data settings.
///
/// Allows users to control:
/// - Analytics and usage data collection
/// - Widget visibility and screenshot permissions
/// - Location data and crash reporting
/// - Data management (clear all data)
class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PrivacyService>(
      future: PrivacyService.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ChangeNotifierProvider.value(
            value: snapshot.data!,
            child: const _PrivacySettingsContent(),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class _PrivacySettingsContent extends StatefulWidget {
  const _PrivacySettingsContent();

  @override
  State<_PrivacySettingsContent> createState() =>
      _PrivacySettingsContentState();
}

class _PrivacySettingsContentState extends State<_PrivacySettingsContent> {
  late PrivacyService _service;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    _service = await PrivacyService.getInstance();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _showClearDataDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final journalService = await JournalService.create();
    final entryCount = await journalService.getEntryCount();

    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAllData),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.clearAllDataWarning),
            const SizedBox(height: 16),
            Text(
              l10n.entriesWillBeDeleted(entryCount),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.deleteAll),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await journalService.clearAllEntries();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.dataCleared)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorClearingData),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<PrivacyService>().settings;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyAndData),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Privacy Controls Section
          Text(
            l10n.privacyControls,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(l10n.collectAnalytics),
            subtitle: Text(l10n.collectAnalyticsDescription),
            secondary: const Icon(Icons.analytics_outlined),
            value: settings.collectAnalytics,
            onChanged: (value) => _service.setCollectAnalytics(value),
          ),
          SwitchListTile(
            title: Text(l10n.shareUsageData),
            subtitle: Text(l10n.shareUsageDataDescription),
            secondary: const Icon(Icons.share_outlined),
            value: settings.shareUsageData,
            onChanged: (value) => _service.setShareUsageData(value),
          ),
          SwitchListTile(
            title: Text(l10n.showJournalOnWidget),
            subtitle: Text(l10n.showJournalOnWidgetDescription),
            secondary: const Icon(Icons.widgets_outlined),
            value: settings.showJournalOnWidget,
            onChanged: (value) => _service.setShowJournalOnWidget(value),
          ),
          SwitchListTile(
            title: Text(l10n.allowScreenshots),
            subtitle: Text(l10n.allowScreenshotsDescription),
            secondary: const Icon(Icons.screenshot_outlined),
            value: settings.allowScreenshots,
            onChanged: (value) => _service.setAllowScreenshots(value),
          ),
          SwitchListTile(
            title: Text(l10n.storeLocationData),
            subtitle: Text(l10n.storeLocationDataDescription),
            secondary: const Icon(Icons.location_on_outlined),
            value: settings.storeLocationData,
            onChanged: (value) => _service.setStoreLocationData(value),
          ),
          SwitchListTile(
            title: Text(l10n.enableCrashReporting),
            subtitle: Text(l10n.enableCrashReportingDescription),
            secondary: const Icon(Icons.bug_report_outlined),
            value: settings.enableCrashReporting,
            onChanged: (value) => _service.setEnableCrashReporting(value),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),

          // Data Management Section
          Text(
            l10n.dataManagement,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(
              Icons.delete_forever,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(l10n.clearAllData),
            subtitle: Text(l10n.clearAllDataDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showClearDataDialog,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.clearDataWarningNote,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
