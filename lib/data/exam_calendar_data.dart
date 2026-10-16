import 'exam_rules.dart';
import '../models/mock_exam.dart';
import '../models/daily_log.dart';

List<MockExam> getExamCalendar({DateTime? targetDate}) {
  final exams = [
    MockExam(
      id: 'D1',
      date: DateTime(2026, 4, 13),
      dayName: 'Pazartesi',
      type: '📘 TYT Denemesi 1',
      scope: 'Türkçe (40) + Mat (40) + Fen (20) + Sos (20) = 120 soru',
      duration: YksExamRules.tytLabel,
      targetNet: 'Hedef yok, sadece ölç',
      analysisMethod:
          '1) Her dersten kaç net yaptın yaz.\n2) Türkçede hangi soru tipinde hata var?\n3) Matta hangi konu tipi?\n4) Bu hataları ertesi gün çalış.',
    ),
    MockExam(
      id: 'D2',
      date: DateTime(2026, 4, 19),
      dayName: 'Pazar',
      type: '📘 TYT Denemesi 2',
      scope: 'Türkçe + Mat + Fen + Sos — tam TYT',
      duration: YksExamRules.tytLabel,
      targetNet: 'D1\'den +3 net fazla',
      analysisMethod:
          '1) D1 ile karşılaştır.\n2) Aynı hatayı tekrar yaptın mı?\n3) Süre yönetimi nasıldı?\n4) En az net dersi ertesi gün çalış.',
    ),
    MockExam(
      id: 'D3',
      date: DateTime(2026, 4, 26),
      dayName: 'Pazar',
      type: '📘 TYT Denemesi 3',
      scope: 'Türkçe + Mat + Fen + Sos — tam TYT',
      duration: YksExamRules.tytLabel,
      targetNet: 'TYT Toplam ~35 net',
      analysisMethod:
          '1) Her dersin net grafiğini çiz (D1-D2-D3).\n2) Sürekli düşük olan dersi belirle.\n3) Kolay sorularda hata varsa tekrar.',
    ),
    MockExam(
      id: 'D4',
      date: DateTime(2026, 5, 3),
      dayName: 'Pazar',
      type: '📘 TYT Denemesi 4',
      scope: 'Türkçe + Mat + Fen + Sos — tam TYT',
      duration: YksExamRules.tytLabel,
      targetNet: 'TYT Toplam ~40 net',
      analysisMethod:
          '1) Türkçede 30+ net hedefi tuttu mu?\n2) Matta hangi problem tipi yanlış?\n3) Fen düşükse temel konuya dön.',
    ),
    MockExam(
      id: 'D5',
      date: DateTime(2026, 5, 10),
      dayName: 'Pazar',
      type: '📘 TYT + AYT Denemesi 1',
      scope:
          'TYT tam (${YksExamRules.tytLabel}) + '
          'AYT kısa çalışma (${YksExamRules.shortAytPracticeMinutes} dk)',
      duration: YksExamRules.tytAndShortAytLabel,
      targetNet: 'TYT ~43 | AYT ~8',
      analysisMethod:
          '1) İlk AYT — sadece bildiğin konuları çöz.\n2) AYT\'de yabancı konuları listele.\n3) TYT devam eden hataları not al.',
    ),
    MockExam(
      id: 'D6',
      date: DateTime(2026, 5, 17),
      dayName: 'Pazar',
      type: '📘 TYT + AYT Denemesi 2',
      scope: 'TYT tam + AYT Mat+Fiz+Kim+Bio kısa',
      duration: YksExamRules.tytAndShortAytLabel,
      targetNet: 'TYT ~46 | AYT ~12',
      analysisMethod:
          '1) D5 ile AYT netleri karşılaştır.\n2) AYT hangi ders hızlı yükseliyor?\n3) TYT süre yönetimi yetişiyor mu?',
    ),
    MockExam(
      id: 'D7',
      date: DateTime(2026, 5, 24),
      dayName: 'Pazar',
      type: '📘 TYT + AYT Denemesi 3',
      scope: 'TYT tam + AYT tam (180 dk)',
      duration: YksExamRules.combinedLabel,
      targetNet: 'TYT ~48 | AYT ~15',
      analysisMethod:
          '1) İlk tam AYT!\n2) Bio>Kim>Fiz>Mat sırası uyguladın mı?\n3) En düşük AYT dersi hangisi?',
    ),
    MockExam(
      id: 'D8',
      date: DateTime(2026, 5, 28),
      dayName: 'Perşembe',
      type: '📘 TYT Denemesi 5',
      scope: 'Sadece TYT tam',
      duration: YksExamRules.tytLabel,
      targetNet: 'TYT ~50 net',
      analysisMethod: '50 net geçti mi? Büyük baraj bu!',
    ),
    MockExam(
      id: 'D9',
      date: DateTime(2026, 5, 31),
      dayName: 'Pazar',
      type: '📘 AYT Denemesi 1',
      scope: 'Sadece AYT tam (180 dk)',
      duration: YksExamRules.aytLabel,
      targetNet: 'AYT ~17 net',
      analysisMethod: 'Soru seçimi doğru muydu? Bio>Kim>Fiz>Mat sırası!',
    ),
    MockExam(
      id: 'D10',
      date: DateTime(2026, 6, 4),
      dayName: 'Perşembe',
      type: '📘 TYT Denemesi 6',
      scope: 'TYT tam',
      duration: YksExamRules.tytLabel,
      targetNet: 'TYT ~52 net',
      analysisMethod: '80. gün! 50 geçtiyse çok iyi!',
    ),
    MockExam(
      id: 'D11',
      date: DateTime(2026, 6, 7),
      dayName: 'Pazar',
      type: '📘 TYT + AYT Tam Simülasyon',
      scope: 'TYT tam + AYT tam',
      duration: YksExamRules.combinedLabel,
      targetNet: 'TYT ~53 | AYT ~18',
      analysisMethod:
          'Tam simülasyon! SAY puanını hesapla, başlangıçla karşılaştır.',
    ),
    MockExam(
      id: 'D12',
      date: DateTime(2026, 6, 11),
      dayName: 'Perşembe',
      type: '📘 TYT Denemesi 7',
      scope: 'TYT tam',
      duration: YksExamRules.tytLabel,
      targetNet: 'TYT ~55 net',
      analysisMethod: '55 net = hedefe ulaştın demek!',
    ),
    MockExam(
      id: 'D13',
      date: DateTime(2026, 6, 14),
      dayName: 'Pazar',
      type: '📘 SON DENEME — TYT + AYT',
      scope: 'TYT + AYT tam',
      duration: YksExamRules.combinedLabel,
      targetNet: 'TYT ~55 | AYT ~20',
      analysisMethod: 'Son deneme! Başlangıçla karşılaştır 😊',
    ),
  ];

  if (targetDate == null) return exams;
  final normalizedTarget = DateTime(
    targetDate.year,
    targetDate.month,
    targetDate.day,
  );
  final shiftDays = normalizedTarget.difference(DateTime(2026, 6, 20)).inDays;
  return exams.map((exam) {
    final shiftedDate = exam.date.add(Duration(days: shiftDays));
    return MockExam(
      id: exam.id,
      date: shiftedDate,
      dayName: turkishWeekdayName(shiftedDate),
      type: exam.type,
      scope: exam.scope,
      duration: exam.duration,
      targetNet: exam.targetNet,
      analysisMethod: exam.analysisMethod,
      isCompleted: exam.isCompleted,
      nets: Map<String, double>.of(exam.nets),
      completedAt: exam.completedAt,
    );
  }).toList();
}
