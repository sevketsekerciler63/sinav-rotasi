class LegacyDailyActivity {
  final String sourceDateKey;
  final DateTime? date;
  final int solvedQuestions;
  final bool isCompleted;
  final String weakTopicNotes;

  const LegacyDailyActivity({
    required this.sourceDateKey,
    required this.date,
    required this.solvedQuestions,
    required this.isCompleted,
    required this.weakTopicNotes,
  });
}
