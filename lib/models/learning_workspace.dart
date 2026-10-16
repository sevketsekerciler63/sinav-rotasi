enum StudyResourceUnit { page, test, question, video }

extension StudyResourceUnitLabel on StudyResourceUnit {
  String get label => switch (this) {
    StudyResourceUnit.page => 'sayfa',
    StudyResourceUnit.test => 'test',
    StudyResourceUnit.question => 'soru',
    StudyResourceUnit.video => 'video',
  };
}

class StudyResource {
  final String id, name, publisher, subjectId, subjectName, session;
  final StudyResourceUnit unit;
  final int totalUnits, initialCompletedUnits;
  final bool archived;

  const StudyResource({
    required this.id,
    required this.name,
    this.publisher = '',
    required this.subjectId,
    required this.subjectName,
    required this.session,
    required this.unit,
    required this.totalUnits,
    this.initialCompletedUnits = 0,
    this.archived = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'publisher': publisher,
    'subjectId': subjectId,
    'subjectName': subjectName,
    'session': session,
    'unit': unit.name,
    'totalUnits': totalUnits,
    'initialCompletedUnits': initialCompletedUnits,
    'archived': archived,
  };

  factory StudyResource.fromJson(Map<String, dynamic> json) {
    final unit = StudyResourceUnit.values
        .where((unit) => unit.name == json['unit'])
        .firstOrNull;
    final total = _integer(json, 'totalUnits', min: 1, max: 1000000);
    if (unit == null || !['TYT', 'AYT', 'YDT'].contains(json['session'])) {
      throw const FormatException('Kaynak birimi veya oturumu geçersiz.');
    }
    return StudyResource(
      id: _text(json, 'id'),
      name: _text(json, 'name'),
      publisher: _text(json, 'publisher', empty: true),
      subjectId: _text(json, 'subjectId'),
      subjectName: _text(json, 'subjectName'),
      session: json['session'],
      unit: unit,
      totalUnits: total,
      initialCompletedUnits: _integer(
        json,
        'initialCompletedUnits',
        min: 0,
        max: total,
      ),
      archived: _boolean(json, 'archived'),
    );
  }

  StudyResource withArchived(bool value) => StudyResource(
    id: id,
    name: name,
    publisher: publisher,
    subjectId: subjectId,
    subjectName: subjectName,
    session: session,
    unit: unit,
    totalUnits: totalUnits,
    initialCompletedUnits: initialCompletedUnits,
    archived: value,
  );
}

class ResourceTask {
  final String id, resourceId, title;
  final int startUnit, endUnit, estimatedMinutes;
  final String? plannedDate;
  final bool archived;

  const ResourceTask({
    required this.id,
    required this.resourceId,
    required this.title,
    required this.startUnit,
    required this.endUnit,
    required this.estimatedMinutes,
    this.plannedDate,
    this.archived = false,
  });

  int get unitCount => endUnit - startUnit + 1;
  Map<String, dynamic> toJson() => {
    'id': id,
    'resourceId': resourceId,
    'title': title,
    'startUnit': startUnit,
    'endUnit': endUnit,
    'estimatedMinutes': estimatedMinutes,
    'plannedDate': plannedDate,
    'archived': archived,
  };

  factory ResourceTask.fromJson(Map<String, dynamic> json) {
    final start = _integer(json, 'startUnit', min: 1, max: 1000000);
    final end = _integer(json, 'endUnit', min: start, max: 1000000);
    final date = json['plannedDate'];
    if (date != null) {
      if (date is! String ||
          !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) ||
          DateTime.tryParse(date) == null ||
          DateTime.parse(date).toIso8601String().substring(0, 10) != date) {
        throw const FormatException('Görev günü geçersiz.');
      }
    }
    return ResourceTask(
      id: _text(json, 'id'),
      resourceId: _text(json, 'resourceId'),
      title: _text(json, 'title'),
      startUnit: start,
      endUnit: end,
      estimatedMinutes: _integer(json, 'estimatedMinutes', min: 1, max: 100000),
      plannedDate: date,
      archived: _boolean(json, 'archived'),
    );
  }

  ResourceTask withArchived(bool value) => ResourceTask(
    id: id,
    resourceId: resourceId,
    title: title,
    startUnit: startUnit,
    endUnit: endUnit,
    estimatedMinutes: estimatedMinutes,
    plannedDate: plannedDate,
    archived: value,
  );
}

class ResourceProgressEvent {
  final String id, taskId;
  final int startUnit, units;
  final DateTime occurredAt;
  final bool active;

  const ResourceProgressEvent({
    required this.id,
    required this.taskId,
    required this.startUnit,
    required this.units,
    required this.occurredAt,
    this.active = true,
  });

  int get endUnit => startUnit + units - 1;
  Map<String, dynamic> toJson() => {
    'id': id,
    'taskId': taskId,
    'startUnit': startUnit,
    'units': units,
    'occurredAt': occurredAt.toUtc().toIso8601String(),
    'active': active,
  };

