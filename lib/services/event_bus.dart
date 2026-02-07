import 'dart:async';

/// Simple event bus for app-wide event broadcasting.
///
/// Uses a singleton pattern to provide a centralized message bus for
/// decoupled communication between app components. Events are strings
/// defined in the [AppEvents] class.
///
/// Currently used for:
/// - `journal_changed`: Notifies listeners when journal entries are modified
///
/// Example:
/// ```dart
/// AppEventBus().emit(AppEvents.journalChanged);
/// AppEventBus().stream.listen((event) => print('Event: $event'));
/// ```
class AppEventBus {
  AppEventBus._internal();
  static final AppEventBus _instance = AppEventBus._internal();
  factory AppEventBus() => _instance;

  final StreamController<String> _controller = StreamController.broadcast();

  Stream<String> get stream => _controller.stream;

  void emit(String event) => _controller.add(event);

  void dispose() => _controller.close();
}

class AppEvents {
  static const String journalChanged = 'journal_changed';
}
