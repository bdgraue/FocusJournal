#!/usr/bin/env python3
"""Erzeugt aus der zweisprachigen docs/privacy-policy.html die beiden
einsprachigen Website-Fassungen:

  website/datenschutz.html   (Deutsch)
  website/en/privacy.html    (Englisch)

Die Quelle bleibt die einzige zu pflegende Datei. Nach jeder Änderung an
docs/privacy-policy.html dieses Skript erneut ausführen:

  python3 tool/split_privacy_policy.py

Das Skript scheitert hart, wenn die erwarteten Marker in der Quelle fehlen —
lieber ein Fehler als eine stillschweigend unvollständige Rechtstext-Seite.
"""

from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
QUELLE = REPO / "docs" / "privacy-policy.html"
ZIEL_DE = REPO / "website" / "datenschutz.html"
ZIEL_EN = REPO / "website" / "en" / "privacy.html"

MARKER_DE = "<!-- ===== DEUTSCH ===== -->"
MARKER_EN = "<!-- ===== ENGLISH ===== -->"
MARKER_FUSS = "<footer>"
MARKER_SCRIPT_AUF = "<script>"
MARKER_SCRIPT_ZU = "</script>"

SWITCH = """  <div class="lang-switch">
    <button class="lang-btn active" onclick="setLang('de')" id="btn-de">DE</button>
    <button class="lang-btn" onclick="setLang('en')" id="btn-en">EN</button>
  </div>"""

SWITCH_DE = """  <div class="lang-switch">
    <a class="lang-btn" href="en/privacy.html" hreflang="en" lang="en">EN</a>
  </div>"""

SWITCH_EN = """  <div class="lang-switch">
    <a class="lang-btn" href="../datenschutz.html" hreflang="de" lang="de">DE</a>
  </div>"""

# Der Sprachwechsel ist in den Splits ein Link, kein Button.
LINK_CSS = "    .lang-switch a { text-decoration: none; display: inline-block; }\n  </style>"

MARKER_FAVICON = "<!-- FAVICON: wird beim Split durch den passenden Pfad ersetzt -->"
FAVICON_DE = '<link rel="icon" href="assets/logo.png" type="image/png">'
FAVICON_EN = '<link rel="icon" href="../assets/logo.png" type="image/png">'

TITEL = "<title>Focus Journal – Datenschutzerklärung / Privacy Policy</title>"
SUB_DE = "Datenschutzerklärung · Stand: August 2026"
SUB_EN = "Privacy Policy · Last updated: August 2026"


def schneide(text: str, von: str, bis: str) -> str:
    """Entfernt den Abschnitt [von, bis) aus text; beide Marker müssen
    genau einmal vorkommen und in dieser Reihenfolge stehen."""
    a = text.index(von)
    b = text.index(bis)
    assert a < b, f"Marker in falscher Reihenfolge: {von!r} nach {bis!r}"
    return text[:a] + text[b:]


def gemeinsam(text: str) -> str:
    """Umbauten, die beide Fassungen brauchen."""
    # setLang-Script komplett entfernen (inkl. Leerzeile davor unerheblich).
    a = text.index(MARKER_SCRIPT_AUF)
    b = text.index(MARKER_SCRIPT_ZU, a) + len(MARKER_SCRIPT_ZU)
    text = text[:a] + text[b:]
    # Umschalt-CSS wird nicht mehr gebraucht; Wrapper bleiben sichtbar.
    text = text.replace("    [data-lang] { display: none; }\n", "")
    text = text.replace("    [data-lang].visible { display: block; }\n", "")
    text = text.replace('<div data-lang="de" class="visible">', "<div>")
    text = text.replace('<div data-lang="en">', "<div>")
    # Link-Optik für den Sprachwechsel ans Ende des Stylesheets.
    assert text.count("  </style>") == 1
    text = text.replace("  </style>", LINK_CSS)
    return text


quelle = QUELLE.read_text(encoding="utf-8")

# Eindeutigkeit aller Marker in der QUELLE prüfen — nach dem Zuschnitt sind
# die Sprachmarker der jeweils anderen Fassung absichtlich verschwunden.
for marker in (MARKER_DE, MARKER_EN, MARKER_FUSS, SWITCH, TITEL,
               MARKER_SCRIPT_AUF, MARKER_FAVICON, "  </style>",
               "    [data-lang] { display: none; }\n",
               "    [data-lang].visible { display: block; }\n"):
    assert quelle.count(marker) == 1, f"Marker nicht eindeutig: {marker!r}"

de = schneide(quelle, MARKER_EN, MARKER_FUSS)
de = gemeinsam(de)
de = de.replace(TITEL, "<title>Focus Journal – Datenschutzerklärung</title>")
de = de.replace(SWITCH, SWITCH_DE)
de = de.replace(MARKER_FAVICON, FAVICON_DE)

en = schneide(quelle, MARKER_DE, MARKER_EN)
en = gemeinsam(en)
en = en.replace('<html lang="de">', '<html lang="en">')
en = en.replace(TITEL, "<title>Focus Journal – Privacy Policy</title>")
en = en.replace(SWITCH, SWITCH_EN)
en = en.replace(MARKER_FAVICON, FAVICON_EN)
assert en.count(SUB_DE) == 1, "Header-Untertitel nicht gefunden"
en = en.replace(SUB_DE, SUB_EN)

for ziel, inhalt, wort in ((ZIEL_DE, de, "Verantwortlicher"),
                           (ZIEL_EN, en, "Data Controller")):
    assert wort in inhalt, f"{ziel.name}: erwarteter Inhalt fehlt ({wort!r})"
    assert "data-lang" not in inhalt, f"{ziel.name}: data-lang-Reste"
    assert "setLang" not in inhalt, f"{ziel.name}: Script-Reste"
    assert MARKER_FAVICON not in inhalt, f"{ziel.name}: Favicon-Marker nicht ersetzt"
    ziel.parent.mkdir(parents=True, exist_ok=True)
    ziel.write_text(inhalt, encoding="utf-8")
    print(f"geschrieben: {ziel.relative_to(REPO)} ({len(inhalt)} Zeichen)")
