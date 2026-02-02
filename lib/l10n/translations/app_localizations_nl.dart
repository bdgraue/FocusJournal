import 'app_localizations_en.dart';

class AppLocalizationsNl extends AppLocalizationsEn {
  AppLocalizationsNl() : super('nl');

  @override
  String get appTitle => 'Focus Dagboek';

  @override
  String get authenticationRequired => 'Authenticatie vereist';

  @override
  String get setupPin => 'PIN instellen';

  @override
  String get enterPasswordPrompt => 'Voer je wachtwoord in';

  @override
  String get enterPinPrompt => 'Voer je PIN in';

  @override
  String get setupPasswordPrompt => 'Stel je wachtwoord in';

  @override
  String setupPinPrompt(int minLength) =>
      'Stel je PIN in (minimaal $minLength cijfers)';

  @override
  String get password => 'Wachtwoord';

  @override
  String get pin => 'PIN';

  @override
  String get unlock => 'Ontgrendelen';

  @override
  String get setPassword => 'Wachtwoord instellen';

  @override
  String get setPin => 'PIN instellen';

  @override
  String get changePassword => 'Wachtwoord wijzigen';

  @override
  String get setupPassword => 'Wachtwoord instellen';

  @override
  String get journal => 'Dagboek';

  @override
  String get settings => 'Instellingen';

  @override
  String get welcomeToJournal => 'Welkom bij Focus Dagboek';

  @override
  String get journalDescription =>
      'Je veilige ruimte voor gerichte gedachten en reflecties.';

  @override
  String get setupSecurity => 'Beveiliging instellen';

  @override
  String get chooseAuthMethod => 'Kies je authenticatiemethode';

  @override
  String get passwordDescription => 'Gebruik een wachtwoord voor authenticatie';

  @override
  String get pinDescription => 'Gebruik een numerieke PIN voor authenticatie';

  @override
  String get pattern => 'Patroon';

  @override
  String get patternDescription => 'Teken een patroon voor authenticatie';

  @override
  String get enableBiometrics => 'Biometrische authenticatie inschakelen';

  @override
  String get biometricsDescription =>
      'Gebruik vingerafdruk of gezichtsherkenning voor snelle toegang';

  @override
  String get drawPattern => 'Teken je patroon';

  @override
  String get patternTooShort => 'Patroon moet minimaal 4 punten verbinden';

  @override
  String get confirmPattern => 'Bevestig je patroon';

  @override
  String get patternsDoNotMatch => 'Patronen komen niet overeen';

  @override
  String get changePattern => 'Patroon wijzigen';

  @override
  String get setupPattern => 'Patroon instellen';

  @override
  String get reset => 'Opnieuw';

  @override
  String get clear => 'Wissen';

  @override
  String get confirm => 'Bevestigen';

  @override
  String get next => 'Volgende';

  @override
  String get changePin => 'PIN wijzigen';

  @override
  String pinTooShort(int minLength) =>
      'PIN moet minimaal $minLength cijfers bevatten';

  @override
  String get pinOnlyNumbers => 'PIN mag alleen cijfers bevatten';

  @override
  String get confirmPin => 'Bevestig PIN';

  @override
  String get pinsDoNotMatch => 'PINs komen niet overeen';

  @override
  String get securitySettings => 'Beveiligingsinstellingen';

  @override
  String get currentAuthMethod => 'Huidige authenticatiemethode';

  @override
  String get changeAuthMethod => 'Authenticatiemethode wijzigen';

  @override
  String get selectNewAuthMethod => 'Selecteer een nieuwe authenticatiemethode';

  @override
  String get logout => 'Uitloggen';

  @override
  String get themeSettings => 'Thema-instellingen';

  @override
  String get darkMode => 'Donkere modus';

  @override
  String get lightMode => 'Lichte modus';

  @override
  String get systemTheme => 'Systeemthema';

  @override
  String get primaryColor => 'Primaire kleur';

  @override
  String get accentColor => 'Accentkleur';

  @override
  String get customFont => 'Aangepast lettertype';

  @override
  String get backupSettings => 'Back-upinstellingen';

  @override
  String get autoBackup => 'Automatische back-up';

  @override
  String get backupFrequency => 'Back-upfrequentie';

  @override
  String get exportBackup => 'Back-up exporteren';

  @override
  String get importBackup => 'Back-up importeren';

  @override
  String get privacySettings => 'Privacy-instellingen';

  @override
  String get analytics => 'Analyses';

  @override
  String get shareUsageData => 'Gebruiksgegevens delen';

  @override
  String get allowScreenshots => 'Schermafbeeldingen toestaan';

