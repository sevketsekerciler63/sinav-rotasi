import '../data/achievements_data.dart';
import '../models/mock_exam.dart';
import '../models/subject.dart';
import '../models/weak_topic.dart';

/// Applies achievement thresholds to the current profile's progress.
class AchievementProgressMetrics {
  const AchievementProgressMetrics._();

  static int totalTopicCount(Iterable<Subject> subjects) =>
      subjects.fold(0, (sum, subject) => sum + subject.topics.length);

  static int completedTopicCount(Iterable<Subject> subjects) =>
      subjects.fold(0, (sum, subject) => sum + subject.completedCount);

  static double topicProgress(Iterable<Subject> subjects) {
    final total = totalTopicCount(subjects);
    return total == 0 ? 0 : completedTopicCount(subjects) / total;
  }

  static int unlockedCount(Iterable<Achievement> achievements) =>
      achievements.where((achievement) => achievement.isUnlocked).length;

  static String? unlockEligibleAchievements({
    required List<Achievement> achievements,
    required List<Subject> subjects,
    required List<MockExam> mockExams,
    required List<WeakTopic> weakTopics,
    required int streak,
    required int completedTopics,
    required int totalTopics,
    required int completedDays,
    required DateTime now,
  }) {
    final dateStr = DateTime(now.year, now.month, now.day).toIso8601String();
    var anyNew = false;
    String? lastUnlockedTitle;

    void unlock(String id) {
      final achievement = achievements.firstWhere((item) => item.id == id);
      if (!achievement.isUnlocked) {
        achievement.isUnlocked = true;
        achievement.unlockedDate = dateStr;
        lastUnlockedTitle = achievement.title;
        anyNew = true;
      }
    }

    if (streak >= 3) unlock('streak_3');
    if (streak >= 7) unlock('streak_7');
    if (streak >= 14) unlock('streak_14');
    if (streak >= 30) unlock('streak_30');
    if (streak >= 60) unlock('streak_60');

    if (completedTopics >= 1) unlock('topic_1');
    if (completedTopics >= 10) unlock('topic_10');
    if (completedTopics >= 25) unlock('topic_25');
    if (completedTopics >= 50) unlock('topic_50');
    if (completedTopics >= 75) unlock('topic_75');
    if (completedTopics >= totalTopics && totalTopics > 0) {
      unlock('topic_all');
    }

    final tytMat = subjects.firstWhere(
      (subject) => subject.name == 'TYT Matematik',
    );
    if (tytMat.progress >= 0.5) unlock('tyt_mat_50');
    if (tytMat.progress >= 1.0) unlock('tyt_mat_100');

    final tytTur = subjects.firstWhere(
      (subject) => subject.name == 'TYT Türkçe',
    );
    if (tytTur.progress >= 0.5) unlock('tyt_tur_50');
    if (tytTur.progress >= 1.0) unlock('tyt_tur_100');

    final officialTytSubjects = subjects
        .where((subject) => subject.type == 'TYT' && !subject.isCustom)
        .toList();
    final officialAytSubjects = subjects
        .where((subject) => subject.type == 'AYT' && !subject.isCustom)
        .toList();
    final allTytDone = officialTytSubjects.every(
      (subject) => subject.progress >= 1.0,
    );
    if (allTytDone && officialTytSubjects.isNotEmpty) unlock('all_tyt');

    final allAytDone = officialAytSubjects.every(
      (subject) => subject.progress >= 1.0,
    );
    if (allAytDone && officialAytSubjects.isNotEmpty) unlock('all_ayt');

    final completedExams = mockExams.where((exam) => exam.isCompleted).length;
    if (completedExams >= 1) unlock('exam_1');
    if (completedExams >= 5) unlock('exam_5');
    if (completedExams >= 10) unlock('exam_10');
    if (mockExams.isNotEmpty && completedExams >= mockExams.length) {
      unlock('exam_all');
    }

    for (final exam in mockExams.where((item) => item.isCompleted)) {
      final officialTyt = subjects.where(
        (subject) => subject.type == 'TYT' && !subject.isCustom,
      );
      if (exam.hasScoresForSubjects(officialTyt)) {
        final officialTytNet = exam.totalForSubjects(officialTyt);
        if (officialTytNet >= 40) unlock('tyt_40');
        if (officialTytNet >= 50) unlock('tyt_50');
        if (officialTytNet >= 60) unlock('tyt_60');
      }
    }

    if (completedDays >= 1) unlock('day_first');
    if (completedDays >= 7) unlock('day_7');
    if (completedDays >= 30) unlock('day_30');
    if (completedDays >= 60) unlock('day_60');
    if (completedDays >= 90) unlock('day_90');

    if (weakTopics.where((topic) => topic.isStudied).length >= 5) {
      unlock('weak_5');
    }

    return anyNew ? lastUnlockedTitle : null;
  }
}
