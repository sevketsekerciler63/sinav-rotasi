class WeakTopic {
  final String id;
  String date;
  String subject;
  String? subjectId;
  String topic;
  String? topicId;
  String errorType;
  int errorCount;
  String action;
  bool isStudied;
  bool needsRepeat;
  DateTime? lastReviewedAt;
  DateTime? nextReviewAt;
  int reviewRepetitions;
  int reviewIntervalDays;

  WeakTopic({
    required this.id,
    required this.date,
    required this.subject,
    this.subjectId,
    required this.topic,
    this.topicId,
    required this.errorType,
    required this.errorCount,
    required this.action,
    this.isStudied = false,
    this.needsRepeat = false,
    this.lastReviewedAt,
    this.nextReviewAt,
    int reviewRepetitions = 0,
    int reviewIntervalDays = 0,
  }) : reviewRepetitions = reviewRepetitions < 0
           ? 0
           : reviewRepetitions > 10000
           ? 10000
           : reviewRepetitions,
       reviewIntervalDays = reviewIntervalDays < 0
           ? 0
           : reviewIntervalDays > 30
           ? 30
           : reviewIntervalDays;

  bool isReviewDueOn(DateTime date) {
    final next = nextReviewAt?.toLocal();
    if (next == null) return false;
    final reviewDay = DateTime(next.year, next.month, next.day);
    final targetDay = DateTime(date.year, date.month, date.day);
    return !reviewDay.isAfter(targetDay);
  }

  void scheduleNextReview(DateTime now) {
    final nextInterval = switch (reviewRepetitions) {
      0 => 1,
      1 => 3,
      _ => (reviewIntervalDays * 2).clamp(1, 30).toInt(),
    };
    final reviewedAt = now.toUtc();
    reviewRepetitions++;
    reviewIntervalDays = nextInterval;
    lastReviewedAt = reviewedAt;
    nextReviewAt = reviewedAt.add(Duration(days: nextInterval));
  }

  bool migrateLegacyReviewToDue(DateTime now) {
    if (!isStudied || nextReviewAt != null) return false;
    nextReviewAt = now.toUtc();
    return true;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'subject': subject,
    'subjectId': subjectId,
    'topic': topic,
    'topicId': topicId,
    'errorType': errorType,
    'errorCount': errorCount,
    'action': action,
    'isStudied': isStudied,
    'needsRepeat': needsRepeat,
    'lastReviewedAt': lastReviewedAt?.toUtc().toIso8601String(),
    'nextReviewAt': nextReviewAt?.toUtc().toIso8601String(),
    'reviewRepetitions': reviewRepetitions,
    'reviewIntervalDays': reviewIntervalDays,
  };

  factory WeakTopic.fromJson(Map<String, dynamic> json) => WeakTopic(
    id: json['id'] ?? '',
    date: json['date'] ?? '',
    subject: json['subject'] ?? '',
    subjectId: json['subjectId'] is String ? json['subjectId'] as String : null,
    topic: json['topic'] ?? '',
    topicId: json['topicId'] is String ? json['topicId'] as String : null,
    errorType: json['errorType'] ?? '',
    errorCount: json['errorCount'] ?? 0,
    action: json['action'] ?? '',
    isStudied: json['isStudied'] ?? false,
    needsRepeat: json['needsRepeat'] ?? false,
    lastReviewedAt: _parseDate(json['lastReviewedAt']),
    nextReviewAt: _parseDate(json['nextReviewAt']),
    reviewRepetitions: _parseInt(json['reviewRepetitions'], maximum: 10000),
    reviewIntervalDays: _parseInt(json['reviewIntervalDays'], maximum: 30),
  );

  static DateTime? _parseDate(Object? value) =>
      value is String ? DateTime.tryParse(value)?.toUtc() : null;

  static int _parseInt(Object? value, {required int maximum}) {
    if (value is! int) return 0;
    return value.clamp(0, maximum).toInt();
  }
}
