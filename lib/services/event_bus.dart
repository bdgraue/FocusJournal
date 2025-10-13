import 'dart:async';

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
