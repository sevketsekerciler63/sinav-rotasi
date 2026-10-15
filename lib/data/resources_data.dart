class Resource {
  final String subject;
  final String channel;
  final String searchQuery;
  final String focus;

  const Resource({
    required this.subject,
    required this.channel,
    required this.searchQuery,
    required this.focus,
  });
}

class ExamTactic {
  final String title;
  final String description;

  const ExamTactic({required this.title, required this.description});
}

List<Resource> getResources() {
  return const [
    Resource(
      subject: 'TYT Matematik',
      channel: 'Hocalara Geldik',
      searchQuery: 'Hocalara Geldik TYT Matematik konu anlatımı',
      focus: 'TYT matematik konu anlatımı araması.',
    ),
    Resource(
      subject: 'AYT Matematik',
      channel: 'Rehber Matematik',
      searchQuery: 'Rehber Matematik AYT konu anlatımı',
      focus: 'AYT matematik konu anlatımı araması.',
    ),
    Resource(
      subject: 'TYT Türkçe',
      channel: 'Türkçecim',
      searchQuery: 'Türkçecim TYT Türkçe',
      focus: 'Paragraf ve dil bilgisi içeriklerini ara.',
    ),
    Resource(
      subject: 'TYT Türkçe',
      channel: 'Kemal Hoca',
      searchQuery: 'Kemal Hoca Türkçe YKS',
      focus: 'YKS Türkçe içeriklerini ara.',
    ),
    Resource(
      subject: 'TYT/AYT Fizik',
      channel: 'Fizik konu anlatımı',
      searchQuery: 'TYT AYT Fizik konu anlatımı',
      focus: 'TYT ve AYT fizik içeriklerini ara.',
    ),
    Resource(
      subject: 'TYT/AYT Kimya',
      channel: 'Kimya konu anlatımı',
      searchQuery: 'TYT AYT Kimya konu anlatımı',
      focus: 'TYT ve AYT kimya içeriklerini ara.',
    ),
    Resource(
      subject: 'TYT/AYT Biyoloji',
      channel: 'Biyoloji konu anlatımı',
      searchQuery: 'TYT AYT Biyoloji konu anlatımı',
      focus: 'TYT ve AYT biyoloji içeriklerini ara.',
    ),
    Resource(
      subject: 'TYT Sosyal',
      channel: 'Tarih ve coğrafya',
      searchQuery: 'TYT Sosyal Bilimler tarih coğrafya',
      focus: 'TYT sosyal bilimler içeriklerini ara.',
    ),
    Resource(
      subject: 'Genel',
      channel: 'YKS soru çözümü',
      searchQuery: 'YKS soru çözümü',
      focus: 'Farklı derslerden soru çözüm videolarını ara.',
    ),
    Resource(
      subject: 'Genel',
      channel: 'Khan Academy Türkçe',
      searchQuery: 'Khan Academy Türkçe matematik fen',
      focus: 'Matematik ve fen öğrenme içeriklerini ara.',
    ),
  ];
}

List<ExamTactic> getExamTactics() {
  return const [
    ExamTactic(
      title: '⏱️ TYT Süre Yönetimi',
      description:
          'Türkçe: 40-45 dk\nMatematik: 50-55 dk\nFen: 15-20 dk\nSosyal: 15-20 dk\nToplam: 135 dk',
    ),
    ExamTactic(
      title: '📋 TYT Sıralama',
      description:
          '1. Türkçe (en hızlı net)\n2. Sosyal (ezber, hızlı)\n3. Fen (7+7+6 soru, kısa)\n4. Matematik (en son, en çok zaman)',
    ),
    ExamTactic(
      title: '🎯 AYT Sıralama',
      description:
          '1. Biyoloji (en kolay, 13 soru)\n2. Kimya (formül + mantık)\n3. Fizik (hesap yoğun)\n4. Matematik (zor, en sona)',
    ),
    ExamTactic(
      title: '❌ Boş Bırakma Stratejisi',
      description:
          '4 yanlış = 1 doğruyu götürür!\n- Kesin bilmiyorsan: BOŞ BIRAK\n- 2 şık elediysen: İŞARETLE\n- Hiçbir fikrin yoksa: BOŞ BIRAK',
    ),
    ExamTactic(
      title: '🧠 Sınav Günü Rutini',
      description:
          '1. Erken kalk, kahvaltını yap\n2. Son formül kağıdını göz at\n3. Sınav yerine erken git\n4. Stres yapma, derin nefes al\n5. "Ben hazırım" de!',
    ),
    ExamTactic(
      title: '📝 Sınav Sırasında',
      description:
          '1. İlk 5 dk: tüm soruları tara\n2. Kolay soruları önce çöz\n3. Zor sorulara TAKILMA\n4. Son 10 dk: optik kontrol\n5. Boş bıraktığın soruları kontrol et',
    ),
  ];
}
