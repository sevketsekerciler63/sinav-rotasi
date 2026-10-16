class ExamTestSpec {
  final String id, label;
  final int questions;
  const ExamTestSpec(this.id, this.label, this.questions);
}

class YksAttemptCatalog {
  static const version = 'yks-2026-v1';
  static const source =
      'https://dokuman.osym.gov.tr/pdfdokuman/2026/YKS/basvuru_kilavuz06022026.pdf';
  static const tyt = [
    ExamTestSpec('tyt_mat', 'Matematik', 40),
    ExamTestSpec('tyt_turkce', 'Türkçe', 40),
    ExamTestSpec('tyt_fizik', 'Fizik', 7),
    ExamTestSpec('tyt_kimya', 'Kimya', 7),
    ExamTestSpec('tyt_biyoloji', 'Biyoloji', 6),
    ExamTestSpec('tyt_sosyal', 'Sosyal', 20),
  ];
  static const math = ExamTestSpec('ayt_mat', 'Matematik', 40);
  static const literature = [
    ExamTestSpec('ayt_edebiyat', 'Edebiyat', 24),
    ExamTestSpec('ayt_tarih1', 'Tarih-1', 10),
    ExamTestSpec('ayt_cografya1', 'Coğrafya-1', 6),
  ];
  static List<ExamTestSpec> tests(
    String session,
    String area, {
    bool religionExempt = false,
  }) => switch (session) {
    'TYT' => tyt,
    'YDT' => const [ExamTestSpec('ydt_dil', 'Yabancı dil', 80)],
    'AYT' => switch (area) {
      'say' => const [
        math,
        ExamTestSpec('ayt_fizik', 'Fizik', 14),
        ExamTestSpec('ayt_kimya', 'Kimya', 13),
        ExamTestSpec('ayt_biyoloji', 'Biyoloji', 13),
      ],
      'ea' => [math, ...literature],
      'soz' => [
        ...literature,
        const ExamTestSpec('ayt_tarih2', 'Tarih-2', 11),
        const ExamTestSpec('ayt_cografya2', 'Coğrafya-2', 11),
        ExamTestSpec('ayt_felsefe', 'Felsefe grubu', religionExempt ? 18 : 12),
        if (!religionExempt) const ExamTestSpec('ayt_din', 'Din kültürü', 6),
      ],
      _ => throw const FormatException('AYT alanı geçersiz.'),
    },
    _ => throw const FormatException('Oturum geçersiz.'),
  };
}

class AttemptScore {
  final double net;
  final int? correct, wrong, blank;
  const AttemptScore.net(this.net) : correct = null, wrong = null, blank = null;
  AttemptScore.counts(int correct, int wrong, int blank)
    : this._(correct - wrong / 4, correct, wrong, blank);
  const AttemptScore._(this.net, this.correct, this.wrong, this.blank);
  Map<String, dynamic> toJson() => {
    'net': net,
    'correct': correct,
    'wrong': wrong,
    'blank': blank,
  };
  factory AttemptScore.fromJson(Map<String, dynamic> json, int questions) {
    final value = json['net'];
    if (value is! num ||
        !value.isFinite ||
        value < -questions / 4 ||
        value > questions ||
        (value * 4 - (value * 4).round()).abs() > 0.000001) {
      throw const FormatException('Net soru sınırında ve 0,25 adımlı olmalı.');
    }
    final counts = [json['correct'], json['wrong'], json['blank']];
    if (counts.every((value) => value == null)) {
      return AttemptScore.net(value.toDouble());
    }
    if (counts.any((value) => value is! int || value < 0) ||
        counts.cast<int>().fold<int>(0, (a, b) => a + b) != questions) {
      throw const FormatException(
        'Doğru + yanlış + boş, soru sayısına eşit olmalı.',
      );
    }
    final result = AttemptScore.counts(
      counts[0] as int,
      counts[1] as int,
      counts[2] as int,
    );
    if ((result.net - value).abs() > 0.000001) {
      throw const FormatException('Net ile doğru/yanlış uyuşmuyor.');
    }
    return result;
  }
}

