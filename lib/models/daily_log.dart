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
  String? reviewTopicId;
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
    this.reviewTopicId,
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
    'reviewTopicId': reviewTopicId,
  };

  void fromJson(Map<String, dynamic> json) {
    final completedValue = json['isCompleted'];
    isCompleted = completedValue is bool ? completedValue : false;
    completedProgressCount = isCompleted ? 1 : 0;
    final questionValue = json['solvedQuestions'];
    final questionCount = questionValue is num && questionValue.isFinite
        ? questionValue.toInt()
        : 0;
    solvedQuestions = questionCount < 0 ? 0 : questionCount;
    final notesValue = json['weakTopicNotes'];
    weakTopicNotes = notesValue is String ? notesValue : '';
    completedAt = _readDate(json['completedAt']);
    activityAt = _readDate(json['activityAt']);
    reviewTopicId = json['reviewTopicId'] is String
        ? json['reviewTopicId'] as String
        : null;
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
