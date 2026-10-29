// Eski 95 günlük şablonun AYT sütunu SAY için yazılmıştı (2026-10-30):
// EA/SÖZ/DİL profilleri aynı gün ve görev kimliklerini korur, AYT metni ise
// kendi derslerini gösterir.
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:yks_study_app/data/ayt_social_subjects_data.dart';
import 'package:yks_study_app/data/daily_schedule_data.dart';
import 'package:yks_study_app/models/daily_log.dart';
import 'package:yks_study_app/providers/app_state.dart';
import 'package:yks_study_app/services/profile_storage.dart';

final _science = RegExp(r'\b(Fizik|Kimya|Bio|Kim)\b');

List<String> _ayt(List<DailyLog> logs) =>
    logs.map((log) => log.aytContent).toList();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('SAY ve belirtilmemiş profil şablonu birebir korur', () {
    final original = _ayt(getDailySchedule());
    expect(_ayt(getDailySchedule(scoreType: 'say')), original);
    expect(_ayt(getDailySchedule(scoreType: 'unspecified')), original);
    expect(original.where(_science.hasMatch), isNotEmpty);
  });

  for (final scoreType in ['ea', 'soz', 'dil']) {
    test('$scoreType gün, görev kimliği ve TYT metnini değiştirmez', () {
      final original = getDailySchedule();
      final adapted = getDailySchedule(scoreType: scoreType);
      expect(adapted, hasLength(original.length));
      for (var i = 0; i < original.length; i++) {
        expect(adapted[i].progressIds, original[i].progressIds);
        expect(adapted[i].date, original[i].date);
        expect(adapted[i].tytContent, original[i].tytContent);
      }
      expect(
        _ayt(adapted).where(_science.hasMatch),
        isEmpty,
        reason: '$scoreType planında fen dersi kalmamalı',
      );
    });
  }

  test('EA matematiği korur, her EA konusunu planlar', () {
    final ayt = _ayt(getDailySchedule(scoreType: 'ea')).join('\n');
    expect(ayt, contains('AYT: Mat — Polinomlar'));
    for (final course in getAytSocialSubjects().where(
      (subject) => subject.areas.contains('ea'),
    )) {
      for (final topic in course.topics) {
        expect(ayt, contains(topic.name), reason: topic.id);
      }
    }
    expect(ayt, isNot(contains('Tarih-2')));
  });

  test('SÖZ matematik içermez, her SÖZ konusunu planlar', () {
    final ayt = _ayt(getDailySchedule(scoreType: 'soz')).join('\n');
    expect(ayt, isNot(contains('AYT: Mat')));
    expect(ayt, isNot(contains('Matematik')));
    for (final course in getAytSocialSubjects()) {
      for (final topic in course.topics) {
        expect(ayt, contains(topic.name), reason: topic.id);
      }
    }
  });

  test('DİL AYT dersi yerine YDT çalışması görür', () {
    final ayt = _ayt(getDailySchedule(scoreType: 'dil'));
    expect(ayt.where((text) => text.startsWith('YDT:')), isNotEmpty);
    expect(ayt.where((text) => text.startsWith('AYT: Mat')), isEmpty);
    expect(ayt.join('\n'), isNot(contains('Edebiyat')));
  });

  test('profilin puan türü günlük plana yansır', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    SharedPreferences.setMockInitialValues({});
    SharedPreferencesStorePlatform.instance =
        InMemorySharedPreferencesStore.empty();
    final state = AppState(profileStorage: ProfileStorage.forTesting());
    addTearDown(() {
      state.dispose();
      debugDefaultTargetPlatformOverride = null;
    });
    await state.loadData();
    expect(_ayt(state.dailyLogs).where(_science.hasMatch), isNotEmpty);

    await state.updateActiveProfile(scoreType: 'soz');
    expect(state.dailyLogs, isNotEmpty);
    expect(_ayt(state.dailyLogs).where(_science.hasMatch), isEmpty);
    expect(_ayt(state.dailyLogs).join('\n'), contains('Edebiyat'));
  });
}
