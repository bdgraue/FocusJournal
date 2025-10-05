import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/settings/theme_settings.dart';
import 'settings_service.dart';

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

  // Get the ThemeData for light mode
  ThemeData getLightTheme() {
    final settings = themeSettings;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: settings.primaryColor,
      primary: settings.primaryColor,
      secondary: settings.accentColor,
      brightness: Brightness.light,
    );

    var theme = FlexThemeData.light(
      scheme: FlexScheme.material,
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarElevation: 0.5,
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        blendOnLevel: 20,
        blendOnColors: false,
        useTextTheme: true,
      ),
    );

    if (settings.useCustomFont && settings.customFontFamily != null) {
      theme = theme.copyWith(
        textTheme: GoogleFonts.getTextTheme(
          settings.customFontFamily!,
          theme.textTheme,
        ),
      );
    }

    return theme;
  }

  // Get the ThemeData for dark mode
  ThemeData getDarkTheme() {
    final settings = themeSettings;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: settings.primaryColor,
      primary: settings.primaryColor,
      secondary: settings.accentColor,
      brightness: Brightness.dark,
    );

    var theme = FlexThemeData.dark(
      scheme: FlexScheme.material,
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarElevation: 0.5,
      subThemesData: const FlexSubThemesData(
        interactionEffects: true,
        blendOnLevel: 20,
        blendOnColors: false,
        useTextTheme: true,
      ),
      darkIsTrueBlack: false,
    );

    if (settings.useCustomFont && settings.customFontFamily != null) {
      theme = theme.copyWith(
        textTheme: GoogleFonts.getTextTheme(
          settings.customFontFamily!,
          theme.textTheme,
        ),
      );
    }

    return theme;
  }

  // Get current ThemeMode
  ThemeMode getThemeMode() => themeSettings.themeMode;

  // Toggle between light and dark mode
  Future<void> toggleThemeMode() async {
    final currentMode = themeSettings.themeMode;
    final newMode = currentMode == ThemeMode.light
        ? ThemeMode.dark
        : currentMode == ThemeMode.dark
            ? ThemeMode.system
            : ThemeMode.light;

    await updateThemeSettings(themeSettings.copyWith(themeMode: newMode));
  }

  // Update primary color
  Future<void> updatePrimaryColor(Color color) async {
    await updateThemeSettings(themeSettings.copyWith(primaryColor: color));
  }

  // Update accent color
  Future<void> updateAccentColor(Color color) async {
    await updateThemeSettings(themeSettings.copyWith(accentColor: color));
  }

  // Update font settings
  Future<void> updateFontSettings({
    bool? useCustomFont,
    String? customFontFamily,
  }) async {
    await updateThemeSettings(
      themeSettings.copyWith(
        useCustomFont: useCustomFont,
        customFontFamily: customFontFamily,
      ),
    );
  }

  // Update dynamic theming
  Future<void> setDynamicTheming(bool enabled) async {
    await updateThemeSettings(themeSettings.copyWith(useDynamicTheming: enabled));
  }

  // Update contrast level
  Future<void> setContrastLevel(double level) async {
    await updateThemeSettings(themeSettings.copyWith(contrastLevel: level));
  }
}