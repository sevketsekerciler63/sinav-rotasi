import '../models/daily_log.dart';
import '../models/question_event.dart';
import '../models/study_session.dart';

/// Shared date and duration rules for the study history shown across screens.
class StudyHistoryMetrics {
  const StudyHistoryMetrics._();

  static int solvedQuestionsOn(Iterable<QuestionEvent> events, DateTime date) {
    final dateKey = _dateKey(date);
    return events.fold<int>(0, (sum, event) {
      final occurredAt = event.occurredAt;
      if (event.isLegacyUnattributed ||
          occurredAt == null ||
          _dateKey(occurredAt) != dateKey) {
        return sum;
      }
      return sum + event.questionCount;
    });
  }

  static int solvedQuestionsForProgressOn(
    Iterable<QuestionEvent> events,
    String progressId,
    DateTime date,
  ) {
    final dateKey = _dateKey(date);
    return events.fold<int>(0, (sum, event) {
      final occurredAt = event.occurredAt;
      if (event.progressId != progressId ||
          event.isLegacyUnattributed ||
          occurredAt == null ||
          _dateKey(occurredAt) != dateKey) {
        return sum;
      }
      return sum + event.questionCount;
    });
  }

  static int legacyUnattributedQuestionCount(Iterable<QuestionEvent> events) =>
      events
          .where((event) => event.isLegacyUnattributed)
          .fold(0, (sum, event) => sum + event.questionCount);

  static int completedSessionsOn(
    Iterable<StudySession> sessions,
    DateTime date,
  ) {
    final dateKey = _dateKey(date);
    return sessions
        .where(
          (session) =>
              session.status == StudySessionStatus.completed &&
              _dateKey(session.startedAt) == dateKey,
        )
        .length;
  }

  static int activeSecondsOn(Iterable<StudySession> sessions, DateTime date) {
    final dateKey = _dateKey(date);
    return sessions
        .where(
          (session) =>
              session.status == StudySessionStatus.completed &&
              _dateKey(session.startedAt) == dateKey,
        )
        .fold<int>(0, (sum, session) => sum + session.activeSeconds);
  }

  static int completedSessionsBetween(
    Iterable<StudySession> sessions, {
    required DateTime start,
    required DateTime end,
  }) {
    final startDay = _day(start);
    final endDay = _day(end);
    return sessions.where((session) {
      final date = session.sessionDate;
      return session.status == StudySessionStatus.completed &&
          !date.isBefore(startDay) &&
          !date.isAfter(endDay);
    }).length;
  }

  static int activeSecondsBetween(
    Iterable<StudySession> sessions, {
    required DateTime start,
    required DateTime end,
  }) {
    final startDay = _day(start);
    final endDay = _day(end);
    return sessions
        .where((session) {
          final date = session.sessionDate;
          return session.status == StudySessionStatus.completed &&
              !date.isBefore(startDay) &&
              !date.isAfter(endDay);
        })
        .fold<int>(0, (sum, session) => sum + session.activeSeconds);
  }

  static Set<String> completedStudyDateKeys(
    Map<String, dynamic> planEntries,
    Iterable<DailyLog> templateLogs,
  ) {
    final completedDays = <String>{};
    final template = templateLogs.toList();
    for (final entry in planEntries.entries) {
      if (entry.value is! Map || (entry.value as Map)['isCompleted'] != true) {
        continue;
      }
      final progress = Map<String, dynamic>.from(entry.value as Map);
      DateTime? completedAt = progress['completedAt'] is String
          ? DateTime.tryParse(progress['completedAt'] as String)
          : null;
      if (completedAt == null && entry.key.startsWith('review_')) {
        completedAt = DateTime.tryParse(entry.key.substring('review_'.length));
      }
      if (completedAt == null) {
        final match = RegExp(r'^day_(\d{3})$').firstMatch(entry.key);
        final index = int.tryParse(match?.group(1) ?? '');
        if (index != null && index > 0 && index <= template.length) {
          completedAt = template[index - 1].date;
        }
      }
      if (completedAt != null) completedDays.add(_dateKey(completedAt));
    }
    return completedDays;
  }

  static int streak(
    Set<String> completedDateKeys,
    Iterable<int> availableWeekdays,
    DateTime now,
  ) {
    final weekdays = availableWeekdays.toSet();
    final today = _day(now);
    var cursor = today;
    if (weekdays.contains(today.weekday) &&
        !completedDateKeys.contains(_dateKey(today))) {
      cursor = DateTime(today.year, today.month, today.day - 1);
    }
    var count = 0;
    final oldest = DateTime(today.year, today.month, today.day - 365);
    while (!cursor.isBefore(oldest)) {
      if (weekdays.contains(cursor.weekday)) {
        if (!completedDateKeys.contains(_dateKey(cursor))) break;
        count++;
      }
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    return count;
  }

  static DateTime _day(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
