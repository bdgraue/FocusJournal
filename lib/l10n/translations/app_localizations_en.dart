import '../app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([super.locale = 'en']);

  @override
  String get appTitle => 'Focus Journal';

  @override
  String get authenticationRequired => 'Authentication Required';

  @override
  String get setupPin => 'Setup PIN';

  @override
  String get enterPasswordPrompt => 'Enter your password';

  @override
  String get enterPinPrompt => 'Enter your PIN';

  @override
  String get setupPasswordPrompt => 'Setup your password';

  @override
  String setupPinPrompt(int minLength) {
    return 'Setup your PIN (minimum $minLength digits)';
  }

  @override
  String get password => 'Password';

  @override
  String get pin => 'PIN';

  @override
  String get unlock => 'Unlock';

  @override
  String get setPassword => 'Set Password';

  @override
  String get setPin => 'Set PIN';

  @override
  String get changePassword => 'Change Password';

  @override
  String get setupPassword => 'Setup Password';

  @override
  String get journal => 'Journal';

  @override
  String get settings => 'Settings';

  @override
  String get welcomeToJournal => 'Welcome to Focus Journal';

  @override
  String get journalDescription =>
      'Your secure space for focused thoughts and reflections.';

  @override
  String get setupSecurity => 'Setup Security';

  @override
  String get chooseAuthMethod => 'Choose your authentication method';

  @override
  String get passwordDescription => 'Use a password for authentication';

  @override
  String get pinDescription => 'Use a numeric PIN for authentication';

  @override
  String get pattern => 'Pattern';

  @override
  String get patternDescription => 'Draw a pattern for authentication';

  @override
  String get enableBiometrics => 'Enable Biometric Authentication';

  @override
  String get biometricsDescription =>
      'Use fingerprint or face recognition for quick access';

  @override
  String get drawPattern => 'Draw your pattern';

  @override
  String get patternTooShort => 'Pattern must connect at least 4 dots';

  @override
  String get confirmPattern => 'Confirm your pattern';

  @override
  String get patternsDoNotMatch => 'Patterns do not match';

  @override
  String get changePattern => 'Change Pattern';

  @override
  String get setupPattern => 'Setup Pattern';

  @override
  String get reset => 'Reset';

  @override
  String get clear => 'Clear';

  @override
  String get confirm => 'Confirm';

  @override
  String get next => 'Next';

  @override
  String get changePin => 'Change PIN';

  @override
  String pinTooShort(int minLength) {
    return 'PIN must be at least $minLength digits';
  }

  @override
  String get pinOnlyNumbers => 'PIN must contain only numbers';

  @override
  String get confirmPin => 'Confirm PIN';

  @override
  String get pinsDoNotMatch => 'PINs do not match';

  @override
  String get securitySettings => 'Security Settings';

  @override
  String get currentAuthMethod => 'Current Authentication Method';

  @override
  String get changeAuthMethod => 'Change Authentication Method';

  @override
  String get selectNewAuthMethod => 'Select a new authentication method';

  @override
  String get logout => 'Logout';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemTheme => 'System Theme';

  @override
  String get primaryColor => 'Primary Color';

  @override
  String get accentColor => 'Accent Color';

  @override
  String get customFont => 'Custom Font';

  @override
  String get backupSettings => 'Backup Settings';

  @override
  String get autoBackup => 'Auto Backup';

  @override
  String get backupFrequency => 'Backup Frequency';

  @override
  String get exportBackup => 'Export Backup';

  @override
  String get importBackup => 'Import Backup';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get analytics => 'Analytics';

  @override
  String get shareUsageData => 'Share Usage Data';

  @override
  String get allowScreenshots => 'Allow Screenshots';

  @override
  String get storeLocationData => 'Store Location Data';

  @override
  String get journalPreferences => 'Journal Preferences';

  @override
  String get defaultView => 'Default View';

  @override
  String get sortOrder => 'Sort Order';

  @override
  String get fontSize => 'Font Size';

  @override
  String get showDateHeaders => 'Show Date Headers';

  @override
  String get showTags => 'Show Tags';

  @override
  String get enableSpellCheck => 'Enable Spell Check';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get newEntry => 'New Entry';

  @override
  String get editEntry => 'Edit Entry';

  @override
  String get writeYourThoughts => 'Write your thoughts...';

  @override
  String get contentRequired => 'Content is required';
}
