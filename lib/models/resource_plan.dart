/// Frozen expectations. Titles and estimated minutes remain historical snapshots.
class ResourcePlanBlock {
  final String taskId, title, resourceName, unitLabel;
  final int startUnit, endUnit, estimatedMinutes;
  const ResourcePlanBlock({
    required this.taskId,
    required this.title,
    required this.resourceName,
    required this.unitLabel,
    required this.startUnit,
    required this.endUnit,
    required this.estimatedMinutes,
  });
  int get units => endUnit - startUnit + 1;
  Map<String, dynamic> toJson() => {
    'taskId': taskId,
    'title': title,
    'resourceName': resourceName,
    'unitLabel': unitLabel,
    'startUnit': startUnit,
    'endUnit': endUnit,
    'estimatedMinutes': estimatedMinutes,
  };
  factory ResourcePlanBlock.fromJson(Map<String, dynamic> json) {
    for (final key in ['taskId', 'title', 'resourceName', 'unitLabel']) {
      if (json[key] is! String ||
          (json[key] as String).trim().isEmpty ||
          (json[key] as String).length > 240) {
        throw const FormatException('Plan metni geçersiz.');
      }
    }
    for (final key in ['startUnit', 'endUnit', 'estimatedMinutes']) {
      if (json[key] is! int || json[key] < 1 || json[key] > 1000000) {
        throw const FormatException('Plan aralığı/süresi geçersiz.');
      }
    }
    if (json['endUnit'] < json['startUnit']) {
      throw const FormatException('Plan aralığı ters.');
    }
    return ResourcePlanBlock(
      taskId: json['taskId'],
      title: json['title'],
      resourceName: json['resourceName'],
      unitLabel: json['unitLabel'],
      startUnit: json['startUnit'],
      endUnit: json['endUnit'],
      estimatedMinutes: json['estimatedMinutes'],
    );
  }
}

class ResourcePlanDay {
  final String date;
  final int capacityMinutes;
  final List<ResourcePlanBlock> blocks;
  ResourcePlanDay({
    required this.date,
    required this.capacityMinutes,
    required List<ResourcePlanBlock> blocks,
  }) : blocks = List.unmodifiable(blocks);
  int get plannedMinutes =>
      blocks.fold(0, (sum, block) => sum + block.estimatedMinutes);
  Map<String, dynamic> toJson() => {
    'date': date,
    'capacityMinutes': capacityMinutes,
    'blocks': blocks.map((block) => block.toJson()).toList(),
  };
  factory ResourcePlanDay.fromJson(Map<String, dynamic> json) {
    final date = json['date'];
    final capacity = json['capacityMinutes'];
    if (date is! String ||
        !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) ||
        DateTime.tryParse(date) == null ||
        DateTime.parse(date).toIso8601String().substring(0, 10) != date ||
        capacity is! int ||
        capacity < 0 ||
        capacity > 480 ||
        json['blocks'] is! List ||
        (json['blocks'] as List).length > 10000) {
      throw const FormatException('Plan günü geçersiz.');
    }
    final day = ResourcePlanDay(
      date: date,
      capacityMinutes: capacity,
      blocks: [
        for (final raw in json['blocks'])
          ResourcePlanBlock.fromJson(Map<String, dynamic>.from(raw as Map)),
      ],
    );
    if (day.plannedMinutes > capacity) {
      throw const FormatException('Plan günlük kapasiteyi aşıyor.');
    }
    return day;
  }
}

String resourceDayKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
