import 'package:flutter/material.dart';
import 'backup_settings.dart';
import 'journal_preferences.dart';
import 'privacy_settings.dart';
import 'security_settings.dart';
import 'theme_settings.dart';

@immutable
class AppSettings {
  final JournalPreferences journalPreferences;
  final BackupSettings backupSettings;
  final SecuritySettings securitySettings;
  final ThemeSettings themeSettings;
  final PrivacySettings privacySettings;

  const AppSettings({
    this.journalPreferences = const JournalPreferences(),
    this.backupSettings = const BackupSettings(),
    this.securitySettings = const SecuritySettings(),
    this.themeSettings = const ThemeSettings(),
    this.privacySettings = const PrivacySettings(),
  });

  AppSettings copyWith({
    JournalPreferences? journalPreferences,
    BackupSettings? backupSettings,
    SecuritySettings? securitySettings,
    ThemeSettings? themeSettings,
    PrivacySettings? privacySettings,
  }) {
    return AppSettings(
      journalPreferences: journalPreferences ?? this.journalPreferences,
      backupSettings: backupSettings ?? this.backupSettings,
      securitySettings: securitySettings ?? this.securitySettings,
      themeSettings: themeSettings ?? this.themeSettings,
      privacySettings: privacySettings ?? this.privacySettings,
    );
  }

  Map<String, dynamic> toJson() => {
    'journalPreferences': journalPreferences.toJson(),
    'backupSettings': backupSettings.toJson(),
    'securitySettings': securitySettings.toJson(),
    'themeSettings': themeSettings.toJson(),
    'privacySettings': privacySettings.toJson(),
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      journalPreferences: JournalPreferences.fromJson(
        json['journalPreferences'] as Map<String, dynamic>,
      ),
      backupSettings: BackupSettings.fromJson(
        json['backupSettings'] as Map<String, dynamic>,
      ),
      securitySettings: SecuritySettings.fromJson(
        json['securitySettings'] as Map<String, dynamic>,
      ),
      themeSettings: ThemeSettings.fromJson(
        json['themeSettings'] as Map<String, dynamic>,
      ),
      privacySettings: PrivacySettings.fromJson(
        json['privacySettings'] as Map<String, dynamic>,
      ),
    );
  }
}
