import '../models/daily_log.dart';
import '../models/question_event.dart';
import '../models/subject.dart';
import '../models/weak_topic.dart';
import 'study_history_metrics.dart';

/// Shared selection and completion rules for the daily plan.
class DailyPlanMetrics {
  const DailyPlanMetrics._();

  static List<WeakTopic> prioritizedWeakTopicsFor(
    Iterable<WeakTopic> weakTopics,
    DateTime date,
  ) {
    final targetDay = DateTime(date.year, date.month, date.day);
    final topics = weakTopics.where((topic) {
      final addedOn = _weakTopicDate(topic.date);
      if (addedOn != null &&
          DateTime(
            addedOn.year,
            addedOn.month,
            addedOn.day,
          ).isAfter(targetDay)) {
        return false;
      }
      return !topic.isStudied || topic.needsRepeat || topic.isReviewDueOn(date);
    }).toList();
    topics.sort((a, b) {
      final repeatOrder = (b.needsRepeat ? 1 : 0).compareTo(
        a.needsRepeat ? 1 : 0,
      );
      if (repeatOrder != 0) return repeatOrder;
      final aDue = a.isReviewDueOn(date);
      final bDue = b.isReviewDueOn(date);
      if (aDue != bDue) return bDue ? 1 : -1;
      final errorOrder = b.errorCount.compareTo(a.errorCount);
      if (errorOrder != 0) return errorOrder;
      return (_weakTopicDate(b.date) ?? DateTime(0)).compareTo(
        _weakTopicDate(a.date) ?? DateTime(0),
      );
    });
    return topics;
  }

  static void applyWeakTopicReviews({
    required List<DailyLog> logs,
    required List<WeakTopic> weakTopics,
    required List<Subject> subjects,
  }) {
    final reviewDays = logs
        .where(
          (log) =>
              log.progressIds.length == 1 &&
              log.progressIds.single.startsWith('review_'),
        )
        .toList();
    for (var index = 0; index < reviewDays.length; index++) {
      final log = reviewDays[index];
      final priorityTopics = prioritizedWeakTopicsFor(weakTopics, log.date);
      WeakTopic? topic;
      final assignedTopicId = log.reviewTopicId;
      if (assignedTopicId != null) {
        for (final candidate in weakTopics) {
          if (candidate.id == assignedTopicId) {
            topic = candidate;
            break;
          }
        }
      }
      if (topic != null &&
          !log.isCompleted &&
          !priorityTopics.any((candidate) => candidate.id == topic!.id)) {
        topic = null;
      }
      topic ??= log.isCompleted || priorityTopics.isEmpty
          ? null
          : priorityTopics[index % priorityTopics.length];
      final selectedTopic = topic;
      if (selectedTopic == null) {
        log.reviewTopicId = null;
        log.tytContent =
            'Önceki konulardan kısa tekrar yap; takıldığın başlıkları not et.';
        log.aytContent =
            'Dersler veya Zayıf Konular bölümünden bir eksik seçip çalış.';
        log.motivationNote =
            'Sınava kadar kalan dönemi tekrar ve eksik kapatmaya ayır.';
        continue;
      }
      log.reviewTopicId = selectedTopic.id;
      final subject = subjects.where(
        (item) =>
            item.storageId == selectedTopic.subjectId ||
            item.name == selectedTopic.subject,
      );
      final isAyt = subject.isNotEmpty
          ? subject.first.type == 'AYT'
          : selectedTopic.subject.toUpperCase().startsWith('AYT');
      final content =
          'Öncelikli tekrar: ${selectedTopic.topic} · ${selectedTopic.errorType}. ${selectedTopic.action}';
      if (isAyt) {
        log.tytContent = 'Kısa paragraf veya temel matematik tekrarı yap.';
        log.aytContent = '${selectedTopic.subject}: $content';
      } else {
        log.tytContent = '${selectedTopic.subject}: $content';
        log.aytContent = 'Son işlediğin konudan kısa tekrar yap.';
      }
      log.motivationNote =
          'Deneme ve hata kayıtlarına göre ${selectedTopic.subject} önceliklendirildi.';
    }
  }

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

  static void saveLogProgress({
    required Map<String, dynamic> planEntries,
    required DailyLog changedLog,
    bool? completedOverride,
  }) {
    final ids = changedLog.progressIds;
    if (ids.isEmpty || changedLog.isRestDay) return;
    final each = changedLog.solvedQuestions ~/ ids.length;
    final remainder = changedLog.solvedQuestions % ids.length;
    for (var index = 0; index < ids.length; index++) {
      final id = ids[index];
      final previous = planEntries[id] is Map
          ? Map<String, dynamic>.from(planEntries[id] as Map)
          : <String, dynamic>{};
      previous['solvedQuestions'] = each + (index < remainder ? 1 : 0);
      previous['weakTopicNotes'] = index == 0 ? changedLog.weakTopicNotes : '';
      previous['activityAt'] = changedLog.activityAt?.toIso8601String();
      if (changedLog.reviewTopicId == null) {
        previous.remove('reviewTopicId');
      } else {
        previous['reviewTopicId'] = changedLog.reviewTopicId;
      }
      if (completedOverride != null) {
        previous['isCompleted'] = completedOverride;
        previous['completedAt'] = completedOverride
            ? changedLog.completedAt?.toIso8601String()
            : null;
      }
      planEntries[id] = previous;
    }
  }

  static void setSolvedQuestionsForLog({
    required DailyLog log,
    required List<QuestionEvent> questionEvents,
    required String profileId,
    required int targetCount,
    required String Function() nextEventId,
  }) {
    final normalizedCount = targetCount < 0 ? 0 : targetCount;
    final ids = log.progressIds;
    final each = ids.isEmpty ? 0 : normalizedCount ~/ ids.length;
    final remainder = ids.isEmpty ? 0 : normalizedCount % ids.length;
    for (var index = 0; index < ids.length; index++) {
      StudyHistoryMetrics.setSolvedQuestionsForProgressOn(
        events: questionEvents,
        profileId: profileId,
        progressId: ids[index],
        targetCount: each + (index < remainder ? 1 : 0),
        studyDate: log.date,
        nextEventId: nextEventId,
      );
    }
    log.solvedQuestions = normalizedCount;
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

  static DateTime? _weakTopicDate(String value) {
    final isoDate = DateTime.tryParse(value);
    if (isoDate != null) return isoDate;
    final parts = value.split('.');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }
}
