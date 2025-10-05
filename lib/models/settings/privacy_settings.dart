class PrivacySettings {
  final bool collectAnalytics;
  final bool shareUsageData;
  final bool showJournalOnWidget;
  final bool allowScreenshots;
  final bool storeLocationData;
  final bool enableCrashReporting;
  final List<String> excludedDataTypes;

  const PrivacySettings({
    this.collectAnalytics = false,
    this.shareUsageData = false,
    this.showJournalOnWidget = false,
    this.allowScreenshots = true,
    this.storeLocationData = false,
    this.enableCrashReporting = true,
    this.excludedDataTypes = const [],
  });

  PrivacySettings copyWith({
    bool? collectAnalytics,
    bool? shareUsageData,
    bool? showJournalOnWidget,
    bool? allowScreenshots,
    bool? storeLocationData,
    bool? enableCrashReporting,
    List<String>? excludedDataTypes,
  }) {
    return PrivacySettings(
      collectAnalytics: collectAnalytics ?? this.collectAnalytics,
      shareUsageData: shareUsageData ?? this.shareUsageData,
      showJournalOnWidget: showJournalOnWidget ?? this.showJournalOnWidget,
      allowScreenshots: allowScreenshots ?? this.allowScreenshots,
      storeLocationData: storeLocationData ?? this.storeLocationData,
      enableCrashReporting: enableCrashReporting ?? this.enableCrashReporting,
      excludedDataTypes: excludedDataTypes ?? this.excludedDataTypes,
    );
  }

  Map<String, dynamic> toJson() => {
    'collectAnalytics': collectAnalytics,
    'shareUsageData': shareUsageData,
    'showJournalOnWidget': showJournalOnWidget,
    'allowScreenshots': allowScreenshots,
    'storeLocationData': storeLocationData,
    'enableCrashReporting': enableCrashReporting,
    'excludedDataTypes': excludedDataTypes,
  };

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      collectAnalytics: json['collectAnalytics'] as bool,
      shareUsageData: json['shareUsageData'] as bool,
      showJournalOnWidget: json['showJournalOnWidget'] as bool,
      allowScreenshots: json['allowScreenshots'] as bool,
      storeLocationData: json['storeLocationData'] as bool,
      enableCrashReporting: json['enableCrashReporting'] as bool,
      excludedDataTypes: List<String>.from(json['excludedDataTypes'] as List),
    );
  }
}