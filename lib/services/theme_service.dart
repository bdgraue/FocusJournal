import 'package:flutter/material.dart';
import '../models/settings/theme_settings.dart';
import 'settings_service.dart';

/// Simplified theme service - only handles themeMode and dynamic theming toggle
class ThemeService extends ChangeNotifier {
  final SettingsService _settingsService;

  // Singleton pattern
  static ThemeService? _instance;

  static Future<ThemeService> getInstance() async {
    if (_instance == null) {
      final settingsService = await SettingsService.getInstance();
      _instance = ThemeService._(settingsService);
      _instance!._initialize();
    }
    return _instance!;
  }

  ThemeService._(this._settingsService);

  void _initialize() {
    _settingsService.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _settingsService.removeListener(notifyListeners);
    super.dispose();
  }

  // Get current theme settings
  ThemeSettings get themeSettings => _settingsService.settings.themeSettings;

  // Update theme settings
  Future<void> updateThemeSettings(ThemeSettings newSettings) async {
    await _settingsService.updateThemeSettings(
      (settings) => settings.copyWith(themeSettings: newSettings),
    );
    notifyListeners();
  }

  // Get current ThemeMode
  ThemeMode getThemeMode() => themeSettings.themeMode;

  // Update theme mode (System/Light/Dark)
  Future<void> setThemeMode(ThemeMode mode) async {
    await updateThemeSettings(themeSettings.copyWith(themeMode: mode));
  }

  // Update dynamic theming toggle
  Future<void> setDynamicTheming(bool enabled) async {
    await updateThemeSettings(
      themeSettings.copyWith(useDynamicTheming: enabled),
    );
  }

  // Get whether dynamic theming is enabled
  bool get useDynamicTheming => themeSettings.useDynamicTheming;
}
