# Focus Journal

> A calm, private journaling app for focus, reflection, and small daily wins.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/WariKoda/FocusJournal/pulls)
[![Code of Conduct](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md)

---

## About

Focus Journal is a local-first journaling app for people who want to build a
quiet daily practice around focus and reflection. No account, no cloud, no
tracking — your entries live on your device, encrypted.

> _Made with [kodawari](https://en.wikipedia.org/wiki/Kodawari) in mind:
> careful craftsmanship and attention to detail, in every small interaction._

## Features

- **Encrypted journal entries** — AES-256 encryption for all content
- **Multiple auth methods** — biometric (fingerprint/face), PIN, password, or pattern
- **Calendar view** — browse entries by date with an intuitive calendar
- **Full-text search** — find entries across your whole journal
- **Same-day editing** — entries are immutable after the day they were written
- **Encrypted backups** — AES-256-GCM with PBKDF2 (100k iterations), `.fjb` format
- **Material 3 design** — dynamic color (Android 12+), light & dark themes
- **Multilingual** — 7 languages (DE, EN, ES, FR, IT, NL, PL)
- **Cross-platform** — Android, iOS, Linux, macOS, Windows, Web

## Screenshots

<!-- Add screenshots under docs/screenshots/ and reference them here -->

_Coming soon._

## Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **State management:** [Provider](https://pub.dev/packages/provider)
- **Local storage:** SQLite with AES-256 content encryption
  (via [`encrypt`](https://pub.dev/packages/encrypt) + [`crypto`](https://pub.dev/packages/crypto))
- **Secure credential storage:** [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage)
- **Auth:** [`local_auth`](https://pub.dev/packages/local_auth) for biometrics
- **Theming:** Material 3 + [`dynamic_color`](https://pub.dev/packages/dynamic_color) + [`flex_color_scheme`](https://pub.dev/packages/flex_color_scheme)

## Getting Started

### Prerequisites

- Flutter SDK (stable channel, `^3.8.1`)
- Platform toolchain for your target (Android SDK, Xcode, etc.)

### Build & Run

```bash
git clone https://github.com/WariKoda/FocusJournal.git
cd FocusJournal

flutter pub get
flutter run
```

### Building for release

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Desktop
flutter build linux --release
flutter build macos --release
flutter build windows --release

# Web
flutter build web --release
```

### Running tests

```bash
flutter analyze
flutter test
```

## Project Structure

```
lib/
├── l10n/          # Localization files (7 languages)
├── models/        # Data models (incl. settings)
├── screens/       # UI screens
├── services/      # Business logic (auth, backup, journal, theme, notifications)
└── widgets/       # Reusable UI components
```

## Contributing

Contributions are very welcome — whether that's code, documentation, bug
reports, translations, or design feedback. If you're new to the project, look
for issues tagged [`good first issue`](https://github.com/WariKoda/FocusJournal/labels/good%20first%20issue).

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request,
and note that this project adheres to the [Contributor Covenant Code of
Conduct](CODE_OF_CONDUCT.md).

Questions and ideas are welcome in
[Discussions](https://github.com/WariKoda/FocusJournal/discussions). Issues
and PRs can be in English or German — whichever feels more natural to you.

## Roadmap

See the [open issues](https://github.com/WariKoda/FocusJournal/issues) for an
up-to-date view of planned work.

## Security

If you find a security-sensitive issue, please follow the process in
[SECURITY.md](SECURITY.md) instead of opening a public issue.

## License

Focus Journal is free software, licensed under the
[GNU General Public License v3.0](LICENSE). You are free to use, study, share,
and modify it under the terms of that license.

## Acknowledgements

- The Flutter and Dart communities.
- Everyone who takes the time to open an issue or send a pull request.
