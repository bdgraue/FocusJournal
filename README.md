# Focus Journal

**Version 1.1.2**

A minimalist, privacy-focused journaling app built with Flutter. Focus Journal helps you maintain a personal journal with strong encryption and biometric authentication, designed for mindfulness and personal growth.

## Features

### Core Functionality
- **Encrypted Journal Entries**: All entries are encrypted using AES-256 encryption
- **Secure Authentication**: Multiple authentication methods:
  - Biometric (fingerprint/face recognition)
  - PIN code
  - Password
  - Pattern lock
- **Calendar View**: Browse entries by date with an intuitive calendar interface
- **Search**: Quickly find entries across your entire journal
- **Same-Day Editing**: Edit entries only on the day they were created (read-only afterwards)

### Privacy & Security
- **Local Storage**: All data stays on your device
- **Secure Storage**: Credentials stored using platform-secure storage APIs
- **No Cloud Sync**: Your journal never leaves your device (unless you explicitly export)
- **Encryption**: AES-256 encryption for all journal content

### User Experience
- **Material 3 Design**: Modern, clean interface following Material Design 3 guidelines
- **Dynamic Color**: Adapts to your system color scheme (Android 12+)
- **Dark/Light Theme**: System-aware theme switching
- **Multilingual**: Support for 8 languages (DE, EN, ES, FR, IT, NL, PL)
- **Cross-Platform**: Android, iOS, Linux, macOS, Windows, Web

### Data Management
- **Backup & Export**: Export your journal to share or backup
- **Import**: Restore entries from backup files
- **Notifications**: Optional daily reminders to journal

## Getting Started

### Prerequisites
- Flutter SDK ^3.8.1
- Dart SDK (comes with Flutter)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd FocusJournal
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building for Release

#### Android
```bash
flutter build apk --release
# or for app bundle:
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

#### Desktop (Linux/macOS/Windows)
```bash
flutter build linux --release
flutter build macos --release
flutter build windows --release
```

#### Web
```bash
flutter build web --release
```

## Project Structure

```
lib/
├── l10n/                    # Localization files
│   └── translations/        # Translations for 8 languages
├── models/                  # Data models
│   └── settings/           # Settings-related models
├── screens/                # UI screens (11 screens)
├── services/               # Business logic services (7 services)
└── widgets/                # Reusable UI components
```

## Key Dependencies

- **flutter_secure_storage**: Secure credential storage
- **local_auth**: Biometric authentication
- **encrypt/crypto**: AES-256 encryption
- **table_calendar**: Calendar view
- **flutter_local_notifications**: Daily reminders
- **share_plus**: Export functionality
- **dynamic_color**: Material You dynamic theming
- **provider**: State management
- **flex_color_scheme**: Advanced theming
- **google_fonts**: Custom typography

## Security Features

### Screen Rotation Behavior
Focus Journal ensures that rotating the device never changes the lock state:
- If the app is currently locked, rotating the screen keeps it locked (no auto-unlock)
- If the app is currently unlocked (e.g., in Settings), rotating the screen keeps it unlocked (no auto-lock)
- Authentication is required when returning from background or when explicitly locked

### Encryption
- All journal entries are encrypted using AES-256
- Encryption keys are derived from your authentication credentials
- Keys are stored securely using platform-specific secure storage

## Development

### Running Tests
```bash
flutter test
```

### Code Generation
The app uses code generation for some features. If you modify models or add new localizations, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Localization
To add a new language:
1. Create a new file in `lib/l10n/translations/app_localizations_XX.dart`
2. Implement the `AppLocalizations` abstract class
3. Add the locale to the `supportedLocales` in [main.dart](lib/main.dart)

## Roadmap

See [TODO_SETTINGS.md](TODO_SETTINGS.md) for planned features and settings sections currently in development.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is private and not intended for redistribution.

## Maintainer

bdgraue (bdgraue@gmail.com)

## Links

- Homepage: https://bdgraue.vancheng.de
- Repository: https://bdgraue.vancheng.de/focus_journal
- Issue Tracker: https://bdgraue.vancheng.de/focus_journal/issues
