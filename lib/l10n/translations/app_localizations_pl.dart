import 'app_localizations_en.dart';

class AppLocalizationsPl extends AppLocalizationsEn {
  AppLocalizationsPl() : super('pl');

  @override
  String get appTitle => 'Dziennik Focus';

  @override
  String get authenticationRequired => 'Wymagana autoryzacja';

  @override
  String get setupPin => 'Ustaw PIN';

  @override
  String get enterPasswordPrompt => 'Wprowadź swoje hasło';

  @override
  String get enterPinPrompt => 'Wprowadź swój PIN';

  @override
  String get setupPasswordPrompt => 'Ustaw swoje hasło';

  @override
  String setupPinPrompt(int minLength) =>
      'Ustaw swój PIN (minimum $minLength cyfr)';

  @override
  String get password => 'Hasło';

  @override
  String get pin => 'PIN';

  @override
  String get unlock => 'Odblokuj';

  @override
  String get setPassword => 'Ustaw hasło';

  @override
  String get setPin => 'Ustaw PIN';

  @override
  String get changePassword => 'Zmień hasło';

  @override
  String get setupPassword => 'Ustaw hasło';

  @override
  String get journal => 'Dziennik';

  @override
  String get settings => 'Ustawienia';

  @override
  String get welcomeToJournal => 'Witaj w Focus Dziennik';

  @override
  String get journalDescription =>
      'Twoja bezpieczna przestrzeń na skoncentrowane myśli i refleksje.';

  @override
  String get setupSecurity => 'Konfiguracja zabezpieczeń';

  @override
  String get chooseAuthMethod => 'Wybierz metodę uwierzytelniania';

  @override
  String get passwordDescription => 'Użyj hasła do uwierzytelniania';

  @override
  String get pinDescription => 'Użyj numerycznego PINu do uwierzytelniania';

  @override
  String get pattern => 'Wzór';

  @override
  String get patternDescription => 'Narysuj wzór do uwierzytelniania';

  @override
  String get enableBiometrics => 'Włącz uwierzytelnianie biometryczne';

  @override
  String get biometricsDescription =>
      'Użyj odcisku palca lub rozpoznawania twarzy do szybkiego dostępu';

  @override
  String get drawPattern => 'Narysuj swój wzór';

  @override
  String get patternTooShort => 'Wzór musi łączyć co najmniej 4 punkty';

  @override
  String get confirmPattern => 'Potwierdź swój wzór';

  @override
  String get patternsDoNotMatch => 'Wzory nie pasują do siebie';

  @override
  String get changePattern => 'Zmień wzór';

  @override
  String get setupPattern => 'Ustaw wzór';

  @override
  String get reset => 'Reset';

  @override
  String get clear => 'Wyczyść';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get next => 'Dalej';

  @override
  String get changePin => 'Zmień PIN';

  @override
  String pinTooShort(int minLength) =>
      'PIN musi mieć co najmniej $minLength cyfr';

  @override
  String get pinOnlyNumbers => 'PIN może zawierać tylko cyfry';

  @override
  String get confirmPin => 'Potwierdź PIN';

  @override
  String get pinsDoNotMatch => 'PINy nie pasują do siebie';

  @override
  String get securitySettings => 'Ustawienia zabezpieczeń';

  @override
  String get currentAuthMethod => 'Obecna metoda uwierzytelniania';

  @override
  String get changeAuthMethod => 'Zmień metodę uwierzytelniania';

  @override
  String get selectNewAuthMethod => 'Wybierz nową metodę uwierzytelniania';

  @override
  String get logout => 'Wyloguj';

  @override
  String get themeSettings => 'Ustawienia motywu';

  @override
  String get darkMode => 'Tryb ciemny';

  @override
  String get lightMode => 'Tryb jasny';

  @override
  String get systemTheme => 'Motyw systemowy';

  @override
  String get primaryColor => 'Kolor podstawowy';

  @override
  String get accentColor => 'Kolor akcentu';

  @override
  String get customFont => 'Własna czcionka';

  @override
  String get backupSettings => 'Ustawienia kopii zapasowej';

  @override
  String get autoBackup => 'Automatyczna kopia zapasowa';

  @override
  String get backupFrequency => 'Częstotliwość kopii zapasowej';

  @override
  String get exportBackup => 'Eksportuj kopię zapasową';

  @override
  String get importBackup => 'Importuj kopię zapasową';

  @override
  String get privacySettings => 'Ustawienia prywatności';

  @override
  String get analytics => 'Analityka';

  @override
  String get shareUsageData => 'Udostępnij dane o użytkowaniu';

  @override
  String get allowScreenshots => 'Zezwól na zrzuty ekranu';

  @override
  String get storeLocationData => 'Przechowuj dane lokalizacji';

  @override
  String get journalPreferences => 'Preferencje dziennika';

  @override
  String get defaultView => 'Domyślny widok';

  @override
  String get sortOrder => 'Kolejność sortowania';

  @override
  String get fontSize => 'Rozmiar czcionki';

  @override
  String get showDateHeaders => 'Pokaż nagłówki dat';

  @override
  String get showTags => 'Pokaż tagi';

  @override
  String get enableSpellCheck => 'Włącz sprawdzanie pisowni';
}