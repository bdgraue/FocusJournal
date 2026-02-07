import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/authentication_service.dart';
import '../services/notification_service.dart';
import '../services/theme_service.dart';
import '../widgets/material3_card.dart';
import 'acknowledgments_screen.dart';
import 'backup_screen.dart';
import 'security_settings_screen.dart';
import 'settings/journal_preferences_screen.dart';
import 'settings/privacy_settings_screen.dart';
import 'theme_settings_screen.dart';

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
  ThemeService? _themeService;
  ThemeMode _currentThemeMode = ThemeMode.system;

  // Feature flags to temporarily hide inactive settings until implemented.
  final bool _showSecuritySection = true;
  String _currentAuthMethod = AuthenticationService.authMethodPassword;

  // Journal preferences feature is now implemented
  final bool _showJournalPreferencesSection = true;

  // TODO(settings): Implement language selector and additional customization options
  final bool _showCustomizationSection = true;

  // Privacy & Data feature is now implemented
  final bool _showPrivacySection = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationState();
    _loadAuthMethod();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    _themeService = await ThemeService.getInstance();
    setState(() {
      _currentThemeMode = _themeService!.getThemeMode();
    });
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

  String _getThemeModeDisplayName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return AppLocalizations.of(context)!.systemTheme;
      case ThemeMode.light:
        return AppLocalizations.of(context)!.lightMode;
      case ThemeMode.dark:
        return AppLocalizations.of(context)!.darkMode;
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
              Material3Card(
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
                Material3Card(
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
              Material3Card(
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
              Material3Card(
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
              // Journal Preferences Section
              if (_showJournalPreferencesSection)
                Material3Card(
                  child: ListTile(
                    leading: const Icon(Icons.tune),
                    title: Text(AppLocalizations.of(context)!.journalPreferences),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const JournalPreferencesScreen(),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Customization Section
              if (_showCustomizationSection)
                Material3Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.appearance,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          leading: const Icon(Icons.palette_outlined),
                          title: Text(AppLocalizations.of(context)!.themeSettings),
                          subtitle: Text(_getThemeModeDisplayName(_currentThemeMode)),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ThemeSettingsScreen(),
                            ),
                          ).then((_) => _loadThemeMode()),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // Privacy & Data Section
              if (_showPrivacySection)
                Material3Card(
                  child: ListTile(
                    leading: const Icon(Icons.privacy_tip),
                    title: Text(AppLocalizations.of(context)!.privacyAndData),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacySettingsScreen(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
      ),
    );
  }
}
