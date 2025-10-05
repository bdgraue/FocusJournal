import '../app_localizations.dart';

class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([super.locale = 'de']);

  @override
  String get appTitle => 'Focus Tagebuch';

  @override
  String get authenticationRequired => 'Authentifizierung erforderlich';

  @override
  String get setupPin => 'PIN einrichten';

  @override
  String get enterPasswordPrompt => 'Geben Sie Ihr Passwort ein';

  @override
  String get enterPinPrompt => 'Geben Sie Ihre PIN ein';

  @override
  String get setupPasswordPrompt => 'Richten Sie Ihr Passwort ein';

  @override
  String setupPinPrompt(int minLength) {
    return 'Richten Sie Ihre PIN ein (mindestens $minLength Ziffern)';
  }

  @override
  String get password => 'Passwort';

  @override
  String get pin => 'PIN';

  @override
  String get unlock => 'Entsperren';

  @override
  String get setPassword => 'Passwort festlegen';

  @override
  String get setPin => 'PIN festlegen';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get setupPassword => 'Passwort einrichten';

  @override
  String get journal => 'Tagebuch';

  @override
  String get settings => 'Einstellungen';

  @override
  String get welcomeToJournal => 'Willkommen bei Focus Tagebuch';

  @override
  String get journalDescription => 'Dein sicherer Ort für fokussierte Gedanken und Reflexionen.';

  @override
  String get setupSecurity => 'Sicherheit einrichten';

  @override
  String get chooseAuthMethod => 'Wählen Sie Ihre Authentifizierungsmethode';

  @override
  String get passwordDescription => 'Verwenden Sie ein Passwort zur Authentifizierung';

  @override
  String get pinDescription => 'Verwenden Sie eine numerische PIN zur Authentifizierung';

  @override
  String get pattern => 'Muster';

  @override
  String get patternDescription => 'Zeichnen Sie ein Muster zur Authentifizierung';

  @override
  String get enableBiometrics => 'Biometrische Authentifizierung aktivieren';

  @override
  String get biometricsDescription => 'Fingerabdruck oder Gesichtserkennung für schnellen Zugriff verwenden';

  @override
  String get drawPattern => 'Zeichnen Sie Ihr Muster';

  @override
  String get patternTooShort => 'Muster muss mindestens 4 Punkte verbinden';

  @override
  String get confirmPattern => 'Bestätigen Sie Ihr Muster';

  @override
  String get patternsDoNotMatch => 'Muster stimmen nicht überein';

  @override
  String get changePattern => 'Muster ändern';

  @override
  String get setupPattern => 'Muster einrichten';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get clear => 'Löschen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get next => 'Weiter';

  @override
  String get changePin => 'PIN ändern';

  @override
  String pinTooShort(int minLength) {
    return 'PIN muss mindestens $minLength Ziffern haben';
  }

  @override
  String get pinOnlyNumbers => 'PIN darf nur Zahlen enthalten';

  @override
  String get confirmPin => 'PIN bestätigen';

  @override
  String get pinsDoNotMatch => 'PINs stimmen nicht überein';

  @override
  String get securitySettings => 'Sicherheitseinstellungen';

  @override
  String get currentAuthMethod => 'Aktuelle Authentifizierungsmethode';

  @override
  String get changeAuthMethod => 'Authentifizierungsmethode ändern';

  @override
  String get selectNewAuthMethod => 'Wählen Sie eine neue Authentifizierungsmethode';

  @override
  String get logout => 'Abmelden';

  @override
  String get themeSettings => 'Design-Einstellungen';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get lightMode => 'Heller Modus';

  @override
  String get systemTheme => 'System-Design';

  @override
  String get primaryColor => 'Hauptfarbe';

  @override
  String get accentColor => 'Akzentfarbe';

  @override
  String get customFont => 'Benutzerdefinierte Schrift';

  @override
  String get backupSettings => 'Backup-Einstellungen';

  @override
  String get autoBackup => 'Automatisches Backup';

  @override
  String get backupFrequency => 'Backup-Häufigkeit';

  @override
  String get exportBackup => 'Backup exportieren';

  @override
  String get importBackup => 'Backup importieren';

  @override
  String get privacySettings => 'Datenschutz-Einstellungen';

  @override
  String get analytics => 'Analytik';

  @override
  String get shareUsageData => 'Nutzungsdaten teilen';

  @override
  String get allowScreenshots => 'Screenshots erlauben';

  @override
  String get storeLocationData => 'Standortdaten speichern';

  @override
  String get journalPreferences => 'Tagebuch-Einstellungen';

  @override
  String get defaultView => 'Standardansicht';

  @override
  String get sortOrder => 'Sortierreihenfolge';

  @override
  String get fontSize => 'Schriftgröße';

  @override
  String get showDateHeaders => 'Datumsüberschriften anzeigen';

  @override
  String get showTags => 'Tags anzeigen';

  @override
  String get enableSpellCheck => 'Rechtschreibprüfung aktivieren';
}