  @override
  String get storeLocationData => 'Locatiegegevens opslaan';

  @override
  String get journalPreferences => 'Dagboekvoorkeuren';

  @override
  String get defaultView => 'Standaardweergave';

  @override
  String get sortOrder => 'Sorteervolgorde';

  @override
  String get fontSize => 'Lettergrootte';

  @override
  String get showDateHeaders => 'Datumkoppen weergeven';

  @override
  String get showTags => 'Tags weergeven';

  @override
  String get enableSpellCheck => 'Spellingcontrole inschakelen';

  @override
  String get today => 'Vandaag';

  @override
  String get yesterday => 'Gisteren';

  @override
  String get newEntry => 'Nieuw item';

  @override
  String get editEntry => 'Item bewerken';

  @override
  String get writeYourThoughts => 'Schrijf je gedachten...';

  @override
  String get contentRequired => 'Inhoud is vereist';

  @override
  String get incorrectPattern => 'Onjuist patroon';
  @override
  String get pleaseDrawYourPattern => 'Teken uw patroon';
  @override
  String get useBackupPassword => 'Gebruik back-upwachtwoord';
  @override
  String get usePin => 'Gebruik PIN';
  @override
  String get usePattern => 'Gebruik patroon';
  @override
  String get incorrectPassword => 'Onjuist wachtwoord';
  @override
  String get incorrectPin => 'Onjuiste PIN';
  @override
  String get incorrectBackupPassword => 'Onjuist back-upwachtwoord';
  @override
  String get pleaseEnterYourPassword => 'Voer uw wachtwoord in';
  @override
  String get pleaseEnterYourPin => 'Voer uw PIN in';
  @override
  String get pleaseEnterYourBackupPassword => 'Voer uw back-upwachtwoord in';
  @override
  String get confirmPassword => 'Bevestig wachtwoord';
  @override
  String get pleaseEnterAPassword => 'Voer een wachtwoord in';
  @override
  String passwordMinLength(int minLength) => 'Wachtwoord moet minimaal $minLength tekens bevatten';
  @override
  String get passwordsDoNotMatch => 'Wachtwoorden komen niet overeen';
  @override
  String get journalExportedSuccessfully => 'Dagboek succesvol geëxporteerd';
  @override
  String exportFailed(String error) => 'Export mislukt: $error';
  @override
  String importFailed(String error) => 'Import mislukt: $error';
  @override
  String get importStrategy => 'Importstrategie';
  @override
  String get completeOverwrite => 'Volledig overschrijven';
  @override
  String get replaceAllData => 'Alle bestaande gegevens vervangen';
  @override
  String get smartMerge => 'Slim samenvoegen (Aanbevolen)';
  @override
  String get mergeWithConflicts => 'Samenvoegen met conflictoplossing';
  @override
  String get addNewOnly => 'Alleen nieuwe toevoegen';
  @override
  String get onlyImportNew => 'Alleen nieuwe items importeren';
  @override
  String get cancel => 'Annuleren';
  @override
  String get proceed => 'Doorgaan';
  @override
  String get couldNotGetFilePath => 'Kan bestandspad niet ophalen';
  @override
  String get noFileSelected => 'Geen bestand geselecteerd';
  @override
  String filePickFailed(String error) => 'Bestandsselectie mislukt: $error';
  @override
  String get backupAndRecovery => 'Back-up en herstel';
  @override
  String get backupPasswordLabel => 'Back-upwachtwoord';
  @override
  String get backupPasswordHint => 'Stel een wachtwoord in om uw back-ups te beveiligen';
  @override
  String get passwordRequired => 'Wachtwoord is vereist';
  @override
  String get createBackup => 'Back-up maken';
  @override
  String get restoreBackup => 'Back-up herstellen';
  @override
  String importSuccessMessage(int added, int updated, int total) =>
      'Import geslaagd: +$added nieuw, ~$updated bijgewerkt, $total totaal.';
  @override
  String get appearance => 'Weergave';
  @override
  String get colors => 'Kleuren';
  @override
  String get typography => 'Typografie';
  @override
  String get useCustomFont => 'Aangepast lettertype gebruiken';
  @override
  String get fontFamily => 'Lettertypefamilie';
  @override
  String get advancedSettings => 'Geavanceerd';
  @override
  String get dynamicTheming => 'Dynamisch thema';
  @override
  String get dynamicThemingDescription => 'Kleuren aanpassen op basis van achtergrond';
  @override
  String get contrastLabel => 'Contrast';
  @override
  String get pickAColor => 'Kies een kleur';
}
