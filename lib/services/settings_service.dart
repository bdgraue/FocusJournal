import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings/app_settings.dart';

class SettingsService extends ChangeNotifier {
  static const String _settingsKey = 'app_settings';
  final SharedPreferences _prefs;
  AppSettings _settings;
  
  // Singleton pattern
  static SettingsService? _instance;
  
  static Future<SettingsService> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = SettingsService._(prefs);
      await _instance!._loadSettings();
    }
    return _instance!;
  }

  SettingsService._(this._prefs) : _settings = const AppSettings();

  // Getters for all settings
  AppSettings get settings => _settings;
  
  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final String? settingsJson = _prefs.getString(_settingsKey);
    if (settingsJson != null) {
      try {
        final Map<String, dynamic> decoded = json.decode(settingsJson);
        _settings = AppSettings.fromJson(decoded);
      } catch (e) {
        debugPrint('Error loading settings: $e');
        _settings = const AppSettings(); // Use defaults if loading fails
      }
    } else {
      _settings = const AppSettings(); // Use defaults for first launch
    }
    notifyListeners();
  }

  // Save settings to SharedPreferences
  Future<void> saveSettings(AppSettings settings) async {
    try {
      final String encodedSettings = json.encode(settings.toJson());
      await _prefs.setString(_settingsKey, encodedSettings);
      _settings = settings;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving settings: $e');
      rethrow;
    }
  }

  // Convenience methods for updating individual settings sections
  Future<void> updateJournalPreferences(
    AppSettings Function(AppSettings) updateFunction,
  ) async {
    final newSettings = updateFunction(_settings);
    await saveSettings(newSettings);
  }

  Future<void> updateBackupSettings(
    AppSettings Function(AppSettings) updateFunction,
  ) async {
    final newSettings = updateFunction(_settings);
    await saveSettings(newSettings);
  }

  Future<void> updateSecuritySettings(
    AppSettings Function(AppSettings) updateFunction,
  ) async {
    final newSettings = updateFunction(_settings);
    await saveSettings(newSettings);
  }

  Future<void> updateThemeSettings(
    AppSettings Function(AppSettings) updateFunction,
  ) async {
    final newSettings = updateFunction(_settings);
    await saveSettings(newSettings);
  }

  Future<void> updatePrivacySettings(
    AppSettings Function(AppSettings) updateFunction,
  ) async {
    final newSettings = updateFunction(_settings);
    await saveSettings(newSettings);
  }

  // Reset settings to defaults
  Future<void> resetToDefaults() async {
    await saveSettings(const AppSettings());
  }

  // Example usage of section updates:
  // 
  // await settingsService.updateThemeSettings((current) => 
  //   current.copyWith(themeSettings: current.themeSettings.copyWith(
  //     themeMode: ThemeMode.dark
  //   ))
  // );
}