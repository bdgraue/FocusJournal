import 'package:flutter/material.dart';
import '../models/settings/privacy_settings.dart';
import 'settings_service.dart';

/// Service for managing privacy and data settings.
///
/// Provides access to user's privacy preferences including analytics,
/// data sharing, widget visibility, and crash reporting settings.
/// All changes are persisted automatically via SettingsService.
///
/// Singleton pattern ensures single instance across app lifecycle.
/// Use `getInstance()` for async initialization.
class PrivacyService extends ChangeNotifier {
  final SettingsService _settingsService;

  // Singleton pattern
  static PrivacyService? _instance;

  static Future<PrivacyService> getInstance() async {
    if (_instance == null) {
      final settingsService = await SettingsService.getInstance();
      _instance = PrivacyService._(settingsService);
      _instance!._initialize();
    }
    return _instance!;
  }

  PrivacyService._(this._settingsService);

  void _initialize() {
    _settingsService.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _settingsService.removeListener(notifyListeners);
    super.dispose();
  }

  /// Gets current privacy settings
  PrivacySettings get settings => _settingsService.settings.privacySettings;

  /// Updates privacy settings
  Future<void> updateSettings(PrivacySettings newSettings) async {
    await _settingsService.updatePrivacySettings(
      (appSettings) => appSettings.copyWith(privacySettings: newSettings),
    );
    notifyListeners();
  }

  /// Toggles analytics collection
  Future<void> setCollectAnalytics(bool enabled) async {
    await updateSettings(settings.copyWith(collectAnalytics: enabled));
  }

  /// Toggles usage data sharing
  Future<void> setShareUsageData(bool enabled) async {
    await updateSettings(settings.copyWith(shareUsageData: enabled));
  }

  /// Toggles journal visibility on widget
  Future<void> setShowJournalOnWidget(bool enabled) async {
    await updateSettings(settings.copyWith(showJournalOnWidget: enabled));
  }

  /// Toggles screenshot permission
  Future<void> setAllowScreenshots(bool enabled) async {
    await updateSettings(settings.copyWith(allowScreenshots: enabled));
  }

  /// Toggles location data storage
  Future<void> setStoreLocationData(bool enabled) async {
    await updateSettings(settings.copyWith(storeLocationData: enabled));
  }

  /// Toggles crash reporting
  Future<void> setEnableCrashReporting(bool enabled) async {
    await updateSettings(settings.copyWith(enableCrashReporting: enabled));
  }
}
