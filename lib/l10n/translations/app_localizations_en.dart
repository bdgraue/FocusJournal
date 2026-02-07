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

  // --- Authentication screen ---

  @override
  String get incorrectPattern => 'Incorrect pattern';

  @override
  String get pleaseDrawYourPattern => 'Please draw your pattern';

  @override
  String get useBackupPassword => 'Use backup password';

  @override
  String get usePin => 'Use PIN';

  @override
  String get usePattern => 'Use Pattern';

  @override
  String get incorrectPassword => 'Incorrect password';

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String get incorrectBackupPassword => 'Incorrect backup password';

  @override
  String get pleaseEnterYourPassword => 'Please enter your password';

  @override
  String get pleaseEnterYourPin => 'Please enter your PIN';

  @override
  String get pleaseEnterYourBackupPassword => 'Please enter your backup password';

  // --- Password setup ---

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get pleaseEnterAPassword => 'Please enter a password';

  @override
  String passwordMinLength(int minLength) => 'Password must be at least $minLength characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  // --- Backup & Import ---

  @override
  String get journalExportedSuccessfully => 'Journal exported successfully';

  @override
  String exportFailed(String error) => 'Failed to export journal: $error';

  @override
  String importFailed(String error) => 'Failed to import journal: $error';

  @override
  String get importStrategy => 'Import Strategy';

  @override
  String get completeOverwrite => 'Complete Overwrite';

  @override
  String get replaceAllData => 'Replace all existing data';

  @override
  String get smartMerge => 'Smart Merge (Recommended)';

  @override
  String get mergeWithConflicts => 'Merge with conflict resolution';

  @override
  String get addNewOnly => 'Add New Only';

  @override
  String get onlyImportNew => 'Only import new entries';

  @override
  String get cancel => 'Cancel';

  @override
  String get proceed => 'Proceed';

  @override
  String get couldNotGetFilePath => 'Could not get file path';

  @override
  String get noFileSelected => 'No file selected';

  @override
  String filePickFailed(String error) => 'Failed to pick file: $error';

  @override
  String get backupAndRecovery => 'Backup & Recovery';

  @override
  String get backupPasswordLabel => 'Backup Password';

  @override
  String get backupPasswordHint => 'Set a password to secure your backups';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get createBackup => 'Create Backup';

  @override
  String get restoreBackup => 'Restore Backup';

  @override
  String importSuccessMessage(int added, int updated, int total) =>
      'Import successful: +$added new, ~$updated updated, $total total.';

  // --- Theme settings ---

  @override
  String get appearance => 'Appearance';

  @override
  String get colors => 'Colors';

  @override
  String get typography => 'Typography';

  @override
  String get useCustomFont => 'Use Custom Font';

  @override
  String get fontFamily => 'Font Family';

  @override
  String get advancedSettings => 'Advanced';

  @override
  String get dynamicTheming => 'Dynamic Theming';

  @override
  String get dynamicThemingDescription => 'Adapt colors based on wallpaper';

  @override
  String get contrastLabel => 'Contrast';

  @override
  String get pickAColor => 'Pick a color';

  @override
  String get biometricPrompt => 'Authenticate to access your journal';

  @override
  String get enableBiometricsQuestion => 'Would you like to enable biometric authentication for quick access?';

  @override
  String get skip => 'Skip';

  @override
  String get biometricAuthFailed => 'Biometric authentication failed';

  @override
  String get editEntries => 'Edit Entries';
  @override
  String get done => 'Done';
  @override
  String get notificationsAndReminders => 'Notifications & Reminders';
  @override
  String get dailyReminders => 'Daily Reminders';
  @override
  String get dailyRemindersDescription => 'Get a friendly reminder to write in your journal';
  @override
  String get reminderTime => 'Reminder Time';

  // --- Search & Calendar ---
  @override
  String get search => 'Search';
  @override
  String get searchEntries => 'Search entries...';
  @override
  String get noSearchResults => 'No entries found';
  @override
  String get calendarOverview => 'Calendar';
  @override
  String get noEntriesForDay => 'No entries for this day';

  // --- Security ---
  @override
  String tooManyAttempts(int seconds) => 'Too many attempts. Please wait $seconds seconds.';
  @override
  String attemptsRemaining(int count) => '$count attempts remaining';
  @override
  String get passwordComplexityError => 'Must contain uppercase, lowercase, number, and special character';
  @override
  String get unexpectedError => 'An unexpected error occurred. Please try again.';
}
