import 'weak_topic_review_history.dart';

class WeakTopic {
  final String id;
  String date;
  String subject;
  String? subjectId;
  String topic;
  String? topicId;
  String? unlinkedSubjectId, unlinkedTopicId;
  String errorType;
  int errorCount;
  String action;
  bool isStudied;
  bool needsRepeat;
  DateTime? lastReviewedAt;
  DateTime? nextReviewAt;
  int reviewRepetitions;
  int reviewIntervalDays;
  WeakTopicReviewHistory? _reviewHistory;

  WeakTopic({
    required this.id,
    required this.date,
    required this.subject,
    this.subjectId,
    required this.topic,
    this.topicId,
    this.unlinkedSubjectId,
    this.unlinkedTopicId,
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

  WeakTopicReviewHistory get _history =>
      _reviewHistory ??= WeakTopicReviewHistory(
        WeakTopicReviewState(
          isStudied: isStudied,
          needsRepeat: needsRepeat,
          lastReviewedAt: lastReviewedAt,
          nextReviewAt: nextReviewAt,
          repetitions: reviewRepetitions,
          intervalDays: reviewIntervalDays,
        ),
      );

  void _applyReviewHistory() {
    final state = _history.state;
    isStudied = state.isStudied;
    needsRepeat = state.needsRepeat;
    lastReviewedAt = state.lastReviewedAt;
    nextReviewAt = state.nextReviewAt;
    reviewRepetitions = state.repetitions;
    reviewIntervalDays = state.intervalDays;
  }

  bool scheduleNextReview(DateTime now, {String? eventId}) {
    final history = _history;
    final changed = history.record(
      eventId ?? 'manual:${now.microsecondsSinceEpoch}:${history.length}',
      now,
    );
    _applyReviewHistory();
    return changed;
  }

  void setReviewFlags(DateTime now, {bool? isStudied, bool? needsRepeat}) {
    final history = _history;
    history.setFlags(
      'flags:${now.microsecondsSinceEpoch}:${history.length}',
      now,
      isStudied: isStudied,
      needsRepeat: needsRepeat,
    );
    _applyReviewHistory();
  }

  bool undoReview(String eventId) {
    if (_reviewHistory == null || !_reviewHistory!.undo(eventId)) return false;
    _applyReviewHistory();
    return true;
  }

  bool registerLegacyReview(String eventId, DateTime at) {
    final history = _history;
    if (history.contains(eventId)) return false;
    history.record(eventId, at, legacy: true);
    _applyReviewHistory();
    return true;
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
    if (unlinkedSubjectId != null) 'unlinkedSubjectId': unlinkedSubjectId,
    if (unlinkedTopicId != null) 'unlinkedTopicId': unlinkedTopicId,
    'errorType': errorType,
    'errorCount': errorCount,
    'action': action,
    'isStudied': isStudied,
    'needsRepeat': needsRepeat,
    'lastReviewedAt': lastReviewedAt?.toUtc().toIso8601String(),
    'nextReviewAt': nextReviewAt?.toUtc().toIso8601String(),
    'reviewRepetitions': reviewRepetitions,
    'reviewIntervalDays': reviewIntervalDays,
    if (_reviewHistory != null) 'reviewHistory': _reviewHistory!.toJson(),
  };

  factory WeakTopic.fromJson(Map<String, dynamic> json) {
    final topic = WeakTopic(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      subject: json['subject'] ?? '',
      subjectId: json['subjectId'] is String
          ? json['subjectId'] as String
          : null,
      topic: json['topic'] ?? '',
      topicId: json['topicId'] is String ? json['topicId'] as String : null,
      unlinkedSubjectId: json['unlinkedSubjectId'] as String?,
      unlinkedTopicId: json['unlinkedTopicId'] as String?,
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
    final history = json['reviewHistory'];
    if (history != null) {
      if (history is! Map) {
        throw const FormatException('Tekrar geçmişi geçersiz.');
      }
      topic._reviewHistory = WeakTopicReviewHistory.fromJson(
        Map<String, dynamic>.from(history),
      );
      topic._applyReviewHistory();
    }
    return topic;
  }

  static DateTime? _parseDate(Object? value) =>
      value is String ? DateTime.tryParse(value)?.toUtc() : null;

  static int _parseInt(Object? value, {required int maximum}) {
    if (value is! int) return 0;
    return value.clamp(0, maximum).toInt();
  }
}
