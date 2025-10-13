enum BackupFrequency { never, daily, weekly, monthly }

enum BackupRetentionPolicy {
  keepAll,
  keepLast5,
  keepLast10,
  keepLastMonth,
  keepLastYear,
}

class BackupSettings {
  final bool autoBackupEnabled;
  final BackupFrequency frequency;
  final BackupRetentionPolicy retentionPolicy;
  final List<String> selectedFolders;
  final bool includeAttachments;
  final bool encryptBackups;

  const BackupSettings({
    this.autoBackupEnabled = true,
    this.frequency = BackupFrequency.weekly,
    this.retentionPolicy = BackupRetentionPolicy.keepLastMonth,
    this.selectedFolders = const [],
    this.includeAttachments = true,
    this.encryptBackups = true,
  });

  BackupSettings copyWith({
    bool? autoBackupEnabled,
    BackupFrequency? frequency,
    BackupRetentionPolicy? retentionPolicy,
    List<String>? selectedFolders,
    bool? includeAttachments,
    bool? encryptBackups,
  }) {
    return BackupSettings(
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      frequency: frequency ?? this.frequency,
      retentionPolicy: retentionPolicy ?? this.retentionPolicy,
      selectedFolders: selectedFolders ?? this.selectedFolders,
      includeAttachments: includeAttachments ?? this.includeAttachments,
      encryptBackups: encryptBackups ?? this.encryptBackups,
    );
  }

  Map<String, dynamic> toJson() => {
    'autoBackupEnabled': autoBackupEnabled,
    'frequency': frequency.index,
    'retentionPolicy': retentionPolicy.index,
    'selectedFolders': selectedFolders,
    'includeAttachments': includeAttachments,
    'encryptBackups': encryptBackups,
  };

  factory BackupSettings.fromJson(Map<String, dynamic> json) {
    return BackupSettings(
      autoBackupEnabled: json['autoBackupEnabled'] as bool,
      frequency: BackupFrequency.values[json['frequency'] as int],
      retentionPolicy:
          BackupRetentionPolicy.values[json['retentionPolicy'] as int],
      selectedFolders: List<String>.from(json['selectedFolders'] as List),
      includeAttachments: json['includeAttachments'] as bool,
      encryptBackups: json['encryptBackups'] as bool,
    );
  }
}
