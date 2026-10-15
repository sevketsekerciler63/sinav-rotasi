import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  static Future<void> showDailyReminder() async {
    if (!_initialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder',
      'Gunluk Hatirlatma',
      channelDescription: 'Gunluk calisma hatirlatmasi',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      1,
      'Calisma Vakti!',
      'Bugunun planini tamamlamayi unutma. Hedefine bir adim daha yaklasiyorsun!',
      details,
    );
  }

  static Future<void> showExamReminder(String examName, int daysUntil) async {
    if (!_initialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'exam_reminder',
      'Deneme Hatirlatma',
      channelDescription: 'Deneme sinavi hatirlatmasi',
      importance: Importance.max,
      priority: Priority.max,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      2,
      '$daysUntil gun sonra deneme!',
      '$examName icin hazirlanyorum. Basarilar!',
      details,
    );
  }

  static Future<void> showStreakReminder(int streak) async {
    if (!_initialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'streak_reminder',
      'Seri Hatirlatma',
      channelDescription: 'Calisma serisi hatirlatmasi',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      3,
      '$streak gunluk serin var!',
      'Seriyi kirma, bugun de calis. Her gun bir adim daha!',
      details,
    );
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
