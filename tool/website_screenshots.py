#!/usr/bin/env python3
"""Übernimmt die Screenshots aus store_assets/ in die Website und setzt sie in
die Funktionsstreifen beider Startseiten ein.

  python3 tool/website_screenshots.py

Kopiert store_assets/screenshots/<locale>/phone/<theme>/NN-*.png nach
website/assets/screenshots/<locale>/phone/<theme>/ und füllt in
website/index.html bzw. website/en/index.html jeden Container
`<div class="streifen-bild" data-shot="NN-name">…</div>` mit dem Bildpaar für
helle und dunkle Darstellung. Der Fließtext der Streifen bleibt unangetastet —
er steht im HTML, nicht hier.

Scheitert hart, wenn ein Streifen kein Bild hat oder ein vorhandenes Bild von
keinem Streifen verwendet wird: lieber ein Fehler als eine Seite, die ein
fehlendes Bild nachlädt oder einen Screenshot stillschweigend unterschlägt.
"""

import re
import shutil
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
QUELLE = REPO / "store_assets" / "screenshots"
ZIEL = REPO / "website" / "assets" / "screenshots"

# Alternativtext je Motiv und Sprache. Er beschreibt, was auf dem Bild zu sehen
# ist — die Erklärung dazu steht als Fließtext im HTML.
ALT = {
    "01-journal": {
        "de": "Tagebuch-Liste mit Einträgen mehrerer Tage, Datumsüberschriften und Sternen",
        "en": "Journal list with entries from several days, date headings and stars",
    },
    "02-calendar": {
        "de": "Monatskalender; Tage mit Eintrag tragen einen Punkt",
        "en": "Month calendar; days with an entry carry a dot",
    },
    "03-search": {
        "de": "Suche mit hervorgehobener Fundstelle in den Treffern",
        "en": "Search with the match highlighted in the results",
    },
    "04-highlights": {
        "de": "Sammlung der mit Stern markierten Einträge",
        "en": "Collection of starred entries",
    },
    "05-write": {
        "de": "Neuer Eintrag mit Textfeld und Speichern-Symbol",
        "en": "New entry with text field and save icon",
    },
    "06-lock": {
        "de": "Sperrbildschirm mit PIN-Eingabe und Entsperren-Knopf",
        "en": "Lock screen with PIN entry and unlock button",
    },
    "07-backup": {
        "de": "Backup erstellen und wiederherstellen, mit Passwortfeld",
        "en": "Creating and restoring a backup, with password field",
    },
    "08-settings": {
        "de": "Einstellungen mit täglicher Erinnerung und Uhrzeit",
        "en": "Settings with the daily reminder and its time",
    },
    "09-theme": {
        "de": "Design-Einstellungen: hell, dunkel oder System",
        "en": "Theme settings: light, dark or system",
    },
}

SEITEN = {
    "de": (REPO / "website" / "index.html", "assets/screenshots"),
    "en": (REPO / "website" / "en" / "index.html", "../assets/screenshots"),
}

CONTAINER = re.compile(
    r'(<div class="streifen-bild" data-shot="([^"]+)">).*?(</div>)', re.S
)


def kopiere(locale: str) -> set[str]:
    """Kopiert die Bilder einer Sprache und liefert die Motiv-Schlüssel,
    die in mindestens einem Design vorliegen."""
    vorhanden: set[str] = set()
    for theme in ("light", "dark"):
        quelle = QUELLE / locale / "phone" / theme
        if not quelle.is_dir():
            continue
        ziel = ZIEL / locale / "phone" / theme
        ziel.mkdir(parents=True, exist_ok=True)
        for bild in sorted(quelle.glob("*.png")):
            shutil.copy2(bild, ziel / bild.name)
            vorhanden.add(bild.stem)
    unbekannt = vorhanden - ALT.keys()
    assert not unbekannt, f"Motiv ohne Alternativtext: {sorted(unbekannt)}"
    return vorhanden


def bildpaar(locale: str, praefix: str, motiv: str) -> str:
    """Beide Fassungen eines Motivs als <img>-Paar. Liegt nur eine vor, gilt
    sie für beide Designs."""
    alt = ALT[motiv][locale]
    hell = ZIEL / locale / "phone" / "light" / f"{motiv}.png"
    dunkel = ZIEL / locale / "phone" / "dark" / f"{motiv}.png"
    assert hell.exists() or dunkel.exists(), f"{motiv}: kein Bild vorhanden"
    quelle_hell = "light" if hell.exists() else "dark"
    quelle_dunkel = "dark" if dunkel.exists() else "light"
    return (
        "\n"
        f'            <img class="bild-hell" src="{praefix}/{locale}/phone/'
        f'{quelle_hell}/{motiv}.png" alt="{alt}" loading="lazy"'
        ' width="1080" height="1920">\n'
        f'            <img class="bild-dunkel" src="{praefix}/{locale}/phone/'
        f'{quelle_dunkel}/{motiv}.png" alt="{alt}" loading="lazy"'
        ' width="1080" height="1920">\n'
        "          "
    )


for locale, (seite, praefix) in SEITEN.items():
    vorhanden = kopiere(locale)
    assert vorhanden, f"{locale}: keine Screenshots unter {QUELLE / locale}"

    text = seite.read_text(encoding="utf-8")
    verwendet = [m.group(2) for m in CONTAINER.finditer(text)]
    assert verwendet, f"{seite.name}: kein Container mit data-shot gefunden"

    fehlend = [m for m in verwendet if m not in vorhanden]
    assert not fehlend, f"{seite.name}: Streifen ohne Bild: {fehlend}"
    ungenutzt = sorted(vorhanden - set(verwendet))
    assert not ungenutzt, (
        f"{seite.name}: Screenshots ohne Streifen: {ungenutzt} — entweder "
        "einen Streifen dafür anlegen oder das Bild aus store_assets entfernen"
    )

    text = CONTAINER.sub(
        lambda m: m.group(1) + bildpaar(locale, praefix, m.group(2)) + m.group(3),
        text,
    )
    seite.write_text(text, encoding="utf-8")
    print(f"{seite.relative_to(REPO)}: {len(verwendet)} Streifen bebildert")
