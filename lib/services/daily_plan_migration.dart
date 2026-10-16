import 'dart:convert';

import '../models/daily_log.dart';

class DailyPlanProgressSnapshot {
  final Map<String, dynamic> entries;
  final Map<String, dynamic> history;

  const DailyPlanProgressSnapshot({
    required this.entries,
    required this.history,
  });
}

/// Restores current and date-keyed legacy daily plan records.
class DailyPlanMigration {
  const DailyPlanMigration._();

  static DailyPlanProgressSnapshot restore(
    String logsJson, {
    required List<DailyLog> templateLogs,
  }) {
    final decoded = jsonDecode(logsJson);
    if (decoded is! Map) {
      throw const FormatException('Günlük plan kayıtları geçersiz.');
    }

    if (decoded['schemaVersion'] == 2 && decoded['entries'] is Map) {
      final history = decoded['history'];
      return DailyPlanProgressSnapshot(
        entries: Map<String, dynamic>.from(decoded['entries'] as Map),
        history: history is Map ? Map<String, dynamic>.from(history) : {},
      );
    }

    final legacy = Map<String, dynamic>.from(decoded);
    final entries = <String, dynamic>{};

    for (final originalLog in templateLogs) {
      final saved = legacy[originalLog.dateKey];
      if (saved is! Map) continue;

      final progress = Map<String, dynamic>.from(saved);
      final hasActivity =
          progress['isCompleted'] == true ||
          (progress['solvedQuestions'] is num &&
              (progress['solvedQuestions'] as num) > 0) ||
          (progress['weakTopicNotes'] is String &&
              (progress['weakTopicNotes'] as String).isNotEmpty);
      if (progress['completedAt'] == null && progress['isCompleted'] == true) {
        progress['completedAt'] = originalLog.date.toIso8601String();
      }
      if (progress['activityAt'] == null && hasActivity) {
        progress['activityAt'] = originalLog.date.toIso8601String();
      }

      final progressId = originalLog.progressIds.first;
      entries[progressId] = progress;
    }

    // Preserve the full original map, including entries also migrated above.
    return DailyPlanProgressSnapshot(
      entries: entries,
      history: Map<String, dynamic>.of(legacy),
    );
  }
}
