class Achievement {
  final String id;
  final String emoji;
  final String title;
  final String description;
  final String category; // streak, topic, exam, study
  bool isUnlocked;
  String? unlockedDate;

  String? get unlockedDateLabel {
    final date = DateTime.tryParse(unlockedDate ?? '');
    if (date == null) return unlockedDate;
    return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  Achievement({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    required this.category,
    this.isUnlocked = false,
    this.unlockedDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'isUnlocked': isUnlocked,
    'unlockedDate': unlockedDate,
  };

  void fromJson(Map<String, dynamic> json) {
    isUnlocked = json['isUnlocked'] ?? false;
    unlockedDate = normalizeUnlockedDate(json['unlockedDate']);
  }

  static String? normalizeUnlockedDate(dynamic value) {
    if (value is! String) return null;
    final isoDate = DateTime.tryParse(value);
    if (isoDate != null) return isoDate.toIso8601String();

    final legacy = RegExp(r'^(\d{1,2})\.(\d{1,2})\.(\d{4})$').firstMatch(value);
    if (legacy == null) return null;
    final day = int.parse(legacy.group(1)!);
    final month = int.parse(legacy.group(2)!);
    final year = int.parse(legacy.group(3)!);
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date.toIso8601String();
  }
}

List<Achievement> getDefaultAchievements() {
  return [
    // Streak achievements
    Achievement(
      id: 'streak_3',
      emoji: '🔥',
      title: '3 Günlük Seri',
      description: '3 gün üst üste çalış',
      category: 'streak',
    ),
    Achievement(
      id: 'streak_7',
      emoji: '🔥',
      title: 'Haftalık Seri',
      description: '7 gün üst üste çalış',
      category: 'streak',
    ),
    Achievement(
      id: 'streak_14',
      emoji: '🔥',
      title: '2 Haftalık Seri',
      description: '14 gün üst üste çalış',
      category: 'streak',
    ),
    Achievement(
      id: 'streak_30',
      emoji: '💎',
      title: 'Aylık Seri',
      description: '30 gün üst üste çalış',
      category: 'streak',
    ),
    Achievement(
      id: 'streak_60',
      emoji: '👑',
      title: 'Efsanevi Seri',
      description: '60 gün üst üste çalış',
      category: 'streak',
    ),

    // Topic achievements
    Achievement(
      id: 'topic_1',
      emoji: '⭐',
      title: 'İlk Adım',
      description: 'İlk konunu tamamla',
      category: 'topic',
    ),
    Achievement(
      id: 'topic_10',
      emoji: '📚',
      title: 'Çalışkan Öğrenci',
      description: '10 konu tamamla',
      category: 'topic',
    ),
    Achievement(
      id: 'topic_25',
      emoji: '🎓',
      title: 'Bilgi Avcısı',
      description: '25 konu tamamla',
      category: 'topic',
    ),
    Achievement(
      id: 'topic_50',
      emoji: '🏆',
      title: 'Yarı Yolda',
      description: '50 konu tamamla',
      category: 'topic',
    ),
    Achievement(
      id: 'topic_75',
      emoji: '💪',
      title: 'Neredeyse Tamam',
      description: '75 konu tamamla',
      category: 'topic',
    ),
    Achievement(
      id: 'topic_all',
      emoji: '🎯',
      title: 'Tüm Konular Bitti!',
      description: 'Tüm konuları tamamla',
      category: 'topic',
    ),

    // Subject-specific
    Achievement(
      id: 'tyt_mat_50',
      emoji: '📐',
      title: 'TYT Mat %50',
      description: 'TYT Matematik konularının yarısını bitir',
      category: 'topic',
    ),
    Achievement(
      id: 'tyt_mat_100',
      emoji: '📐',
      title: 'TYT Mat Tamamlandı!',
      description: 'TYT Matematik konularının hepsini bitir',
      category: 'topic',
    ),
    Achievement(
      id: 'tyt_tur_50',
      emoji: '📖',
      title: 'TYT Türkçe %50',
      description: 'TYT Türkçe konularının yarısını bitir',
      category: 'topic',
    ),
    Achievement(
      id: 'tyt_tur_100',
      emoji: '📖',
      title: 'TYT Türkçe Tamamlandı!',
      description: 'TYT Türkçe konularının hepsini bitir',
      category: 'topic',
    ),
    Achievement(
      id: 'all_tyt',
      emoji: '🌟',
      title: 'TYT Fatihi',
      description: 'Tüm TYT konularını tamamla',
      category: 'topic',
    ),
    Achievement(
      id: 'all_ayt',
      emoji: '💫',
      title: 'AYT Fatihi',
      description: 'Tüm AYT konularını tamamla',
      category: 'topic',
    ),

    // Exam achievements
    Achievement(
      id: 'exam_1',
      emoji: '📝',
      title: 'İlk Deneme',
      description: 'İlk deneme sınavına gir',
      category: 'exam',
    ),
    Achievement(
      id: 'exam_5',
      emoji: '📝',
      title: 'Deneme Uzmanı',
      description: '5 deneme sınavına gir',
      category: 'exam',
    ),
    Achievement(
      id: 'exam_10',
      emoji: '🏅',
      title: 'Deneme Makinesi',
      description: '10 deneme sınavına gir',
      category: 'exam',
    ),
    Achievement(
      id: 'exam_all',
      emoji: '🏆',
      title: 'Tüm Denemeler Bitti!',
      description: '13 denemenin hepsine gir',
      category: 'exam',
    ),
    Achievement(
      id: 'tyt_40',
      emoji: '🎯',
      title: 'TYT 40 Net',
      description: 'Bir denemede TYT 40+ net yap',
      category: 'exam',
    ),
    Achievement(
      id: 'tyt_50',
      emoji: '🚀',
      title: 'TYT 50 Net',
      description: 'Bir denemede TYT 50+ net yap',
      category: 'exam',
    ),
    Achievement(
      id: 'tyt_60',
      emoji: '💎',
      title: 'TYT 60 Net',
      description: 'Bir denemede TYT 60+ net yap',
      category: 'exam',
    ),

    // Study achievements
    Achievement(
      id: 'day_first',
      emoji: '🌅',
      title: 'Yolculuk Başladı!',
      description: 'İlk çalışma gününü tamamla',
      category: 'study',
    ),
    Achievement(
      id: 'day_7',
      emoji: '📅',
      title: '1 Hafta Tamam',
      description: '7 çalışma günü tamamla',
      category: 'study',
    ),
    Achievement(
      id: 'day_30',
      emoji: '📅',
      title: '1 Ay Tamam',
      description: '30 çalışma günü tamamla',
      category: 'study',
    ),
    Achievement(
      id: 'day_60',
      emoji: '📅',
      title: '2 Ay Tamam',
      description: '60 çalışma günü tamamla',
      category: 'study',
    ),
    Achievement(
      id: 'day_90',
      emoji: '🏆',
      title: 'Son Sprint!',
      description: '90 çalışma günü tamamla',
      category: 'study',
    ),
    Achievement(
      id: 'weak_5',
      emoji: '⚠️',
      title: 'Zayıf Nokta Avcısı',
      description: '5 zayıf konuyu çalış ve işaretle',
      category: 'study',
    ),
  ];
}

class MotivationQuote {
  final String text;
  final String author;

  const MotivationQuote(this.text, this.author);
}

List<MotivationQuote> getMotivationQuotes() {
  return const [
    MotivationQuote('Bugün çalışmayanın yarını zordur.', 'Anonim'),
    MotivationQuote(
      'Başarı, her gün tekrarlanan küçük çabaların toplamıdır.',
      'Robert Collier',
    ),
    MotivationQuote('Tek sınır, koyduğun sınırdır.', 'Anonim'),
    MotivationQuote(
      'Hayal etmekten korkma, hayallerini gerçekleştirmekten korkma.',
      'Walt Disney',
    ),
    MotivationQuote(
      'Her ustanın bir zamanlar çırak olduğunu unutma.',
      'Anonim',
    ),
    MotivationQuote('Bugünkü çaban, yarınki başarının temelidir.', 'Anonim'),
    MotivationQuote(
      'Zorluklara rağmen devam eden, hedefe ulaşandır.',
      'Anonim',
    ),
    MotivationQuote(
      'Bin kilometrelik yolculuk tek bir adımla başlar.',
      'Lao Tzu',
    ),
    MotivationQuote('Çalışmak zekayı yener.', 'Anonim'),
    MotivationQuote(
      'Dün çalışmaya başlamanın en iyi zamanıydı. İkinci en iyi zaman şimdi.',
      'Anonim',
    ),
    MotivationQuote(
      'Motivasyon seni başlatır, alışkanlık seni devam ettirir.',
      'Jim Ryun',
    ),
    MotivationQuote('Hata yapmaktan korkma, hata yapmamaktan kork.', 'Anonim'),
    MotivationQuote('Gelecek, bugün hazırlananlara aittir.', 'Malcolm X'),
    MotivationQuote(
      'Asla pes etme! Başarısızlık, vazgeçtiğin andır.',
      'Anonim',
    ),
    MotivationQuote(
      'YKS sadece bir sınav değil, kendine verdiğin bir söz.',
      'Anonim',
    ),
    MotivationQuote('Sabır ve azim, inatçılığın yerini alır.', 'Anonim'),
    MotivationQuote('Her gün, bir önceki günden daha güçlüsün.', 'Anonim'),
    MotivationQuote('Hedefe odaklan, engelleri değil.', 'Anonim'),
    MotivationQuote(
      'Başarılı insanlar, başarısız insanların yapmak istemediği şeyleri yapar.',
      'Anonim',
    ),
    MotivationQuote('Düşmekten korkma, kalkmamaktan kork.', 'Anonim'),
    MotivationQuote(
      'Bugün attığın her adım, seni üniversiteye bir adım daha yaklaştırır.',
      'Anonim',
    ),
    MotivationQuote('Çalışırken zor, sınavda kolay!', 'Anonim'),
    MotivationQuote('Kendine inan. Sen yapabilirsin!', 'Anonim'),
    MotivationQuote(
      'Disiplin, motivasyonun bittiği yerde devreye girer.',
      'Anonim',
    ),
    MotivationQuote(
      '95 gün sonra gülümsemek istiyorsan, bugün ter dök.',
      'Anonim',
    ),
    MotivationQuote('Hedefin büyükse, çaban da büyük olmalı.', 'Anonim'),
    MotivationQuote(
      'Yavaş ilerleyen bile, hareketsiz olandan önde gider.',
      'Anonim',
    ),
    MotivationQuote(
      'Her soru çözdüğünde, rakiplerinden bir adım öndesin.',
      'Anonim',
    ),
    MotivationQuote(
      'Azim, yeteneğin yerini alabilir; ama yetenek, azmin yerini asla alamaz.',
      'Anonim',
    ),
    MotivationQuote('Bu süreç geçici, ama sonuçları kalıcı.', 'Anonim'),
  ];
}

MotivationQuote getDailyQuote() {
  final dayOfYear = DateTime.now()
      .difference(DateTime(DateTime.now().year, 1, 1))
      .inDays;
  final quotes = getMotivationQuotes();
  return quotes[dayOfYear % quotes.length];
}
