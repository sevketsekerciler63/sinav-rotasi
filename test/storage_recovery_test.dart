import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:yks_study_app/models/exam_profile.dart';
import 'package:yks_study_app/models/goal.dart';
import 'exam_attempt_test.dart' show attempt;
import 'package:yks_study_app/models/study_schedule_preferences.dart';
import 'package:yks_study_app/models/study_session.dart';
import 'package:yks_study_app/models/daily_log.dart';
import 'package:yks_study_app/models/weak_topic.dart';
import 'package:yks_study_app/models/learning_workspace.dart';
import 'package:yks_study_app/providers/app_state.dart';
import 'package:yks_study_app/services/profile_storage.dart';

class ControlledStore extends InMemorySharedPreferencesStore {
  ControlledStore() : super.withData({});
  String? failSuffix;
  String? holdSuffix;
  Completer<void>? enteredWrite;
  Completer<void>? releaseWrite;

  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (holdSuffix != null && key.endsWith(holdSuffix!)) {
      holdSuffix = null;
      enteredWrite!.complete();
      await releaseWrite!.future;
    }
    if (failSuffix != null && key.endsWith(failSuffix!)) {
      failSuffix = null;
      return false;
    }
    return super.setValue(type, key, value);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ControlledStore store;
  late ProfileStorage storage;
  late AppState state;

  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    SharedPreferences.setMockInitialValues({});
    store = ControlledStore();
    SharedPreferencesStorePlatform.instance = store;
    storage = ProfileStorage.forTesting();
    state = AppState(profileStorage: storage);
    await state.loadData();
    expect(state.bootStatus, AppBootStatus.ready);
  });
  tearDown(() {
    state.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  StudySession session(String id, {int seconds = 1500}) {
    final start = DateTime(2026, 10, 16, 12);
    return StudySession(
      id: id,
      profileId: state.activeProfile.id,
      taskId: null,
      topicId: null,
      startedAt: start,
      endedAt: start.add(const Duration(minutes: 25)),
      activeSeconds: seconds,
      status: StudySessionStatus.completed,
    );
  }

  test('parallel sessions, exact retry and conflicting identity', () async {
    expect(
      await Future.wait([
        state.recordStudySession(session('first')),
        state.recordStudySession(session('second')),
      ]),
      [true, true],
    );
    expect(await state.recordStudySession(session('first')), isTrue);
    expect(
      await state.recordStudySession(session('first', seconds: 1200)),
      isFalse,
    );
    final saved =
        jsonDecode((await storage.readString('study_sessions'))!) as List;
    expect(saved.map((e) => e['id']).toSet(), {'first', 'second'});
    expect(state.studySessions.length, 2);
  });

  test(
    'write failure rolls back preferences and unrelated save keeps error',
    () async {
      await state.updateSchedulePreferences(
        availableWeekdays: [1, 2, 3, 4, 5, 6, 7],
        dailyStudyMinutes: 180,
      );
      store.failSuffix = '__schedule_preferences';
      await expectLater(
        state.updateSchedulePreferences(
          availableWeekdays: [1, 2, 3, 4, 5, 6, 7],
          dailyStudyMinutes: 30,
        ),
        throwsStateError,
      );
      expect(state.schedulePreferences.dailyStudyMinutes, 180);
      expect(
        jsonDecode(
          (await storage.readString('schedule_preferences'))!,
        )['dailyStudyMinutes'],
        180,
      );
      expect(state.persistenceError, isNotNull);
      expect(await state.recordStudySession(session('unrelated')), isTrue);
      expect(state.persistenceError, isNotNull);
      await state.updateSchedulePreferences(
        availableWeekdays: [1, 2, 3, 4, 5, 6, 7],
        dailyStudyMinutes: 30,
      );
      expect(state.persistenceError, isNull);
      expect(state.schedulePreferences.dailyStudyMinutes, 30);
    },
  );

  test(
    'net aliases reject conflicts, concurrent exams survive reload',
    () async {
      final first = state.mockExams[0];
      final second = state.mockExams[1];
      expect(
        await state.updateMockExam(
          first.id,
          nets: {'TYT Türkçe': 100, 'TYT Turkce': 0},
        ),
        isFalse,
      );
      expect(
        await state.updateMockExam(
          first.id,
          nets: {'TYT Türkçe': 20, 'TYT Turkce': 10},
        ),
        isFalse,
      );
      expect(
        await Future.wait([
          state.updateMockExam(
            first.id,
            nets: {'TYT Türkçe': 20.25, 'TYT Turkce': 20.25},
            isCompleted: true,
          ),
          state.updateMockExam(
            second.id,
            nets: {'TYT Matematik': 12.5},
            isCompleted: true,
          ),
        ]),
        [true, true],
      );
      await state.loadData();
      expect(state.mockExams[0].nets, {'TYT Türkçe': 20.25});
      expect(state.mockExams[1].nets, {'TYT Matematik': 12.5});
      store.failSuffix = '__mock_exams';
      expect(
        await state.updateMockExam(first.id, nets: {'TYT Türkçe': 30}),
        isFalse,
      );
      expect(state.mockExams[0].nets, {'TYT Türkçe': 20.25});
      expect(
        (jsonDecode((await storage.readString('mock_exams'))!)
            as Map)[first.id]['nets'],
        {'TYT Türkçe': 20.25},
      );
    },
  );

  test(
    'profile switch during session write cannot contaminate new profile',
    () async {
      final oldId = state.activeProfile.id;
      store.holdSuffix = '__study_sessions';
      store.enteredWrite = Completer<void>();
      store.releaseWrite = Completer<void>();
      final pending = state.recordStudySession(session('before_switch'));
      await store.enteredWrite!.future;
      final transition = state.createYksProfile(
        name: 'Yeni kontrol profili',
        scoreType: 'say',
        startingLevel: 'basic',
        targetDate: DateTime.now().add(const Duration(days: 100)),
        schedulePreferences: StudySchedulePreferences.defaults,
      );
      store.releaseWrite!.complete();
      expect(await pending, isTrue);
      await transition;
      expect(state.activeProfile.id, isNot(oldId));
      expect(state.studySessions, isEmpty);
      final saved =
          jsonDecode(
                (await storage.readStringForProfile(oldId, 'study_sessions'))!,
              )
              as List;
      expect(saved.single['id'], 'before_switch');
    },
  );

  test(
    'multi-profile backup preserves raw corruption across two round trips',
    () async {
      final oldId = state.activeProfile.id;
      final other = ExamProfile(
        id: 'review-other',
        name: 'Diğer profil',
        examSystem: 'YKS',
        examType: 'TYT_AYT',
        scoreType: 'ea',
        startingLevel: 'basic',
        targetDate: DateTime(2027, 6, 1),
        templateId: 'yks_tyt_ayt_2026',
      );
      await storage.addProfile(
        other,
        initialData: {
          'schedule_preferences': jsonEncode(
            StudySchedulePreferences.defaults.toJson(),
          ),
        },
      );
      final prefs = await SharedPreferences.getInstance();
      const raw = '{bozuk Türkçe veri\n';
      await prefs.setString('profile_${oldId}__study_sessions', raw);
      final backup = await storage.exportBackup();
      final preview = await storage.previewBackup(backup);
      expect(preview.profileNames.length, 2);
      expect(preview.recoveryRecordCount, 1);
      expect(backup['data'][oldId]['study_sessions'], isNull);
      expect(
        backup['data'][oldId]['recovery_records']['records'].single['rawValue'],
        raw,
      );
      await storage.importBackup(backup);
      await state.loadData();
      expect(state.bootStatus, AppBootStatus.ready);
      expect(state.studySessions, isEmpty);
      final second = await storage.exportBackup();
      expect(
        second['data'][oldId]['recovery_records']['records'].single['rawValue'],
        raw,
      );
      await storage.importBackup(second);
      expect(
        (await storage.previewBackup(
          await storage.exportBackup(),
        )).recoveryRecordCount,
        1,
      );
    },
  );

  test(
    'supported version markers and flat legacy backup remain readable',
    () async {
      final backup = await storage.exportBackup();
      for (
        var version = 1;
        version <= ProfileStorage.schemaVersion;
        version++
      ) {
        final sample = jsonDecode(jsonEncode(backup)) as Map<String, dynamic>;
        sample['schemaVersion'] = version;
        expect((await storage.previewBackup(sample)).profileNames, isNotEmpty);
      }
      final legacy = {
        'mock_exams': {
          state.mockExams.first.id: {
            'isCompleted': true,
            'nets': {'TYT Turkce': 12.25},
          },
        },
      };
      expect((await storage.previewBackup(legacy)).isLegacy, isTrue);
      await storage.importBackup(legacy);
      await state.loadData();
      expect(state.mockExams.first.nets, {'TYT Türkçe': 12.25});
    },
  );

  test('default and caller day lists remain untouched by validation', () {
    expect(
      StudySchedulePreferences.fromJson(
        StudySchedulePreferences.defaults.toJson(),
      ).availableWeekdays,
      [1, 2, 3, 4, 5, 6, 7],
    );
    final input = <int>[7, 1, 3];
    final decoded = StudySchedulePreferences.fromJson({
      'version': 1,
      'availableWeekdays': input,
      'dailyStudyMinutes': 60,
    });
    expect(decoded.availableWeekdays, [1, 3, 7]);
    expect(input, [7, 1, 3]);
  });

  test(
    'damaged metadata still exports raw managed bytes without activating them',
    () async {
      final prefs = await SharedPreferences.getInstance();
      const rawMetadata = '{bozuk profil';
      await prefs.setString('exam_profiles', rawMetadata);
      await prefs.setString('unrelated_secret', 'not study data');
      await prefs.setString('profile_data_transaction', '{bozuk işlem');
      final unopened = ProfileStorage.forTesting();
      await expectLater(unopened.exportBackup(), throwsFormatException);
      final archive = await unopened.exportEmergencyArchive();
      expect(archive['format'], ProfileStorage.emergencyArchiveFormat);
      expect(archive['rawPreferences']['exam_profiles'], rawMetadata);
      expect(
        archive['rawPreferences']['profile_data_transaction'],
        '{bozuk işlem',
      );
      expect(
        archive['rawPreferences'].containsKey('unrelated_secret'),
        isFalse,
      );
      expect(prefs.getString('exam_profiles'), rawMetadata);
      await expectLater(
        unopened.previewBackupForStartupRecovery(archive),
        throwsFormatException,
      );
    },
  );

  test('interrupted write restores journal before opening profile', () async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'profile_${state.activeProfile.id}__schedule_preferences';
    final previous = prefs.getString(key);
    await prefs.setString(
      'profile_data_transaction',
      jsonEncode({
        'version': 1,
        'before': {key: previous},
      }),
    );
    await prefs.setString(key, '{incomplete write');
    final reopened = ProfileStorage.forTesting();
    await reopened.initialize();
    expect(prefs.getString(key), previous);
    expect(prefs.containsKey('profile_data_transaction'), isFalse);
  });

  test('plan review completion undo redo persists one review event', () async {
    final now = DateTime.now();
    final topic = WeakTopic(
      id: 'review-test',
      date: now.toIso8601String(),
      subject: 'TYT Matematik',
      topic: 'Test',
      errorType: 'Test',
      errorCount: 1,
      action: 'Tekrar',
      isStudied: true,
      needsRepeat: true,
    );
    state.weakTopics = [topic];
    final log = DailyLog(
      date: now,
      dayName: 'Kontrol',
      tytContent: 'Tekrar',
      aytContent: '',
      studyHours: '30 dk',
      motivationNote: '',
      progressIds: ['review_${now.toIso8601String().substring(0, 10)}'],
      reviewTopicId: topic.id,
    );
    state.dailyLogs = [log];
    await state.toggleDayCompleted(log.dateKey);
    await state.toggleDayCompleted(log.dateKey);
    await state.toggleDayCompleted(log.dateKey);
    expect(state.weakTopics.single.reviewRepetitions, 1);
    expect(state.weakTopics.single.reviewIntervalDays, 1);
    final backup = await storage.exportBackup();
    await storage.importBackup(backup);
    await state.loadData();
    expect(state.weakTopics.single.reviewRepetitions, 1);
    expect(state.weakTopics.single.reviewIntervalDays, 1);
  });

  StudyResource studyResource(String id) {
    final subject = state.subjects.first;
    return StudyResource(
      id: id,
      name: 'Kaynak $id',
      subjectId: subject.storageId,
      subjectName: subject.name,
      session: subject.type,
      unit: StudyResourceUnit.question,
      totalUnits: 100,
    );
  }

  test(
    'resource graph writes merge, failed saves keep memory and retries stay idempotent',
    () async {
      expect(
        await Future.wait([
          state.saveStudyResource(studyResource('one')),
          state.saveStudyResource(studyResource('two')),
        ]),
        [true, true],
      );
      final task = ResourceTask(
        id: 'task',
        resourceId: 'one',
        title: 'Soru çöz',
        startUnit: 1,
        endUnit: 20,
        estimatedMinutes: 40,
      );
      expect(await state.saveResourceTask(task), isTrue);
      final at = DateTime.now();
      final first = ResourceProgressEvent(
        id: 'a',
        taskId: 'task',
        startUnit: 1,
        units: 5,
        occurredAt: at,
      );
      final second = ResourceProgressEvent(
        id: 'b',
        taskId: 'task',
        startUnit: 6,
        units: 5,
        occurredAt: at,
      );
      expect(
        await Future.wait([
          state.recordResourceProgress(first),
          state.recordResourceProgress(second),
        ]),
        [true, true],
      );
      expect(await state.recordResourceProgress(first), isTrue);
      expect(state.learningWorkspace.taskProgress('task'), 10);
      store.failSuffix = '__learning_workspace';
      expect(await state.saveStudyResource(studyResource('three')), isFalse);
      expect(state.learningWorkspace.resources.length, 2);
      expect(await state.saveStudyResource(studyResource('unrelated')), isTrue);
      expect(state.persistenceError, isNotNull);
      expect(await state.saveStudyResource(studyResource('three')), isTrue);
      expect(state.persistenceError, isNull);
      await state.loadData();
      expect(state.learningWorkspace.resources.length, 4);
      expect(state.learningWorkspace.taskProgress('task'), 10);
    },
  );

  test(
    'resource graph is profile isolated and survives backup round trip',
    () async {
      final oldId = state.activeProfile.id;
      expect(await state.saveStudyResource(studyResource('one')), isTrue);
      await state.createYksProfile(
        name: 'Yeni',
        scoreType: 'say',
        startingLevel: 'basic',
        targetDate: DateTime.now().add(const Duration(days: 100)),
        schedulePreferences: StudySchedulePreferences.defaults,
      );
      expect(state.learningWorkspace.resources, isEmpty);
      await state.switchActiveProfile(oldId);
      final backup = await storage.exportBackup();
      await storage.importBackup(backup);
      await state.loadData();
      expect(state.learningWorkspace.resources.single.id, 'one');
      final corrupted = jsonDecode(jsonEncode(backup)) as Map<String, dynamic>;
      corrupted['data'][oldId]['learning_workspace']['profileId'] =
          'another-profile';
      await expectLater(
        storage.previewBackup(corrupted),
        throwsFormatException,
      );
    },
  );
  test(
    'resource plan and completion persist atomically with failed write and backup roundtrip',
    () async {
      await state.createYksProfile(
        name: 'Plan',
        scoreType: 'say',
        startingLevel: 'basic',
        targetDate: DateTime.now().add(const Duration(days: 10)),
        schedulePreferences: const StudySchedulePreferences(
          dailyStudyMinutes: 30,
        ),
      );
      await state.saveStudyResource(studyResource('one'));
      await state.saveResourceTask(
        const ResourceTask(
          id: 'task',
          resourceId: 'one',
          title: 'Çalış',
          startUnit: 1,
          endUnit: 20,
          estimatedMinutes: 40,
        ),
      );
      expect(await state.rebuildResourcePlan(), isTrue);
      final day = state.learningWorkspace.plans.first;
      final block = day.blocks.single;
      expect(block.units, 15);
      store.failSuffix = '__learning_workspace';
      expect(
        await state.completeResourcePlanBlock(
          day.date,
          block.taskId,
          block.startUnit,
          block.endUnit,
        ),
        isFalse,
      );
      expect(state.learningWorkspace.taskProgress('task'), 0);
      expect(
        await state.completeResourcePlanBlock(
          day.date,
          block.taskId,
          block.startUnit,
          block.endUnit,
        ),
        isTrue,
      );
      expect(
        await state.completeResourcePlanBlock(
          day.date,
          block.taskId,
          block.startUnit,
          block.endUnit,
        ),
        isTrue,
      );
      expect(state.learningWorkspace.events.length, 1);
      await state.rebuildResourcePlan();
      expect(state.learningWorkspace.plans.first.toJson(), day.toJson());
      final backup = await storage.exportBackup();
      await storage.importBackup(backup);
      await state.loadData();
      expect(
        state.learningWorkspace.blockProgress(
          state.learningWorkspace.plans.first,
          block,
        ),
        15,
      );
      expect(state.learningWorkspace.taskProgress('task'), 15);
      expect(state.totalSolvedQuestions, 15);
      expect(state.completedStudyDateKeys, contains(day.date));
      expect(
        state.reportDailyLogs
            .firstWhere((log) => log.dateKey == day.date)
            .isCompleted,
        isTrue,
      );
      await state.undoResourceProgress(
        state.learningWorkspace.events.single.id,
      );
      expect(state.totalSolvedQuestions, 0);
      expect(state.completedStudyDateKeys, isNot(contains(day.date)));
      expect(
        state.reportDailyLogs
            .firstWhere((log) => log.dateKey == day.date)
            .isCompleted,
        isFalse,
      );
    },
  );
  test(
    'free attempts merge, preserve failed draft state and survive profile backup',
    () async {
      expect(
        await Future.wait([
          state.saveExamAttempt(attempt('one')),
          state.saveExamAttempt(attempt('two', area: 'say')),
        ]),
        [true, true],
      );
      store.failSuffix = '__exam_attempts';
      expect(await state.saveExamAttempt(attempt('three')), isFalse);
      expect(state.examAttemptBook.attempts.length, 2);
      expect(await state.saveExamAttempt(attempt('three')), isTrue);
      expect(state.examAttemptBook.attempts.length, 3);
      final profile = state.activeProfile.id;
      final backup = await storage.exportBackup();
      await storage.importBackup(backup);
      await state.loadData();
      expect(state.examAttemptBook.attempts.length, 3);
      expect(state.completedExams, 3);
      await state.createYksProfile(
        name: 'İkinci',
        scoreType: 'say',
        startingLevel: 'basic',
        targetDate: DateTime.now().add(const Duration(days: 100)),
        schedulePreferences: StudySchedulePreferences.defaults,
      );
      expect(state.examAttemptBook.attempts, isEmpty);
      await state.switchActiveProfile(profile);
      expect(state.examAttemptBook.attempts.length, 3);
      expect(await state.archiveExamAttempt('one', true), isTrue);
      expect(state.completedExams, 2);
      final corrupted = jsonDecode(jsonEncode(backup)) as Map<String, dynamic>;
      corrupted['data'][profile]['exam_attempts']['profileId'] = 'foreign';
      await expectLater(
        storage.previewBackup(corrupted),
        throwsFormatException,
      );
    },
  );
  test(
    'topic writes merge by identity and failed completion never celebrates',
    () async {
      final first = state.subjects.first.topics[0],
          second = state.subjects.first.topics[1];
      var celebrations = 0;
      state.onCelebrate = () => celebrations++;
      store.failSuffix = '__topics_data';
      expect(await state.toggleTopic(first.id), isFalse);
      expect(first.isCompleted, isFalse);
      expect(celebrations, 0);
      expect(
        await Future.wait([
          state.updateTopicNotes(first.id, 'Notum'),
          state.toggleTopic(second.id),
        ]),
        [true, true],
      );
      expect(first.notes, 'Notum');
      expect(second.isCompleted, isTrue);
      expect(celebrations, 1);
      await state.loadData();
      expect(state.subjects.first.topics.first.notes, 'Notum');
      expect(state.subjects.first.topics[1].isCompleted, isTrue);
    },
  );
  test(
    'goals preserve failed add progress delete and protected legacy records',
    () async {
      final now = DateTime.now();
      final goal = Goal(
        id: 'g',
        title: 'Hedef',
        subject: 'Genel',
        targetCount: 10,
        unit: 'soru',
        deadline: 'ozel',
        dueDate: now.add(const Duration(days: 7)),
      );
      store.failSuffix = '__goals_data';
      expect(await state.addGoal(goal), isFalse);
      expect(state.goals, isEmpty);
      expect(await state.addGoal(goal), isTrue);
      var celebrations = 0;
      state.onCelebrate = () => celebrations++;
      store.failSuffix = '__goals_data';
      expect(await state.updateGoalProgress('g', 10), isFalse);
      expect(state.goals.single.currentCount, 0);
      expect(celebrations, 0);
      expect(await state.updateGoalProgress('g', 10), isTrue);
      expect(celebrations, 1);
      store.failSuffix = '__goals_data';
      expect(await state.removeGoal('g'), isFalse);
      expect(state.goals.length, 1);
      expect(await state.removeGoal('g'), isTrue);
      expect(
        await state.restoreGoal(
          goal,
          index: 0,
          profileId: state.activeProfile.id,
        ),
        isTrue,
      );
      await storage.writeStringsForProfile(state.activeProfile.id, {
        'goals_data': jsonEncode([
          goal.toJson(),
          {'bad': 'preserve'},
        ]),
      });
      await state.loadData();
      expect(state.quarantinedGoalRecords.length, 1);
      expect(await state.updateGoalProgress('g', 3), isTrue);
      await state.loadData();
      expect(state.quarantinedGoalRecords.single, {'bad': 'preserve'});
    },
  );
  test(
    'weak topic failure leaves review flags count and removal unchanged',
    () async {
      final topic = WeakTopic(
        id: 'w',
        date: '16.10.2026',
        subject: state.subjects.first.name,
        subjectId: state.subjects.first.storageId,
        topic: 'Sayılar',
        errorType: 'Kavram',
        errorCount: 1,
        action: 'Tekrar',
      );
      store.failSuffix = '__weak_topics';
      expect(await state.addWeakTopic(topic), isFalse);
      expect(state.weakTopics, isEmpty);
      expect(await state.addWeakTopic(topic), isTrue);
      store.failSuffix = '__weak_topics';
      expect(await state.toggleWeakTopicStudied('w'), isFalse);
      expect(state.weakTopics.single.isStudied, isFalse);
      expect(state.weakTopics.single.reviewRepetitions, 0);
      expect(await state.toggleWeakTopicStudied('w'), isTrue);
      expect(state.weakTopics.single.reviewRepetitions, 1);
      store.failSuffix = '__weak_topics';
      expect(await state.removeWeakTopic('w'), isFalse);
      expect(state.weakTopics.length, 1);
      await state.loadData();
      expect(state.weakTopics.single.reviewRepetitions, 1);
    },
  );
  test(
    'custom curriculum stages edits and deletion keeps related history safe',
    () async {
      store.failSuffix = '__custom_curriculum';
      await expectLater(
        state.addCustomSubject(
          name: 'Ek ders',
          type: 'TYT',
          totalQuestions: 20,
        ),
        throwsStateError,
      );
      expect(
        state.subjects.any((subject) => subject.name == 'Ek ders'),
        isFalse,
      );
      await state.addCustomSubject(
        name: 'Ek ders',
        type: 'TYT',
        totalQuestions: 20,
      );
      final subject = state.subjects.firstWhere(
        (subject) => subject.name == 'Ek ders',
      );
      await state.addCustomTopic(
        subjectId: subject.storageId,
        name: 'Özel konu',
        description: 'Açıklama',
        questionCount: 5,
        difficulty: '🟢 Kolay',
        priority: '🟡 ORTA',
        estimatedDays: 1,
      );
      final topic = state.subjects
          .firstWhere((item) => item.storageId == subject.storageId)
          .topics
          .single;
      await state.updateTopicNotes(topic.id, 'Korunan not');
      store.failSuffix = '__custom_curriculum';
      await expectLater(
        state.updateCustomTopic(
          subjectId: subject.storageId,
          topicId: topic.id,
          name: 'Yeni ad',
          description: 'Yeni',
          questionCount: 5,
          difficulty: '🟢 Kolay',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        throwsStateError,
      );
      expect(
        state.subjects
            .firstWhere((item) => item.storageId == subject.storageId)
            .topics
            .single
            .name,
        'Özel konu',
      );
      expect(
        state.subjects
            .firstWhere((item) => item.storageId == subject.storageId)
            .topics
            .single
            .notes,
        'Korunan not',
      );
      await state.saveStudyResource(
        StudyResource(
          id: 'linked',
          name: 'Kaynak',
          subjectId: subject.storageId,
          subjectName: subject.name,
          session: subject.type,
          unit: StudyResourceUnit.page,
          totalUnits: 20,
        ),
      );
      await expectLater(
        state.removeCustomSubject(subject.storageId),
        throwsStateError,
      );
      expect(
        state.subjects.any((item) => item.storageId == subject.storageId),
        isTrue,
      );
      await state.loadData();
      expect(
        state.subjects
            .firstWhere((item) => item.storageId == subject.storageId)
            .topics
            .single
            .notes,
        'Korunan not',
      );
    },
  );
  test(
    'custom topic deletion rolls back curriculum and progress in one transaction',
    () async {
      final subjectId = state.subjects.first.storageId;
      await state.addCustomTopic(
        subjectId: subjectId,
        name: 'Ek konu',
        description: '',
        questionCount: 5,
        difficulty: '🟢 Kolay',
        priority: '🟡 ORTA',
        estimatedDays: 1,
      );
      final topic = state.subjects.first.topics.last;
      await state.updateTopicNotes(topic.id, 'Not');
      store.failSuffix = '__topics_data';
      await expectLater(
        state.removeCustomTopic(subjectId: subjectId, topicId: topic.id),
        throwsStateError,
      );
      expect(
        state.subjects.first.topics.any((item) => item.id == topic.id),
        isTrue,
      );
      await state.loadData();
      expect(state.subjects.first.topics.last.notes, 'Not');
      await state.removeCustomTopic(subjectId: subjectId, topicId: topic.id);
      await state.loadData();
      expect(
        state.subjects.first.topics.any((item) => item.id == topic.id),
        isFalse,
      );
    },
  );
  test(
    'legacy day completion questions and review roll back together on failure',
    () async {
      final now = DateTime.now();
      await state.addWeakTopic(
        WeakTopic(
          id: 'review-day',
          date: now.toIso8601String(),
          subject: state.subjects.first.name,
          subjectId: state.subjects.first.storageId,
          topic: 'Test',
          errorType: 'Test',
          errorCount: 1,
          action: 'Tekrar',
          isStudied: true,
          needsRepeat: true,
        ),
      );
      final log = DailyLog(
        date: now,
        dayName: 'Kontrol',
        tytContent: 'Tekrar',
        aytContent: '',
        studyHours: '30 dk',
        motivationNote: '',
        progressIds: ['review_${now.toIso8601String().substring(0, 10)}'],
        reviewTopicId: 'review-day',
      );
      state.dailyLogs = [log];
      store.failSuffix = '__question_history';
      expect(await state.toggleDayCompleted(log.dateKey), isFalse);
      expect(log.isCompleted, isFalse);
      expect(state.weakTopics.single.reviewRepetitions, 0);
      expect(await state.toggleDayCompleted(log.dateKey), isTrue);
      expect(log.isCompleted, isTrue);
      expect(state.weakTopics.single.reviewRepetitions, 1);
      store.failSuffix = '__daily_logs';
      expect(
        await state.updateDailyLog(log.dateKey, solvedQuestions: 20),
        isFalse,
      );
      expect(log.solvedQuestions, 0);
      expect(state.questionEvents, isEmpty);
      expect(
        await state.updateDailyLog(log.dateKey, solvedQuestions: 20),
        isTrue,
      );
      expect(log.solvedQuestions, 20);
      expect(state.totalSolvedQuestions, 20);
      await state.loadData();
      expect(state.totalSolvedQuestions, 20);
      expect(state.weakTopics.single.reviewRepetitions, 1);
    },
  );
  test(
    'badge write failure cannot publish an unlocked badge before durable retry',
    () async {
      final topic = state.subjects.first.topics.first;
      store.failSuffix = '__achievements_data';
      expect(await state.toggleTopic(topic.id), isTrue);
      expect(topic.isCompleted, isTrue);
      expect(
        state.achievements
            .firstWhere((badge) => badge.id == 'topic_1')
            .isUnlocked,
        isFalse,
      );
      expect(state.lastUnlockedAchievement, isNull);
      await state.checkAchievements();
      expect(
        state.achievements
            .firstWhere((badge) => badge.id == 'topic_1')
            .isUnlocked,
        isTrue,
      );
      await state.loadData();
      expect(
        state.achievements
            .firstWhere((badge) => badge.id == 'topic_1')
            .isUnlocked,
        isTrue,
      );
    },
  );
}
