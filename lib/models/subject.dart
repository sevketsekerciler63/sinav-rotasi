import 'topic.dart';

class Subject {
  final String? id;
  final bool isCustom;
  final String name;
  final String emoji;
  final String type; // TYT or AYT
  final int totalQuestions;
  final List<Topic> topics;
  final String tip;

  Subject({
    this.id,
    this.isCustom = false,
    required this.name,
    required this.emoji,
    required this.type,
    required this.totalQuestions,
    required this.topics,
    this.tip = '',
  });

  String get storageId => id ?? 'builtin_${type}_${Uri.encodeComponent(name)}';

  int get completedCount => topics.where((t) => t.isCompleted).length;
  double get progress => topics.isEmpty ? 0 : completedCount / topics.length;
  int get remainingDays => topics
      .where((t) => !t.isCompleted)
      .fold(0, (sum, t) => sum + t.estimatedDays);
}
