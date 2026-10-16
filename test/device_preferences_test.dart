import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:yks_study_app/services/device_preferences.dart';
import 'package:yks_study_app/services/daily_reminder_service.dart';
import 'storage_recovery_test.dart' show ControlledStore;

final class FailingAsyncStore extends InMemorySharedPreferencesAsync {
  FailingAsyncStore() : super.empty();
  bool fail = true;
  @override
  Future<bool> setString(
    String key,
    String value,
    SharedPreferencesOptions options,
  ) async {
    if (fail) {
      fail = false;
      throw StateError('Disk dolu');
    }
    return super.setString(key, value, options);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Android device preference migration keeps study data and never restores permission or backup claim',
    () async {
      SharedPreferences.setMockInitialValues({
        'profile_x__study_sessions': 'important',
        'daily_reminder_enabled': true,
        'daily_reminder_hour': 21,
        'daily_reminder_minute': 30,
        'last_file_export_at': '2026-10-16T12:00:00',
      });
      final previous = await SharedPreferences.getInstance();
      final store = FailingAsyncStore();
      SharedPreferencesAsyncPlatform.instance = store;
      final destination = SharedPreferencesAsync();
      await expectLater(
        DevicePreferences.migrateAndroid(previous, destination),
        throwsStateError,
      );
      expect(previous.getString('profile_x__study_sessions'), 'important');
      expect(previous.getInt('daily_reminder_hour'), 21);
      expect(await destination.getBool('device_storage_ready'), isNull);
      await DevicePreferences.migrateAndroid(previous, destination);
      expect(
        jsonDecode(
          (await destination.getString(DevicePreferences.reminderKey))!,
        ),
        {'enabled': false, 'hour': 21, 'minute': 30},
      );
      expect(await destination.getString('last_file_export_at'), isNull);
      expect(previous.getString('profile_x__study_sessions'), 'important');
      expect(previous.containsKey('daily_reminder_enabled'), isFalse);
      await destination.setString(
        DevicePreferences.reminderKey,
        jsonEncode({'enabled': true, 'hour': 22, 'minute': 0}),
      );
      await DevicePreferences.migrateAndroid(previous, destination);
      expect(
        jsonDecode(
          (await destination.getString(DevicePreferences.reminderKey))!,
        )['enabled'],
        isTrue,
      );
    },
  );
  test(
    'disabled reminder time update is one durable snapshot and failure leaves prior settings',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      SharedPreferences.setMockInitialValues({});
      final store = ControlledStore();
      SharedPreferencesStorePlatform.instance = store;
      try {
        await DailyReminderService.updateTime(
          hour: 20,
          minute: 15,
          profileName: 'Profil',
          targetDate: DateTime(2027),
        );
        store.failSuffix = DevicePreferences.reminderKey;
        await expectLater(
          DailyReminderService.updateTime(
            hour: 22,
            minute: 30,
            profileName: 'Profil',
            targetDate: DateTime(2027),
          ),
          throwsStateError,
        );
        final current = await DailyReminderService.readSettings();
        expect(current.hour, 20);
        expect(current.minute, 15);
        expect(current.enabled, isFalse);
        await DailyReminderService.updateTime(
          hour: 22,
          minute: 30,
          profileName: 'Profil',
          targetDate: DateTime(2027),
        );
        expect((await DailyReminderService.readSettings()).hour, 22);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    },
  );
}
