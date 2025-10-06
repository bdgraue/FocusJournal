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
  String get selectNewAuthMethod => 'Seleziona un nuovo metodo di autenticazione';

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
}