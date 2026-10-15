class ExamProfile {
  final String id;
  final String name;
  final String examSystem;
  final String examType;
  final DateTime targetDate;
  final String templateId;

  const ExamProfile({
    required this.id,
    required this.name,
    required this.examSystem,
    required this.examType,
    required this.targetDate,
    required this.templateId,
  });

  static const defaultYksId = 'yks-default';

  static DateTime _initialPlanningTarget() {
    final target = DateTime.now().add(const Duration(days: 180));
    return DateTime(target.year, target.month, target.day);
  }

  static final defaultYks = ExamProfile(
    id: defaultYksId,
    name: 'YKS çalışma planım',
    examSystem: 'YKS',
    examType: 'TYT_AYT',
    // This is a personal planning horizon, not an asserted official YKS date.
    targetDate: _initialPlanningTarget(),
    templateId: 'yks_tyt_ayt_2026',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'examSystem': examSystem,
    'examType': examType,
    'targetDate': targetDate.toIso8601String(),
    'templateId': templateId,
  };

  ExamProfile copyWith({String? name, DateTime? targetDate}) => ExamProfile(
    id: id,
    name: name ?? this.name,
    examSystem: examSystem,
    examType: examType,
    targetDate: targetDate ?? this.targetDate,
    templateId: templateId,
  );

  factory ExamProfile.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final examSystem = json['examSystem'];
    final examType = json['examType'];
    final targetDate = json['targetDate'];
    final templateId = json['templateId'];

    if (id is! String || !_validId.hasMatch(id)) {
      throw const FormatException('Profil kimliği geçersiz.');
    }
    if (name is! String || name.trim().isEmpty) {
      throw const FormatException('Profil adı boş olamaz.');
    }
    if (examSystem is! String ||
        examSystem.trim().isEmpty ||
        examType is! String ||
        examType.trim().isEmpty) {
      throw const FormatException('Sınav sistemi veya türü geçersiz.');
    }
    if (targetDate is! String || DateTime.tryParse(targetDate) == null) {
      throw const FormatException('Hedef tarihi geçersiz.');
    }
    if (templateId is! String || templateId.trim().isEmpty) {
      throw const FormatException('Şablon kimliği geçersiz.');
    }
    if (examSystem != 'YKS' ||
        examType != 'TYT_AYT' ||
        templateId != 'yks_tyt_ayt_2026') {
      throw const FormatException(
        'Bu sürüm yalnızca YKS TYT/AYT şablonunu destekliyor.',
      );
    }

    return ExamProfile(
      id: id,
      name: name,
      examSystem: examSystem,
      examType: examType,
      targetDate: DateTime.parse(targetDate),
      templateId: templateId,
    );
  }

  static final RegExp _validId = RegExp(r'^[a-zA-Z0-9_-]+$');
}
