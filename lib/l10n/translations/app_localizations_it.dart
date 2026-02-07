import 'app_localizations_en.dart';

class AppLocalizationsIt extends AppLocalizationsEn {
  AppLocalizationsIt() : super('it');

  @override
  String get appTitle => 'Diario Focus';

  @override
  String get authenticationRequired => 'Autenticazione richiesta';

  @override
  String get setupPin => 'Configura PIN';

  @override
  String get enterPasswordPrompt => 'Inserisci la tua password';

  @override
  String get enterPinPrompt => 'Inserisci il tuo PIN';

  @override
  String get setupPasswordPrompt => 'Configura la tua password';

  @override
  String setupPinPrompt(int minLength) =>
      'Configura il tuo PIN (minimo $minLength cifre)';

  @override
  String get password => 'Password';

  @override
  String get pin => 'PIN';

  @override
  String get unlock => 'Sblocca';

  @override
  String get setPassword => 'Imposta password';

  @override
  String get setPin => 'Imposta PIN';

  @override
  String get changePassword => 'Cambia password';

  @override
  String get setupPassword => 'Configura password';

  @override
  String get journal => 'Diario';

  @override
  String get settings => 'Impostazioni';

  @override
  String get welcomeToJournal => 'Benvenuto in Focus Diario';

  @override
  String get journalDescription =>
      'Il tuo spazio sicuro per pensieri e riflessioni concentrate.';

  @override
  String get setupSecurity => 'Configura sicurezza';

  @override
  String get chooseAuthMethod => 'Scegli il tuo metodo di autenticazione';

  @override
  String get passwordDescription => 'Usa una password per l\'autenticazione';

  @override
  String get pinDescription => 'Usa un PIN numerico per l\'autenticazione';

  @override
  String get pattern => 'Schema';

  @override
  String get patternDescription => 'Disegna uno schema per l\'autenticazione';

  @override
  String get enableBiometrics => 'Attiva autenticazione biometrica';

  @override
  String get biometricsDescription =>
      'Usa l\'impronta digitale o il riconoscimento facciale per un accesso rapido';

  @override
  String get drawPattern => 'Disegna il tuo schema';

  @override
  String get patternTooShort => 'Lo schema deve collegare almeno 4 punti';

  @override
  String get confirmPattern => 'Conferma il tuo schema';

  @override
  String get patternsDoNotMatch => 'Gli schemi non corrispondono';

  @override
  String get changePattern => 'Cambia schema';

  @override
  String get setupPattern => 'Configura schema';

  @override
  String get reset => 'Reimposta';

  @override
  String get clear => 'Cancella';

  @override
  String get confirm => 'Conferma';

  @override
  String get next => 'Avanti';

  @override
  String get changePin => 'Cambia PIN';

  @override
  String pinTooShort(int minLength) =>
      'Il PIN deve avere almeno $minLength cifre';

  @override
  String get pinOnlyNumbers => 'Il PIN deve contenere solo numeri';

  @override
  String get confirmPin => 'Conferma PIN';

  @override
  String get pinsDoNotMatch => 'I PIN non corrispondono';

  @override
  String get securitySettings => 'Impostazioni di sicurezza';

  @override
  String get currentAuthMethod => 'Metodo di autenticazione attuale';

  @override
  String get changeAuthMethod => 'Cambia metodo di autenticazione';

  @override
  String get selectNewAuthMethod =>
      'Seleziona un nuovo metodo di autenticazione';

  @override
  String get logout => 'Disconnetti';

  @override
  String get themeSettings => 'Impostazioni tema';

  @override
  String get darkMode => 'Modalità scura';

  @override
  String get lightMode => 'Modalità chiara';

  @override
  String get systemTheme => 'Tema di sistema';

  @override
  String get primaryColor => 'Colore primario';

  @override
  String get accentColor => 'Colore di accento';

  @override
  String get customFont => 'Font personalizzato';

  @override
  String get backupSettings => 'Impostazioni backup';

  @override
  String get autoBackup => 'Backup automatico';

  @override
  String get backupFrequency => 'Frequenza backup';

  @override
  String get exportBackup => 'Esporta backup';

  @override
  String get importBackup => 'Importa backup';

  @override
  String get privacySettings => 'Impostazioni privacy';

  @override
  String get analytics => 'Analitiche';

  @override
  String get shareUsageData => 'Condividi dati di utilizzo';

  @override
  String get allowScreenshots => 'Permetti screenshot';

  @override
  String get storeLocationData => 'Memorizza dati posizione';

  @override
  String get journalPreferences => 'Preferenze diario';

  @override
  String get defaultView => 'Vista predefinita';

  @override
  String get sortOrder => 'Ordinamento';

  @override
  String get fontSize => 'Dimensione font';

  @override
  String get showDateHeaders => 'Mostra intestazioni data';

  @override
  String get showTags => 'Mostra tag';

  @override
  String get enableSpellCheck => 'Attiva controllo ortografico';

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get newEntry => 'Nuova voce';

  @override
  String get editEntry => 'Modifica voce';

  @override
  String get writeYourThoughts => 'Scrivi i tuoi pensieri...';

  @override
  String get contentRequired => 'Il contenuto è obbligatorio';

