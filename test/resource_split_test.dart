// Parça 1: Kaynağı otomatik görevlere bölme.
import 'package:flutter_test/flutter_test.dart';
import 'package:yks_study_app/models/learning_workspace.dart';
import 'package:yks_study_app/models/study_schedule_preferences.dart';

const book = StudyResource(
  id: 'book',
  name: 'Soru Bankası',
  subjectId: 'course',
  subjectName: 'Matematik',
  session: 'TYT',
  unit: StudyResourceUnit.page,
  totalUnits: 100,
  initialCompletedUnits: 10,
);

LearningWorkspace base() => LearningWorkspace.empty('p').saveResource(book);

List<ResourceTask> split(
  LearningWorkspace w, {
  int per = 20,
  int minutes = 60,
  String prefix = 'Bölüm',
}) => w.splitUnassigned(
  resourceId: 'book',
  unitsPerTask: per,
  minutesPerTask: minutes,
  titlePrefix: prefix,
  idPrefix: 'task-x',
);

void main() {
  test('başlangıçta bitirilen kısımdan sonrasını eşit görevlere böler', () {
    final tasks = split(base());
    expect(tasks.map((t) => (t.startUnit, t.endUnit)), [
      (11, 30),
      (31, 50),
      (51, 70),
      (71, 90),
      (91, 100),
    ]);
    expect(tasks.first.title, 'Bölüm 1 (11–30)');
    expect(tasks.last.estimatedMinutes, 30, reason: '10 sayfa = 60/2 dk');
    expect(tasks.map((t) => t.id), [
      'task-x-0001',
      'task-x-0002',
      'task-x-0003',
      'task-x-0004',
      'task-x-0005',
    ]);
    final saved = base().saveTasks(tasks);
    expect(saved.unassignedRanges('book'), isEmpty);
    expect(saved.tasks, hasLength(5));
  });

  test('mevcut görevler ve arşivli görevin çalışılmış kısmı korunur', () {
    var w = base()
        .saveTask(
          const ResourceTask(
            id: 'manual',
            resourceId: 'book',
            title: 'Elle',
            startUnit: 41,
            endUnit: 60,
            estimatedMinutes: 30,
          ),
        )
        .saveTask(
          const ResourceTask(
            id: 'old',
            resourceId: 'book',
            title: 'Eski',
            startUnit: 11,
            endUnit: 30,
            estimatedMinutes: 30,
          ),
        )
        .record(
          ResourceProgressEvent(
            id: 'e1',
            taskId: 'old',
            startUnit: 11,
            units: 5,
            occurredAt: DateTime.utc(2026, 10, 20),
          ),
        );
    w = w.saveTask(w.tasks.firstWhere((t) => t.id == 'old').withArchived(true));
    expect(w.unassignedRanges('book'), [(16, 40), (61, 100)]);
    final tasks = split(w, per: 25);
    expect(tasks.map((t) => (t.startUnit, t.endUnit)), [
      (16, 40),
      (61, 85),
      (86, 100),
    ]);
    final saved = w.saveTasks(tasks);
    expect(saved.unassignedRanges('book'), isEmpty);
    expect(saved.taskProgress('old'), 5, reason: 'geçmiş korunur');
  });

  test('geçersiz ayar ve dolu kaynak açık hata verir', () {
    expect(() => split(base(), per: 0), throwsFormatException);
    expect(() => split(base(), minutes: 0), throwsFormatException);
    expect(
      () => base().splitUnassigned(
        resourceId: 'book',
        unitsPerTask: 1,
        minutesPerTask: 10,
        titlePrefix: '',
        idPrefix: 't',
        maxTasks: 50,
      ),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'mesaj',
          contains('90 görev'),
        ),
      ),
    );
    final full = base().saveTasks(split(base()));
    expect(() => split(full), throwsFormatException);
  });

  test('planlayıcı bölünmüş görevleri sırayla yerleştirir (10. > 2.)', () {
    final tasks = split(base(), per: 5, minutes: 30);
    expect(tasks, hasLength(18));
    final w = base().saveTasks(tasks);
    final now = DateTime(2026, 10, 21, 9);
    final planned = w.planResources(
      now,
      DateTime(2026, 11, 30),
      const StudySchedulePreferences(dailyStudyMinutes: 60),
    );
    final order = [
      for (final day in List.of(
        planned.plans,
      )..sort((a, b) => a.date.compareTo(b.date)))
        for (final block in day.blocks) block.startUnit,
    ];
    final sorted = List<int>.of(order)..sort();
    expect(order, sorted);
    expect(order.first, 11);
  });
}
