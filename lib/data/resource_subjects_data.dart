import '../models/subject.dart';
import '../models/exam_attempt.dart';

/// Resource bindings do not pretend to include a complete curriculum inventory.
List<Subject> getResourceSubjects(Iterable<Subject> curriculum) {
  final result = List<Subject>.of(curriculum);
  for (final test in [
    ...YksAttemptCatalog.tests('AYT', 'ea'),
    ...YksAttemptCatalog.tests('AYT', 'soz'),
  ]) {
    final name = 'AYT ${test.label}';
    if (result.any(
      (subject) =>
          !subject.isCustom && subject.type == 'AYT' && subject.name == name,
    )) {
      continue;
    }
    result.add(
      Subject(
        id: 'yks_course_${test.id}',
        name: name,
        emoji: '📙',
        type: 'AYT',
        totalQuestions: test.questions,
        topics: [],
      ),
    );
  }
  for (final entry in const {
    'english': 'İngilizce',
    'german': 'Almanca',
    'arabic': 'Arapça',
    'french': 'Fransızca',
    'russian': 'Rusça',
  }.entries) {
    result.add(
      Subject(
        id: 'yks_course_ydt_${entry.key}',
        name: 'YDT ${entry.value}',
        emoji: '📗',
        type: 'YDT',
        totalQuestions: 80,
        topics: [],
      ),
    );
  }
  return result;
}
