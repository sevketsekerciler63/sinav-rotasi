import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

/// Android keeps these in a file excluded from OS backup/transfer rules.
class DevicePreferences {
  static const fileName = 'sinav_rotasi_device';
  static const reminderKey = 'daily_reminder_settings_v2';
  final SharedPreferences? _legacy;
  final SharedPreferencesAsync? _android;
  DevicePreferences._(this._legacy, this._android);
  static Future<DevicePreferences>? _androidOpening;
  static Future<DevicePreferences> open() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return DevicePreferences._(await SharedPreferences.getInstance(), null);
    }
    return _androidOpening ??= _openAndroid().catchError((Object error) {
      _androidOpening = null;
      throw error;
    });
  }

  static Future<DevicePreferences> _openAndroid() async {
    final destination = SharedPreferencesAsync(
      options: const SharedPreferencesAsyncAndroidOptions(
        backend: SharedPreferencesAndroidBackendLibrary.SharedPreferences,
        originalSharedPreferencesOptions: AndroidSharedPreferencesStoreOptions(
          fileName: fileName,
        ),
      ),
    );
    await migrateAndroid(await SharedPreferences.getInstance(), destination);
    return DevicePreferences._(null, destination);
  }

  @visibleForTesting
  static Future<void> migrateAndroid(
    SharedPreferences previous,
    SharedPreferencesAsync destination,
  ) async {
    if (await destination.getBool('device_storage_ready') == true) return;
    final oldHour = previous.get('daily_reminder_hour');
    final oldMinute = previous.get('daily_reminder_minute');
    var hour = oldHour is int ? oldHour : 20;
    var minute = oldMinute is int ? oldMinute : 0;
    final pending = await destination.getString(reminderKey);
    final oldValue = previous.get(reminderKey);
    final old = pending ?? (oldValue is String ? oldValue : null);
    if (old != null) {
      try {
        final json = jsonDecode(old);
        if (json is Map && json['hour'] is int && json['minute'] is int) {
          hour = json['hour'];
          minute = json['minute'];
        }
      } catch (_) {
        /* Keep safe defaults for corrupt optional device preferences. */
      }
    }
    if (hour < 0 || hour > 23) hour = 20;
    if (minute < 0 || minute > 59) minute = 0;
    // Never activate a restored device's reminder or claim its old file export.
    await destination.setString(
      reminderKey,
      jsonEncode({'enabled': false, 'hour': hour, 'minute': minute}),
    );
    for (final key in [
      'daily_reminder_enabled',
      'daily_reminder_hour',
      'daily_reminder_minute',
      reminderKey,
      'last_file_export_at',
    ]) {
      if (previous.containsKey(key) && !await previous.remove(key)) {
        throw StateError('Eski cihaz tercihi ayrılamadı.');
      }
    }
    await destination.setBool('device_storage_ready', true);
  }

  Future<String?> getString(String key) async => _android == null
      ? _legacy!.getString(key)
      : await _android.getString(key);
  Future<int?> getInt(String key) async =>
      _android == null ? _legacy!.getInt(key) : await _android.getInt(key);
  Future<bool?> getBool(String key) async =>
      _android == null ? _legacy!.getBool(key) : await _android.getBool(key);
  Future<bool> setString(String key, String value) async {
    if (_android == null) {
      final saved = await _legacy!.setString(key, value);
      if (!saved) await _legacy.reload();
      return saved;
    }
    await _android.setString(key, value);
    return true;
  }
}