  factory ResourceProgressEvent.fromJson(Map<String, dynamic> json) {
    final raw = json['occurredAt'];
    if (raw is! String || DateTime.tryParse(raw) == null) {
      throw const FormatException('Kaynak çalışma tarihi geçersiz.');
    }
    return ResourceProgressEvent(
      id: _text(json, 'id'),
      taskId: _text(json, 'taskId'),
      startUnit: _integer(json, 'startUnit', min: 1, max: 1000000),
      units: _integer(json, 'units', min: 1, max: 1000000),
      occurredAt: DateTime.parse(raw).toUtc(),
      active: _boolean(json, 'active'),
    );
  }

  ResourceProgressEvent withActive(bool value) => ResourceProgressEvent(
    id: id,
    taskId: taskId,
    startUnit: startUnit,
    units: units,
    occurredAt: occurredAt,
    active: value,
  );
}

/// A profile-scoped graph. Every update validates references, ranges and counts
/// before the complete graph is committed in the existing storage transaction.
class LearningWorkspace {
  final String profileId;
  final Map<String, StudyResource> _resources;
  final Map<String, ResourceTask> _tasks;
  final Map<String, ResourceProgressEvent> _events;

  LearningWorkspace.empty(this.profileId)
    : _resources = {},
      _tasks = {},
      _events = {};
  LearningWorkspace._(
    this.profileId,
    this._resources,
    this._tasks,
    this._events,
  );

  List<StudyResource> get resources => List.unmodifiable(_resources.values);
  List<ResourceTask> get tasks => List.unmodifiable(_tasks.values);
  List<ResourceProgressEvent> get events => List.unmodifiable(_events.values);

  int taskProgress(String id) => _events.values
      .where((event) => event.active && event.taskId == id)
      .fold(0, (sum, event) => sum + event.units);

  int resourceProgress(String id) {
    final resource = _resources[id];
    if (resource == null) return 0;
    return resource.initialCompletedUnits +
        _tasks.values
            .where((task) => task.resourceId == id)
            .fold(0, (sum, task) => sum + taskProgress(task.id));
  }

  List<(int, int)> remainingRanges(String taskId) {
    final task = _tasks[taskId];
    if (task == null) return [];
    final events =
        _events.values
            .where((event) => event.active && event.taskId == taskId)
            .toList()
          ..sort((a, b) => a.startUnit.compareTo(b.startUnit));
    final result = <(int, int)>[];
    var start = task.startUnit;
    for (final event in events) {
      if (start < event.startUnit) result.add((start, event.startUnit - 1));
      start = event.endUnit + 1;
    }
    if (start <= task.endUnit) result.add((start, task.endUnit));
    return result;
  }

  LearningWorkspace saveResource(StudyResource resource) {
    final previous = _resources[resource.id];
    if (previous != null &&
        (_tasks.values.any((task) => task.resourceId == resource.id) ||
            previous.initialCompletedUnits > 0) &&
        (previous.unit != resource.unit ||
            previous.subjectId != resource.subjectId ||
            previous.session != resource.session ||
            previous.initialCompletedUnits != resource.initialCompletedUnits)) {
      throw const FormatException(
        'Geçmişi olan kaynağın birimi, dersi ve başlangıç ilerlemesi değiştirilemez.',
      );
    }
    return _checked(
      resources: {
        ..._resources,
        resource.id: StudyResource.fromJson(resource.toJson()),
      },
    );
  }

  LearningWorkspace saveTask(ResourceTask task) {
    final previous = _tasks[task.id];
    final resource = _resources[task.resourceId];
    if (resource != null &&
        resource.archived &&
        (previous == null || (previous.archived && !task.archived))) {
      throw const FormatException('Önce kaynağı arşivden çıkar.');
    }
    if (previous != null &&
        _events.values.any((event) => event.taskId == task.id) &&
        (previous.resourceId != task.resourceId ||
            previous.startUnit != task.startUnit ||
            previous.endUnit != task.endUnit)) {
      throw const FormatException(
        'Çalışma geçmişi olan görevin kaynak/aralığı değiştirilemez. Yeni görev ekle.',
      );
    }
    return _checked(
      tasks: {..._tasks, task.id: ResourceTask.fromJson(task.toJson())},
    );
  }

  LearningWorkspace record(ResourceProgressEvent event) {
    final checked = ResourceProgressEvent.fromJson(event.toJson());
    final existing = _events[event.id];
    if (existing != null) {
      if (existing.taskId != checked.taskId ||
          existing.units != checked.units ||
          existing.startUnit != checked.startUnit ||
          existing.occurredAt != checked.occurredAt) {
        throw const FormatException(
          'Çalışma kimliği başka bir kayıtta kullanılıyor.',
        );
      }
      // A retry must never reactivate a deliberately undone event.
      return this;
    }
    final task = _tasks[event.taskId];
    if (!checked.active ||
        task == null ||
        task.archived ||
        _resources[task.resourceId]!.archived) {
      throw const FormatException('Görev veya kaynak etkin değil.');
    }
    return _checked(events: {..._events, event.id: checked});
  }

