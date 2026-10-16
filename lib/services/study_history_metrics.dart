import '../models/daily_log.dart';
import '../models/legacy_daily_activity.dart';
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

  static void setSolvedQuestionsForProgressOn({
    required List<QuestionEvent> events,
    required String profileId,
    required String progressId,
    required int targetCount,
    required DateTime studyDate,
    required String Function() nextEventId,
  }) {
    final day = _day(studyDate);
    final dateKey = _dateKey(day);
    final currentCount = solvedQuestionsForProgressOn(events, progressId, day);
    if (targetCount > currentCount) {
      events.add(
        QuestionEvent(
          id: nextEventId(),
          profileId: profileId,
          progressId: progressId,
          topicId: null,
          occurredAt: day,
          questionCount: targetCount - currentCount,
        ),
      );
      return;
    }
    if (targetCount == currentCount) return;

    var toRemove = currentCount - targetCount;
    final dated =
        events
            .where(
              (event) =>
                  event.progressId == progressId &&
                  !event.isLegacyUnattributed &&
                  event.occurredAt != null &&
                  _dateKey(event.occurredAt!) == dateKey,
            )
            .toList()
          ..sort(
            (first, second) => second.occurredAt!.compareTo(first.occurredAt!),
          );
    for (final event in dated) {
      if (toRemove == 0) break;
      final removed = event.questionCount < toRemove
          ? event.questionCount
          : toRemove;
      toRemove -= removed;
      if (removed == event.questionCount) {
        events.remove(event);
      } else {
        final index = events.indexOf(event);
        events[index] = event.withQuestionCount(event.questionCount - removed);
      }
    }
  }

  static int legacyUnattributedQuestionCount(Iterable<QuestionEvent> events) =>
      events
          .where((event) => event.isLegacyUnattributed)
          .fold(0, (sum, event) => sum + event.questionCount);

  static List<LegacyDailyActivity> legacyDailyActivities(
    Map<String, dynamic> dailyLogHistory,
    Iterable<DailyLog> templateLogs,
  ) {
    final templateDateKeys = templateLogs.map((log) => log.dateKey).toSet();
    final activities = <LegacyDailyActivity>[];
    for (final entry in dailyLogHistory.entries) {
      if (templateDateKeys.contains(entry.key) || entry.value is! Map) {
        continue;
      }
      final progress = Map<String, dynamic>.from(entry.value as Map);
      final questions = (progress['solvedQuestions'] as num?)?.toInt() ?? 0;
      final isCompleted = progress['isCompleted'] == true;
      final notes = progress['weakTopicNotes'] is String
          ? progress['weakTopicNotes'] as String
          : '';
      if (!isCompleted && questions <= 0 && notes.isEmpty) continue;
      activities.add(
        LegacyDailyActivity(
          sourceDateKey: entry.key,
          date: DateTime.tryParse(entry.key),
          solvedQuestions: questions < 0 ? 0 : questions,
          isCompleted: isCompleted,
          weakTopicNotes: notes,
        ),
      );
    }
    activities.sort((first, second) {
      final firstDate = first.date;
      final secondDate = second.date;
      if (firstDate != null && secondDate != null) {
        return secondDate.compareTo(firstDate);
      }
      if (firstDate != null) return -1;
      if (secondDate != null) return 1;
      return second.sourceDateKey.compareTo(first.sourceDateKey);
    });
    return List.unmodifiable(activities);
  }

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
