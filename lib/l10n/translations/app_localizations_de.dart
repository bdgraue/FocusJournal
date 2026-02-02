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
  String get journalDescription =>
      'Dein sicherer Ort für fokussierte Gedanken und Reflexionen.';

  @override
  String get setupSecurity => 'Sicherheit einrichten';

  @override
  String get chooseAuthMethod => 'Wählen Sie Ihre Authentifizierungsmethode';

  @override
  String get passwordDescription =>
      'Verwenden Sie ein Passwort zur Authentifizierung';

  @override
  String get pinDescription =>
      'Verwenden Sie eine numerische PIN zur Authentifizierung';

  @override
  String get pattern => 'Muster';

  @override
  String get patternDescription =>
      'Zeichnen Sie ein Muster zur Authentifizierung';

  @override
  String get enableBiometrics => 'Biometrische Authentifizierung aktivieren';

  @override
  String get biometricsDescription =>
      'Fingerabdruck oder Gesichtserkennung für schnellen Zugriff verwenden';

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
  String get selectNewAuthMethod =>
      'Wählen Sie eine neue Authentifizierungsmethode';

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

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get newEntry => 'Neuer Eintrag';

  @override
  String get editEntry => 'Eintrag bearbeiten';

  @override
  String get writeYourThoughts => 'Schreibe deine Gedanken...';

  @override
  String get contentRequired => 'Inhalt ist erforderlich';

  // --- Authentication screen ---

  @override
  String get incorrectPattern => 'Falsches Muster';

  @override
  String get pleaseDrawYourPattern => 'Bitte zeichnen Sie Ihr Muster';

  @override
  String get useBackupPassword => 'Backup-Passwort verwenden';

  @override
  String get usePin => 'PIN verwenden';

  @override
  String get usePattern => 'Muster verwenden';

  @override
  String get incorrectPassword => 'Falsches Passwort';

  @override
  String get incorrectPin => 'Falsche PIN';

  @override
  String get incorrectBackupPassword => 'Falsches Backup-Passwort';

  @override
  String get pleaseEnterYourPassword => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String get pleaseEnterYourPin => 'Bitte geben Sie Ihre PIN ein';

  @override
  String get pleaseEnterYourBackupPassword => 'Bitte geben Sie Ihr Backup-Passwort ein';

  // --- Password setup ---

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get pleaseEnterAPassword => 'Bitte geben Sie ein Passwort ein';

  @override
  String passwordMinLength(int minLength) => 'Passwort muss mindestens $minLength Zeichen lang sein';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  // --- Backup & Import ---

  @override
  String get journalExportedSuccessfully => 'Tagebuch erfolgreich exportiert';

  @override
  String exportFailed(String error) => 'Export fehlgeschlagen: $error';

  @override
  String importFailed(String error) => 'Import fehlgeschlagen: $error';

  @override
  String get importStrategy => 'Import-Strategie';

  @override
  String get completeOverwrite => 'Vollständig überschreiben';

  @override
  String get replaceAllData => 'Alle vorhandenen Daten ersetzen';

  @override
  String get smartMerge => 'Intelligentes Zusammenführen (Empfohlen)';

  @override
  String get mergeWithConflicts => 'Zusammenführen mit Konfliktlösung';

  @override
  String get addNewOnly => 'Nur neue hinzufügen';

  @override
  String get onlyImportNew => 'Nur neue Einträge importieren';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get proceed => 'Fortfahren';

  @override
  String get couldNotGetFilePath => 'Dateipfad konnte nicht ermittelt werden';

  @override
  String get noFileSelected => 'Keine Datei ausgewählt';

  @override
  String filePickFailed(String error) => 'Dateiauswahl fehlgeschlagen: $error';

  @override
  String get backupAndRecovery => 'Backup & Wiederherstellung';

  @override
  String get backupPasswordLabel => 'Backup-Passwort';

  @override
  String get backupPasswordHint => 'Legen Sie ein Passwort fest, um Ihre Backups zu sichern';

  @override
  String get passwordRequired => 'Passwort ist erforderlich';

  @override
  String get createBackup => 'Backup erstellen';

  @override
  String get restoreBackup => 'Backup wiederherstellen';

  @override
  String importSuccessMessage(int added, int updated, int total) =>
      'Import erfolgreich: +$added neue, ~$updated aktualisiert, $total gesamt.';

  // --- Theme settings ---

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get colors => 'Farben';

  @override
  String get typography => 'Typografie';

  @override
  String get useCustomFont => 'Eigene Schriftart verwenden';

  @override
  String get fontFamily => 'Schriftfamilie';

  @override
  String get advancedSettings => 'Erweitert';

  @override
  String get dynamicTheming => 'Dynamisches Design';

  @override
  String get dynamicThemingDescription => 'Farben basierend auf dem Hintergrundbild anpassen';

  @override
  String get contrastLabel => 'Kontrast';

  @override
  String get pickAColor => 'Farbe wählen';
}
