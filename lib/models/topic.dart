class Topic {
  final String id;
  final String name;
  final String description;
  final int questionCount;
  final String difficulty; // 🟢 Kolay, 🟡 Orta, 🔴 Zor
  final String priority; // 🔴 ÇOK KRİTİK, 🟠 ÖNEMLİ, 🟡 ORTA, 🔵 DÜŞÜK
  final int estimatedDays;
  final String? sourceLabel;
  final String? sourceUrl;
  bool isCompleted;
  String notes;
  bool isCustom;

  Topic({
    required this.id,
    required this.name,
    required this.description,
    required this.questionCount,
    required this.difficulty,
    required this.priority,
    required this.estimatedDays,
    this.sourceLabel,
    this.sourceUrl,
    this.isCompleted = false,
    this.notes = '',
    this.isCustom = false,
  });

  double get priorityScore {
    switch (priority) {
      case '🔴 ÇOK KRİTİK':
        return 4.0;
      case '🟠 ÖNEMLİ':
        return 3.0;
      case '🟡 ORTA':
        return 2.0;
      case '🔵 DÜŞÜK':
        return 1.0;
      default:
        return 2.0;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'isCompleted': isCompleted,
    'notes': notes,
  };

  void fromJson(Map<String, dynamic> json) {
    isCompleted = json['isCompleted'] ?? false;
    notes = json['notes'] ?? '';
  }
}
