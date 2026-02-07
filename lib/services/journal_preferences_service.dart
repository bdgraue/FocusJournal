import 'package:flutter/material.dart';
import '../models/settings/journal_preferences.dart';
import 'settings_service.dart';

/// Service for managing journal preferences and settings.
///
/// Provides access to user's journal customization including view mode,
/// sort order, font size, and display toggles. All changes are persisted
/// automatically via SettingsService.
///
/// Singleton pattern ensures single instance across app lifecycle.
/// Use `getInstance()` for async initialization.
class JournalPreferencesService extends ChangeNotifier {
  final SettingsService _settingsService;

  // Singleton pattern
  static JournalPreferencesService? _instance;

  static Future<JournalPreferencesService> getInstance() async {
    if (_instance == null) {
      final settingsService = await SettingsService.getInstance();
      _instance = JournalPreferencesService._(settingsService);
      _instance!._initialize();
    }
    return _instance!;
  }

  JournalPreferencesService._(this._settingsService);

  void _initialize() {
    _settingsService.addListener(notifyListeners);
  }

  @override
  void dispose() {
    _settingsService.removeListener(notifyListeners);
    super.dispose();
  }

  /// Gets current journal preferences
  JournalPreferences get preferences =>
      _settingsService.settings.journalPreferences;

  /// Updates journal preferences
  Future<void> updatePreferences(JournalPreferences newPreferences) async {
    await _settingsService.updateJournalPreferences(
      (settings) => settings.copyWith(journalPreferences: newPreferences),
    );
    notifyListeners();
  }

  /// Sets the default view mode (calendar/list/timeline)
  Future<void> setDefaultView(JournalViewMode mode) async {
    await updatePreferences(preferences.copyWith(defaultView: mode));
  }

  /// Sets the entry sort order
  Future<void> setSortOrder(EntrySortOrder order) async {
    await updatePreferences(preferences.copyWith(sortOrder: order));
  }

  /// Sets the font size
  Future<void> setFontSize(FontSize size) async {
    await updatePreferences(preferences.copyWith(fontSize: size));
  }

  /// Toggles date headers display
  Future<void> setShowDateHeaders(bool show) async {
    await updatePreferences(preferences.copyWith(showDateHeaders: show));
  }

  /// Toggles tags display
  Future<void> setShowTags(bool show) async {
    await updatePreferences(preferences.copyWith(showTags: show));
  }

  /// Toggles spell check
  Future<void> setEnableSpellCheck(bool enable) async {
    await updatePreferences(preferences.copyWith(enableSpellCheck: enable));
  }
}
