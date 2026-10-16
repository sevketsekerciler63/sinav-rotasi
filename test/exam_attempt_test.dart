import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:yks_study_app/models/exam_attempt.dart';

ExamAttempt attempt(
  String id, {
  String session = 'AYT',
  String area = 'ea',
  String language = '',
  bool exempt = false,
}) => ExamAttempt(
  id: id,
  title: 'Denemem',
  date: '2026-10-16',
  session: session,
  area: area,
  language: language,
  religionExempt: exempt,
  scores: {
    for (final test in YksAttemptCatalog.tests(
      session,
      area,
      religionExempt: exempt,
    ))
      test.id: AttemptScore.counts(test.questions - 4, 4, 0),
  },
);
void main() {
  test('independent AYT EA SOZ and YDT use only their official tests', () {
    for (final exam in [
      attempt('ea'),
      attempt('soz', area: 'soz'),
      attempt('muaf', area: 'soz', exempt: true),
      attempt('dil', session: 'YDT', area: '', language: 'İngilizce'),
    ]) {
      final parsed = ExamAttempt.fromJson(
        jsonDecode(jsonEncode(exam.toJson())),
      );
      expect(parsed.scores.keys, isNot(contains('tyt_mat')));
      expect(
        parsed.totalNet,
        exam.session == 'YDT' ? 75 : 80 - 5 * exam.scores.length,
      );
    }
    expect(
      attempt('ea').comparisonKey,
      isNot(attempt('say', area: 'say').comparisonKey),
    );
    expect(
      attempt(
        'dil',
        session: 'YDT',
        area: '',
        language: 'İngilizce',
      ).comparisonKey,
      isNot(
        attempt(
          'dil2',
          session: 'YDT',
          area: '',
          language: 'Almanca',
        ).comparisonKey,
      ),
    );
  });
  test(
    'counts total, negative quarter net and invalid dates or foreign tests are checked',
    () {
      expect(
        AttemptScore.fromJson(const AttemptScore.net(-10).toJson(), 40).net,
        -10,
      );
      expect(
        () => AttemptScore.fromJson(const AttemptScore.net(20.1).toJson(), 40),
        throwsFormatException,
      );
      expect(
        () => AttemptScore.fromJson(AttemptScore.counts(40, 1, 0).toJson(), 40),
        throwsFormatException,
      );
      final invalid = attempt('ea').toJson();
      invalid['date'] = '2026-02-30';
      expect(() => ExamAttempt.fromJson(invalid), throwsFormatException);
      final foreign = attempt('ea').toJson();
      foreign['scores']['tyt_mat'] = const AttemptScore.net(10).toJson();
      expect(() => ExamAttempt.fromJson(foreign), throwsFormatException);
    },
  );
  test('more than 13 records, exact retry and archive remain durable data', () {
    var book = ExamAttemptBook('profile', []);
    for (var i = 0; i < 20; i++) {
      book = book.save(attempt('$i'));
    }
    book = book.save(attempt('0'));
    expect(book.attempts.length, 20);
    book = book.save(book.attempts.first.withArchived(true));
    final restored = ExamAttemptBook.fromJson(
      jsonDecode(jsonEncode(book.toJson())),
    );
    expect(restored.attempts.where((attempt) => attempt.archived).length, 1);
    expect(restored.attempts.length, 20);
  });
}
