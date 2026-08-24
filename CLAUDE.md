# Focus Journal - Claude Code Project Context

> **Version**: 1.5.0
> **Last Updated**: 2026-08-24
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
- **JournalService**: encrypted entries in SharedPreferences, DEK in secure storage
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
    ├── backup_service_test.dart   # validation, merging, crypto round trip
    └── journal_service_test.dart  # entry format, legacy reads, fail-hard
```

## 🔐 Security Architecture

### Backup Encryption (BackupService)
```dart
Algorithm:    AES-256-GCM (authenticated, 128-bit tag)
Key Derivation: PBKDF2-HMAC-SHA256
Iterations:   100,000
Salt:         256-bit random
Nonce:        96-bit random
File Format:  .fjb (Focus Journal Backup)
```

Backups written before version 2.0 are AES-256-CTR although their metadata
claims GCM. `decryptBackup` therefore decides the mode by trying — GCM first,
because a wrong key fails there definitively — and never by reading
`encryptionMethod`.

### Entry Encryption (JournalService)
```dart
Algorithm:    AES-256-GCM (authenticated, 128-bit tag)
Key:          256-bit DEK, Random.secure(), kept in flutter_secure_storage
Nonce:        96-bit random, fresh per write
Record:       v2:<base64 nonce>:<base64 ciphertext+tag>
```

Records without the `v2:` prefix predate authenticated encryption and are
AES-256-CTR; they stay readable and are lifted to v2 on the next write.

### Data Format
```json
{
  "metadata": {
    "version": "2.0",
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
`flutter test`: 61 passing ✓

### Test Strategy
- **Data Validation**: format validation of imported journal data
- **Merge Strategies**: all three import strategies
- **Encryption round trip**: encrypt → decrypt, wrong password, tampered
  ciphertext, and a hand-built legacy CTR fixture that proves old backups and
  old entries stay readable
- **Fail hard**: unreadable stored entries must raise, never look like an empty
  journal — a returned `[]` would invite the next write to overwrite them

Device-level checks that a unit test cannot cover — the platform keystore
holding the data encryption key — live in
`integration_test/legacy_encryption_test.dart`:

```
flutter test integration_test/legacy_encryption_test.dart -d <device>
```

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

## 🏷️ Releases and tags

- Tags are named `X.Y.Z` — **no `v` prefix**.
- A tag sits on the commit that set that version in `pubspec.yaml`, and that
  commit must be on `main`. Tagging a pre-squash branch head leaves the tag off
  the main line, where `git describe` will not find it.
- Tag only **after** the pull request is merged, on the merged state. `main` is
  protected; nothing lands on it directly.
- Version choice follows semver as it applies to an app: a changed on-disk
  format or changed user-visible behaviour is a MINOR bump, a bug fix is PATCH.
  Note that migrations here are one-way — a newer format cannot be read by an
  older build — so a MINOR release still breaks downgrades.

### The 1.3.2 anomaly

There is no `1.3.2` tag, and there cannot be one. A GitHub release named
"1.3.2" was once published as **immutable** against a commit that already
carried version 1.4.1. Immutability permanently reserves the tag name: it
could not be moved, and after the release and tag were removed the name could
not be created again either (`Cannot create ref due to creations being
restricted`).

**`v1.3.2` is the 1.3.2 release.** It points at `1646676`, the commit that set
version 1.3.2, and it is the one tag in the repository that keeps the old
prefix — not an oversight.

The lesson worth keeping: do not publish an immutable release until the tag is
certain, because the name is spent either way.

## 🤝 Contributing

When working on this project:
1. Always run `flutter analyze` before committing
2. Ensure all tests pass: `flutter test`
3. Update this CLAUDE.md if architecture changes
4. Security-critical changes require extra review
5. Use conventional commit messages
6. Tag releases per the section above — `X.Y.Z`, after the merge

---

**Maintained by**: bdgraue (bdgraue@gmail.com)
**Repository**: https://github.com/WariKoda/FocusJournal
