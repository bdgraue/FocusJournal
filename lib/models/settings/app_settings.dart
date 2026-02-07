import 'package:flutter/material.dart';
import 'backup_settings.dart';
import 'journal_preferences.dart';
import 'security_settings.dart';
import 'theme_settings.dart';

@immutable
class AppSettings {
  final JournalPreferences journalPreferences;
  final BackupSettings backupSettings;
  final SecuritySettings securitySettings;
  final ThemeSettings themeSettings;

  const AppSettings({
    this.journalPreferences = const JournalPreferences(),
    this.backupSettings = const BackupSettings(),
    this.securitySettings = const SecuritySettings(),
    this.themeSettings = const ThemeSettings(),
  });

  AppSettings copyWith({
    JournalPreferences? journalPreferences,
    BackupSettings? backupSettings,
    SecuritySettings? securitySettings,
    ThemeSettings? themeSettings,
  }) {
    return AppSettings(
      journalPreferences: journalPreferences ?? this.journalPreferences,
      backupSettings: backupSettings ?? this.backupSettings,
      securitySettings: securitySettings ?? this.securitySettings,
      themeSettings: themeSettings ?? this.themeSettings,
    );
  }

  Map<String, dynamic> toJson() => {
    'journalPreferences': journalPreferences.toJson(),
    'backupSettings': backupSettings.toJson(),
    'securitySettings': securitySettings.toJson(),
    'themeSettings': themeSettings.toJson(),
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      journalPreferences: JournalPreferences.fromJson(
        json['journalPreferences'] as Map<String, dynamic>? ?? {},
      ),
      backupSettings: BackupSettings.fromJson(
        json['backupSettings'] as Map<String, dynamic>? ?? {},
      ),
      securitySettings: SecuritySettings.fromJson(
        json['securitySettings'] as Map<String, dynamic>? ?? {},
      ),
      themeSettings: ThemeSettings.fromJson(
        json['themeSettings'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
