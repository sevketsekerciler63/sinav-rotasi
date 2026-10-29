// Katalog güncellemesi (2026-10-21): AYT/TYT Matematik'e eklenen hazır
// konular, daha önce aynı adla kişisel konu eklemiş öğrencinin verisini ve
// yedeğini bozmamalıdır.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:yks_study_app/data/subjects_data.dart';
import 'package:yks_study_app/models/topic.dart';
import 'package:yks_study_app/providers/app_state.dart';
import 'package:yks_study_app/services/profile_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Hazır katalog', () {
    final subjects = getAllSubjects();

    test('konu kimlikleri benzersiz ve her konunun kaynağı var', () {
      final ids = <String>{};
      for (final subject in subjects) {
        final names = <String>{};
        for (final topic in subject.topics) {
          expect(ids.add(topic.id), isTrue, reason: 'yinelenen ${topic.id}');
          expect(
            names.add(topic.name.trim().toLowerCase()),
            isTrue,
            reason: '${subject.name} içinde yinelenen ${topic.name}',
          );
          expect(topic.description.trim(), isNotEmpty);
          expect(topic.sourceLabel, isNotNull, reason: topic.id);
          expect(topic.sourceUrl, startsWith('https://'), reason: topic.id);
          expect(topic.questionCount, greaterThan(0), reason: topic.id);
        }
      }
      expect(ids.length, 115);
    });

    test('AYT Matematik geometri, olasılık ve dönüşüm konularını içerir', () {
      final ayt = subjects.firstWhere((s) => s.name == 'AYT Matematik');
      final ids = ayt.topics.map((topic) => topic.id).toSet();
      for (var index = 1; index <= 16; index++) {
        expect(ids, contains('ayt_mat_$index'));
      }
      final tyt = subjects.firstWhere((s) => s.name == 'TYT Matematik');
      expect(
        tyt.topics.map((topic) => topic.id),
        containsAll(['tyt_mat_26', 'tyt_mat_27']),
      );
    });
  });

  group('Kişisel konu ile ad çakışması', () {
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

    String aytMathId() => state.subjects
        .firstWhere((subject) => subject.name == 'AYT Matematik')
        .storageId;

    Future<void> writeOldCurriculum() async {
      // Eski sürümde katalogda olmayan "Koşullu Olasılık" kişisel konu
      // olarak eklenmiş ve tamamlanmış.
      await storage.writeStringsForProfile(state.activeProfile.id, {
        'custom_curriculum': jsonEncode({
          'version': 1,
          'customSubjects': [],
          'customTopics': [
            {
              'subjectId': aytMathId(),
              'topic': {
                'id': 'custom_topic_1',
                'name': 'Koşullu olasılık',
                'description': 'Kendi notum',
                'questionCount': 2,
                'difficulty': '🟡 Orta',
                'priority': '🟠 ÖNEMLİ',
                'estimatedDays': 2,
              },
            },
          ],
        }),
        'topics_data': jsonEncode({
          'custom_topic_1': {'isCompleted': true, 'notes': 'bitti'},
        }),
      });
    }

    List<Topic> aytTopics() => state.subjects
        .firstWhere((subject) => subject.name == 'AYT Matematik')
        .topics;

    test('kişisel konu korunur, adı (kişisel) ekiyle ayrışır', () async {
      await writeOldCurriculum();
      await state.loadData();

      final builtIn = aytTopics().singleWhere((t) => t.id == 'ayt_mat_13');
      final personal = aytTopics().singleWhere((t) => t.id == 'custom_topic_1');
      expect(builtIn.name, 'Koşullu Olasılık');
      expect(personal.name, 'Koşullu olasılık (kişisel)');
      expect(personal.isCustom, isTrue);
      expect(personal.isCompleted, isTrue);
      expect(personal.notes, 'bitti');
      expect(personal.description, 'Kendi notum');
    });

    test('böyle bir profilin yedeği iki tur boyunca içe aktarılır', () async {
      await writeOldCurriculum();
      await state.loadData();

      for (var round = 0; round < 2; round++) {
        final backup = await storage.exportBackup();
        final data = (backup['data'] as Map)[state.activeProfile.id] as Map;
        // Müfredat kurtarma kaydına düşmeden normal veri olarak taşınmalı.
        expect(data['custom_curriculum'], isNotNull);
        expect(data['recovery_records'], isNull);
        await storage.importBackup(backup);
        await state.loadData();
      }

      final personal = aytTopics().where((t) => t.id == 'custom_topic_1');
      expect(personal, hasLength(1));
      expect(personal.single.isCompleted, isTrue);
      expect(
        aytTopics()
            .map((topic) => topic.name.trim().toLowerCase())
            .toSet()
            .length,
        aytTopics().length,
      );
    });

    test('kişisel konular kendi aralarında yine yinelenemez', () async {
      final backup = await storage.exportBackup();
      final profiles = backup['profiles'];
      expect(profiles, isNotNull);
      final data = backup['data'] as Map<String, dynamic>;
      final profileData = data[state.activeProfile.id] as Map<String, dynamic>;
      Map<String, Object> custom(int id) => {
        'subjectId': aytMathId(),
        'topic': {
          'id': 'custom_topic_$id',
          'name': 'Aynı ad',
          'description': '',
          'questionCount': 1,
          'difficulty': '🟡 Orta',
          'priority': '🟡 ORTA',
          'estimatedDays': 1,
        },
      };
      profileData['custom_curriculum'] = {
        'version': 1,
        'customSubjects': [],
        'customTopics': [custom(1), custom(2)],
      };
      await expectLater(storage.importBackup(backup), throwsFormatException);
    });
  });
}
