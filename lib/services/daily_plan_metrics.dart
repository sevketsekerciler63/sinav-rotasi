import '../models/daily_log.dart';

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
}
