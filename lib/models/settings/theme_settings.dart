import 'package:flutter/material.dart';

/// Simplified theme settings - only themeMode and dynamic color toggle
class ThemeSettings {
  final ThemeMode themeMode;
  final bool useDynamicTheming;

  const ThemeSettings({
    this.themeMode = ThemeMode.system,
    this.useDynamicTheming = true,
  });

  ThemeSettings copyWith({
    ThemeMode? themeMode,
    bool? useDynamicTheming,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      useDynamicTheming: useDynamicTheming ?? this.useDynamicTheming,
    );
  }

  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.index,
    'useDynamicTheming': useDynamicTheming,
  };

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? 0],
      useDynamicTheming: json['useDynamicTheming'] as bool? ?? true,
    );
  }
}
