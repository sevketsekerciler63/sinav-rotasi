// EA/SÖZ AYT dersleri (2026-10-30): dersler puan türüne göre görünür,
// SAY/belirtilmemiş profilin kataloğu değişmez, önceki kaynak bağları ve
// aynı adlı kişisel dersler korunur.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:yks_study_app/data/resource_subjects_data.dart';
import 'package:yks_study_app/data/subjects_data.dart';
import 'package:yks_study_app/models/exam_attempt.dart';
import 'package:yks_study_app/providers/app_state.dart';
import 'package:yks_study_app/services/profile_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('EA/SÖZ dersleri Kaynaklarım kimlik ve adlarıyla eşleşir', () {
    final catalog = getAllSubjects();
    for (final spec in [
      ...YksAttemptCatalog.tests('AYT', 'ea'),
      ...YksAttemptCatalog.tests('AYT', 'soz'),
    ]) {
      if (spec.id case 'ayt_mat' || 'ayt_din') continue;
      final subject = catalog.singleWhere(
        (item) => item.storageId == 'yks_course_${spec.id}',
      );
      expect(subject.name, 'AYT ${spec.label}');
      expect(subject.totalQuestions, spec.questions);
      expect(subject.topics, isNotEmpty);
    }
    final resources = getResourceSubjects(catalog);
    final ids = resources.map((subject) => subject.storageId).toList();
    expect(ids.toSet().length, ids.length, reason: 'yinelenen kaynak dersi');
    expect(
      resources
          .singleWhere((s) => s.storageId == 'yks_course_ayt_edebiyat')
          .topics,
      isNotEmpty,
    );
    // Hazır konusu olmayan dersler Kaynaklarım'da boş ders olarak kalır.
    expect(
      resources.singleWhere((s) => s.storageId == 'yks_course_ayt_din'),
      isNotNull,
    );
  });

  group('Puan türüne göre AYT dersleri', () {
    late ProfileStorage storage;
    late AppState state;

    setUp(() async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      SharedPreferences.setMockInitialValues({});
      SharedPreferencesStorePlatform.instance =
          InMemorySharedPreferencesStore.empty();
      storage = ProfileStorage.forTesting();
      state = AppState(profileStorage: storage);
      await state.loadData();
      expect(state.bootStatus, AppBootStatus.ready);
    });

    tearDown(() {
      state.dispose();
      debugDefaultTargetPlatformOverride = null;
    });

    List<String> aytNames() =>
        state.aytSubjects.map((subject) => subject.name).toList();

    test('belirtilmemiş profil eski SAY kataloğunu ve toplamını korur', () {
      expect(aytNames(), [
        'AYT Matematik',
        'AYT Fizik',
        'AYT Kimya',
        'AYT Biyoloji',
      ]);
      expect(state.totalTopics, 115);
    });

    test('EA, SÖZ ve DİL kendi derslerini görür', () async {
      await state.updateActiveProfile(scoreType: 'ea');
      expect(aytNames(), [
        'AYT Matematik',
        'AYT Edebiyat',
        'AYT Tarih-1',
        'AYT Coğrafya-1',
      ]);

      await state.updateActiveProfile(scoreType: 'soz');
      expect(aytNames(), [
        'AYT Edebiyat',
        'AYT Tarih-1',
        'AYT Coğrafya-1',
        'AYT Tarih-2',
        'AYT Coğrafya-2',
        'AYT Felsefe grubu',
      ]);
      expect(state.tytSubjects, hasLength(6));

      await state.updateActiveProfile(scoreType: 'dil');
      expect(aytNames(), isEmpty);
      expect(state.subjects.where((s) => s.type == 'AYT'), hasLength(10));
    });

    test('puan türü değişince çalışılmış ders gizlenmez', () async {
      await storage.writeStringsForProfile(state.activeProfile.id, {
        'topics_data': jsonEncode({
          'ayt_fiz_1': {'isCompleted': true, 'notes': ''},
          'ayt_kim_1': {'isCompleted': false, 'notes': 'tekrar et'},
        }),
      });
      await state.loadData();
      await state.updateActiveProfile(scoreType: 'ea');

      expect(aytNames(), containsAll(['AYT Fizik', 'AYT Kimya']));
      expect(aytNames(), isNot(contains('AYT Biyoloji')));
      expect(state.completedTopics, 1);
    });

    test('aynı adlı kişisel ders silinmez, (kişisel) ekiyle korunur', () async {
      await storage.writeStringsForProfile(state.activeProfile.id, {
        'custom_curriculum': jsonEncode({
          'version': 1,
          'customSubjects': [
            {
              'id': 'custom_subject_1',
              'name': 'AYT Edebiyat',
              'emoji': '📘',
              'type': 'AYT',
              'totalQuestions': 24,
              'tip': '',
              'topics': [
                {
                  'id': 'custom_topic_1',
                  'name': 'Divan şiiri tekrar',
                  'description': '',
                  'questionCount': 2,
                  'difficulty': '🟡 Orta',
                  'priority': '🟠 ÖNEMLİ',
                  'estimatedDays': 1,
                },
              ],
            },
          ],
          'customTopics': [],
        }),
        'topics_data': jsonEncode({
          'custom_topic_1': {'isCompleted': true, 'notes': 'bitti'},
        }),
      });
      await state.loadData();

      for (var round = 0; round < 2; round++) {
        final backup = await storage.exportBackup();
        final data = (backup['data'] as Map)[state.activeProfile.id] as Map;
        expect(data['recovery_records'], isNull);
        await storage.importBackup(backup);
        await state.loadData();
      }

      final personal = state.subjects.singleWhere(
        (subject) => subject.storageId == 'custom_subject_1',
      );
      expect(personal.name, 'AYT Edebiyat (kişisel)');
      expect(personal.topics.single.isCompleted, isTrue);
      expect(
        state.subjects.where((s) => s.storageId == 'yks_course_ayt_edebiyat'),
        hasLength(1),
      );
      // Kişisel ders puan türünden bağımsız olarak görünür kalır.
      expect(state.aytSubjects, contains(personal));
    });
  });
}
