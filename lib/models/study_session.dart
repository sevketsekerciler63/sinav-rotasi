enum StudySessionStatus { completed, skipped, cancelled }

class StudySession {
  final String id;
  final String profileId;
  final String? taskId;
  final String? topicId;
  final DateTime startedAt;
  final DateTime endedAt;
  final int activeSeconds;
  final StudySessionStatus status;

  const StudySession({
    required this.id,
    required this.profileId,
    required this.taskId,
    required this.topicId,
    required this.startedAt,
    required this.endedAt,
    required this.activeSeconds,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'profileId': profileId,
    'taskId': taskId,
    'topicId': topicId,
    'startedAt': startedAt.toIso8601String(),
    'endedAt': endedAt.toIso8601String(),
    'activeSeconds': activeSeconds,
    'status': status.name,
  };

  factory StudySession.fromJson(Map<String, dynamic> json) {
    final statusValue = json['status'];
    final status = StudySessionStatus.values
        .where((value) => value.name == statusValue)
        .firstOrNull;
    final session = StudySession(
      id: json['id'] as String,
      profileId: json['profileId'] as String,
      taskId: json['taskId'] as String?,
      topicId: json['topicId'] as String?,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: DateTime.parse(json['endedAt'] as String),
      activeSeconds: json['activeSeconds'] as int,
      status:
          status ??
          (throw const FormatException('Odak oturumu durumu geçersiz.')),
    );
    if (session.id.trim().isEmpty ||
        session.profileId.trim().isEmpty ||
        session.activeSeconds < 0 ||
        session.endedAt.isBefore(session.startedAt)) {
      throw const FormatException('Odak oturumu geçersiz.');
    }
    return session;
  }

  DateTime get sessionDate =>
      DateTime(startedAt.year, startedAt.month, startedAt.day);
}