class ExamAttempt {
  final String id,
      title,
      publisher,
      date,
      session,
      area,
      language,
      catalogVersion;
  final bool archived, religionExempt;
  final Map<String, AttemptScore> scores;
  ExamAttempt({
    required this.id,
    required this.title,
    this.publisher = '',
    required this.date,
    required this.session,
    this.area = '',
    this.language = '',
    this.catalogVersion = YksAttemptCatalog.version,
    this.archived = false,
    this.religionExempt = false,
    required Map<String, AttemptScore> scores,
  }) : scores = Map.unmodifiable(scores);
  double get totalNet => scores.values.fold(0, (sum, score) => sum + score.net);
  String get comparisonKey =>
      '$catalogVersion:$session:$area:$language:$religionExempt';
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'publisher': publisher,
    'date': date,
    'session': session,
    'area': area,
    'language': language,
    'catalogVersion': catalogVersion,
    'archived': archived,
    'religionExempt': religionExempt,
    'scores': scores.map((key, value) => MapEntry(key, value.toJson())),
  };
  ExamAttempt withArchived(bool value) =>
      ExamAttempt.fromJson({...toJson(), 'archived': value});
  factory ExamAttempt.fromJson(Map<String, dynamic> json) {
    for (final key in [
      'id',
      'title',
      'publisher',
      'date',
      'session',
      'area',
      'language',
      'catalogVersion',
    ]) {
      if (json[key] is! String ||
          (json[key] as String).length > 240 ||
          (['id', 'title'].contains(key) &&
              (json[key] as String).trim().isEmpty)) {
        throw const FormatException('Deneme metni geçersiz.');
      }
    }
    final date = json['date'] as String;
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) ||
        DateTime.tryParse(date) == null ||
        DateTime.parse(date).toIso8601String().substring(0, 10) != date) {
      throw const FormatException('Deneme tarihi geçersiz.');
    }
    if (json['catalogVersion'] != YksAttemptCatalog.version ||
        json['archived'] is! bool ||
        json['religionExempt'] is! bool) {
      throw const FormatException('Deneme sürümü veya durumu geçersiz.');
    }
    final session = json['session'] as String,
        area = json['area'] as String,
        language = json['language'] as String;
    if ((session != 'AYT' && area != '') ||
        (session == 'YDT'
            ? ![
                'İngilizce',
                'Almanca',
                'Arapça',
                'Fransızca',
                'Rusça',
              ].contains(language)
            : language != '') ||
        (json['religionExempt'] == true &&
            !(session == 'AYT' && area == 'soz'))) {
      throw const FormatException('Alan/dil/muafiyet oturumla uyuşmuyor.');
    }
    final tests = YksAttemptCatalog.tests(
      session,
      area,
      religionExempt: json['religionExempt'],
    );
    final raw = json['scores'];
    if (raw is! Map ||
        raw.length != tests.length ||
        tests.any((test) => !raw.containsKey(test.id))) {
      throw const FormatException('Denemenin testleri eksik veya yabancı.');
    }
    return ExamAttempt(
      id: json['id'],
      title: json['title'],
      publisher: json['publisher'],
      date: date,
      session: session,
      area: area,
      language: language,
      religionExempt: json['religionExempt'],
      catalogVersion: json['catalogVersion'],
      archived: json['archived'],
      scores: {
        for (final test in tests)
          test.id: AttemptScore.fromJson(
            Map<String, dynamic>.from(raw[test.id] as Map),
            test.questions,
          ),
      },
    );
  }
}

class ExamAttemptBook {
  final String profileId;
  final List<ExamAttempt> attempts;
  ExamAttemptBook(this.profileId, Iterable<ExamAttempt> attempts)
    : attempts = List.unmodifiable(attempts);
  ExamAttemptBook save(ExamAttempt attempt) => ExamAttemptBook.fromJson({
    'version': 1,
    'profileId': profileId,
    'attempts': [
      for (final item in attempts)
        if (item.id != attempt.id) item.toJson(),
      attempt.toJson(),
    ],
  });
  Map<String, dynamic> toJson() => {
    'version': 1,
    'profileId': profileId,
    'attempts': attempts.map((attempt) => attempt.toJson()).toList(),
  };
  factory ExamAttemptBook.fromJson(Map<String, dynamic> json) {
    if (json['version'] != 1 ||
        json['profileId'] is! String ||
        (json['profileId'] as String).isEmpty ||
        json['attempts'] is! List ||
        (json['attempts'] as List).length > 100000) {
      throw const FormatException('Deneme defteri geçersiz.');
    }
    final attempts = [
      for (final raw in json['attempts'])
        ExamAttempt.fromJson(Map<String, dynamic>.from(raw as Map)),
    ];
    if (attempts.map((attempt) => attempt.id).toSet().length != attempts.length) {
      throw const FormatException('Deneme kimliği yineleniyor.');
    }
    return ExamAttemptBook(json['profileId'], attempts);
  }
}
