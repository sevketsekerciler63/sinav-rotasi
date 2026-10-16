import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:convert';
import 'device_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class DailyReminderSettings {
  const DailyReminderSettings({
    required this.enabled,
    required this.hour,
    required this.minute,
  });

  final bool enabled;
  final int hour;
  final int minute;

  String get formattedTime =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

/// Device-local daily reminder. Its preference is intentionally not included
/// in profile backups because notification permission belongs to this device.
class DailyReminderService {
  DailyReminderService._();

  static const int _notificationId = 41;
  static const String _enabledKey = 'daily_reminder_enabled';
  static const String _hourKey = 'daily_reminder_hour';
  static const String _minuteKey = 'daily_reminder_minute';

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static bool _timezoneDatabaseInitialized = false;

  static bool get isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static Future<void> initialize() async {
    if (_initialized || !isSupportedPlatform) return;

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<DailyReminderSettings> readSettings() async {
    final preferences = await DevicePreferences.open();
    final raw = await preferences.getString(DevicePreferences.reminderKey);
    if (raw != null) {
      final json = jsonDecode(raw);
      if (json is! Map ||
          json['enabled'] is! bool ||
          json['hour'] is! int ||
          json['minute'] is! int ||
          json['hour'] < 0 ||
          json['hour'] > 23 ||
          json['minute'] < 0 ||
          json['minute'] > 59) {
        throw const FormatException('Hatırlatıcı tercihi bozuk.');
      }
      return DailyReminderSettings(
        enabled: json['enabled'],
        hour: json['hour'],
        minute: json['minute'],
      );
    }
    return DailyReminderSettings(
      enabled: await preferences.getBool(_enabledKey) ?? false,
      hour: await preferences.getInt(_hourKey) ?? 20,
      minute: await preferences.getInt(_minuteKey) ?? 0,
    );
  }

  static Future<void> _saveSettings(bool enabled, int hour, int minute) async {
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw const FormatException('Hatırlatıcı saati geçersiz.');
    }
    final preferences = await DevicePreferences.open();
    if (!await preferences.setString(
      DevicePreferences.reminderKey,
      jsonEncode({'enabled': enabled, 'hour': hour, 'minute': minute}),
    )) {
      throw StateError('Hatırlatıcı tercihi kaydedilemedi.');
    }
  }

  static Future<bool?> notificationsAllowed() async {
    if (!isSupportedPlatform) return null;
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) return android.areNotificationsEnabled();
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return (await ios?.checkPermissions())?.isEnabled;
  }

  /// Returns false when the user declines permission; it never enables a
  /// setting whose notifications cannot currently be delivered.
  static Future<bool> enable({
    required int hour,
    required int minute,
    required String profileName,
    required DateTime targetDate,
  }) async {
    if (!isSupportedPlatform) return false;
    await initialize();
    final permitted = await _requestPermission();
    if (!permitted) return false;

    try {
      await _schedule(
        hour: hour,
        minute: minute,
        profileName: profileName,
        targetDate: targetDate,
      );
      await _saveSettings(true, hour, minute);
      return true;
    } catch (_) {
      await _plugin.cancel(_notificationId);
      rethrow;
    }
  }

  static Future<void> disable() async {
    final settings = await readSettings();
    await _saveSettings(false, settings.hour, settings.minute);
    if (isSupportedPlatform) {
      await initialize();
      await _plugin.cancel(_notificationId);
    }
  }

  static Future<void> updateTime({
    required int hour,
    required int minute,
    required String profileName,
    required DateTime targetDate,
  }) async {
    final settings = await readSettings();
    if (!settings.enabled) {
      await _saveSettings(false, hour, minute);
      return;
    }

    final allowed = await notificationsAllowed();
    if (allowed != true) {
      throw StateError('Bildirim izni kapalı. Cihaz ayarlarından izin ver.');
    }
    await _schedule(
      hour: hour,
      minute: minute,
      profileName: profileName,
      targetDate: targetDate,
    );
    await _saveSettings(true, hour, minute);
  }

  /// Refresh the repeating notification after a profile/date/time-zone change.
  /// Permission is checked but never requested from this background sync path.
  static Future<void> syncForProfile({
    required String profileName,
    required DateTime targetDate,
  }) async {
    if (!isSupportedPlatform) return;
    final settings = await readSettings();
    if (!settings.enabled) {
      await initialize();
      await _plugin.cancel(_notificationId);
      return;
    }
    await initialize();
    if (await notificationsAllowed() != true) {
      await _plugin.cancel(_notificationId);
      return;
    }
    await _schedule(
      hour: settings.hour,
      minute: settings.minute,
      profileName: profileName,
      targetDate: targetDate,
    );
  }

  static Future<bool> _requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? await android.areNotificationsEnabled() ?? false;
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(alert: true, sound: true) ?? false;
  }

  static Future<void> _schedule({
    required int hour,
    required int minute,
    required String profileName,
    required DateTime targetDate,
  }) async {
    await _initializeTimezone();
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day + 1,
        hour,
        minute,
      );
    }

    final normalizedTarget = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    final dateLabel =
        '${normalizedTarget.day.toString().padLeft(2, '0')}'
        '.${normalizedTarget.month.toString().padLeft(2, '0')}'
        '.${normalizedTarget.year}';
    await _plugin.zonedSchedule(
      _notificationId,
      'Günlük çalışma hatırlatıcısı',
      '$profileName · plan hedefi $dateLabel. Bugünkü planına göz at.',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_study_reminder',
          'Günlük çalışma hatırlatıcısı',
          channelDescription: 'Seçtiğin saatte günlük çalışma planı bildirimi',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> _initializeTimezone() async {
    if (!_timezoneDatabaseInitialized) {
      tz_data.initializeTimeZones();
      _timezoneDatabaseInitialized = true;
    }
    final localTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone.identifier));
  }
}
