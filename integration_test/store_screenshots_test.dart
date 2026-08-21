import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:focus_journal/main.dart';
import 'package:focus_journal/screens/backup_screen.dart';
import 'package:focus_journal/screens/calendar_screen.dart';
import 'package:focus_journal/screens/general_settings_screen.dart';
import 'package:focus_journal/screens/highlights_screen.dart';
import 'package:focus_journal/screens/journal_entry_screen.dart';
import 'package:focus_journal/screens/search_screen.dart';
import 'package:focus_journal/screens/theme_settings_screen.dart';
import 'package:focus_journal/services/authentication_service.dart';
import 'package:focus_journal/services/journal_service.dart';
import 'package:focus_journal/services/theme_service.dart';
import 'package:focus_journal/widgets/journal_entry_card.dart';

/// Erzeugt die Store- und Website-Screenshots (Muster: Quirl, Daily Thoughts).
/// Läuft auf einem Emulator mit Play-tauglicher Auflösung (1080×1920) über
/// `flutter drive` mit `test_driver/store_screenshots_driver.dart` — Aufruf
/// siehe store_assets/README.md.
///
/// `FJ_SHOT_LOCALE` bestimmt den Ablage-Ordner, die Sprache der Demo-Einträge
/// UND die Sprache der Oberfläche. Letztere wird im Test über
/// `binding.platformDispatcher.localesTestValue` erzwungen — die App hat
/// keinen eigenen Sprachwähler (lib/main.dart übergibt der MaterialApp kein
/// `locale:`), und eine per `adb shell cmd locale set-app-locales` gesetzte
/// App-Sprache überlebt die Neuinstallation durch `flutter drive` nicht.
const _locale = String.fromEnvironment('FJ_SHOT_LOCALE', defaultValue: 'de');

/// `light` oder `dark` — wird vor dem Start als ThemeMode persistiert. Die
/// Website-Galerie zeigt je Seiten-Design den passenden Satz.
const _theme = String.fromEnvironment('FJ_SHOT_THEME', defaultValue: 'light');

/// Formfaktor; bestimmt nur den Ablage-Ordner. Die Auflösung kommt vom Gerät.
const _device = String.fromEnvironment('FJ_SHOT_DEVICE', defaultValue: 'phone');

/// Zugangsdaten der Demo-Installation. Die App verlangt eine eingerichtete
/// Sperre, bevor sie das Tagebuch zeigt — der Lauf richtet sie ein und
/// entsperrt danach wie eine echte Nutzerin.
const _backupPasswort = 'FocusShots#2026';
const _pin = '204815';

/// Demo-Einträge je Sprache: Text und Abstand zu heute in Tagen.
const _eintraege = {
  'de': [
    (0, 'Der Morgen war zäh. Dann eine Stunde am Stück gearbeitet — ohne '
        'Handy, ohne Nachrichten. Danach war der Kopf leicht.', true),
    (1, 'Langer Spaziergang am Deich. Der Wind hat alles leer geräumt, was '
        'sich über die Woche angesammelt hatte.', false),
    (2, 'Heute wenig geschafft, und das ist in Ordnung. Nicht jeder Tag muss '
        'etwas beweisen.', false),
    (3, 'Das Gespräch, vor dem ich mich zwei Wochen gedrückt habe, hat zehn '
        'Minuten gedauert. Zehn Minuten.', true),
    (5, 'Früh aufgestanden, als das Haus noch ruhig war. Eine Stunde nur für '
        'mich, bevor der Tag anfängt.', false),
    (8, 'Wieder zu spät ins Bett. Morgen wandert das Handy aus dem '
        'Schlafzimmer.', false),
    (12, 'Erste Seite im neuen Notizbuch. Fühlt sich an wie ein aufgeräumter '
        'Tisch.', true),
    (15, 'Regen den ganzen Tag. Tee, Decke, ein Buch — mehr hat es nicht '
        'gebraucht.', false),
  ],
  'en': [
    (0, 'The morning dragged. Then one full hour of work — no phone, no '
        'messages. Afterwards my head felt light.', true),
    (1, 'Long walk along the dyke. The wind cleared out everything the week '
        'had piled up.', false),
    (2, 'Got little done today, and that is fine. Not every day has to prove '
        'something.', false),
    (3, 'The conversation I had been avoiding for two weeks took ten '
        'minutes. Ten minutes.', true),
    (5, 'Up early, while the house was still quiet. One hour just for me '
        'before the day starts.', false),
    (8, 'Went to bed too late again. Tomorrow the phone stays out of the '
        'bedroom.', false),
    (12, 'First page in the new notebook. Feels like a tidy desk.', true),
    (15, 'Rain all day. Tea, a blanket, a book — nothing else needed.', false),
  ],
};

/// Suchbegriff, der in mehreren Demo-Einträgen vorkommt.
const _suchbegriff = {'de': 'Stunde', 'en': 'hour'};

