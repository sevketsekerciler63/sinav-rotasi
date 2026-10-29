// Temel sözleşme testleri: sınav kuralları, hedef tarih ve profil JSON'u.
// Bu kontroller resmî ÖSYM tarihi uydurulmadığını ve kişisel hedefe göre
// deneme takviminin hizalandığını korur.
import 'package:flutter_test/flutter_test.dart';
import 'package:yks_study_app/data/exam_calendar_data.dart';
import 'package:yks_study_app/data/exam_rules.dart';
import 'package:yks_study_app/models/daily_log.dart';
import 'package:yks_study_app/models/exam_profile.dart';
import 'package:yks_study_app/models/net_score.dart';

void main() {
  group('YKS süre kuralları', () {
    test('TYT/AYT/YDT süreleri 2026 kılavuzuyla tek kaynaktan gelir', () {
      expect(YksExamRules.tytMinutes, 165);
      expect(YksExamRules.aytMinutes, 180);
      expect(YksExamRules.ydtMinutes, 120);
      expect(YksExamRules.combinedTotalMinutes, 345);
      expect(YksExamRules.tytLabel, '165 dk');
      expect(
        YksExamRules.sourceUrl,
        startsWith('https://dokuman.osym.gov.tr/'),
      );
    });
  });

  group('Deneme takvimi', () {
    test('hedef verilmezse 13 deneme kronolojik sırada döner', () {
      final exams = getExamCalendar();
      expect(exams, hasLength(13));
      for (var i = 1; i < exams.length; i++) {
        expect(
          exams[i].date.isAfter(exams[i - 1].date),
          isTrue,
          reason: '${exams[i].id} öncekinden sonra olmalı',
        );
      }
    });

    test('kişisel hedefe kaydırılınca son deneme hedeften 6 gün önce olur', () {
      final target = DateTime(2027, 6, 19);
      final exams = getExamCalendar(targetDate: target);
      expect(exams.last.date, DateTime(2027, 6, 13));
      expect(exams.every((e) => e.date.isBefore(target)), isTrue);
      for (final exam in exams) {
        expect(exam.dayName, turkishWeekdayName(exam.date));
      }
    });
  });

  group('Türkçe net gösterimi', () {
    test('ondalık virgülle yazılır ve girişte yeniden okunur', () {
      expect(NetScore.format(25), '25');
      expect(NetScore.format(25.5), '25,5');
      expect(NetScore.format(59.75), '59,75');
      expect(NetScore.format(-1.25), '-1,25');
      expect(NetScore.format(0), '0');
      for (final value in [25.0, 25.5, 59.75, -1.25, 0.25]) {
        expect(NetScore.parse(NetScore.format(value)), value);
      }
    });
  });

  group('Varsayılan profil', () {
    test('resmî tarih uydurmaz; hedef bugünden yaklaşık 180 gün sonradır', () {
      final today = DateTime.now();
      final start = DateTime(today.year, today.month, today.day);
      final days = ExamProfile.defaultYks.targetDate.difference(start).inDays;
      expect(days, inInclusiveRange(179, 181));
      expect(ExamProfile.defaultYks.examYear, isNull);
      expect(
        ExamProfile.defaultYks.contentNotice,
        contains('henüz doğrulanmadı'),
      );
    });

    test('JSON gidiş-dönüşünde alanlar korunur', () {
      final profile = ExamProfile.defaultYks.copyWith(
        name: 'Deneme profili',
        scoreType: 'ea',
        startingLevel: 'basic',
        examYear: 2027,
        targetDate: DateTime(2027, 6, 19),
      );
      final restored = ExamProfile.fromJson(profile.toJson());
      expect(restored.toJson(), profile.toJson());
    });

    test('geçersiz sınav yılı ve bilinmeyen içerik sürümü reddedilir', () {
      final base = ExamProfile.defaultYks.toJson();
      expect(
        () => ExamProfile.fromJson({...base, 'examYear': 1999}),
        throwsFormatException,
      );
      expect(
        () => ExamProfile.fromJson({
          ...base,
          'curriculumVersion': 'yks-reference-2099-v9',
        }),
        throwsFormatException,
      );
    });
  });
}
