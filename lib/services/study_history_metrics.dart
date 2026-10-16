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

  static DateTime _day(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
