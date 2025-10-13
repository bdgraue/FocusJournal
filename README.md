# focus_journal

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Screen rotation and lock behavior

Focus Journal ensures that rotating the device never changes the lock state by itself:

- If the app is currently locked, rotating the screen keeps it locked (no auto-unlock).
- If the app is currently unlocked (e.g., you're in Settings), rotating the screen keeps it unlocked (no auto-lock).

The app will require authentication again when returning from background or when explicitly locked by the app logic, but not for rotation-only changes.
