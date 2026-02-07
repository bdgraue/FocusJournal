import 'package:flutter/material.dart';
import 'backup_settings.dart';
import 'security_settings.dart';
import 'theme_settings.dart';

@immutable
class AppSettings {
  final BackupSettings backupSettings;
  final SecuritySettings securitySettings;
  final ThemeSettings themeSettings;

  const AppSettings({
    this.backupSettings = const BackupSettings(),
    this.securitySettings = const SecuritySettings(),
    this.themeSettings = const ThemeSettings(),
  });

  AppSettings copyWith({
    BackupSettings? backupSettings,
    SecuritySettings? securitySettings,
    ThemeSettings? themeSettings,
  }) {
    return AppSettings(
      backupSettings: backupSettings ?? this.backupSettings,
      securitySettings: securitySettings ?? this.securitySettings,
      themeSettings: themeSettings ?? this.themeSettings,
    );
  }

  Map<String, dynamic> toJson() => {
    'backupSettings': backupSettings.toJson(),
    'securitySettings': securitySettings.toJson(),
    'themeSettings': themeSettings.toJson(),
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
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
