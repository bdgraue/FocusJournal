# Store- und Website-Screenshots

Die Screenshots entstehen aus einem echten App-Lauf auf einem Emulator, nicht
von Hand: `integration_test/store_screenshots_test.dart` richtet eine
Demo-Installation ein (Sperre, Design, Tagebuch-Einträge), klickt die
Bildschirme durch und legt die Bilder über
`test_driver/store_screenshots_driver.dart` ab. Muster: die Quirl- und die
Daily-Thoughts-App.

## Emulator

Play erlaubt für Handy-Screenshots höchstens 2:1 — die üblichen 1080×2400
(2,22:1) sind ungeeignet. Gelöst wird das **nicht** über ein eigenes AVD,
sondern über einen Größen-Override zur Laufzeit.

Verifiziertes Rezept für diese Maschine (identisch zu Quirl und Daily Thoughts,
siehe deren Projekt-Memory `android-emulator-quirks.md`):

```
~/Android/Sdk/emulator/emulator -avd Medium_Phone_API_36.1 \
  -no-window -no-snapshot -no-audio -no-boot-anim -gpu swiftshader_indirect
adb wait-for-device
until adb shell pm path android >/dev/null 2>&1; do sleep 5; done
adb shell wm size 1080x1920
adb shell settings put global window_animation_scale 0
adb shell settings put global transition_animation_scale 0
adb shell settings put global animator_duration_scale 0
```

Nach dem Lauf: `adb shell wm size reset`.

> **Nimm das gewachsene AVD, nicht ein frisches.** Mit dem System-Image
> `android-36.1 google_apis_playstore` stürzt auf einem per `avdmanager`
> erzeugten AVD der Gast-`surfaceflinger` in Schleife ab —
> `Assertion failed: !rcEnc->featureInfo()->hasReadColorBufferDma`
> (`GoldfishMapper::readFromHost`, aufgerufen aus
> `RegionSamplingThread::threadMain`). Jeder Absturz reißt `system_server` mit;
> danach scheitern `adb install` (NPE in
> `StorageManagerService.allocateBytes`) und `am start` („Activity class …
> does not exist"), obwohl das APK in Ordnung ist. Weder ein `-gpu`-Flag noch
> `-feature -GLDMA` noch ein Emulator-Update lösen das. `Medium_Phone_API_36.1`
> ist mit demselben Image stabil.

> **Immer `-no-window`.** Auf diesem Host (AMD RX 7600 XT, Mesa 26) segfaultet
> der Emulator mit Qt-Fenster und `-gpu host` sofort.

> **Wenn `adb install` „Can't find service: package" meldet:** meist ist /data
> voll, weil das Play-Store-Image die Google-Dienste selbst aktualisiert.
> Zerstörungsfrei: `adb shell pm uninstall-system-updates`.

Der Lauf braucht `android/app/debug.keystore` — `android/app/build.gradle.kts`
pinnt eine eigene Debug-Signatur, und Keystores sind aus Git verbannt. Einmalig
mit den Android-Standardwerten erzeugen:

```
keytool -genkeypair -v -keystore android/app/debug.keystore \
  -storepass android -alias androiddebugkey -keypass android \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -dname "CN=Android Debug,O=Android,C=US"
```

## Sprache

Die App hat keinen eigenen Sprachwähler (`lib/main.dart` übergibt der
`MaterialApp` kein `locale:`) — sie folgt dem Gerät. Der Test erzwingt die
Oberflächensprache deshalb selbst über
`binding.platformDispatcher.localesTestValue`, gesteuert von
`FJ_SHOT_LOCALE`. Am Gerät ist **nichts** einzustellen.

> Der naheliegende Weg über
> `adb shell cmd locale set-app-locales com.warikoda.focus_journal --locales de-DE`
> funktioniert hier **nicht**: `flutter drive` installiert die App vor jedem
> Lauf neu, und die Neuinstallation verwirft die App-Sprache. Ergebnis wären
> stillschweigend deutsche Screenshots im `en`-Ordner.

## Läufe

Pro Sprache **und** Design ein Lauf:

```
flutter drive \
  --driver=test_driver/store_screenshots_driver.dart \
  --target=integration_test/store_screenshots_test.dart \
  --dart-define=FJ_SHOT_LOCALE=de \
  --dart-define=FJ_SHOT_THEME=light \
  -d emulator-5554
# … und erneut mit FJ_SHOT_LOCALE=en bzw. FJ_SHOT_THEME=dark
```

Ergebnis unter `store_assets/screenshots/<locale>/phone/<theme>/NN-*.png`
(gitignored). Maße vor dem Upload prüfen: `identify store_assets/screenshots/**/*.png`.

## Was der Lauf nebenbei aufdeckt

Der Test läuft gegen eine echte Debug-Installation und legt damit Fehler offen,
die im Alltag durchrutschen. Beim ersten Durchlauf war das ein
`LateInitializationError` in `lib/screens/theme_settings_screen.dart`: Das
`late`-Feld `_themeService` wurde beim ersten `build()` gelesen, obwohl
`initState` es erst asynchron setzte. Behoben, indem der Dienst aus dem
Provider gelesen wird, den `ThemeSettingsScreen` ohnehin um das Widget legt.

Wenn der Lauf also scheitert: erst prüfen, ob der Test eine echte
App-Regression gefunden hat, bevor am Test geschraubt wird.

## Motive

| Datei | Bildschirm |
|---|---|
| `01-journal` | Tagebuch mit Einträgen (`journal_screen`) |
| `02-calendar` | Kalenderübersicht (`calendar_screen`) |
| `03-search` | Volltextsuche mit Treffern (`search_screen`) |
| `04-highlights` | Sterne-Sammlung (`highlights_screen`) |
| `05-write` | Eintrag schreiben (`journal_entry_screen`) |
| `06-lock` | Sperrbildschirm (`authentication_screen`) |
| `07-backup` | Backup & Wiederherstellung (`backup_screen`) |
| `08-settings` | Einstellungen (`general_settings_screen`) |
| `09-theme` | Design-Einstellungen (`theme_settings_screen`) |

Für das Play-Listing sind höchstens 8 Handy-Screenshots erlaubt — dort
`09-theme` weglassen. Die Website zeigt alle neun.

## Weitergabe an die Website

`python3 tool/website_screenshots.py` erledigt das: Es kopiert die Bilder nach
`website/assets/screenshots/<locale>/phone/<light|dark>/` und setzt sie in die
Funktionsstreifen beider Startseiten ein — je Bildschirm ein Streifen aus Bild
und Erklärtext. Details in `website/README.md`.
