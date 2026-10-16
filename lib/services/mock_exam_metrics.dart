import '../models/mock_exam.dart';
import '../models/net_score.dart';
import '../models/subject.dart';

/// Shared validation rules for mock exam score updates.
class MockExamMetrics {
  const MockExamMetrics._();

  static int completedCount(Iterable<MockExam> exams) =>
      exams.where((exam) => exam.isCompleted).length;

  static MockExam? nextUpcoming(
    Iterable<MockExam> exams, {
    required DateTime now,
  }) {
    final today = DateTime(now.year, now.month, now.day);
    for (final exam in exams) {
      final examDate = DateTime(exam.date.year, exam.date.month, exam.date.day);
      if (!exam.isCompleted && !examDate.isBefore(today)) return exam;
    }
    return null;
  }

  static bool areNetUpdatesValid({
    required Map<String, double> nets,
    required Iterable<Subject> subjects,
  }) {
    final normalized = <String, double>{};
    for (final entry in nets.entries) {
      if (!NetScore.isStorable(entry.value)) return false;
      normalized[MockExam.normalizeNetKey(entry.key)] = entry.value;
    }
    for (final subject in subjects) {
      final key = MockExam.netKeyForSubject(subject.type, subject.name);
      final value = normalized[key];
      if (value != null && !NetScore.isValid(value, subject.totalQuestions)) {
        return false;
      }
    }
    return true;
  }
}
