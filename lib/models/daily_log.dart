class DailyLog {
  final DateTime date;
  final String dayName;
  String tytContent;
  String aytContent;
  final String studyHours;
  String motivationNote;
  bool isCompleted;
  int solvedQuestions;
  String weakTopicNotes;
  DateTime? completedAt;
  DateTime? activityAt;
  List<String> progressIds;
  final List<String> completedTaskSummaries;
  bool isRestDay;
  int completedProgressCount = 0;

  DailyLog({
    required this.date,
    required this.dayName,
    required this.tytContent,
    required this.aytContent,
    required this.studyHours,
    required this.motivationNote,
    this.isCompleted = false,
    this.solvedQuestions = 0,
    this.weakTopicNotes = '',
    this.completedAt,
    this.activityAt,
    this.progressIds = const [],
    this.completedTaskSummaries = const [],
    this.isRestDay = false,
  });

  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  bool get isExamDay =>
      tytContent.contains('DENEME') || tytContent.contains('📘');
  bool get isExamPrepDay =>
      tytContent.contains('SINAV HAZIRLIĞI') || tytContent.contains('SINAV');

  Map<String, dynamic> toJson() => {
    'isCompleted': isCompleted,
    'solvedQuestions': solvedQuestions,
    'weakTopicNotes': weakTopicNotes,
    'completedAt': completedAt?.toIso8601String(),
    'activityAt': activityAt?.toIso8601String(),
  };

  void fromJson(Map<String, dynamic> json) {
    isCompleted = json['isCompleted'] ?? false;
    completedProgressCount = isCompleted ? 1 : 0;
    solvedQuestions = json['solvedQuestions'] ?? 0;
    weakTopicNotes = json['weakTopicNotes'] ?? '';
    completedAt = _readDate(json['completedAt']);
    activityAt = _readDate(json['activityAt']);
  }

  static DateTime? _readDate(dynamic value) =>
      value is String ? DateTime.tryParse(value) : null;
}

String turkishWeekdayName(DateTime date) => const [
  'Pazartesi',
  'Salı',
  'Çarşamba',
  'Perşembe',
  'Cuma',
  'Cumartesi',
  'Pazar',
][date.weekday - 1];
