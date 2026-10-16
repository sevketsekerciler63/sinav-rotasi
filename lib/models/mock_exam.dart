import 'daily_log.dart';
import 'subject.dart';

class MockExam {
  final String id;
  DateTime date;
  String dayName;
  final String type;
  final String scope;
  final String duration;
  final String targetNet;
  final String analysisMethod;
  bool isCompleted;
  Map<String, double> nets; // ders -> net
  DateTime? completedAt;
  DateTime? updatedAt;

  DateTime get displayDate => completedAt ?? date;
  String get displayDayName => turkishWeekdayName(displayDate);

  MockExam({
    required this.id,
    required this.date,
    required this.dayName,
    required this.type,
    required this.scope,
    required this.duration,
    required this.targetNet,
    required this.analysisMethod,
    this.isCompleted = false,
    Map<String, double>? nets,
    this.completedAt,
    this.updatedAt,
  }) : nets = nets ?? {};

  /// Totals only the supplied catalog entries. Screens pass the built-in
  /// curriculum here when displaying an official TYT/AYT total, keeping
  /// profile-specific extra subjects visible without changing that total.
  double totalForSubjects(Iterable<Subject> catalog) => catalog.fold(
    0.0,
    (sum, subject) =>
        sum +
        (hasNetForCatalogSubject(subject)
            ? netForCatalogSubject(subject)
            : 0.0),
  );

  bool hasScoresForSubjects(Iterable<Subject> catalog) =>
      catalog.any((subject) => hasNetForCatalogSubject(subject));

  Map<String, double> get normalizedNets {
    final normalized = <String, double>{};
    for (final entry in nets.entries) {
      final key = normalizeNetKey(entry.key);
      // Prefer the canonical key if both it and a legacy alias are present.
      if (!normalized.containsKey(key) || entry.key == key) {
        normalized[key] = entry.value;
      }
    }
    return normalized;
  }

  static String netKeyForSubject(String type, String name) {
    return name.startsWith('$type ') ? name : '$type $name';
  }

  static String scoreKeyForSubject(Subject subject) =>
      'subject:${subject.storageId}';
  static String foldedSubjectKey(String type, String name) {
    var clean = name.trim();
    final prefix = RegExp('^${RegExp.escape(type)}\\s+', caseSensitive: false);
    while (prefix.hasMatch(clean)) {
      clean = clean.replaceFirst(prefix, '').trim();
    }
    var value = '$type $clean'.toLowerCase();
    for (final pair in const {
      'ı': 'i',
      'İ': 'i',
      'ü': 'u',
      'ö': 'o',
      'ş': 's',
      'ğ': 'g',
      'ç': 'c',
    }.entries) {
      value = value.replaceAll(pair.key, pair.value);
    }
    return value.replaceAll(RegExp(r'\s+'), ' ');
  }

  static Map<String, double> canonicalizeNetsForCatalog(
    Map<String, double> values,
    Iterable<Subject> subjects,
  ) {
    final catalog = subjects.toList();
    final byName = <String, List<Subject>>{};
    for (final subject in catalog) {
      byName
          .putIfAbsent(foldedSubjectKey(subject.type, subject.name), () => [])
          .add(subject);
    }
    final result = <String, double>{};
    for (final entry in values.entries) {
      var key = entry.key;
      if (key.startsWith('subject:') &&
          !catalog.any((subject) => scoreKeyForSubject(subject) == key)) {
        key = 'legacy-unmapped:$key';
      }
      if (!key.startsWith('subject:') && !key.startsWith('legacy-unmapped:')) {
        final type = key.trim().split(RegExp(r'\s+')).first;
        final matches = byName[foldedSubjectKey(type, key)] ?? <Subject>[];
        key = matches.length == 1
            ? scoreKeyForSubject(matches.single)
            : 'legacy-unmapped:${entry.key}';
      }
      if (result.containsKey(key) && result[key] != entry.value) {
        throw FormatException('$key için çelişen netler var.');
      }
      result[key] = entry.value;
    }
    return result;
  }

  void applySubjectCatalog(Iterable<Subject> catalog) {
    nets = canonicalizeNetsForCatalog(nets, catalog);
  }

  Map<String, double> get unmappedNets => {
    for (final entry in nets.entries)
      if (entry.key.startsWith('legacy-unmapped:'))
        entry.key.substring('legacy-unmapped:'.length): entry.value,
  };
  double netForCatalogSubject(Subject subject) =>
      nets[scoreKeyForSubject(subject)] ??
      (subject.isCustom ? 0 : netForSubject(subject.type, subject.name));
  bool hasNetForCatalogSubject(Subject subject) =>
      nets.containsKey(scoreKeyForSubject(subject)) ||
      (!subject.isCustom && hasNetForSubject(subject.type, subject.name));

  static String normalizeNetKey(String key) {
    if (key == 'TYT Turkce') return 'TYT Türkçe';
    return key;
  }

  /// Migrate legacy aliases once, rejecting ambiguous scores before writing.
  static Map<String, double> canonicalizeNets(Map<String, double> values) {
    final result = <String, double>{};
    for (final entry in values.entries) {
      final key = normalizeNetKey(entry.key);
      if (result.containsKey(key) && result[key] != entry.value) {
        throw FormatException('$key için çelişen net değerleri var.');
      }
      result[key] = entry.value;
    }
    return result;
  }

  double netForSubject(String type, String name) {
    final key = netKeyForSubject(type, name);
    final idKey = 'subject:builtin_${type}_${Uri.encodeComponent(key)}';
    final direct = nets[idKey] ?? nets[key];
    if (direct != null) return direct;
    for (final entry in nets.entries) {
      if (normalizeNetKey(entry.key) == key) return entry.value;
    }
    return 0;
  }

  bool hasNetForSubject(String type, String name) =>
      normalizedNets.containsKey(netKeyForSubject(type, name)) ||
      nets.containsKey(
        'subject:builtin_${type}_${Uri.encodeComponent(netKeyForSubject(type, name))}',
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'isCompleted': isCompleted,
    'nets': nets.map((k, v) => MapEntry(k, v)),
    'plannedDate': isCompleted ? date.toIso8601String() : null,
    'completedAt': completedAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  void fromJson(Map<String, dynamic> json) {
    isCompleted = json['isCompleted'] ?? false;
    final plannedDateValue = json['plannedDate'];
    final plannedDate = plannedDateValue is String
        ? DateTime.tryParse(plannedDateValue)
        : null;
    if (isCompleted && plannedDate != null) {
      date = plannedDate;
      dayName = turkishWeekdayName(plannedDate);
    }
    final completedAtValue = json['completedAt'];
    completedAt = completedAtValue is String
        ? DateTime.tryParse(completedAtValue)
        : null;
    final updatedAtValue = json['updatedAt'];
    updatedAt = updatedAtValue is String
        ? DateTime.tryParse(updatedAtValue)
        : null;
    if (json['nets'] != null) {
      nets = Map<String, double>.from(
        (json['nets'] as Map).map(
          (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
        ),
      );
    }
  }
}
