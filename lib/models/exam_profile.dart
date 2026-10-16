class ExamProfile {
  final String id;
  final String name;
  final String examSystem;
  final String examType;
  final String scoreType;
  final String startingLevel;
  final DateTime targetDate;
  final String templateId;
  final int? examYear;
  final String curriculumVersion;
  static const referenceCurriculumVersion = 'yks-reference-2026-v1';
  static const contentScope =
      'Hazır konu rehberi: TYT + AYT SAY (2026 referansı). EA, SÖZ ve YDT için kişisel kaynak ve deneme takibi kullanılabilir; tam konu rehberi henüz yok.';
  String get contentNotice =>
      '$contentScope ${examYear == 2026 ? '' : 'Seçilen sınav yılı için içerik uygunluğu henüz doğrulanmadı.'}';

  const ExamProfile({
    required this.id,
    required this.name,
    required this.examSystem,
    required this.examType,
    required this.scoreType,
    required this.startingLevel,
    required this.targetDate,
    required this.templateId,
    this.examYear,
    this.curriculumVersion = referenceCurriculumVersion,
  });

  static const defaultYksId = 'yks-default';
  static const unspecified = 'unspecified';
  static const scoreTypeLabels = <String, String>{
    unspecified: 'Belirtilmedi',
    'say': 'SAY',
    'ea': 'EA',
    'soz': 'SÖZ',
    'dil': 'DİL',
  };
  static const startingLevelLabels = <String, String>{
    unspecified: 'Belirtilmedi',
    'beginner': 'Başlangıç',
    'basic': 'Temel',
    'intermediate': 'Orta',
    'advanced': 'İleri',
  };

  static DateTime _initialPlanningTarget() {
    final target = DateTime.now().add(const Duration(days: 180));
    return DateTime(target.year, target.month, target.day);
  }

  static final defaultYks = ExamProfile(
    id: defaultYksId,
    name: 'YKS çalışma planım',
    examSystem: 'YKS',
    examType: 'TYT_AYT',
    scoreType: unspecified,
    startingLevel: unspecified,
    // This is a personal planning horizon, not an asserted official YKS date.
    targetDate: _initialPlanningTarget(),
    templateId: 'yks_tyt_ayt_2026',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'examSystem': examSystem,
    'examType': examType,
    'scoreType': scoreType,
    'startingLevel': startingLevel,
    'targetDate': targetDate.toIso8601String(),
    'templateId': templateId,
    'examYear': examYear,
    'curriculumVersion': curriculumVersion,
  };

  ExamProfile copyWith({
    int? examYear,
    bool clearExamYear = false,
    String? name,
    String? scoreType,
    String? startingLevel,
    DateTime? targetDate,
  }) => ExamProfile(
    id: id,
    examYear: clearExamYear ? null : examYear ?? this.examYear,
    curriculumVersion: curriculumVersion,
    name: name ?? this.name,
    examSystem: examSystem,
    examType: examType,
    scoreType: scoreType ?? this.scoreType,
    startingLevel: startingLevel ?? this.startingLevel,
    targetDate: targetDate ?? this.targetDate,
    templateId: templateId,
  );

  factory ExamProfile.fromJson(Map<String, dynamic> json) {
    final examYear = json['examYear'];
    final curriculumVersion =
        json['curriculumVersion'] ?? referenceCurriculumVersion;
    if (examYear != null &&
        (examYear is! int || examYear < 2020 || examYear > 2100)) {
      throw const FormatException('Sınav yılı geçersiz.');
    }
    if (curriculumVersion != referenceCurriculumVersion) {
      throw const FormatException(
        'İçerik sürümü bu uygulamada desteklenmiyor.',
      );
    }
    final id = json['id'];
    final name = json['name'];
    final examSystem = json['examSystem'];
    final examType = json['examType'];
    final rawScoreType = json['scoreType'];
    final rawStartingLevel = json['startingLevel'];
    final scoreType = rawScoreType ?? unspecified;
    final startingLevel = rawStartingLevel ?? unspecified;
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
    if (scoreType is! String || !scoreTypeLabels.containsKey(scoreType)) {
      throw const FormatException('Puan türü geçersiz.');
    }
    if (startingLevel is! String ||
        !startingLevelLabels.containsKey(startingLevel)) {
      throw const FormatException('Başlangıç seviyesi geçersiz.');
    }

    return ExamProfile(
      id: id,
      examYear: examYear as int?,
      curriculumVersion: curriculumVersion as String,
      name: name,
      examSystem: examSystem,
      examType: examType,
      scoreType: scoreType,
      startingLevel: startingLevel,
      targetDate: DateTime.parse(targetDate),
      templateId: templateId,
    );
  }

  static final RegExp _validId = RegExp(r'^[a-zA-Z0-9_-]+$');
}
