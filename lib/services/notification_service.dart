import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

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

  Future<void> initialize() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();

    // Set the local timezone based on the device
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const androidSettings = AndroidInitializationSettings('@drawable/ic_launcher_foreground');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(initSettings);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, hour);
    await prefs.setInt(_minuteKey, minute);

    if (await isEnabled()) {
      await scheduleDailyReminder(hour, minute);
    }
  }

  Future<void> scheduleDailyReminder(int hour, int minute) async {
    if (!_initialized) await initialize();

    await _notifications.cancel(_notificationId);

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If the time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final message = _getRandomMessage();

    await _notifications.zonedSchedule(
      _notificationId,
      'Focus Journal',
      message,
      scheduledDate,
      const NotificationDetails(
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
    await _notifications.cancel(_notificationId);
  }

  String _getRandomMessage() {
    final random = Random();
    return _reminderMessages[random.nextInt(_reminderMessages.length)];
  }

  /// Request notification permission (Android 13+)
  Future<bool> requestPermission() async {
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
