enum FlashcardRating { forgotten, hesitant, remembered }

/// A small, transparent local schedule for a single flashcard.
class FlashcardReview {
  final FlashcardRating? lastRating;
  final int repetitions;
  final int intervalDays;
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewAt;

  const FlashcardReview({
    required this.lastRating,
    required this.repetitions,
    required this.intervalDays,
    required this.lastReviewedAt,
    required this.nextReviewAt,
  });

  /// Keeps the old “known” mark visible while making the card due immediately.
  factory FlashcardReview.legacyKnown(DateTime now) => FlashcardReview(
    lastRating: FlashcardRating.remembered,
    repetitions: 0,
    intervalDays: 0,
    lastReviewedAt: null,
    nextReviewAt: now.toUtc(),
  );

  factory FlashcardReview.fromJson(Object? value, String path) {
    if (value is! Map) throw FormatException('$path bir nesne olmalı.');
    final json = Map<String, dynamic>.from(value);
    final ratingValue = json['lastRating'];
    FlashcardRating? rating;
    if (ratingValue != null) {
      if (ratingValue is! String) {
        throw FormatException('$path.lastRating metin olmalı.');
      }
      for (final candidate in FlashcardRating.values) {
        if (candidate.name == ratingValue) rating = candidate;
      }
      if (rating == null) {
        throw FormatException('$path.lastRating tanınmıyor.');
      }
    }

    final repetitions = json['repetitions'];
    final intervalDays = json['intervalDays'];
    if (repetitions is! int || repetitions < 0 || repetitions > 10000) {
      throw FormatException('$path.repetitions geçersiz.');
    }
    if (intervalDays is! int || intervalDays < 0 || intervalDays > 30) {
      throw FormatException('$path.intervalDays geçersiz.');
    }

    return FlashcardReview(
      lastRating: rating,
      repetitions: repetitions,
      intervalDays: intervalDays,
      lastReviewedAt: _date(json['lastReviewedAt'], '$path.lastReviewedAt'),
      nextReviewAt: _date(json['nextReviewAt'], '$path.nextReviewAt'),
    );
  }

  bool isDueAt(DateTime now) {
    final due = nextReviewAt;
    return due == null || !due.isAfter(now.toUtc());
  }

  FlashcardReview rate(FlashcardRating rating, DateTime now) {
    final nextRepetitions = switch (rating) {
      FlashcardRating.forgotten => 0,
      FlashcardRating.hesitant => repetitions,
      FlashcardRating.remembered => repetitions + 1,
    };
    final nextInterval = switch (rating) {
      FlashcardRating.forgotten => 1,
      FlashcardRating.hesitant =>
        intervalDays <= 1 ? 1 : (intervalDays / 2).ceil(),
      FlashcardRating.remembered => switch (nextRepetitions) {
        1 => 1,
        2 => 3,
        _ => (intervalDays * 2).clamp(1, 30).toInt(),
      },
    };
    final reviewedAt = now.toUtc();
    return FlashcardReview(
      lastRating: rating,
      repetitions: nextRepetitions,
      intervalDays: nextInterval,
      lastReviewedAt: reviewedAt,
      nextReviewAt: reviewedAt.add(Duration(days: nextInterval)),
    );
  }

  Map<String, dynamic> toJson() => {
    'lastRating': lastRating?.name,
    'repetitions': repetitions,
    'intervalDays': intervalDays,
    'lastReviewedAt': lastReviewedAt?.toUtc().toIso8601String(),
    'nextReviewAt': nextReviewAt?.toUtc().toIso8601String(),
  };

  static DateTime? _date(Object? value, String path) {
    if (value == null) return null;
    if (value is! String) throw FormatException('$path tarih olmalı.');
    final parsed = DateTime.tryParse(value);
    if (parsed == null) throw FormatException('$path tarih olmalı.');
    return parsed.toUtc();
  }
}

class FlashcardReviewData {
  static const int formatVersion = 1;

  final Map<String, FlashcardReview> cards;

  const FlashcardReviewData(this.cards);

  factory FlashcardReviewData.fromJson(Object? value) {
    if (value is! Map || value['version'] != formatVersion) {
      throw const FormatException('Kart tekrar verisinin sürümü geçersiz.');
    }
    final cardsValue = value['cards'];
    if (cardsValue is! Map || cardsValue.keys.any((key) => key is! String)) {
      throw const FormatException('Kart tekrar listesi geçersiz.');
    }
    final cards = <String, FlashcardReview>{};
    for (final entry in cardsValue.entries) {
      final id = entry.key as String;
      if (id.trim().isEmpty) {
        throw const FormatException('Kart kimliği boş olamaz.');
      }
      cards[id] = FlashcardReview.fromJson(entry.value, 'cards.$id');
    }
    return FlashcardReviewData(Map.unmodifiable(cards));
  }

  Map<String, dynamic> toJson() => {
    'version': formatVersion,
    'cards': {
      for (final entry in cards.entries) entry.key: entry.value.toJson(),
    },
  };
}