  @override
  String get incorrectPattern => 'Schema errato';
  @override
  String get pleaseDrawYourPattern => 'Per favore disegna il tuo schema';
  @override
  String get useBackupPassword => 'Usa password di backup';
  @override
  String get usePin => 'Usa PIN';
  @override
  String get usePattern => 'Usa schema';
  @override
  String get incorrectPassword => 'Password errata';
  @override
  String get incorrectPin => 'PIN errato';
  @override
  String get incorrectBackupPassword => 'Password di backup errata';
  @override
  String get pleaseEnterYourPassword => 'Per favore inserisci la tua password';
  @override
  String get pleaseEnterYourPin => 'Per favore inserisci il tuo PIN';
  @override
  String get pleaseEnterYourBackupPassword => 'Per favore inserisci la tua password di backup';
  @override
  String get confirmPassword => 'Conferma password';
  @override
  String get pleaseEnterAPassword => 'Per favore inserisci una password';
  @override
  String passwordMinLength(int minLength) => 'La password deve avere almeno $minLength caratteri';
  @override
  String get passwordsDoNotMatch => 'Le password non corrispondono';
  @override
  String get journalExportedSuccessfully => 'Diario esportato con successo';
  @override
  String exportFailed(String error) => 'Errore nell\'esportazione: $error';
  @override
  String importFailed(String error) => 'Errore nell\'importazione: $error';
  @override
  String get importStrategy => 'Strategia di importazione';
  @override
  String get completeOverwrite => 'Sovrascrittura completa';
  @override
  String get replaceAllData => 'Sostituisci tutti i dati esistenti';
  @override
  String get smartMerge => 'Unione intelligente (Consigliato)';
  @override
  String get mergeWithConflicts => 'Unisci con risoluzione dei conflitti';
  @override
  String get addNewOnly => 'Aggiungi solo nuove';
  @override
  String get onlyImportNew => 'Importa solo nuove voci';
  @override
  String get cancel => 'Annulla';
  @override
  String get proceed => 'Procedi';
  @override
  String get couldNotGetFilePath => 'Impossibile ottenere il percorso del file';
  @override
  String get noFileSelected => 'Nessun file selezionato';
  @override
  String filePickFailed(String error) => 'Errore nella selezione del file: $error';
  @override
  String get backupAndRecovery => 'Backup e ripristino';
  @override
  String get backupPasswordLabel => 'Password di backup';
  @override
  String get backupPasswordHint => 'Imposta una password per proteggere i tuoi backup';
  @override
  String get passwordRequired => 'La password è obbligatoria';
  @override
  String get createBackup => 'Crea backup';
  @override
  String get restoreBackup => 'Ripristina backup';
  @override
  String get saveBackupLocally => 'Salva backup localmente';
  @override
  String get createAndShareBackup => 'Crea e condividi backup';
  @override
  String get backupSavedSuccessfully => 'Backup salvato con successo';
  @override
  String backupSavedTo(String path) => 'Backup salvato in: $path';
  @override
  String importSuccessMessage(int added, int updated, int total) =>
      'Importazione riuscita: +$added nuove, ~$updated aggiornate, $total in totale.';
  @override
  String get appearance => 'Aspetto';
  @override
  String get colors => 'Colori';
  @override
  String get typography => 'Tipografia';
  @override
  String get useCustomFont => 'Usa font personalizzato';
  @override
  String get fontFamily => 'Famiglia di font';
  @override
  String get advancedSettings => 'Avanzate';
  @override
  String get dynamicTheming => 'Tema dinamico';
  @override
  String get dynamicThemingDescription => 'Adatta i colori in base allo sfondo';
  @override
  String get contrastLabel => 'Contrasto';
  @override
  String get pickAColor => 'Scegli un colore';

  @override
  String get biometricPrompt => 'Autenticati per accedere al tuo diario';

  @override
  String get enableBiometricsQuestion => 'Vuoi attivare l\'autenticazione biometrica per un accesso rapido?';

  @override
  String get skip => 'Salta';

  @override
  String get biometricAuthFailed => 'Autenticazione biometrica non riuscita';

  @override
  String get editEntries => 'Modifica voci';
  @override
  String get done => 'Fatto';
  @override
  String get notificationsAndReminders => 'Notifiche e promemoria';
  @override
  String get dailyReminders => 'Promemoria giornalieri';
  @override
  String get dailyRemindersDescription => 'Ricevi un promemoria amichevole per scrivere nel tuo diario';
  @override
  String get reminderTime => 'Orario promemoria';

  // --- View entry ---
  @override
  String get viewEntry => 'Visualizza voce';

  // --- Search & Calendar ---
  @override
  String get search => 'Cerca';
  @override
  String get searchEntries => 'Cerca voci...';
  @override
  String get noSearchResults => 'Nessuna voce trovata';
  @override
  String get calendarOverview => 'Calendario';
  @override
  String get noEntriesForDay => 'Nessuna voce per questo giorno';

  // --- Security ---
  @override
  String tooManyAttempts(int seconds) => 'Troppi tentativi. Attendere $seconds secondi.';
  @override
  String attemptsRemaining(int count) => '$count tentativi rimanenti';
  @override
  String get passwordComplexityError => 'Deve contenere maiuscola, minuscola, numero e carattere speciale';
  @override
  String get unexpectedError => 'Si \u00e8 verificato un errore imprevisto. Riprova.';

  // --- Ringraziamenti ---
  @override
  String get credits => 'Ringraziamenti';
  @override
  String get creditsDeike => 'Per le sue meravigliose idee e il suo contributo al successo di questa app. E per le conversazioni meravigliose in ogni momento, la tenerezza e l\'affetto che ricevo.';
}