  LearningWorkspace undo(String id) {
    final event = _events[id];
    if (event == null) throw const FormatException('Çalışma kaydı bulunamadı.');
    return _checked(events: {..._events, id: event.withActive(false)});
  }

  LearningWorkspace _checked({
    Map<String, StudyResource>? resources,
    Map<String, ResourceTask>? tasks,
    Map<String, ResourceProgressEvent>? events,
  }) {
    final result = LearningWorkspace._(
      profileId,
      resources ?? _resources,
      tasks ?? _tasks,
      events ?? _events,
    );
    result._validate();
    return result;
  }

  void _validate() {
    if (profileId.trim().isEmpty) {
      throw const FormatException('Çalışma profili boş.');
    }
    final ranges = <String, List<(int, int)>>{};
    final byTask = <String, List<ResourceProgressEvent>>{};
    for (final event in _events.values) {
      final task = _tasks[event.taskId];
      if (task == null) {
        throw const FormatException('Çalışma kaydı olmayan bir göreve bağlı.');
      }
      if (event.startUnit < task.startUnit || event.endUnit > task.endUnit) {
        throw const FormatException('Çalışma kaydı görev aralığı dışında.');
      }
      if (event.active) byTask.putIfAbsent(event.taskId, () => []).add(event);
    }
    for (final task in _tasks.values) {
      final resource = _resources[task.resourceId];
      final completed = byTask[task.id] ?? [];
      completed.sort((a, b) => a.startUnit.compareTo(b.startUnit));
      final done = completed.fold<int>(0, (sum, event) => sum + event.units);
      if (resource == null ||
          task.endUnit > resource.totalUnits ||
          task.startUnit <= resource.initialCompletedUnits ||
          done > task.unitCount) {
        throw const FormatException(
          'Görev aralığı, kaynağı veya ilerlemesi geçersiz.',
        );
      }
      for (var i = 0; i < completed.length; i++) {
        final event = completed[i];
        if (event.startUnit < task.startUnit ||
            event.endUnit > task.endUnit ||
            (i > 0 && event.startUnit <= completed[i - 1].endUnit)) {
          throw const FormatException(
            'Çalışılan aralık görev dışında veya yineleniyor.',
          );
        }
      }
      final reserved = ranges.putIfAbsent(task.resourceId, () => []);
      if (task.archived) {
        reserved.addAll(
          completed.map((event) => (event.startUnit, event.endUnit)),
        );
      } else {
        reserved.add((task.startUnit, task.endUnit));
      }
    }
    for (final list in ranges.values) {
      list.sort((a, b) => a.$1.compareTo(b.$1));
      for (var i = 1; i < list.length; i++) {
        if (list[i].$1 <= list[i - 1].$2) {
          throw const FormatException(
            'Aynı kaynak aralığı iki göreve ayrılamaz.',
          );
        }
      }
    }
  }

  Map<String, dynamic> toJson() => {
    'version': 1,
    'profileId': profileId,
    'resources': resources.map((resource) => resource.toJson()).toList(),
    'tasks': tasks.map((task) => task.toJson()).toList(),
    'events': events.map((event) => event.toJson()).toList(),
  };

  factory LearningWorkspace.fromJson(Map<String, dynamic> json) {
    if (json['version'] != 1) {
      throw const FormatException('Çalışma alanı sürümü geçersiz.');
    }
    final result = LearningWorkspace._(
      _text(json, 'profileId'),
      _records(json, 'resources', StudyResource.fromJson, (item) => item.id),
      _records(json, 'tasks', ResourceTask.fromJson, (item) => item.id),
      _records(
        json,
        'events',
        ResourceProgressEvent.fromJson,
        (item) => item.id,
      ),
    );
    result._validate();
    return result;
  }
}

String _text(Map<String, dynamic> json, String field, {bool empty = false}) {
  final value = json[field];
  if (value is! String ||
      (!empty && value.trim().isEmpty) ||
      value.length > 240) {
    throw FormatException('$field metni geçersiz.');
  }
  return value;
}

int _integer(
  Map<String, dynamic> json,
  String field, {
  required int min,
  required int max,
}) {
  final value = json[field];
  if (value is! int || value < min || value > max) {
    throw FormatException('$field sayısı geçersiz.');
  }
  return value;
}

bool _boolean(Map<String, dynamic> json, String field) {
  final value = json[field];
  if (value is! bool) throw FormatException('$field durumu geçersiz.');
  return value;
}

Map<String, T> _records<T>(
  Map<String, dynamic> json,
  String field,
  T Function(Map<String, dynamic>) parse,
  String Function(T) id,
) {
  final raw = json[field];
  if (raw is! List || raw.length > 100000) {
    throw FormatException('$field listesi geçersiz.');
  }
  final result = <String, T>{};
  for (final record in raw) {
    if (record is! Map) throw FormatException('$field kaydı geçersiz.');
    final item = parse(Map<String, dynamic>.from(record));
    if (result.containsKey(id(item))) {
      throw FormatException('$field kimliği yineleniyor.');
    }
    result[id(item)] = item;
  }
  return result;
}
