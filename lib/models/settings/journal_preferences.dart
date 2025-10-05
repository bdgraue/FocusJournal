import 'package:flutter/material.dart';

enum JournalViewMode {
  calendar,
  list,
  timeline
}

enum EntrySortOrder {
  newestFirst,
  oldestFirst,
  titleAscending,
  titleDescending
}

enum FontSize {
  small,
  medium,
  large,
  extraLarge
}

class JournalPreferences {
  final JournalViewMode defaultView;
  final EntrySortOrder sortOrder;
  final FontSize fontSize;
  final bool showDateHeaders;
  final bool showTags;
  final bool enableSpellCheck;

  const JournalPreferences({
    this.defaultView = JournalViewMode.calendar,
    this.sortOrder = EntrySortOrder.newestFirst,
    this.fontSize = FontSize.medium,
    this.showDateHeaders = true,
    this.showTags = true,
    this.enableSpellCheck = true,
  });

  JournalPreferences copyWith({
    JournalViewMode? defaultView,
    EntrySortOrder? sortOrder,
    FontSize? fontSize,
    bool? showDateHeaders,
    bool? showTags,
    bool? enableSpellCheck,
  }) {
    return JournalPreferences(
      defaultView: defaultView ?? this.defaultView,
      sortOrder: sortOrder ?? this.sortOrder,
      fontSize: fontSize ?? this.fontSize,
      showDateHeaders: showDateHeaders ?? this.showDateHeaders,
      showTags: showTags ?? this.showTags,
      enableSpellCheck: enableSpellCheck ?? this.enableSpellCheck,
    );
  }

  Map<String, dynamic> toJson() => {
    'defaultView': defaultView.index,
    'sortOrder': sortOrder.index,
    'fontSize': fontSize.index,
    'showDateHeaders': showDateHeaders,
    'showTags': showTags,
    'enableSpellCheck': enableSpellCheck,
  };

  factory JournalPreferences.fromJson(Map<String, dynamic> json) {
    return JournalPreferences(
      defaultView: JournalViewMode.values[json['defaultView'] as int],
      sortOrder: EntrySortOrder.values[json['sortOrder'] as int],
      fontSize: FontSize.values[json['fontSize'] as int],
      showDateHeaders: json['showDateHeaders'] as bool,
      showTags: json['showTags'] as bool,
      enableSpellCheck: json['enableSpellCheck'] as bool,
    );
  }
}