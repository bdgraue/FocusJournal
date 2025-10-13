import 'package:flutter/material.dart';

class ThemeSettings {
  final ThemeMode themeMode;
  final Color primaryColor;
  final Color accentColor;
  final bool useDynamicTheming;
  final double contrastLevel;
  final bool useCustomFont;
  final String? customFontFamily;

  const ThemeSettings({
    this.themeMode = ThemeMode.system,
    this.primaryColor = const Color(0xFF6200EE),
    this.accentColor = const Color(0xFF03DAC6),
    this.useDynamicTheming = true,
    this.contrastLevel = 1.0,
    this.useCustomFont = false,
    this.customFontFamily,
  });

  ThemeSettings copyWith({
    ThemeMode? themeMode,
    Color? primaryColor,
    Color? accentColor,
    bool? useDynamicTheming,
    double? contrastLevel,
    bool? useCustomFont,
    String? customFontFamily,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      useDynamicTheming: useDynamicTheming ?? this.useDynamicTheming,
      contrastLevel: contrastLevel ?? this.contrastLevel,
      useCustomFont: useCustomFont ?? this.useCustomFont,
      customFontFamily: customFontFamily ?? this.customFontFamily,
    );
  }

  Map<String, dynamic> toJson() => {
    'themeMode': themeMode.index,
    'primaryColor': primaryColor.value,
    'accentColor': accentColor.value,
    'useDynamicTheming': useDynamicTheming,
    'contrastLevel': contrastLevel,
    'useCustomFont': useCustomFont,
    'customFontFamily': customFontFamily,
  };

  factory ThemeSettings.fromJson(Map<String, dynamic> json) {
    return ThemeSettings(
      themeMode: ThemeMode.values[json['themeMode'] as int],
      primaryColor: Color(json['primaryColor'] as int),
      accentColor: Color(json['accentColor'] as int),
      useDynamicTheming: json['useDynamicTheming'] as bool,
      contrastLevel: json['contrastLevel'] as double,
      useCustomFont: json['useCustomFont'] as bool,
      customFontFamily: json['customFontFamily'] as String?,
    );
  }
}
