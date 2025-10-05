enum SecurityLevel {
  none,
  low,
  medium,
  high
}

enum AuthMethod {
  none,
  pin,
  password,
  pattern,
  biometric
}

class SecuritySettings {
  final SecurityLevel securityLevel;
  final AuthMethod primaryAuthMethod;
  final bool enableBiometric;
  final Duration autoLockTimeout;
  final bool requireAuthOnStart;
  final bool requireAuthOnBackground;
  final bool hideAppContent;
  final bool enableSecureBackup;

  const SecuritySettings({
    this.securityLevel = SecurityLevel.medium,
    this.primaryAuthMethod = AuthMethod.pin,
    this.enableBiometric = true,
    this.autoLockTimeout = const Duration(minutes: 5),
    this.requireAuthOnStart = true,
    this.requireAuthOnBackground = true,
    this.hideAppContent = false,
    this.enableSecureBackup = true,
  });

  SecuritySettings copyWith({
    SecurityLevel? securityLevel,
    AuthMethod? primaryAuthMethod,
    bool? enableBiometric,
    Duration? autoLockTimeout,
    bool? requireAuthOnStart,
    bool? requireAuthOnBackground,
    bool? hideAppContent,
    bool? enableSecureBackup,
  }) {
    return SecuritySettings(
      securityLevel: securityLevel ?? this.securityLevel,
      primaryAuthMethod: primaryAuthMethod ?? this.primaryAuthMethod,
      enableBiometric: enableBiometric ?? this.enableBiometric,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      requireAuthOnStart: requireAuthOnStart ?? this.requireAuthOnStart,
      requireAuthOnBackground: requireAuthOnBackground ?? this.requireAuthOnBackground,
      hideAppContent: hideAppContent ?? this.hideAppContent,
      enableSecureBackup: enableSecureBackup ?? this.enableSecureBackup,
    );
  }

  Map<String, dynamic> toJson() => {
    'securityLevel': securityLevel.index,
    'primaryAuthMethod': primaryAuthMethod.index,
    'enableBiometric': enableBiometric,
    'autoLockTimeoutMinutes': autoLockTimeout.inMinutes,
    'requireAuthOnStart': requireAuthOnStart,
    'requireAuthOnBackground': requireAuthOnBackground,
    'hideAppContent': hideAppContent,
    'enableSecureBackup': enableSecureBackup,
  };

  factory SecuritySettings.fromJson(Map<String, dynamic> json) {
    return SecuritySettings(
      securityLevel: SecurityLevel.values[json['securityLevel'] as int],
      primaryAuthMethod: AuthMethod.values[json['primaryAuthMethod'] as int],
      enableBiometric: json['enableBiometric'] as bool,
      autoLockTimeout: Duration(minutes: json['autoLockTimeoutMinutes'] as int),
      requireAuthOnStart: json['requireAuthOnStart'] as bool,
      requireAuthOnBackground: json['requireAuthOnBackground'] as bool,
      hideAppContent: json['hideAppContent'] as bool,
      enableSecureBackup: json['enableSecureBackup'] as bool,
    );
  }
}