/// Text für den Screenshot „Eintrag schreiben".
const _neuerEintrag = {
  'de': 'Heute drei Dinge, die gut gelaufen sind — und keins davon stand auf '
      'der Liste.',
  'en': 'Three things that went well today — and none of them was on the '
      'list.',
};

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shot(WidgetTester tester, String name) async {
    await tester.pumpAndSettle();
    await binding.takeScreenshot('$_locale/$_device/$_theme/$name');
  }

  // Live-Binding: pumpAndSettle kehrt teils vor Ende einer Routen-Transition
  // zurück (Lektion aus den Quirl-/Daily-Thoughts-Läufen) — deshalb explizit
  // auf das Ziel warten und hart scheitern, statt still den falschen Screen
  // zu knipsen.
  Future<void> warteAuf(WidgetTester tester, Finder ziel, String was) async {
    await tester.pumpAndSettle();
    for (var i = 0; i < 50; i++) {
      if (ziel.evaluate().isNotEmpty) break;
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(ziel, findsWidgets, reason: '$was ist nicht erschienen.');
  }

  /// Öffnet einen Eintrag des Überlaufmenüs der Startseite.
  Future<void> menuTap(
    WidgetTester tester,
    IconData icon,
    Finder ziel,
    String was,
  ) async {
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(icon).last);
    await warteAuf(tester, ziel, was);
  }

  Future<void> zurueck(WidgetTester tester) async {
    await tester.tap(find.byType(BackButton).last);
    await tester.pumpAndSettle();
  }

  testWidgets('Store- und Website-Screenshots erzeugen', (tester) async {
    if (_eintraege[_locale] == null) {
      fail('FJ_SHOT_LOCALE muss de oder en sein, war: $_locale');
    }
    if (_theme != 'light' && _theme != 'dark') {
      fail('FJ_SHOT_THEME muss light oder dark sein, war: $_theme');
    }

    await initializeDateFormatting();

    // Das DEBUG-Band gehört nicht auf Store-Bilder.
    WidgetsApp.debugAllowBannerOverride = false;


    // Sterne sind für die Screenshots an (Standard der App).
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('stars_enabled', true);

    // Sperre einrichten: erst das Passwort (setzt hasSetupAuth), dann die
    // PIN als aktive Methode — das Passwort bleibt als Rückfallweg stehen.
    final auth = AuthenticationService();
    await auth.setupPassword(_backupPasswort);
    await auth.setupPin(_pin);

    // Design festnageln: dynamische Farben aus, damit der Emulator-Hintergrund
    // die Palette nicht verändert (lib/main.dart nutzt sonst DynamicColor).
    final themeService = await ThemeService.getInstance();
    await themeService.setDynamicTheming(false);
    await themeService.setThemeMode(
      _theme == 'dark' ? ThemeMode.dark : ThemeMode.light,
    );

    // Tagebuch mit Demo-Einträgen füllen — der Lauf soll wie eine gepflegte
    // Installation aussehen. Vorher leeren, damit Läufe wiederholbar sind.
    final journal = await JournalService.create();
    await journal.clearAllEntries();
    final jetzt = DateTime.now();
    final heute = DateTime(jetzt.year, jetzt.month, jetzt.day);
    final eintraege = <JournalEntry>[];
    for (final (abstand, text, markiert) in _eintraege[_locale]!) {
      final zeitpunkt = heute
          .subtract(Duration(days: abstand))
          .add(const Duration(hours: 20, minutes: 40));
      eintraege.add(JournalEntry(
        content: text,
        createdAt: zeitpunkt,
        lastModified: zeitpunkt,
        isHighlighted: markiert,
      ));
    }
    await journal.saveEntries(eintraege);

    // Oberflächensprache erzwingen: Die App folgt sonst dem Gerät, und die
    // Geräte-Locale ist je nach Emulator eine andere.
    binding.platformDispatcher.localesTestValue = [Locale(_locale)];
    addTearDown(binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Android rendert sonst auf einer Surface, die der Screenshot-Kanal nicht
    // lesen kann (integration_test-Doku zu convertFlutterSurfaceToImage).
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
    }

    // --- Die Sperre: muss vor dem Entsperren aufgenommen werden. ---
    await warteAuf(tester, find.byType(TextField), 'PIN-Feld der Sperre');
    await shot(tester, '06-lock');

    await tester.enterText(find.byType(TextField), _pin);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ElevatedButton));
    await warteAuf(tester, find.byType(JournalEntryCard), 'Tagebuch-Liste');
    await shot(tester, '01-journal');

    // --- Kalender ---
    await menuTap(tester, Icons.calendar_month, find.byType(CalendarScreen),
        'Kalender');
    await shot(tester, '02-calendar');
    await zurueck(tester);

    // --- Suche ---
    await menuTap(tester, Icons.search, find.byType(SearchScreen), 'Suche');
    await tester.enterText(find.byType(TextField).first, _suchbegriff[_locale]!);
    await warteAuf(tester, find.byType(JournalEntryCard), 'Suchtreffer');
    await shot(tester, '03-search');
    await zurueck(tester);

    // --- Highlights ---
    await menuTap(tester, Icons.star_outline, find.byType(HighlightsScreen),
        'Highlights');
    await shot(tester, '04-highlights');
    await zurueck(tester);

    // --- Eintrag schreiben ---
    await tester.tap(find.byIcon(Icons.add));
    await warteAuf(tester, find.byType(JournalEntryScreen), 'Neuer Eintrag');
    await tester.enterText(find.byType(TextField).last, _neuerEintrag[_locale]!);
    await shot(tester, '05-write');
    await zurueck(tester);

    // --- Einstellungen, Backup, Design ---
    await menuTap(tester, Icons.settings_outlined,
        find.byType(GeneralSettingsScreen), 'Einstellungen');
    await shot(tester, '08-settings');

    await tester.tap(find.byIcon(Icons.backup));
    await warteAuf(tester, find.byType(BackupScreen), 'Backup-Bildschirm');
    await shot(tester, '07-backup');
    await zurueck(tester);

    await tester.tap(find.byIcon(Icons.palette_outlined));
    await warteAuf(tester, find.byType(ThemeSettingsScreen), 'Design-Einstellungen');
    await shot(tester, '09-theme');
  });
}
