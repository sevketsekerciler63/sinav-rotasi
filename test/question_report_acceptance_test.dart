// Kabul Turu 1, madde 3'ün otomatik karşılığı: 100 + 20 soru kaydı
// günlük ve haftalık raporda doğru güne düşüyor mu? Cihaz kabulünün yerine
// geçmez; hesaplama kuralını korur.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:yks_study_app/models/question_event.dart';
import 'package:yks_study_app/services/study_history_metrics.dart';
import 'package:yks_study_app/services/weekly_report_metrics.dart';

void main() {
  // 2026-10-19 Pazartesi, 2026-10-20 Salı.
  final monday = DateTime(2026, 10, 19);
  final tuesday = DateTime(2026, 10, 20);

  QuestionEvent event(String id, DateTime at, int count) => QuestionEvent(
    id: id,
    profileId: 'yks-default',
    progressId: 'day_001',
    topicId: null,
    occurredAt: at,
    questionCount: count,
  );

  WeeklyReportMetrics report(List<QuestionEvent> events, DateTime now) =>
      WeeklyReportMetrics.current(
        now: now,
        logs: const [],
        completedStudyDates: const [],
        questionEvents: events,
        studySessions: const [],
        mockExams: const [],
      );

  test('gece yarısına yakın 100 + 20 soru ayrı günlere düşer', () {
    final events = [
      event('q1', DateTime(2026, 10, 19, 23, 59), 100),
      event('q2', DateTime(2026, 10, 20, 0, 1), 20),
    ];

    expect(StudyHistoryMetrics.solvedQuestionsOn(events, monday), 100);
    expect(StudyHistoryMetrics.solvedQuestionsOn(events, tuesday), 20);

    final weekly = report(events, DateTime(2026, 10, 20, 12));
    expect(weekly.questions, 120);
    final byDay = {
      for (final day in weekly.dailyBreakdown) day.date: day.questions,
    };
    expect(byDay[monday], 100);
    expect(byDay[tuesday], 20);
  });

  test('salı sayısını değiştirmek pazartesi kaydına dokunmaz', () {
    final events = <QuestionEvent>[];
    var next = 0;
    String nextId() => 'q${++next}';

    StudyHistoryMetrics.setSolvedQuestionsForProgressOn(
      events: events,
      profileId: 'yks-default',
      progressId: 'day_001',
      targetCount: 100,
      studyDate: monday,
      nextEventId: nextId,
    );
    StudyHistoryMetrics.setSolvedQuestionsForProgressOn(
      events: events,
      profileId: 'yks-default',
      progressId: 'day_001',
      targetCount: 20,
      studyDate: tuesday,
      nextEventId: nextId,
    );
    StudyHistoryMetrics.setSolvedQuestionsForProgressOn(
      events: events,
      profileId: 'yks-default',
      progressId: 'day_001',
      targetCount: 15,
      studyDate: tuesday,
      nextEventId: nextId,
    );

    expect(StudyHistoryMetrics.solvedQuestionsOn(events, monday), 100);
    expect(StudyHistoryMetrics.solvedQuestionsOn(events, tuesday), 15);
    expect(StudyHistoryMetrics.totalSolvedQuestions(events), 115);
  });

  test('JSON gidiş-dönüşü sonrası günler kaymaz', () {
    final events = [
      event('q1', DateTime(2026, 10, 19, 23, 59), 100),
      event('q2', DateTime(2026, 10, 20, 0, 1), 20),
    ];
    final restored = (jsonDecode(jsonEncode(events)) as List)
        .map((raw) => QuestionEvent.fromJson(raw as Map<String, dynamic>))
        .toList();

    expect(StudyHistoryMetrics.solvedQuestionsOn(restored, monday), 100);
    expect(StudyHistoryMetrics.solvedQuestionsOn(restored, tuesday), 20);
  });

  test('tarihsiz eski toplam günlük ve haftalık rapora girmez', () {
    final events = [
      event('q1', DateTime(2026, 10, 19, 10), 100),
      const QuestionEvent(
        id: 'legacy',
        profileId: 'yks-default',
        progressId: null,
        topicId: null,
        occurredAt: null,
        questionCount: 500,
        isLegacyUnattributed: true,
      ),
    ];

    expect(StudyHistoryMetrics.solvedQuestionsOn(events, monday), 100);
    expect(StudyHistoryMetrics.legacyUnattributedQuestionCount(events), 500);
    expect(report(events, DateTime(2026, 10, 20, 12)).questions, 100);
  });

  test('önceki haftanın pazar kaydı bu haftanın raporuna eklenmez', () {
    final events = [
      event('q1', DateTime(2026, 10, 18, 23, 30), 100),
      event('q2', DateTime(2026, 10, 19, 8), 20),
    ];

    final weekly = report(events, DateTime(2026, 10, 20, 12));
    expect(weekly.weekStart, monday);
    expect(weekly.questions, 20);
  });
}
