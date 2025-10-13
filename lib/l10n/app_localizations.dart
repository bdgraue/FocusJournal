import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'translations/index.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localization delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de'),
    Locale('fr'),
    Locale('es'),
    Locale('it'),
    Locale('nl'),
    Locale('pl'),
  ];

  /// App title
  ///
  /// In en, this message translates to:
  /// **'Focus Journal'**
  String get appTitle;

  /// Authentication required message
  ///
  /// In en, this message translates to:
  /// **'Authentication Required'**
  String get authenticationRequired;

  /// Setup PIN message
  ///
  /// In en, this message translates to:
  /// **'Setup PIN'**
  String get setupPin;

  /// Enter password prompt
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPasswordPrompt;

  /// Enter PIN prompt
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get enterPinPrompt;

  /// Setup password prompt
  ///
  /// In en, this message translates to:
  /// **'Setup your password'**
  String get setupPasswordPrompt;

  /// Setup PIN prompt with minimum length
  ///
  /// In en, this message translates to:
  /// **'Setup your PIN (minimum {minLength} digits)'**
  String setupPinPrompt(int minLength);

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// PIN label
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// Unlock button
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// Set password button
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get setPassword;

  /// Set PIN button
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get setPin;

  /// Change password
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Setup password
  ///
  /// In en, this message translates to:
  /// **'Setup Password'**
  String get setupPassword;

  /// Journal tab label
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome to Focus Journal'**
  String get welcomeToJournal;

  /// Journal description
  ///
  /// In en, this message translates to:
  /// **'Your secure space for focused thoughts and reflections.'**
  String get journalDescription;

  /// Setup security
  ///
  /// In en, this message translates to:
  /// **'Setup Security'**
  String get setupSecurity;

  /// Choose authentication method
  ///
  /// In en, this message translates to:
  /// **'Choose your authentication method'**
  String get chooseAuthMethod;

  /// Password authentication description
  ///
  /// In en, this message translates to:
  /// **'Use a password for authentication'**
  String get passwordDescription;

  /// PIN authentication description
  ///
  /// In en, this message translates to:
  /// **'Use a numeric PIN for authentication'**
  String get pinDescription;

  /// Pattern label
  ///
  /// In en, this message translates to:
  /// **'Pattern'**
  String get pattern;

  /// Pattern authentication description
  ///
  /// In en, this message translates to:
  /// **'Draw a pattern for authentication'**
  String get patternDescription;

  /// Enable biometrics
  ///
  /// In en, this message translates to:
  /// **'Enable Biometric Authentication'**
  String get enableBiometrics;

  /// Biometrics description
  ///
  /// In en, this message translates to:
  /// **'Use fingerprint or face recognition for quick access'**
  String get biometricsDescription;

  /// Draw pattern prompt
  ///
  /// In en, this message translates to:
  /// **'Draw your pattern'**
  String get drawPattern;

  /// Pattern too short message
  ///
  /// In en, this message translates to:
  /// **'Pattern must connect at least 4 dots'**
  String get patternTooShort;

  /// Confirm pattern prompt
  ///
  /// In en, this message translates to:
  /// **'Confirm your pattern'**
  String get confirmPattern;

  /// Patterns do not match message
  ///
  /// In en, this message translates to:
  /// **'Patterns do not match'**
  String get patternsDoNotMatch;

  /// Change pattern button
  ///
  /// In en, this message translates to:
  /// **'Change Pattern'**
  String get changePattern;

  /// Setup pattern button
  ///
  /// In en, this message translates to:
  /// **'Setup Pattern'**
  String get setupPattern;

  /// Reset button
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Clear button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Change PIN button
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// PIN too short message
  ///
  /// In en, this message translates to:
  /// **'PIN must be at least {minLength} digits'**
  String pinTooShort(int minLength);

  /// PIN must contain only numbers message
  ///
  /// In en, this message translates to:
  /// **'PIN must contain only numbers'**
  String get pinOnlyNumbers;

  /// Confirm PIN prompt
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get confirmPin;

  /// PINs do not match message
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinsDoNotMatch;

  /// Security settings title
  ///
  /// In en, this message translates to:
  /// **'Security Settings'**
  String get securitySettings;

  /// Current authentication method label
  ///
  /// In en, this message translates to:
  /// **'Current Authentication Method'**
  String get currentAuthMethod;

  /// Change authentication method button
  ///
  /// In en, this message translates to:
  /// **'Change Authentication Method'**
  String get changeAuthMethod;

  /// Select new authentication method prompt
  ///
  /// In en, this message translates to:
  /// **'Select a new authentication method'**
  String get selectNewAuthMethod;

  /// Logout button
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Theme settings title
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// Dark mode label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Light mode label
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// System theme label
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get systemTheme;

  /// Primary color label
  ///
  /// In en, this message translates to:
  /// **'Primary Color'**
  String get primaryColor;

  /// Accent color label
  ///
  /// In en, this message translates to:
  /// **'Accent Color'**
  String get accentColor;

  /// Custom font label
  ///
  /// In en, this message translates to:
  /// **'Custom Font'**
  String get customFont;

  /// Backup settings title
  ///
  /// In en, this message translates to:
  /// **'Backup Settings'**
  String get backupSettings;

  /// Auto backup label
  ///
  /// In en, this message translates to:
  /// **'Auto Backup'**
  String get autoBackup;

  /// Backup frequency label
  ///
  /// In en, this message translates to:
  /// **'Backup Frequency'**
  String get backupFrequency;

  /// Export backup button
  ///
  /// In en, this message translates to:
  /// **'Export Backup'**
  String get exportBackup;

  /// Import backup button
  ///
  /// In en, this message translates to:
  /// **'Import Backup'**
  String get importBackup;

  /// Privacy settings title
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// Analytics label
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// Share usage data label
  ///
  /// In en, this message translates to:
  /// **'Share Usage Data'**
  String get shareUsageData;

  /// Allow screenshots label
  ///
  /// In en, this message translates to:
  /// **'Allow Screenshots'**
  String get allowScreenshots;

  /// Today label (for date headers)
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Yesterday label (for date headers)
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Title for creating a new journal entry
  ///
  /// In en, this message translates to:
  /// **'New Entry'**
  String get newEntry;

  /// Title for editing an existing journal entry
  ///
  /// In en, this message translates to:
  /// **'Edit Entry'**
  String get editEntry;

  /// Hint in the entry editor text field
  ///
  /// In en, this message translates to:
  /// **'Write your thoughts...'**
  String get writeYourThoughts;

  /// Error when entry content is empty
  ///
  /// In en, this message translates to:
  /// **'Content is required'**
  String get contentRequired;

  /// Store location data label
  ///
  /// In en, this message translates to:
  /// **'Store Location Data'**
  String get storeLocationData;

  /// Journal preferences title
  ///
  /// In en, this message translates to:
  /// **'Journal Preferences'**
  String get journalPreferences;

  /// Default view label
  ///
  /// In en, this message translates to:
  /// **'Default View'**
  String get defaultView;

  /// Sort order label
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get sortOrder;

  /// Font size label
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// Show date headers label
  ///
  /// In en, this message translates to:
  /// **'Show Date Headers'**
  String get showDateHeaders;

  /// Show tags label
  ///
  /// In en, this message translates to:
  /// **'Show Tags'**
  String get showTags;

  /// Enable spell check label
  ///
  /// In en, this message translates to:
  /// **'Enable Spell Check'**
  String get enableSpellCheck;
}

/// The delegate class which loads AppLocalizations.
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'nl',
    'pl',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue on GitHub with a '
    'reproducible sample app and the gen-l10n configuration that was used.',
  );
}
