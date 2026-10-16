import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:yks_study_app/models/learning_workspace.dart';
import 'package:yks_study_app/models/study_schedule_preferences.dart';
import 'learning_workspace_test.dart' show workspace;

void main() {
  const prefs = StudySchedulePreferences(dailyStudyMinutes: 30);
  final start = DateTime(2026, 10, 16);
  test(
    '30 minute capacity splits units and preserves today after completion and rebuild',
    () {
      var data = workspace().planResources(
        start,
        DateTime(2026, 10, 18),
        prefs,
      );
      expect(data.plans.map((day) => day.plannedMinutes), [30, 10]);
      final today = data.plans.first;
      expect(today.blocks.single.startUnit, 11);
      expect(today.blocks.single.endUnit, 25);
      data = data.record(
        ResourceProgressEvent(
          id: 'done',
          taskId: 'task',
          startUnit: 11,
          units: 15,
          occurredAt: start.add(const Duration(hours: 12)),
        ),
      );
      data = data.planResources(start, DateTime(2026, 10, 18), prefs);
      expect(data.plans.first.toJson(), today.toJson());
      expect(data.plans[1].blocks.single.startUnit, 26);
      data = data
          .undo('done')
          .planResources(start, DateTime(2026, 10, 18), prefs);
      expect(data.plans.first.toJson(), today.toJson());
      expect(data.plans[1].blocks.single.startUnit, 26);
    },
  );
  test(
    'missed expectation stays historical and late work cannot complete it retroactively',
    () {
      var data = workspace().planResources(
        start,
        DateTime(2026, 10, 18),
        prefs,
      );
      final oldDay = data.plans.first;
      data = data.planResources(
        DateTime(2026, 10, 17),
        DateTime(2026, 10, 19),
        prefs,
      );
      expect(data.plans.first.toJson(), oldDay.toJson());
      data = data.record(
        ResourceProgressEvent(
          id: 'late',
          taskId: 'task',
          startUnit: 11,
          units: 15,
          occurredAt: DateTime(2026, 10, 17, 12),
        ),
      );
      expect(data.blockProgress(oldDay, oldDay.blocks.single), 0);
      final reopened = LearningWorkspace.fromJson(
        jsonDecode(jsonEncode(data.toJson())),
      );
      expect(reopened.plans.first.toJson(), oldDay.toJson());
      expect(reopened.blockProgress(oldDay, oldDay.blocks.single), 0);
    },
  );
  test(
    'indivisible expensive unit is not forced into short day; rest days and future hints respected',
    () {
      var data = workspace().saveTask(
        const ResourceTask(
          id: 'task',
          resourceId: 'book',
          title: 'Uzun video',
          startUnit: 11,
          endUnit: 11,
          estimatedMinutes: 60,
        ),
      );
      data = data.planResources(start, DateTime(2026, 10, 18), prefs);
      expect(data.plans.expand((day) => day.blocks), isEmpty);
      data = workspace().saveTask(
        const ResourceTask(
          id: 'task',
          resourceId: 'book',
          title: 'İleri gün',
          startUnit: 11,
          endUnit: 30,
          estimatedMinutes: 40,
          plannedDate: '2026-10-18',
        ),
      );
      data = data.planResources(
        start,
        DateTime(2026, 10, 19),
        const StudySchedulePreferences(
          dailyStudyMinutes: 30,
          availableWeekdays: [1],
        ),
      );
      expect(data.plans.first.capacityMinutes, 0);
      expect(data.plans.last.date, '2026-10-19');
      expect(data.plans.last.plannedMinutes, 30);
    },
  );
  test(
    'plan graph rejects excess minutes and cannot rewrite referenced task range',
    () {
      final data = workspace().planResources(
        start,
        DateTime(2026, 10, 18),
        prefs,
      );
      expect(
        () => data.saveTask(
          const ResourceTask(
            id: 'task',
            resourceId: 'book',
            title: 'Changed',
            startUnit: 11,
            endUnit: 20,
            estimatedMinutes: 20,
          ),
        ),
        throwsFormatException,
      );
      final json =
          jsonDecode(jsonEncode(data.toJson())) as Map<String, dynamic>;
      json['plans'][0]['capacityMinutes'] = 1;
      expect(() => LearningWorkspace.fromJson(json), throwsFormatException);
      final legacy = workspace().toJson()
        ..['version'] = 1
        ..remove('plans');
      expect(LearningWorkspace.fromJson(legacy).plans, isEmpty);
    },
  );
}
