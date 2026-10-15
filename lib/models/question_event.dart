class QuestionEvent {
  final String id;
  final String profileId;
  final String? progressId;
  final String? topicId;
  final DateTime? occurredAt;
  final int questionCount;
  final bool isLegacyUnattributed;

  const QuestionEvent({
    required this.id,
    required this.profileId,
    required this.progressId,
    required this.topicId,
    required this.occurredAt,
    required this.questionCount,
    this.isLegacyUnattributed = false,
  });

  QuestionEvent withQuestionCount(int count) => QuestionEvent(
    id: id,
    profileId: profileId,
    progressId: progressId,
    topicId: topicId,
    occurredAt: occurredAt,
    questionCount: count,
    isLegacyUnattributed: isLegacyUnattributed,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'profileId': profileId,
    'progressId': progressId,
    'topicId': topicId,
    'occurredAt': occurredAt?.toIso8601String(),
    'questionCount': questionCount,
    'isLegacyUnattributed': isLegacyUnattributed,
  };

  factory QuestionEvent.fromJson(Map<String, dynamic> json) {
    final occurredAtValue = json['occurredAt'];
    final occurredAt = occurredAtValue == null
        ? null
        : DateTime.tryParse(occurredAtValue as String);
    if (occurredAtValue != null && occurredAt == null) {
      throw const FormatException('Soru kaydının tarihi geçersiz.');
    }
    final event = QuestionEvent(
      id: json['id'] as String,
      profileId: json['profileId'] as String,
      progressId: json['progressId'] as String?,
      topicId: json['topicId'] as String?,
      occurredAt: occurredAt,
      questionCount: json['questionCount'] as int,
      isLegacyUnattributed: json['isLegacyUnattributed'] as bool? ?? false,
    );
    if (event.id.trim().isEmpty ||
        event.profileId.trim().isEmpty ||
        event.questionCount < 0 ||
        (event.isLegacyUnattributed && event.occurredAt != null) ||
        (!event.isLegacyUnattributed && event.occurredAt == null)) {
      throw const FormatException('Soru kaydı geçersiz.');
    }
    return event;
  }
}
