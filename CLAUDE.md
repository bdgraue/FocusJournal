# Focus Journal - Claude Code Project Context

> **Version**: 1.4.1
> **Last Updated**: 2026-04-16
> **Tech Stack**: Flutter 3.38.9, Dart 3.10.8
> **Architecture**: Material 3 Design with Provider state management

## 🎯 Project Overview

Focus Journal is a **minimalist journaling app** focused on mindfulness and personal growth. It features:
- **Secure local storage** with biometric authentication (PIN/Pattern/Fingerprint/FaceID)
- **Encrypted backups** (AES-256-GCM with PBKDF2)
- **Material 3 design** with dynamic color theming
- **Multi-language support** (EN, DE, FR, ES, IT, NL, PL)
- **Privacy-first**: All data stays on device

## 🏗️ Architecture

### Core Services
- **AuthenticationService**: Handles biometric/PIN/pattern auth with lockout protection
- **BackupService**: AES-256-GCM encryption with PBKDF2 (100k iterations)
- **ExportService**: Coordinates backup/restore with auto-format detection
- **JournalService**: SQLite-based local storage
- **NotificationService**: Daily reminders
- **ThemeService**: Material 3 theming with dynamic colors

### Key Features
1. **Lock Suppression Pattern**: Prevents auth lock during file picker operations
2. **Smart Merge Strategies**: completeOverwrite, addNewOnly, smartMerge
3. **Format Auto-detection**: Handles both encrypted (.fjb) and legacy formats

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point with LockSuppression provider
├── models/
│   ├── import_strategy.dart     # Merge strategy enum
│   └── settings/                # Settings models
├── screens/
│   ├── authentication_screen.dart
│   ├── backup_screen.dart       # Uses RadioGroup for import strategies
│   ├── journal_screen.dart
│   ├── method_selection_screen.dart
│   └── theme_settings_screen.dart
├── services/
│   ├── authentication_service.dart
│   ├── backup_service.dart      # Security-critical: encryption/validation
│   ├── export_service.dart
│   ├── journal_service.dart
│   ├── notification_service.dart
│   └── theme_service.dart
├── widgets/
│   ├── journal_entry_card.dart
│   └── material3_card.dart
└── l10n/                        # Localization files

test/
├── widget_test.dart             # App smoke tests
├── screens/
│   └── authentication_screen_test.dart
└── services/
    └── backup_service_test.dart  # 13 comprehensive tests ✓
```

## 🔐 Security Architecture

### Backup Encryption (BackupService)
```dart
Algorithm:    AES-256-GCM
Key Derivation: PBKDF2-HMAC-SHA256
Iterations:   100,000
Salt:         256-bit random
IV:           128-bit random
File Format:  .fjb (Focus Journal Backup)
```

### Data Format
```json
{
  "metadata": {
    "version": "1.1",
    "exportDate": "2024-01-01T00:00:00Z",
    "encryptionMethod": "AES-256-GCM",
    "keyDerivation": "PBKDF2-HMAC-SHA256",
    "pbkdf2Iterations": 100000,
    "deviceId": "uuid-v4",
    "exportId": "uuid-v4"
  },
  "data": {
    "content": "base64-encrypted-data",
    "iv": "base64-iv",
    "salt": "base64-salt"
  }
}
```

### Journal Entry Format
```json
{
  "entries": [
    {
      "id": "uuid",
      "content": "journal content",
      "createdAt": "ISO-8601",
      "lastModified": "ISO-8601"
    }
  ]
}
```

## 🧪 Testing

### Current Coverage
- **Widget Tests**: 3/3 passing ✓
- **BackupService Tests**: 13/13 passing ✓
- **Total**: 17 tests passing

### Test Strategy
- **Data Validation**: 6 tests covering format validation
- **Merge Strategies**: 5 tests for all merge scenarios
- **Security**: 2 tests for exception handling

## 🚀 Recent Updates (v1.1.5)

### Dependency Updates
- flutter_secure_storage: 9.2.4 → 10.0.0
- local_auth: 2.1.7 → 3.0.0 (with platform packages)
- share_plus: 7.2.2 → 12.0.1
- flutter_local_notifications: 17.2.4 → 20.0.0
- google_fonts: 6.2.1 → 8.0.1
- device_info_plus: 9.1.2 → 12.3.0

### Breaking Changes Fixed
- **local_auth**: Migrated to new `authenticate()` API with `AuthMessages`
- **share_plus**: Updated to `SharePlus.instance.share()` pattern
- **flutter_local_notifications**: Named parameters API
- **RadioListTile**: Migrated to `RadioGroup` pattern (no deprecations)

## 💡 Development Guidelines

### Code Style
- **Material 3**: All UI components use Material 3 design
- **Provider**: State management for LockSuppression and ThemeService
- **Async/Await**: Proper `mounted` checks for BuildContext after async gaps
- **Security**: Never log sensitive data (passwords, keys)

### Common Patterns

#### Lock Suppression
```dart
final lockSuppression = context.read<LockSuppression>();
try {
  lockSuppression.value = true;  // Prevent auth lock
  await performFileOperation();
  lockSuppression.value = false;
} catch (e) {
  lockSuppression.value = false;
  // Handle error
}
```

#### Password Clearing
```dart
// Clear password after operations
_passwordController.clear();
setState(() => _isPasswordVisible = false);

// Clear password on app background
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.inactive ||
      state == AppLifecycleState.paused) {
    _passwordController.clear();
  }
}
```

## 🐛 Known Issues & TODOs

- [ ] Add comprehensive widget tests with mocking (auth screens need complex setup)
- [ ] Implement password strength meter
- [ ] Add biometric-only option for backup operations
- [ ] Consider Argon2 for future encryption upgrades

## 📚 Resources

- [Flutter Docs](https://docs.flutter.dev/)
- [Material 3 Design](https://m3.material.io/)
- [PBKDF2 Standard](https://tools.ietf.org/html/rfc2898)
- [AES-GCM Spec](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38d.pdf)

## 🤝 Contributing

When working on this project:
1. Always run `flutter analyze` before committing
2. Ensure all tests pass: `flutter test`
3. Update this CLAUDE.md if architecture changes
4. Security-critical changes require extra review
5. Use conventional commit messages

---

**Maintained by**: bdgraue (bdgraue@gmail.com)
**Repository**: https://github.com/WariKoda/FocusJournal
