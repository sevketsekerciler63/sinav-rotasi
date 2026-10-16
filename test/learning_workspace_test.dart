import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:yks_study_app/models/learning_workspace.dart';

StudyResource resource() => const StudyResource(
  id: 'book',
  name: 'Kitabım',
  subjectId: 'course',
  subjectName: 'Matematik',
  session: 'TYT',
  unit: StudyResourceUnit.page,
  totalUnits: 100,
  initialCompletedUnits: 10,
);
ResourceTask task(String id, int start, int end) => ResourceTask(
  id: id,
  resourceId: 'book',
  title: 'Kaynağımdan çalışma',
  startUnit: start,
  endUnit: end,
  estimatedMinutes: 40,
);
ResourceProgressEvent event(String id, int start, int count) =>
    ResourceProgressEvent(
      id: id,
      taskId: 'task',
      startUnit: start,
      units: count,
      occurredAt: DateTime.utc(2026, 10, 16),
    );
LearningWorkspace workspace() => LearningWorkspace.empty(
  'profile',
).saveResource(resource()).saveTask(task('task', 11, 30));

void main() {
  test(
    'partial progress and out-of-order undo preserve exact remaining ranges',
    () {
      var data = workspace()
          .record(event('first', 11, 5))
          .record(event('later', 21, 5));
      expect(data.taskProgress('task'), 10);
      expect(data.resourceProgress('book'), 20);
      expect(data.remainingRanges('task'), [(16, 20), (26, 30)]);
      data = data.undo('first');
      expect(data.remainingRanges('task'), [(11, 20), (26, 30)]);
      expect(data.resourceProgress('book'), 15);
    },
  );

  test(
    'overlapping ranges and excessive progress cannot change previous graph',
    () {
      final data = workspace().record(event('first', 11, 5));
      expect(() => data.record(event('overlap', 14, 5)), throwsFormatException);
      expect(() => data.record(event('outside', 29, 5)), throwsFormatException);
      expect(
        () => data.saveTask(task('overlap', 30, 40)),
        throwsFormatException,
      );
      expect(() => data.saveTask(task('initial', 1, 5)), throwsFormatException);
      expect(data.taskProgress('task'), 5);
      expect(data.resources.single.initialCompletedUnits, 10);
    },
  );

  test(
    'exact event retry is safe and undone event cannot be resurrected by retry',
    () {
      var data = workspace().record(event('event', 11, 5));
      data = data.record(event('event', 11, 5));
      expect(data.events.length, 1);
      data = data.undo('event').record(event('event', 11, 5));
      expect(data.taskProgress('task'), 0);
      expect(data.events.single.active, isFalse);
      expect(() => data.record(event('event', 12, 5)), throwsFormatException);
    },
  );

  test('archiving frees only unworked intervals and keeps history', () {
    var data = workspace().record(event('done', 21, 5));
    data = data.saveTask(data.tasks.single.withArchived(true));
    data = data.saveTask(task('new', 11, 20));
    expect(
      () => data.saveTask(task('collision', 21, 25)),
      throwsFormatException,
    );
    expect(
      () => data.saveTask(data.tasks.first.withArchived(false)),
      throwsFormatException,
    );
    data = data.undo('done');
    expect(data.resourceProgress('book'), 10);
    expect(data.events.single.active, isFalse);
  });

  test(
    'worked task identity and resource units cannot be silently rewritten',
    () {
      final data = workspace().record(event('done', 11, 5));
      expect(() => data.saveTask(task('task', 16, 35)), throwsFormatException);
      final json = resource().toJson()..['unit'] = 'question';
      expect(
        () => data.saveResource(StudyResource.fromJson(json)),
        throwsFormatException,
      );
    },
  );

  test(
    'serialized graph retains inactive events, exact ranges and archival state',
    () {
      var data = workspace()
          .record(event('one', 11, 5))
          .record(event('two', 21, 5));
      data = data
          .undo('one')
          .saveResource(data.resources.single.withArchived(true));
      final restored = LearningWorkspace.fromJson(
        jsonDecode(jsonEncode(data.toJson())),
      );
      expect(restored.resourceProgress('book'), 15);
      expect(restored.resources.single.archived, isTrue);
      expect(restored.remainingRanges('task'), [(11, 20), (26, 30)]);
      expect(
        () => restored.record(event('archived', 16, 5)),
        throwsFormatException,
      );
    },
  );

  test(
    'import rejects duplicate identities, broken references and invalid dates',
    () {
      final json =
          jsonDecode(jsonEncode(workspace().toJson())) as Map<String, dynamic>;
      (json['resources'] as List).add(json['resources'].first);
      expect(() => LearningWorkspace.fromJson(json), throwsFormatException);
      final broken = task('broken', 11, 20).toJson()
        ..['resourceId'] = 'missing';
      final data = workspace().toJson()..['tasks'] = [broken];
      expect(() => LearningWorkspace.fromJson(data), throwsFormatException);
      final invalidDate = task('dated', 40, 50).toJson()
        ..['plannedDate'] = '2026-02-31';
      expect(() => ResourceTask.fromJson(invalidDate), throwsFormatException);
    },
  );
}
