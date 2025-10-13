# Settings TODOs (temporarily hidden)

We have hidden some settings sections until they are functionally implemented. This file tracks
the items to implement before re-enabling them in `lib/screens/general_settings_screen.dart`.

## Sections to re-enable

1) Security Section
   - Wire current auth method from `AuthenticationService.getCurrentAuthMethod()`
   - Implement a Security screen to change method, change PIN/password, and show backup password state
   - Remove hardcoded `Pattern` subtitle
   - Optional: Biometrics toggle (if biometrics will be supported) — or remove entirely

2) Journal Preferences
   - Default view selector (Calendar/List)
   - Entry sorting options
   - Default font size

3) Notifications & Reminders
   - Daily reminders toggle and scheduling
   - Time picker for reminder time
   - Weekly summary toggle and scheduling

4) Customization
   - Theme selector (match app theme or provide options)
   - Language selector (via localization)
   - Accent color selector

5) Privacy & Data
   - Data retention settings
   - Analytics toggle + persistence
   - Clear app data flow with confirmation dialog

## Re-enable flags

In `GeneralSettingsScreen` set the following flags to `true` once implemented:

```
final bool _showSecuritySection = true;
final bool _showJournalPreferencesSection = true;
final bool _showNotificationsSection = true;
final bool _showCustomizationSection = true;
final bool _showPrivacySection = true;
```
