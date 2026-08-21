# Focus-Journal-Website

Statische Seite (HTML/CSS/JS) ohne externe Ressourcen — sie stellt Focus
Journal vor und trägt die Rechtstexte, deren URL das Play-Store-Listing
verlangt. Muster: die Quirl- und die Daily-Thoughts-Website.

## Struktur

| Datei | Inhalt |
|---|---|
| `index.html` / `en/index.html` | Startseite Deutsch / Englisch, in einfacher Sprache |
| `datenschutz.html` / `en/privacy.html` | **erzeugt** aus `docs/privacy-policy.html` per `python3 tool/split_privacy_policy.py` — nicht von Hand bearbeiten |
| `impressum.html` / `en/legal-notice.html` | Impressum Deutsch / Englisch, Angaben identisch zur Quirl-Website |
| `assets/` | Stylesheet, Script, Logo (aus `assets/app_icon.png` auf 256 px verkleinert) und die Screenshots |

## Pflege

- **Datenschutzerklärung ändern:** immer in `docs/privacy-policy.html`
  bearbeiten (dort liegen beide Sprachen in einer Datei) und danach
  `python3 tool/split_privacy_policy.py` ausführen — das Skript erzeugt
  `datenschutz.html` und `en/privacy.html` neu und scheitert hart, wenn die
  Quell-Struktur nicht mehr passt. Ändert sich dabei die Monatsangabe
  („Stand: August 2026"), muss sie auch im Skript (`SUB_DE`/`SUB_EN`)
  nachgezogen werden.
- **Aufbau des Abschnitts „Funktionen":** ein Streifen je Bildschirm der App
  (`<article class="streifen">`), abwechselnd Bild links und rechts, getrennt
  durch eine Linie. Der Fließtext steht direkt im HTML — dort wird er auch
  geändert. Das Bild kommt aus dem leeren Container
  `<div class="streifen-bild" data-shot="NN-name">`; den füllt das Skript.
- **Screenshots erneuern:** die Läufe aus `store_assets/README.md` fahren,
  danach `python3 tool/website_screenshots.py`. Das Skript kopiert die Bilder
  aus `store_assets/screenshots/` hierher und setzt in jeden `data-shot`-
  Container das Bildpaar für hell und dunkel. Es scheitert hart, wenn ein
  Streifen kein Bild hat **oder** ein vorhandenes Bild von keinem Streifen
  verwendet wird — Seite und Bildbestand bleiben so in Deckung. Die
  Alternativtexte stehen im Skript in `ALT`.
- **Einen Bildschirm ergänzen:** Screenshot unter dem Namen `NN-name` erzeugen
  lassen (Motiv-Tabelle in `store_assets/README.md`), in `ALT` eintragen und
  in beiden Startseiten einen `<article class="streifen">` mit Text und
  passendem `data-shot` anlegen. Dann das Skript laufen lassen.
- **Hell/Dunkel-Schalter über den Streifen:** Er setzt `data-thema` an
  `.funktionsstreifen` und übersteuert damit das Seiten-Design — Besucher
  können die Screenshots in Dunkel ansehen, während die Seite hell bleibt
  (wie bei Quirl und Daily Thoughts). Ohne JavaScript bleibt er weg, und die
  Bilder folgen weiter dem Seiten-Design; dafür sorgen die `:where()`-Regeln
  in `assets/focusjournal.css`, die bewusst niedrige Spezifität haben.
- **Der Schalter bleibt beim Scrollen erreichbar:** Er sitzt in der Leiste
  `.bild-leiste`, die per `position: sticky` bündig unter der Kopfzeile
  klebt. Ihr Klebebereich endet automatisch mit dem Funktionen-Abschnitt,
  weil ihr Elternelement `.hof` dort endet — weiter unten, wo es keine
  Screenshots gibt, ist sie von selbst verschwunden. Die Leiste ist so breit
  wie der Textkörper und deckend; eine freistehende Pille würde beim Scrollen
  ein Rechteck in Text und Screenshots stanzen.
  - Klebt sie an der falschen Stelle, ist `--kopf-hoehe` in `:root` zu
    korrigieren (Höhe von `.kopf-zeile`), nicht der `top`-Wert der Leiste.
  - Das `hidden` gehört an `.bild-leiste`, **nicht** an `.bild-schalter`:
    Der Schalter trägt `display: flex`, und eine Autorenregel schlägt die
    Browser-Regel `[hidden] { display: none }` — dort wäre `hidden` still
    wirkungslos. Für den Fall, dass `.bild-leiste` später doch ein `display`
    bekommt, steht `.bild-leiste[hidden] { display: none; }` ausdrücklich im
    Stylesheet.
- **Die Bausteine der Startseite:**
  - `.zusagen` — das Zahlen-Band unter dem Held. Jede Ziffer steht im
    Plan-/Beleg-Zusammenhang: 5 Berechtigungen aus dem Release-Manifest,
    7 Sprachen aus `lib/l10n/translations/`, 100.000 Schlüsselrunden aus
    `backup_service.dart`. Ändert sich eine Zahl im Code, hier nachziehen.
  - `.berechtigungen` im Abschnitt `#quellcode` — die fünf tatsächlich
    angeforderten Berechtigungen und darunter abgesetzt die fehlende
    `INTERNET`-Zeile (`li.fehlt`). Quelle ist
    `android/app/src/main/AndroidManifest.xml`; kommt dort eine Berechtigung
    hinzu, gehört sie auch hierher.
  - `.streifen-text .beleg` — die Mono-Zeile mit der harten Zahl unter jedem
    Funktionstext. Adjektive gehören in den Fließtext, Zahlen hierher.
  - `.abbinder` am Ende des FAQ — Schlusssatz und Knopf auf liniertem Papier,
    das Gegenstück zur Held-Karte. Die Innenabstände sind Vielfache von
    1,9 rem, damit der Text auf den Linien sitzt; wer sie ändert, muss beim
    Raster bleiben.
  - `.abschnitt.gedeckt` — jeder zweite Abschnitt auf der Kartenfarbe
    (derzeit `#downloads` und `#faq`), damit die Seite gegliedert wirkt.
- **Downloads:** sobald die App bei Google Play live ist, in beiden
  Startseiten den Status „bald verfügbar" / „coming soon" durch den Play-Link
  ersetzen (`<a>`-Element, Status-Klasse `bereit`). Kommt ein Desktop-Build
  dazu, denselben Weg für die betreffende Kachel gehen — bis dahin bleibt
  dort „geplant" / „planned".
- **Logo neu erzeugen** (falls sich das App-Icon ändert):
  `magick assets/app_icon.png -resize 256x256 -strip website/assets/logo.png`
- **Upload:** den kompletten Inhalt von `website/` (ohne dieses README) auf
  den Webspace laden. Die URLs von `datenschutz.html` und `en/privacy.html`
  sind die Pflichtangaben fürs Play-Listing — nach dem ersten Veröffentlichen
  nicht mehr verschieben.

## Lokale Vorschau

```
cd website && python3 -m http.server 8080
```
