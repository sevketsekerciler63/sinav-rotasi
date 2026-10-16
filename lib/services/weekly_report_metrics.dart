import '../models/daily_log.dart';
import '../models/mock_exam.dart';
import '../models/question_event.dart';
import '../models/study_session.dart';
import 'study_history_metrics.dart';

typedef WeeklyReportDay = ({
  DateTime date,
  DailyLog? log,
  bool completed,
  int questions,
  int sessions,
  int minutes,
});

/// Builds one date-consistent snapshot for the weekly report.
class WeeklyReportMetrics {
  const WeeklyReportMetrics._({
    required this.asOf,
    required this.today,
    required this.weekStart,
    required this.daysCompleted,
    required this.totalDays,
    required this.missedScheduledDays,
    required this.todayPlanIsOngoing,
    required this.dailyBreakdown,
    required this.questions,
    required this.focusSessions,
    required this.focusSeconds,
    required this.exams,
  });

  final DateTime asOf;
  final DateTime today;
  final DateTime weekStart;
  final int daysCompleted;
  final int totalDays;
  final int missedScheduledDays;
  final bool todayPlanIsOngoing;
  final List<WeeklyReportDay> dailyBreakdown;
  final int questions;
  final int focusSessions;
  final int focusSeconds;
  final List<MockExam> exams;

  factory WeeklyReportMetrics.current({
    required DateTime now,
    required Iterable<DailyLog> logs,
    required Iterable<DateTime> completedStudyDates,
    required Iterable<QuestionEvent> questionEvents,
    required Iterable<StudySession> studySessions,
    required Iterable<MockExam> mockExams,
  }) {
    final today = _day(now);
    final weekStart = DateTime(
      today.year,
      today.month,
      today.day - today.weekday + 1,
    );
    final weekEndExclusive = weekStart.add(const Duration(days: 7));
    final currentLogs = logs.where((log) {
      final date = _day(log.date);
      return !date.isBefore(weekStart) && !date.isAfter(today);
    }).toList();
    final completedDates = completedStudyDates
        .map(_day)
        .where((date) => !date.isBefore(weekStart) && !date.isAfter(today))
        .toSet();
    final completedDateKeys = completedDates.map(_dateKey).toSet();
    final scheduledDateKeys =
        currentLogs
            .where((log) => !log.isRestDay)
            .map((log) => log.dateKey)
            .toSet()
          ..addAll(completedDates.map(_dateKey));
    final todayKey = _dateKey(today);
    final missedScheduledDays = scheduledDateKeys
        .where(
          (dateKey) =>
              dateKey.compareTo(todayKey) < 0 &&
              !completedDateKeys.contains(dateKey),
        )
        .length;
    final todayPlanIsOngoing =
        scheduledDateKeys.contains(todayKey) &&
        !completedDateKeys.contains(todayKey);

    final dailyBreakdown = <WeeklyReportDay>[];
    for (
      var date = weekStart;
      !date.isAfter(today);
      date = DateTime(date.year, date.month, date.day + 1)
    ) {
      DailyLog? log;
      for (final candidate in currentLogs) {
        if (_dateKey(candidate.date) == _dateKey(date)) {
          log = candidate;
          break;
        }
      }
      final questions = StudyHistoryMetrics.solvedQuestionsOn(
        questionEvents,
        date,
      );
      final sessions = StudyHistoryMetrics.completedSessionsOn(
        studySessions,
        date,
      );
      final minutes =
          StudyHistoryMetrics.activeSecondsOn(studySessions, date) ~/ 60;
      final completed = completedDateKeys.contains(_dateKey(date));
      if (log != null || completed || questions > 0 || sessions > 0) {
        dailyBreakdown.add((
          date: date,
          log: log,
          completed: completed,
          questions: questions,
          sessions: sessions,
          minutes: minutes,
        ));
      }
    }

    final exams = mockExams.where((exam) {
      final date = exam.displayDate;
      return !date.isBefore(weekStart) && date.isBefore(weekEndExclusive);
    }).toList();

    return WeeklyReportMetrics._(
      asOf: now,
      today: today,
      weekStart: weekStart,
      daysCompleted: completedDates.length,
      totalDays: scheduledDateKeys.length,
      missedScheduledDays: missedScheduledDays,
      todayPlanIsOngoing: todayPlanIsOngoing,
      dailyBreakdown: List.unmodifiable(dailyBreakdown),
      questions: dailyBreakdown.fold<int>(
        0,
        (total, day) => total + day.questions,
      ),
      focusSessions: StudyHistoryMetrics.completedSessionsBetween(
        studySessions,
        start: weekStart,
        end: today,
      ),
      focusSeconds: StudyHistoryMetrics.activeSecondsBetween(
        studySessions,
        start: weekStart,
        end: today,
      ),
      exams: List.unmodifiable(exams),
    );
  }
}

DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);

String _dateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
