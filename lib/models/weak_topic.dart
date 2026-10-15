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
  });

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
  );
}
