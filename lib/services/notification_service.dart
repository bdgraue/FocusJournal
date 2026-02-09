import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

/// Manages daily journal reminders using local notifications.
///
/// Provides customizable notification timing with a selection of friendly
/// reminder messages. Users can enable/disable notifications and choose
/// their preferred reminder time.
///
/// Features:
/// - Daily repeating notifications at user-defined time
/// - Random rotation through 10 mindful reminder messages
/// - Notification permission handling (Android 13+)
/// - Persistent settings via SharedPreferences
///
/// Singleton pattern ensures single notification scheduler across app.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _enabledKey = 'notifications_enabled';
  static const String _hourKey = 'notifications_hour';
  static const String _minuteKey = 'notifications_minute';
  static const int _notificationId = 1;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Friendly reminder messages to rotate through
  static const List<String> _reminderMessages = [
    'Take a moment to reflect on your day.',
    'Your journal is waiting for your thoughts.',
    'A few words can make a big difference.',
    'How are you feeling today?',
    'Capture this moment in your journal.',
    'Your future self will thank you for writing.',
    'What made you smile today?',
    'Time for a mindful pause.',
    'Your thoughts matter. Write them down.',
    'A daily reflection brings clarity.',
  ];

  /// Check if notifications are supported on this platform
  bool get isPlatformSupported {
    // Only Android and iOS are supported
    return Platform.isAndroid || Platform.isIOS;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> initialize() async {
    if (_initialized) return;

    // Skip initialization on unsupported platforms
    if (!isPlatformSupported) {
      _initialized = true;
      return;
    }

    await _configureLocalTimezone();

    const androidSettings = AndroidInitializationSettings('@drawable/ic_launcher_foreground');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings: initSettings);
    _initialized = true;

    // Reschedule if enabled (e.g., after app restart)
    if (await isEnabled()) {
      final time = await getScheduledTime();
      await scheduleDailyReminder(time.$1, time.$2);
    }
  }

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? false;
  }

  Future<void> setEnabled(bool enabled) async {
    if (!isPlatformSupported) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);

    if (enabled) {
      final time = await getScheduledTime();
      await scheduleDailyReminder(time.$1, time.$2);
    } else {
      await cancelReminder();
    }
  }

  Future<(int, int)> getScheduledTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt(_hourKey) ?? 20; // Default 8 PM
    final minute = prefs.getInt(_minuteKey) ?? 0;
    return (hour, minute);
  }

  Future<void> setScheduledTime(int hour, int minute) async {
    if (!isPlatformSupported) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, hour);
    await prefs.setInt(_minuteKey, minute);

    if (await isEnabled()) {
      await scheduleDailyReminder(hour, minute);
    }
  }

  /// Compute the next occurrence of [hour]:[minute] in local time.
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduleDailyReminder(int hour, int minute) async {
    if (!isPlatformSupported) return;
    if (!_initialized) await initialize();

    await _notifications.cancel(id: _notificationId);

    final message = _getRandomMessage();
    final scheduledDate = _nextInstanceOfTime(hour, minute);

    await _notifications.zonedSchedule(
      id: _notificationId,
      title: 'Focus Journal',
      body: message,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Reminders',
          channelDescription: 'Daily journal writing reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          icon: '@drawable/ic_launcher_foreground',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelReminder() async {
    if (!isPlatformSupported) return;
    await _notifications.cancel(id: _notificationId);
  }

  String _getRandomMessage() {
    final random = Random();
    return _reminderMessages[random.nextInt(_reminderMessages.length)];
  }

  /// Request notification permission (Android 13+)
  Future<bool> requestPermission() async {
    if (!isPlatformSupported) return false;
    if (!_initialized) await initialize();

    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    return true;
  }
}
