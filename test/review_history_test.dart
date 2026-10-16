import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:yks_study_app/models/weak_topic.dart';

WeakTopic sample() => WeakTopic(
  id: 'topic',
  date: '2026-10-16',
  subject: 'TYT Matematik',
  topic: 'Test',
  errorType: 'Test',
  errorCount: 1,
  action: 'Tekrar',
  isStudied: true,
  needsRepeat: true,
);

void main() {
  final firstDay = DateTime.utc(2026, 10, 16);
  test('same plan event is idempotent across undo and redo', () {
    final topic = sample();
    topic.scheduleNextReview(firstDay, eventId: 'plan_1');
    final after = topic.toJson();
    expect(topic.scheduleNextReview(firstDay, eventId: 'plan_1'), isFalse);
    expect(topic.reviewRepetitions, 1);
    expect(topic.undoReview('plan_1'), isTrue);
    expect(topic.reviewRepetitions, 0);
    expect(topic.needsRepeat, isTrue);
    topic.scheduleNextReview(
      firstDay.add(const Duration(hours: 1)),
      eventId: 'plan_1',
    );
    expect(topic.reviewRepetitions, 1);
    expect(topic.reviewIntervalDays, 1);
    expect(topic.nextReviewAt?.toIso8601String(), after['nextReviewAt']);
  });

  test('undoing an earlier review retains later review and manual flags', () {
    final topic = sample();
    topic.scheduleNextReview(firstDay, eventId: 'first');
    final later = firstDay.add(const Duration(days: 3));
    topic.scheduleNextReview(later, eventId: 'second');
    topic.setReviewFlags(
      later.add(const Duration(minutes: 1)),
      isStudied: false,
    );
    topic.undoReview('first');
    expect(topic.reviewRepetitions, 1);
    expect(topic.lastReviewedAt, later);
    expect(topic.nextReviewAt, later.add(const Duration(days: 1)));
    expect(topic.isStudied, isFalse);
    topic.scheduleNextReview(firstDay, eventId: 'first');
    expect(topic.reviewRepetitions, 2);
    expect(topic.nextReviewAt, later.add(const Duration(days: 3)));
    expect(topic.isStudied, isFalse);
  });

  test(
    'inactive events survive serialized round trip and reject duplicates',
    () {
      final topic = sample()..scheduleNextReview(firstDay, eventId: 'first');
      topic.undoReview('first');
      final restored = WeakTopic.fromJson(
        jsonDecode(jsonEncode(topic.toJson())),
      );
      restored.scheduleNextReview(firstDay, eventId: 'first');
      expect(restored.reviewRepetitions, 1);
      final invalid =
          jsonDecode(jsonEncode(restored.toJson())) as Map<String, dynamic>;
      final events = invalid['reviewHistory']['events'] as List;
      events.add(Map<String, dynamic>.from(events.first));
      expect(() => WeakTopic.fromJson(invalid), throwsFormatException);
    },
  );

  test(
    'legacy review adoption does not guess or double increment old interval',
    () {
      final topic = sample();
      topic.reviewRepetitions = 3;
      topic.reviewIntervalDays = 6;
      topic.lastReviewedAt = firstDay;
      topic.nextReviewAt = firstDay.add(const Duration(days: 6));
      topic.registerLegacyReview('legacy_plan', firstDay);
      topic.undoReview('legacy_plan');
      topic.scheduleNextReview(firstDay, eventId: 'legacy_plan');
      expect(topic.reviewRepetitions, 3);
      expect(topic.reviewIntervalDays, 6);
      expect(topic.nextReviewAt, firstDay.add(const Duration(days: 6)));
    },
  );
}
