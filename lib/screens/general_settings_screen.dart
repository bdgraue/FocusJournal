import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/authentication_service.dart';
import '../services/notification_service.dart';
import 'acknowledgments_screen.dart';
import 'backup_screen.dart';
import 'security_settings_screen.dart';

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
  final _authService = AuthenticationService();
  final _notificationService = NotificationService();
  bool _notificationsEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 20, minute: 0);

  // Feature flags to temporarily hide inactive settings until implemented.
  final bool _showSecuritySection = true;
  String _currentAuthMethod = AuthenticationService.authMethodPassword;

  // TODO(settings): Implement journal preferences (default view, sorting, font size)
  final bool _showJournalPreferencesSection = false;

  // TODO(settings): Implement customization (theme mode, language via localization, accent color)
  final bool _showCustomizationSection = false;

  // TODO(settings): Implement privacy & data (retention policy, analytics toggle, clear data flow)
  final bool _showPrivacySection = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationState();
    _loadAuthMethod();
  }

  Future<void> _loadAuthMethod() async {
    final method = await _authService.getCurrentAuthMethod();
    setState(() {
      _currentAuthMethod = method;
    });
  }

  Future<void> _loadNotificationState() async {
    await _notificationService.initialize();
    final enabled = await _notificationService.isEnabled();
    final time = await _notificationService.getScheduledTime();
    setState(() {
      _notificationsEnabled = enabled;
      _reminderTime = TimeOfDay(hour: time.$1, minute: time.$2);
    });
  }

  Future<void> _toggleNotifications(bool enabled) async {
    if (enabled) {
      final granted = await _notificationService.requestPermission();
      if (!granted) return;
    }
    await _notificationService.setEnabled(enabled);
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) {
      await _notificationService.setScheduledTime(picked.hour, picked.minute);
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  String _getAuthMethodDisplayName(String method) {
    switch (method) {
      case AuthenticationService.authMethodPassword:
        return AppLocalizations.of(context)!.password;
      case AuthenticationService.authMethodPin:
        return AppLocalizations.of(context)!.pin;
      case AuthenticationService.authMethodPattern:
        return AppLocalizations.of(context)!.pattern;
      default:
        return AppLocalizations.of(context)!.password;
    }
  }

  IconData _getAuthMethodIcon(String method) {
    switch (method) {
      case AuthenticationService.authMethodPassword:
        return Icons.lock_outline;
      case AuthenticationService.authMethodPin:
        return Icons.pin_outlined;
      case AuthenticationService.authMethodPattern:
        return Icons.grid_3x3_outlined;
      default:
        return Icons.lock_outline;
    }
  }

  void _navigateToSecuritySettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SecuritySettingsScreen(),
      ),
    ).then((_) => _loadAuthMethod());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.settings ?? 'Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Notifications & Reminders
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.notificationsAndReminders,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        secondary: const Icon(Icons.notifications_active),
                        title: Text(AppLocalizations.of(context)!.dailyReminders),
                        subtitle: Text(
                          AppLocalizations.of(context)!.dailyRemindersDescription,
                        ),
                        value: _notificationsEnabled,
                        onChanged: _toggleNotifications,
                      ),
                      if (_notificationsEnabled)
                        ListTile(
                          leading: const Icon(Icons.access_time),
                          title: Text(AppLocalizations.of(context)!.reminderTime),
                          subtitle: Text(_reminderTime.format(context)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _pickReminderTime,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Security Section
              if (_showSecuritySection)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.securitySettings,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: Icon(_getAuthMethodIcon(_currentAuthMethod)),
                          title: Text(
                            AppLocalizations.of(context)!.currentAuthMethod,
                          ),
                          subtitle: Text(
                            _getAuthMethodDisplayName(_currentAuthMethod),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _navigateToSecuritySettings,
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Data Backup & Recovery Section
              Card(
                child: ListTile(
                  leading: const Icon(Icons.backup),
                  title: Text(AppLocalizations.of(context)!.backupAndRecovery),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const BackupScreen(),
                    ),
                  ),
                ),
              ),
              // Acknowledgments
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.favorite, color: Colors.pink),
                  title: Text(AppLocalizations.of(context)!.credits),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AcknowledgmentsScreen(),
                    ),
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
    );
  }
}
