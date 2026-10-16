class Goal {
  final String id;
  final String title;
  final String subject;
  final int targetCount; // target number (questions, topics, etc.)
  int currentCount;
  final String unit; // 'soru', 'konu', 'saat', 'deneme'
  final String deadline; // one of the supported goal periods
  final DateTime createdAt;
  final DateTime? dueDate;

  static const int maxTargetCount = 1000000;
  static const String quarantinedRecordMarker = '__srGoalRecoveryVersion';
  static const int quarantinedRecordVersion = 1;
  static const Set<String> supportedUnits = {'soru', 'konu', 'saat', 'deneme'};
  static const Set<String> supportedDeadlines = {
    'bu_hafta',
    'bu_ay',
    'sinava_kadar',
    'ozel', // accepted for backups written by older app versions
  };

  bool get isCompleted => targetCount > 0 && currentCount >= targetCount;
  bool get hasValidTarget => targetCount > 0 && targetCount <= maxTargetCount;

  Goal({
    required this.id,
    required String title,
    required String subject,
    required this.targetCount,
    this.currentCount = 0,
    required this.unit,
    required this.deadline,
    DateTime? createdAt,
    this.dueDate,
  }) : title = title.trim(),
       subject = subject.trim(),
       createdAt = createdAt ?? DateTime.now();

  void validateForCreation() {
    if (id.trim().isEmpty) {
      throw ArgumentError.value(id, 'id', 'Hedef kimliği boş olamaz.');
    }
    if (title.isEmpty || title.length > 120) {
      throw ArgumentError.value(
        title,
        'title',
        'Hedef başlığı 1–120 karakter olmalıdır.',
      );
    }
    if (!hasValidTarget) {
      throw ArgumentError.value(
        targetCount,
        'targetCount',
        'Hedef 1 ile $maxTargetCount arasında olmalıdır.',
      );
    }
    if (currentCount < 0 || currentCount > targetCount * 2) {
      throw ArgumentError.value(
        currentCount,
        'currentCount',
        'İlerleme 0 ile hedefin iki katı arasında olmalıdır.',
      );
    }
    if (!supportedUnits.contains(unit)) {
      throw ArgumentError.value(unit, 'unit', 'Hedef birimi desteklenmiyor.');
    }
    if (!supportedDeadlines.contains(deadline)) {
      throw ArgumentError.value(
        deadline,
        'deadline',
        'Hedef süresi desteklenmiyor.',
      );
    }
    if (dueDate == null) {
      throw ArgumentError.value(
        dueDate,
        'dueDate',
        'Hedef tarihi seçilmelidir.',
      );
    }
    final createdDay = DateTime(createdAt.year, createdAt.month, createdAt.day);
    final dueDay = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    if (dueDay.isBefore(createdDay)) {
      throw ArgumentError.value(
        dueDate,
        'dueDate',
        'Hedef tarihi oluşturulma gününden önce olamaz.',
      );
    }
  }

  /// Validates a goal using the same permissive date rules as stored backups.
  /// Legacy goals may have no due date, but malformed values must not be
  /// written back as active goal records.
  void validateForPersistence() {
    if (id.trim().isEmpty ||
        title.isEmpty ||
        title.length > 120 ||
        subject.trim().isEmpty) {
      throw const FormatException('Hedef kimliği veya metin alanı geçersiz.');
    }
    if (!hasValidTarget) {
      throw const FormatException('Hedef sayısı geçersiz.');
    }
    if (currentCount < 0 || currentCount > targetCount * 2) {
      throw const FormatException('Hedef ilerlemesi geçersiz.');
    }
    if (!supportedUnits.contains(unit) ||
        !supportedDeadlines.contains(deadline)) {
      throw const FormatException('Hedef birimi veya süresi geçersiz.');
    }
    if (dueDate != null) {
      final createdDay = DateTime(
        createdAt.year,
        createdAt.month,
        createdAt.day,
      );
      final dueDay = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
      if (dueDay.isBefore(createdDay)) {
        throw const FormatException('Hedef tarihi oluşturulma gününden önce.');
      }
    }
  }

  static Map<String, dynamic> quarantineRecord(Object? rawValue) => {
    quarantinedRecordMarker: quarantinedRecordVersion,
    'raw': rawValue,
  };

  static bool isQuarantinedRecord(Object? value) =>
      value is Map &&
      value.length == 2 &&
      value[quarantinedRecordMarker] == quarantinedRecordVersion &&
      value.containsKey('raw');

  static Object? quarantinedRawValue(Object? value) =>
      isQuarantinedRecord(value) ? (value as Map)['raw'] : value;

  double get progress =>
      hasValidTarget ? (currentCount / targetCount).clamp(0.0, 1.0) : 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'subject': subject,
    'targetCount': targetCount,
    'currentCount': currentCount,
    'unit': unit,
    'deadline': deadline,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'isCompleted': isCompleted,
  };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: _requiredString(json, 'id'),
    title: _requiredString(json, 'title'),
    subject: _requiredString(json, 'subject'),
    targetCount: _requiredInt(json, 'targetCount'),
    currentCount: json['currentCount'] == null
        ? 0
        : _requiredInt(json, 'currentCount'),
    unit: _requiredString(json, 'unit'),
    deadline: _requiredString(json, 'deadline'),
    createdAt: json['createdAt'] == null
        ? DateTime.now()
        : _requiredDate(json, 'createdAt'),
    dueDate: json['dueDate'] == null ? null : _requiredDate(json, 'dueDate'),
  );

  static String _requiredString(Map<String, dynamic> json, String field) {
    final value = json[field];
    if (value is! String) {
      throw FormatException('Hedef kaydındaki $field alanı geçersiz.');
    }
    return value;
  }

  static int _requiredInt(Map<String, dynamic> json, String field) {
    final value = json[field];
    if (value is! int) {
      throw FormatException('Hedef kaydındaki $field alanı geçersiz.');
    }
    return value;
  }

  static DateTime _requiredDate(Map<String, dynamic> json, String field) {
    final value = json[field];
    final date = value is String ? DateTime.tryParse(value) : null;
    if (date == null) {
      throw FormatException('Hedef kaydındaki $field alanı geçersiz.');
    }
    return date;
  }
}
