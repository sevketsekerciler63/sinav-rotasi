/// The baseline preserves legacy repetition state; subsequent events make
/// completion idempotent and allow undo without discarding later actions.
class WeakTopicReviewState {
  final bool isStudied;
  final bool needsRepeat;
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewAt;
  final int repetitions;
  final int intervalDays;

  const WeakTopicReviewState({
    required this.isStudied,
    required this.needsRepeat,
    required this.lastReviewedAt,
    required this.nextReviewAt,
    required this.repetitions,
    required this.intervalDays,
  });

  Map<String, dynamic> toJson() => {
    'isStudied': isStudied,
    'needsRepeat': needsRepeat,
    'lastReviewedAt': lastReviewedAt?.toUtc().toIso8601String(),
    'nextReviewAt': nextReviewAt?.toUtc().toIso8601String(),
    'repetitions': repetitions,
    'intervalDays': intervalDays,
  };

  factory WeakTopicReviewState.fromJson(Map<String, dynamic> json) {
    DateTime? date(String field) {
      if (json[field] == null) return null;
      if (json[field] is! String || DateTime.tryParse(json[field]) == null) {
        throw const FormatException('Tekrar geçmişi tarihi geçersiz.');
      }
      return DateTime.parse(json[field]).toUtc();
    }

    if (json['isStudied'] is! bool ||
        json['needsRepeat'] is! bool ||
        json['repetitions'] is! int ||
        json['repetitions'] < 0 ||
        json['repetitions'] > 10000 ||
        json['intervalDays'] is! int ||
        json['intervalDays'] < 0 ||
        json['intervalDays'] > 30) {
      throw const FormatException('Tekrar geçmişi başlangıç durumu geçersiz.');
    }
    return WeakTopicReviewState(
      isStudied: json['isStudied'],
      needsRepeat: json['needsRepeat'],
      lastReviewedAt: date('lastReviewedAt'),
      nextReviewAt: date('nextReviewAt'),
      repetitions: json['repetitions'],
      intervalDays: json['intervalDays'],
    );
  }
}

class WeakTopicReviewHistory {
  final WeakTopicReviewState baseline;
  final List<Map<String, dynamic>> _events;

  WeakTopicReviewHistory(this.baseline) : _events = [];
  WeakTopicReviewHistory._(this.baseline, this._events);

  int get length => _events.length;
  bool contains(String id) => _events.any((event) => event['id'] == id);

  bool record(String id, DateTime at, {bool legacy = false}) {
    final existing = _events.where((event) => event['id'] == id).firstOrNull;
    if (existing != null) {
      if (existing['kind'] == 'flags') {
        throw StateError(
          'Tekrar olayı kimliği farklı bir işlemde kullanılıyor.',
        );
      }
      if (existing['active'] == true) return false;
      existing['active'] = true;
      return true;
    }
    _add({
      'id': id,
      'at': at.toUtc().toIso8601String(),
      'active': true,
      'kind': legacy ? 'legacy' : 'review',
    });
    return true;
  }

  void setFlags(String id, DateTime at, {bool? isStudied, bool? needsRepeat}) {
    if (contains(id)) throw StateError('Tekrar olayı kimliği yineleniyor.');
    _add({
      'id': id,
      'at': at.toUtc().toIso8601String(),
      'active': true,
      'kind': 'flags',
      'isStudied': isStudied,
      'needsRepeat': needsRepeat,
    });
  }

  void _add(Map<String, dynamic> event) {
    if (event['id'] is! String ||
        (event['id'] as String).trim().isEmpty ||
        _events.length >= 10000) {
      throw StateError('Tekrar geçmişi kimliği veya kayıt sınırı geçersiz.');
    }
    _events.add(event);
  }

  bool undo(String id) {
    final event = _events.where((event) => event['id'] == id).firstOrNull;
    if (event == null || event['active'] != true) return false;
    event['active'] = false;
    return true;
  }

  WeakTopicReviewState get state {
    var result = baseline;
    for (final event in _events) {
      if (event['active'] != true || event['kind'] == 'legacy') continue;
      if (event['kind'] == 'flags') {
        result = WeakTopicReviewState(
          isStudied: event['isStudied'] as bool? ?? result.isStudied,
          needsRepeat: event['needsRepeat'] as bool? ?? result.needsRepeat,
          lastReviewedAt: result.lastReviewedAt,
          nextReviewAt: result.nextReviewAt,
          repetitions: result.repetitions,
          intervalDays: result.intervalDays,
        );
        continue;
      }
      final interval = switch (result.repetitions) {
        0 => 1,
        1 => 3,
        _ => (result.intervalDays * 2).clamp(1, 30).toInt(),
      };
      final at = DateTime.parse(event['at']).toUtc();
      result = WeakTopicReviewState(
        isStudied: true,
        needsRepeat: false,
        lastReviewedAt: at,
        nextReviewAt: at.add(Duration(days: interval)),
        repetitions: (result.repetitions + 1).clamp(0, 10000).toInt(),
        intervalDays: interval,
      );
    }
    return result;
  }

  Map<String, dynamic> toJson() => {
    'version': 1,
    'baseline': baseline.toJson(),
    'events': _events.map((event) => Map<String, dynamic>.of(event)).toList(),
  };

  factory WeakTopicReviewHistory.fromJson(Map<String, dynamic> json) {
    if (json['version'] != 1 ||
        json['baseline'] is! Map ||
        json['events'] is! List ||
        (json['events'] as List).length > 10000) {
      throw const FormatException('Tekrar geçmişi biçimi geçersiz.');
    }
    final ids = <String>{};
    final events = <Map<String, dynamic>>[];
    for (final raw in json['events']) {
      if (raw is! Map) throw const FormatException('Tekrar olayı geçersiz.');
      final event = Map<String, dynamic>.from(raw);
      if (event['id'] is! String ||
          (event['id'] as String).trim().isEmpty ||
          !ids.add(event['id']) ||
          event['at'] is! String ||
          DateTime.tryParse(event['at']) == null ||
          event['active'] is! bool ||
          !['review', 'legacy', 'flags'].contains(event['kind']) ||
          (event['isStudied'] != null && event['isStudied'] is! bool) ||
          (event['needsRepeat'] != null && event['needsRepeat'] is! bool)) {
        throw const FormatException('Tekrar olayı alanları geçersiz.');
      }
      events.add(event);
    }
    return WeakTopicReviewHistory._(
      WeakTopicReviewState.fromJson(
        Map<String, dynamic>.from(json['baseline']),
      ),
      events,
    );
  }
}
