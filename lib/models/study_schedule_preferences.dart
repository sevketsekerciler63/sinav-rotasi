class StudySchedulePreferences {
  final List<int> availableWeekdays;
  final int dailyStudyMinutes;

  const StudySchedulePreferences({
    this.availableWeekdays = const [1, 2, 3, 4, 5, 6, 7],
    this.dailyStudyMinutes = 180,
  });

  static const defaults = StudySchedulePreferences();

  Map<String, dynamic> toJson() => {
    'version': 1,
    'availableWeekdays': List<int>.of(availableWeekdays),
    'dailyStudyMinutes': dailyStudyMinutes,
  };

  factory StudySchedulePreferences.fromJson(Map<String, dynamic> json) {
    final version = json['version'];
    final weekdays = json['availableWeekdays'];
    final minutes = json['dailyStudyMinutes'];
    if (version != 1 ||
        weekdays is! List ||
        weekdays.isEmpty ||
        weekdays.any((day) => day is! int || day < 1 || day > 7) ||
        weekdays.toSet().length != weekdays.length ||
        minutes is! int ||
        minutes < 30 ||
        minutes > 480 ||
        minutes % 15 != 0) {
      throw const FormatException('Çalışma planı tercihleri geçersiz.');
    }
    return StudySchedulePreferences(
      availableWeekdays: List<int>.from(weekdays)..sort(),
      dailyStudyMinutes: minutes,
    );
  }

  StudySchedulePreferences copyWith({
    List<int>? availableWeekdays,
    int? dailyStudyMinutes,
  }) => StudySchedulePreferences(
    availableWeekdays: availableWeekdays ?? this.availableWeekdays,
    dailyStudyMinutes: dailyStudyMinutes ?? this.dailyStudyMinutes,
  );
}
