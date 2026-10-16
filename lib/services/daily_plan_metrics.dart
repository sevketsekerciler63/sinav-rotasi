import '../models/daily_log.dart';
import '../models/question_event.dart';
import 'study_history_metrics.dart';

/// Shared selection and completion rules for the daily plan.
class DailyPlanMetrics {
  const DailyPlanMetrics._();

  static Set<String> completedCoreTaskIds(Map<String, dynamic> planEntries) =>
      planEntries.entries
          .where(
            (entry) =>
                RegExp(r'^day_\d{3}$').hasMatch(entry.key) &&
                entry.value is Map &&
                (entry.value as Map)['isCompleted'] == true,
          )
          .map((entry) => entry.key)
          .toSet();

  static Set<String> completedCoreTaskIdsOnDate(
    Map<String, dynamic> planEntries,
    DateTime date,
  ) => planEntries.entries
      .where((entry) {
        if (!RegExp(r'^day_\d{3}$').hasMatch(entry.key) ||
            entry.value is! Map ||
            (entry.value as Map)['isCompleted'] != true) {
          return false;
        }
        final completedAtValue = (entry.value as Map)['completedAt'];
        if (completedAtValue is! String) return false;
        final completedAt = DateTime.tryParse(completedAtValue);
        return completedAt != null &&
            completedAt.year == date.year &&
            completedAt.month == date.month &&
            completedAt.day == date.day;
      })
      .map((entry) => entry.key)
      .toSet();

  static DailyLog? nextIncompleteTask({
    required DailyLog log,
    required List<DailyLog> templateTasks,
    required Map<String, dynamic> planEntries,
  }) {
    if (log.isRestDay) return null;
    for (final progressId in log.progressIds) {
      final saved = planEntries[progressId];
      if (saved is Map && saved['isCompleted'] == true) continue;
      for (final task in templateTasks) {
        if (task.progressIds.contains(progressId)) return task;
      }
      if (progressId.startsWith('review_')) return log;
    }
    return null;
  }

  static void applyPersistedProgress({
    required List<DailyLog> logs,
    required Map<String, dynamic> planEntries,
    required Iterable<QuestionEvent> questionEvents,
  }) {
    for (final log in logs) {
      if (log.progressIds.isEmpty) continue;
      final saved = log.progressIds
          .map((id) => planEntries[id])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      if (saved.isNotEmpty) {
        if (log.progressIds.length == 1) {
          log.fromJson(saved.single);
        } else {
          log.isCompleted =
              saved.length == log.progressIds.length &&
              saved.every((item) => item['isCompleted'] == true);
          log.completedProgressCount = saved
              .where((item) => item['isCompleted'] == true)
              .length;
          log.weakTopicNotes = saved
              .map((item) => item['weakTopicNotes'])
              .whereType<String>()
              .where((text) => text.isNotEmpty)
              .join('\n');
          log.activityAt = _latestProgressDate(saved, 'activityAt');
          log.completedAt = log.isCompleted
              ? _latestProgressDate(saved, 'completedAt')
              : null;
        }
      }
      log.solvedQuestions = log.progressIds.fold<int>(
        0,
        (sum, id) =>
            sum +
            StudyHistoryMetrics.solvedQuestionsForProgressOn(
              questionEvents,
              id,
              log.date,
            ),
      );
    }
  }

  static DateTime? _latestProgressDate(
    List<Map<String, dynamic>> progress,
    String key,
  ) {
    final dates = progress
        .map((item) => item[key])
        .whereType<String>()
        .map(DateTime.tryParse)
        .whereType<DateTime>()
        .toList();
    if (dates.isEmpty) return null;
    dates.sort();
    return dates.last;
  }
}
