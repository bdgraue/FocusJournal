// Focus-Journal-Website — JavaScript ist reine Zugabe: Ohne dieses Script
// bleibt jede Seite vollständig lesbar und bedienbar. Kein Tracking, keine
// Requests. Muster: die Quirl- und die Daily-Thoughts-Website.

(function () {
  'use strict';

  // Hell/Dunkel: Systemwahl ist der Default; ein Klick übersteuert sie und
  // wird lokal gemerkt (localStorage, bleibt auf dem Gerät).
  var wurzel = document.documentElement;
  try {
    var gemerkt = localStorage.getItem('focusjournal-thema');
    if (gemerkt === 'light' || gemerkt === 'dark') {
      wurzel.setAttribute('data-theme', gemerkt);
    }
  } catch (fehler) {
    // Speicher gesperrt (z. B. strikte Privatsphäre-Einstellung) → nur Systemwahl.
  }

  // Aktuelles Seiten-Design (explizite Wahl vor Systemwahl).
  var istDunkel = function () {
    var gesetzt = wurzel.getAttribute('data-theme');
    if (gesetzt) return gesetzt === 'dark';
    return window.matchMedia('(prefers-color-scheme: dark)').matches;
  };

  document.addEventListener('DOMContentLoaded', function () {
    var knopf = document.getElementById('themawechsel');
    if (knopf) {
      var zeichne = function () {
        knopf.textContent = istDunkel() ? '☀' : '☾';
      };
      knopf.addEventListener('click', function () {
        var neu = istDunkel() ? 'light' : 'dark';
        wurzel.setAttribute('data-theme', neu);
        try {
          localStorage.setItem('focusjournal-thema', neu);
        } catch (fehler) {
          /* siehe oben */
        }
        zeichne();
      });
      zeichne();
    }

    // Bild-Schalter: Screenshots unabhängig vom Seiten-Design umschalten.
    // Startzustand folgt dem Seiten-Design; danach zählt nur noch die Wahl
    // am Schalter. Ohne JavaScript bleibt der Schalter versteckt und die
    // Bilder folgen weiter dem Seiten-Design (CSS-Fallback).
    var streifen = document.querySelector('.funktionsstreifen');
    var leiste = document.querySelector('.bild-leiste');
    var schalter = document.querySelector('.bild-schalter');
    if (streifen && leiste && schalter) {
      var waehle = function (thema) {
        streifen.setAttribute('data-thema', thema);
        schalter.querySelectorAll('button').forEach(function (b) {
          b.setAttribute('aria-pressed', String(b.dataset.thema === thema));
        });
      };
      schalter.querySelectorAll('button').forEach(function (b) {
        b.addEventListener('click', function () {
          waehle(b.dataset.thema);
        });
      });
      waehle(istDunkel() ? 'dark' : 'light');
      leiste.hidden = false;
    }

    // Streifen sanft einblenden, sobald sie in Sicht kommen. Der
    // Startzustand (unsichtbar) hängt im Stylesheet an .beobachtet — die
    // Klasse wird erst hier gesetzt. Ohne JavaScript ist damit alles sofort
    // sichtbar, statt für immer verborgen zu bleiben.
    var ruhig = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (streifen && !ruhig && 'IntersectionObserver' in window) {
      streifen.classList.add('beobachtet');
      var beobachter = new IntersectionObserver(function (eintraege) {
        eintraege.forEach(function (eintrag) {
          if (!eintrag.isIntersecting) return;
          eintrag.target.classList.add('sichtbar');
          beobachter.unobserve(eintrag.target);
        });
      }, { rootMargin: '0px 0px -12% 0px' });
      streifen.querySelectorAll('.streifen').forEach(function (s) {
        beobachter.observe(s);
      });
    }

    // Startsignal für die Animation der Tagebuchseite (CSS macht den Rest;
    // prefers-reduced-motion schaltet sie dort ab).
    wurzel.classList.add('geladen');
  });
})();
