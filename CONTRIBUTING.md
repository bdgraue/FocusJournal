# Contributing to Focus Journal

First off, thank you for considering contributing. This is a small project
that cares about doing small things well — every report, idea, and pull
request genuinely helps.

## Ways to Contribute

You do not need to write code to help:

- Report a bug or reproduce an existing one
- Suggest a feature or UX improvement
- Improve documentation
- Help triage issues
- Translate the app into another language
- Share the project with someone who might benefit

## Code of Conduct

This project is governed by the [Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you agree to uphold it.

## Development Setup

### Prerequisites

- **Flutter** (stable channel, `^3.8.1`). `flutter doctor` should be clean
  for your target platform.
- **Platform toolchain**: Android SDK (+ device/emulator), Xcode for iOS,
  or a desktop toolchain.
- **Git** and a GitHub account.

### First-time setup

Fork the repository on GitHub, then:

```bash
git clone https://github.com/<your-username>/FocusJournal.git
cd FocusJournal
git remote add upstream https://github.com/WariKoda/FocusJournal.git

flutter pub get
flutter run
```

### Code generation

If you add or modify anything that requires codegen (e.g. new localizations
via `flutter gen-l10n`, or `json_serializable` models), run:

```bash
dart run build_runner build --delete-conflicting-outputs
# or, for iterative work:
dart run build_runner watch --delete-conflicting-outputs
```

## Project Structure

```
lib/
  l10n/        # Localization files
  models/      # Data models
  screens/     # UI screens
  services/    # Business logic (auth, backup, journal, notifications, theme)
  widgets/     # Reusable UI components
  main.dart
test/          # Unit & widget tests
```

Keep related UI, state, and services close together. When a feature grows big
enough to warrant its own folder under `screens/` or `services/`, split it
out.

## Coding Conventions

- **Formatting:** `dart format .` before committing. CI rejects unformatted
  code.
- **Linting:** `flutter analyze` must be clean on `main`.
- **Types:** prefer concrete types over `dynamic`.
- **State:** use `Provider` / `ChangeNotifier`; avoid global mutable state.
- **Persistence:** all storage changes go through the service layer, not
  directly from UI code.
- **UI:** Material 3, responsive to light/dark, accessible tap targets
  (≥ 48dp).
- **Security:** never log sensitive data (passwords, keys, journal content).
- **Comments:** explain *why*, not *what*.

## Commit Messages

This project uses [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<optional scope>): <short summary>

<optional body>

<optional footer, e.g. Closes #123>
```

| Type       | Use for                                                 |
| ---------- | ------------------------------------------------------- |
| `feat`     | A new feature visible to users                          |
| `fix`      | A bug fix                                               |
| `docs`     | Documentation only                                      |
| `style`    | Formatting, whitespace — no code change                 |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf`     | Performance improvement                                 |
| `test`     | Adding or fixing tests                                  |
| `build`    | Build system, dependencies                              |
| `ci`       | CI configuration                                        |
| `chore`    | Miscellaneous, no production code change                |

## Branching & Pull Requests

- Branch from `main`. Use a descriptive name: `feat/quick-capture`,
  `fix/encryption-key-rotation`, etc.
- Keep PRs focused. One logical change per PR.
- Fill in the PR template. Link related issues with `Closes #123`.
- Ensure CI passes before requesting review.
- Be patient and kind during review. Maintainers are volunteers.

### Before opening a PR

```bash
dart format .
flutter analyze
flutter test
```

## Testing

- **Unit tests** live under `test/` mirroring `lib/`.
- **Widget tests** for non-trivial UI behaviour.
- Security-sensitive code (auth, encryption, backup) should have thorough
  coverage. See the existing `test/services/backup_service_test.dart` as a
  reference.
- New features should include tests. Bug fixes should include a regression
  test where feasible.

## Reporting Bugs

Please use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md).
Include device, OS version, app version, reproduction steps, and what you
expected vs. what happened.

## Suggesting Features

Please use the [feature request template](.github/ISSUE_TEMPLATE/feature_request.md).
Describe the problem first, then the proposed solution. Screenshots and
sketches are welcome.

## Translations

Translations live under `lib/l10n/`. Open an issue first if you want to add a
new language so we can coordinate.

## License of Contributions

By contributing, you agree that your contributions will be licensed under the
[GNU General Public License v3.0](LICENSE). Do not submit code you do not
have the right to contribute under this license.
