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
  String get language => 'Sprache';

  @override
  String get languageSettings => 'Spracheinstellungen';

  @override
  String get systemLanguage => 'Systemstandard';

  @override
  String get languageDescription => 'Wählen Sie Ihre bevorzugte Sprache';

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
  String get viewAndLayout => 'Ansicht & Layout';

  @override
  String get displayOptions => 'Anzeigeoptionen';

  @override
  String get editing => 'Bearbeitung';

  @override
  String get calendarView => 'Kalenderansicht';

  @override
  String get listView => 'Listenansicht';

  @override
  String get timelineView => 'Zeitstrahl';

  @override
  String get newestFirst => 'Neueste zuerst';

  @override
  String get oldestFirst => 'Älteste zuerst';

  @override
  String get titleAscending => 'Titel (A-Z)';

  @override
  String get titleDescending => 'Titel (Z-A)';

  @override
  String get fontSizeSmall => 'Klein';

  @override
  String get fontSizeMedium => 'Mittel';

  @override
  String get fontSizeLarge => 'Groß';

  @override
  String get fontSizeExtraLarge => 'Sehr groß';

  @override
  String get showDateHeadersDescription => 'Datumstrennzeichen zwischen Einträgen anzeigen';

  @override
  String get showTagsDescription => 'Tags in Eintragsvorschauen anzeigen';

  @override
  String get enableSpellCheckDescription => 'Rechtschreibung während der Eingabe prüfen';

  @override
  String get privacyAndData => 'Datenschutz & Daten';

  @override
  String get privacyControls => 'Datenschutz-Einstellungen';

  @override
  String get dataManagement => 'Datenverwaltung';

  @override
  String get collectAnalytics => 'Analytics erfassen';

  @override
  String get collectAnalyticsDescription => 'Helfen Sie, die App durch anonyme Nutzungsstatistiken zu verbessern';

  @override
  String get shareUsageDataDescription => 'Anonyme Nutzungsmuster zur Unterstützung der Entwicklung senden';

  @override
  String get showJournalOnWidget => 'Journal im Widget anzeigen';

  @override
  String get showJournalOnWidgetDescription => 'Aktuelle Einträge im Homescreen-Widget anzeigen';

  @override
  String get allowScreenshotsDescription => 'Screenshots von Journaleinträgen erlauben';

  @override
  String get storeLocationDataDescription => 'Standortinformationen an Journaleinträge anhängen';

  @override
  String get enableCrashReporting => 'Absturzberichte aktivieren';

  @override
  String get enableCrashReportingDescription => 'Absturzberichte automatisch senden, um Fehler zu beheben';

  @override
  String get clearAllData => 'Alle Daten löschen';

  @override
  String get clearAllDataDescription => 'Alle Journaleinträge und Einstellungen dauerhaft löschen';

  @override
  String get clearAllDataWarning => 'Diese Aktion kann nicht rückgängig gemacht werden. Alle Ihre Journaleinträge werden dauerhaft gelöscht.';

  @override
  String entriesWillBeDeleted(int count) => '$count Einträge werden gelöscht';

  @override
  String get deleteAll => 'Alle löschen';

  @override
  String get dataCleared => 'Alle Daten wurden gelöscht';

  @override
  String get errorClearingData => 'Fehler beim Löschen der Daten';

  @override
  String get clearDataWarningNote => 'Hinweis: Das Löschen von Daten ist dauerhaft und kann nicht rückgängig gemacht werden. Bitte stellen Sie sicher, dass Sie wichtige Einträge gesichert haben.';

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
  String get saveBackupLocally => 'Backup lokal speichern';

  @override
  String get createAndShareBackup => 'Backup erstellen & teilen';

  @override
  String get backupSavedSuccessfully => 'Backup erfolgreich gespeichert';

  @override
  String backupSavedTo(String path) => 'Backup gespeichert unter: $path';

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

  @override
  String get biometricPrompt => 'Authentifizieren Sie sich, um auf Ihr Tagebuch zuzugreifen';

  @override
  String get enableBiometricsQuestion => 'Möchten Sie die biometrische Authentifizierung für schnellen Zugriff aktivieren?';

  @override
  String get skip => 'Überspringen';

  @override
  String get biometricAuthFailed => 'Biometrische Authentifizierung fehlgeschlagen';

  @override
  String get editEntries => 'Einträge bearbeiten';
  @override
  String get done => 'Fertig';
  @override
  String get notificationsAndReminders => 'Benachrichtigungen & Erinnerungen';
  @override
  String get dailyReminders => 'Tägliche Erinnerungen';
  @override
  String get dailyRemindersDescription => 'Erhalte eine freundliche Erinnerung, in dein Tagebuch zu schreiben';
  @override
  String get reminderTime => 'Erinnerungszeit';

  // --- View entry ---
  @override
  String get viewEntry => 'Eintrag ansehen';

  // --- Search & Calendar ---
  @override
  String get search => 'Suche';
  @override
  String get searchEntries => 'Einträge durchsuchen...';
  @override
  String get noSearchResults => 'Keine Einträge gefunden';
  @override
  String get calendarOverview => 'Kalender';
  @override
  String get noEntriesForDay => 'Keine Einträge für diesen Tag';

  // --- Security ---
  @override
  String tooManyAttempts(int seconds) => 'Zu viele Versuche. Bitte warten Sie $seconds Sekunden.';
  @override
  String attemptsRemaining(int count) => 'Noch $count Versuche übrig';
  @override
  String get passwordComplexityError => 'Muss Groß-, Kleinbuchstaben, Zahl und Sonderzeichen enthalten';
  @override
  String get unexpectedError => 'Ein unerwarteter Fehler ist aufgetreten. Bitte versuchen Sie es erneut.';

  @override
  String get entriesUnreadable =>
      'Deine Einträge konnten nicht entschlüsselt werden. Sie sind vermutlich noch da — schreibe nichts Neues, bevor das geklärt ist, und spiele im Zweifel ein Backup ein.';

  // --- Danksagung ---
  @override
  String get credits => 'Danksagung';
  @override
  String get creditsDeike => 'F\u00fcr ihre tollen Ideen und ihre Unterst\u00fctzung sowie ihren Beitrag zum Gelingen der App. Zudem f\u00fcr die Spazierg\u00e4nge, tolle Gespr\u00e4che und daf\u00fcr, dass sie immer da ist, wenn ich sie brauche.';

  // --- Highlights / Sterne ---
  @override
  String get highlights => 'Highlights';
  @override
  String get noHighlights => 'Noch keine markierten Eintr\u00e4ge';
  @override
  String get enableStars => 'Sterne aktivieren';
  @override
  String get enableStarsDescription => 'Markiere deine liebsten Eintr\u00e4ge';

  // --- \u00dcber die App ---
  @override
  String get aboutApp => '\u00dcber die App';
  @override
  String get version => 'Version';
  @override
  String get installedOn => 'Installiert am';
  @override
  String get lastUpdated => 'Letztes Update';
  @override
  String get developer => 'Entwickler';
  @override
  String get creditsSelf => 'Ich danke mir selbst f\u00fcr meine Geduld, Ausdauer, Beharrlichkeit und Hingabe zum Leben.';
}
