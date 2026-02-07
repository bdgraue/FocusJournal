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
  String get language => 'Język';

  @override
  String get languageSettings => 'Ustawienia języka';

  @override
  String get systemLanguage => 'Domyślny system';

  @override
  String get languageDescription => 'Wybierz preferowany język';

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

  @override
  String get viewAndLayout => 'Widok i układ';

  @override
  String get displayOptions => 'Opcje wyświetlania';

  @override
  String get editing => 'Edycja';

  @override
  String get calendarView => 'Widok kalendarza';

  @override
  String get listView => 'Widok listy';

  @override
  String get timelineView => 'Widok osi czasu';

  @override
  String get newestFirst => 'Najnowsze najpierw';

  @override
  String get oldestFirst => 'Najstarsze najpierw';

  @override
  String get titleAscending => 'Tytuł (A-Z)';

  @override
  String get titleDescending => 'Tytuł (Z-A)';

  @override
  String get fontSizeSmall => 'Mały';

  @override
  String get fontSizeMedium => 'Średni';

  @override
  String get fontSizeLarge => 'Duży';

  @override
  String get fontSizeExtraLarge => 'Bardzo duży';

  @override
  String get showDateHeadersDescription => 'Wyświetlaj separatory dat między wpisami';

  @override
  String get showTagsDescription => 'Wyświetlaj tagi w podglądach wpisów';

  @override
  String get enableSpellCheckDescription => 'Sprawdzaj pisownię podczas pisania';

  @override
  String get privacyAndData => 'Prywatność i dane';

  @override
  String get privacyControls => 'Kontrole prywatności';

  @override
  String get dataManagement => 'Zarządzanie danymi';

  @override
  String get collectAnalytics => 'Zbieraj analitykę';

  @override
  String get collectAnalyticsDescription => 'Pomóż ulepszyć aplikację, udostępniając anonimowe statystyki użytkowania';

  @override
  String get shareUsageDataDescription => 'Wysyłaj anonimowe wzorce użytkowania, aby wspomóc rozwój';

  @override
  String get showJournalOnWidget => 'Pokaż dziennik w widżecie';

  @override
  String get showJournalOnWidgetDescription => 'Wyświetlaj ostatnie wpisy w widżecie ekranu głównego';

  @override
  String get allowScreenshotsDescription => 'Zezwalaj na zrzuty ekranu wpisów dziennika';

  @override
  String get storeLocationDataDescription => 'Dołączaj informacje o lokalizacji do wpisów dziennika';

  @override
  String get enableCrashReporting => 'Włącz raportowanie awarii';

  @override
  String get enableCrashReportingDescription => 'Automatycznie wysyłaj raporty awarii, aby pomóc naprawić błędy';

  @override
  String get clearAllData => 'Wyczyść wszystkie dane';

  @override
  String get clearAllDataDescription => 'Trwale usuń wszystkie wpisy dziennika i ustawienia';

  @override
  String get clearAllDataWarning => 'Ta czynność nie może być cofnięta. Wszystkie wpisy dziennika zostaną trwale usunięte.';

  @override
  String entriesWillBeDeleted(int count) => '$count wpisów zostanie usuniętych';

  @override
  String get deleteAll => 'Usuń wszystko';

  @override
  String get dataCleared => 'Wszystkie dane zostały wyczyszczone';

  @override
  String get errorClearingData => 'Błąd podczas czyszczenia danych';

  @override
  String get clearDataWarningNote => 'Uwaga: Czyszczenie danych jest trwałe i nie można go cofnąć. Upewnij się, że wykonałeś kopię zapasową ważnych wpisów.';

  @override
  String get today => 'Dzisiaj';

  @override
  String get yesterday => 'Wczoraj';

  @override
  String get newEntry => 'Nowy wpis';

  @override
  String get editEntry => 'Edytuj wpis';

  @override
  String get writeYourThoughts => 'Zapisz swoje myśli...';

  @override
  String get contentRequired => 'Treść jest wymagana';

  @override
  String get incorrectPattern => 'Nieprawidłowy wzór';
  @override
  String get pleaseDrawYourPattern => 'Proszę narysować wzór';
  @override
  String get useBackupPassword => 'Użyj hasła zapasowego';
  @override
  String get usePin => 'Użyj PINu';
  @override
  String get usePattern => 'Użyj wzoru';
  @override
  String get incorrectPassword => 'Nieprawidłowe hasło';
  @override
  String get incorrectPin => 'Nieprawidłowy PIN';
  @override
  String get incorrectBackupPassword => 'Nieprawidłowe hasło zapasowe';
  @override
  String get pleaseEnterYourPassword => 'Proszę wprowadzić hasło';
  @override
  String get pleaseEnterYourPin => 'Proszę wprowadzić PIN';
  @override
  String get pleaseEnterYourBackupPassword => 'Proszę wprowadzić hasło zapasowe';
  @override
  String get confirmPassword => 'Potwierdź hasło';
  @override
  String get pleaseEnterAPassword => 'Proszę wprowadzić hasło';
  @override
  String passwordMinLength(int minLength) => 'Hasło musi mieć co najmniej $minLength znaków';
  @override
  String get passwordsDoNotMatch => 'Hasła nie pasują do siebie';
  @override
  String get journalExportedSuccessfully => 'Dziennik wyeksportowany pomyślnie';
  @override
  String exportFailed(String error) => 'Eksport nieudany: $error';
  @override
  String importFailed(String error) => 'Import nieudany: $error';
  @override
  String get importStrategy => 'Strategia importu';
  @override
  String get completeOverwrite => 'Całkowite nadpisanie';
  @override
  String get replaceAllData => 'Zastąp wszystkie istniejące dane';
  @override
  String get smartMerge => 'Inteligentne scalanie (Zalecane)';
  @override
  String get mergeWithConflicts => 'Scalanie z rozwiązywaniem konfliktów';
  @override
  String get addNewOnly => 'Dodaj tylko nowe';
  @override
  String get onlyImportNew => 'Importuj tylko nowe wpisy';
  @override
  String get cancel => 'Anuluj';
  @override
  String get proceed => 'Kontynuuj';
  @override
  String get couldNotGetFilePath => 'Nie udało się uzyskać ścieżki pliku';
  @override
  String get noFileSelected => 'Nie wybrano pliku';
  @override
  String filePickFailed(String error) => 'Wybór pliku nieudany: $error';
  @override
  String get backupAndRecovery => 'Kopia zapasowa i odzyskiwanie';
  @override
  String get backupPasswordLabel => 'Hasło kopii zapasowej';
  @override
  String get backupPasswordHint => 'Ustaw hasło, aby zabezpieczyć swoje kopie zapasowe';
  @override
  String get passwordRequired => 'Hasło jest wymagane';
  @override
  String get createBackup => 'Utwórz kopię zapasową';
  @override
  String get restoreBackup => 'Przywróć kopię zapasową';
  @override
  String get saveBackupLocally => 'Zapisz kopię zapasową lokalnie';
  @override
  String get createAndShareBackup => 'Utwórz i udostępnij kopię zapasową';
  @override
  String get backupSavedSuccessfully => 'Kopia zapasowa została zapisana pomyślnie';
  @override
  String backupSavedTo(String path) => 'Kopia zapasowa zapisana w: $path';
  @override
  String importSuccessMessage(int added, int updated, int total) =>
      'Import udany: +$added nowych, ~$updated zaktualizowanych, $total łącznie.';
  @override
  String get appearance => 'Wygląd';
  @override
  String get colors => 'Kolory';
  @override
  String get typography => 'Typografia';
  @override
  String get useCustomFont => 'Użyj własnej czcionki';
  @override
  String get fontFamily => 'Rodzina czcionki';
  @override
  String get advancedSettings => 'Zaawansowane';
  @override
  String get dynamicTheming => 'Dynamiczny motyw';
  @override
  String get dynamicThemingDescription => 'Dostosuj kolory na podstawie tapety';
  @override
  String get contrastLabel => 'Kontrast';
  @override
  String get pickAColor => 'Wybierz kolor';

  @override
  String get biometricPrompt => 'Uwierzytelnij się, aby uzyskać dostęp do dziennika';

  @override
  String get enableBiometricsQuestion => 'Czy chcesz włączyć uwierzytelnianie biometryczne dla szybkiego dostępu?';

  @override
  String get skip => 'Pomiń';

  @override
  String get biometricAuthFailed => 'Uwierzytelnianie biometryczne nie powiodło się';

  @override
  String get editEntries => 'Edytuj wpisy';
  @override
  String get done => 'Gotowe';
  @override
  String get notificationsAndReminders => 'Powiadomienia i przypomnienia';
  @override
  String get dailyReminders => 'Codzienne przypomnienia';
  @override
  String get dailyRemindersDescription => 'Otrzymuj przyjazne przypomnienie o pisaniu w dzienniku';
  @override
  String get reminderTime => 'Godzina przypomnienia';

  // --- View entry ---
  @override
  String get viewEntry => 'Zobacz wpis';

  // --- Search & Calendar ---
  @override
  String get search => 'Szukaj';
  @override
  String get searchEntries => 'Szukaj wpisów...';
  @override
  String get noSearchResults => 'Nie znaleziono wpisów';
  @override
  String get calendarOverview => 'Kalendarz';
  @override
  String get noEntriesForDay => 'Brak wpisów na ten dzień';

  // --- Security ---
  @override
  String tooManyAttempts(int seconds) => 'Zbyt wiele prób. Poczekaj $seconds sekund.';
  @override
  String attemptsRemaining(int count) => 'Pozostało $count prób';
  @override
  String get passwordComplexityError => 'Musi zawierać wielką, małą literę, cyfrę i znak specjalny';
  @override
  String get unexpectedError => 'Wyst\u0105pi\u0142 nieoczekiwany b\u0142\u0105d. Spr\u00f3buj ponownie.';

  // --- Podziękowania ---
  @override
  String get credits => 'Podzi\u0119kowania';
  @override
  String get creditsDeike => 'Za jej wspania\u0142e pomys\u0142y i wk\u0142ad w sukces tej aplikacji. A tak\u017ce za cudowne rozmowy o ka\u017cdej porze, czu\u0142o\u015b\u0107 i uczucie, kt\u00f3re otrzymuj\u0119.';
}
