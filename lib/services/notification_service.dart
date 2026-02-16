import 'dart:io' show Platform;
import 'dart:math';
import 'dart:ui' show PlatformDispatcher;
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

  /// Localized reminder messages keyed by language code.
  /// Falls back to English for unsupported locales.
  static const Map<String, List<String>> _reminderMessages = {
    'en': [
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
    ],
    'de': [
      'Nimm dir einen Moment, um über deinen Tag nachzudenken.',
      'Dein Tagebuch wartet auf deine Gedanken.',
      'Ein paar Worte können viel bewirken.',
      'Wie fühlst du dich heute?',
      'Halte diesen Moment in deinem Tagebuch fest.',
      'Dein zukünftiges Ich wird dir fürs Schreiben danken.',
      'Was hat dich heute zum Lächeln gebracht?',
      'Zeit für eine achtsame Pause.',
      'Deine Gedanken sind wichtig. Schreib sie auf.',
      'Tägliches Reflektieren bringt Klarheit.',
    ],
    'fr': [
      'Prenez un moment pour réfléchir à votre journée.',
      'Votre journal attend vos pensées.',
      'Quelques mots peuvent faire une grande différence.',
      'Comment vous sentez-vous aujourd\'hui\u00a0?',
      'Capturez ce moment dans votre journal.',
      'Votre futur vous remerciera d\'avoir écrit.',
      'Qu\'est-ce qui vous a fait sourire aujourd\'hui\u00a0?',
      'C\'est le moment d\'une pause attentive.',
      'Vos pensées comptent. Écrivez-les.',
      'Une réflexion quotidienne apporte de la clarté.',
    ],
    'es': [
      'Tómate un momento para reflexionar sobre tu día.',
      'Tu diario espera tus pensamientos.',
      'Unas pocas palabras pueden hacer una gran diferencia.',
      '¿Cómo te sientes hoy?',
      'Captura este momento en tu diario.',
      'Tu yo del futuro te agradecerá haber escrito.',
      '¿Qué te hizo sonreír hoy?',
      'Es hora de una pausa consciente.',
      'Tus pensamientos importan. Escríbelos.',
      'Una reflexión diaria aporta claridad.',
    ],
    'it': [
      'Prenditi un momento per riflettere sulla tua giornata.',
      'Il tuo diario attende i tuoi pensieri.',
      'Poche parole possono fare una grande differenza.',
      'Come ti senti oggi?',
      'Cattura questo momento nel tuo diario.',
      'Il te stesso del futuro ti ringrazierà per aver scritto.',
      'Cosa ti ha fatto sorridere oggi?',
      'È il momento di una pausa consapevole.',
      'I tuoi pensieri contano. Scrivili.',
      'Una riflessione quotidiana porta chiarezza.',
    ],
    'nl': [
      'Neem even de tijd om na te denken over je dag.',
      'Je dagboek wacht op je gedachten.',
      'Een paar woorden kunnen een groot verschil maken.',
      'Hoe voel je je vandaag?',
      'Leg dit moment vast in je dagboek.',
      'Je toekomstige zelf zal je dankbaar zijn dat je schreef.',
      'Waar moest je vandaag om glimlachen?',
      'Tijd voor een bewust moment van rust.',
      'Je gedachten zijn belangrijk. Schrijf ze op.',
      'Dagelijkse reflectie brengt helderheid.',
    ],
    'pl': [
      'Poświęć chwilę na refleksję nad swoim dniem.',
      'Twój dziennik czeka na Twoje myśli.',
      'Kilka słów może wiele zmienić.',
      'Jak się dziś czujesz?',
      'Uwiecznij ten moment w swoim dzienniku.',
      'Twoje przyszłe ja podziękuje Ci za pisanie.',
      'Co wywołało dziś Twój uśmiech?',
      'Czas na uważną przerwę.',
      'Twoje myśli mają znaczenie. Zapisz je.',
      'Codzienna refleksja przynosi jasność.',
    ],
  };

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
    final locale = PlatformDispatcher.instance.locale;
    final lang = locale.languageCode;
    final messages = _reminderMessages[lang] ?? _reminderMessages['en']!;
    final random = Random();
    return messages[random.nextInt(messages.length)];
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
