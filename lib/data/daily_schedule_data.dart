import '../models/daily_log.dart';
import '../models/study_schedule_preferences.dart';

List<DailyLog> getDailySchedule({DateTime? targetDate}) {
  final logs = [
    DailyLog(
      date: DateTime(2026, 3, 17),
      dayName: 'Salı',
      tytContent:
          'Mat: Sayılar sıfırdan — doğal, tam, rasyonel sayı kavramları. Sayı doğrusu. Negatif sayı işlemleri. 20 soru çöz.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'İlk gün! Motivasyonun en yüksek, ağır başla.',
    ),
    DailyLog(
      date: DateTime(2026, 3, 18),
      dayName: 'Çarşamba',
      tytContent:
          'Türkçe: Ana fikir bulma — 10 paragraf oku, her birinin ana fikrini tek cümlede yaz. Hocalara Geldik videosu izle.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Türkçeden başlamak kolay, motivasyon sağlar.',
    ),
    DailyLog(
      date: DateTime(2026, 3, 19),
      dayName: 'Perşembe',
      tytContent:
          'Mat: 4 işlem ve işlem önceliği. Parantez kuralı. Kesir işlemleri sıfırdan — pay/payda, ortak payda. 25 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Kesirler çok kritik, acele etme.',
    ),
    DailyLog(
      date: DateTime(2026, 3, 20),
      dayName: 'Cuma',
      tytContent:
          'Türkçe: Başlık bulma (10 parça) + Boşluğa uygun cümle (10 soru). Bağlaçlara dikkat: ama/fakat/oysa/çünkü.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Paragraf soruları en kolay yükselen alan.',
    ),
    DailyLog(
      date: DateTime(2026, 3, 21),
      dayName: 'Cumartesi',
      tytContent:
          'Mat: Kesirler devam + karma kesir. Üslü sayılar sıfırdan: a²,a³,a⁰=1,a⁻¹. Üs kuralları. 20 soru.',
      aytContent: '—',
      studyHours: '7 saat',
      motivationNote: 'Cumartesi uzun çalışma günü.',
    ),
    DailyLog(
      date: DateTime(2026, 3, 22),
      dayName: 'Pazar',
      tytContent:
          'Fen: Hücre sıfırdan — hücre zarı, sitoplazma, çekirdek, mitokondri, ribozom, kloroplast. Görsel ezber! Biyoloji defteri aç.',
      aytContent: '—',
      studyHours: '7 saat',
      motivationNote: 'Pazar: Fen + Sosyal günü.',
    ),
    DailyLog(
      date: DateTime(2026, 3, 23),
      dayName: 'Pazartesi',
      tytContent:
          'Türkçe: Paragraftan sonuç çıkarma (10 soru) + Sözcükte anlam giriş (gerçek/mecaz). Mat: Köklü sayılar — √4=2...√100=10 ezber. 15 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Hafta sonu tekrar. Bugün ne öğrendiğini gözden geçir.',
    ),
    DailyLog(
      date: DateTime(2026, 3, 24),
      dayName: 'Salı',
      tytContent:
          'Mat: EBOB-EKOK sıfırdan: asal çarpanlarla bulma. EBOB×EKOK=a×b kuralı. 20 soru çöz.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote:
          'EBOB-EKOK sorularında ortak bölen ve kat ilişkilerini örneklerle pekiştir.',
    ),
    DailyLog(
      date: DateTime(2026, 3, 25),
      dayName: 'Çarşamba',
      tytContent:
          'Türkçe: Paragrafın açıklama yöntemi + Anlam bütünlüğünü bozan cümle. Mat: Bölme-bölünebilme kuralları. 15 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: '1 hafta oldu! İlk haftayı bitirdiğin için tebrikler!',
    ),
    DailyLog(
      date: DateTime(2026, 3, 26),
      dayName: 'Perşembe',
      tytContent:
          'Mat: Oran-orantı sıfırdan: doğru-ters orantı, çapraz çarpım. 20 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Oran-orantı TYT\'de en çok çıkan konulardan!',
    ),
    DailyLog(
      date: DateTime(2026, 3, 27),
      dayName: 'Cuma',
      tytContent:
          'Türkçe: Sözcük türleri sıfırdan — isim, sıfat, zamir, zarf, edat, bağlaç. Bu çok kritik! 4 gün alacak.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Sözcük türlerini cümle içinde ayırt ederek çalış.',
    ),
    DailyLog(
      date: DateTime(2026, 3, 28),
      dayName: 'Cumartesi',
      tytContent:
          'Mat: Yüzde problemleri — ardışık yüzde, kar-zarar giriş. 20 soru. Fen: Atom modeli sıfırdan (proton, nötron, elektron).',
      aytContent: '—',
      studyHours: '7 saat',
      motivationNote: 'Cumartesi yoğun gün: Mat + Fen.',
    ),
    DailyLog(
      date: DateTime(2026, 3, 29),
      dayName: 'Pazar',
      tytContent:
          'Sosyal: Osmanlı kuruluş-yükselme + Kurtuluş Savaşı. Tarihler ezber! Türkçe: Sözcük türleri devam (fiil, fiilimsi).',
      aytContent: '—',
      studyHours: '7 saat',
      motivationNote: 'Pazar: Sosyal + Türkçe tekrar günü.',
    ),
    DailyLog(
      date: DateTime(2026, 3, 30),
      dayName: 'Pazartesi',
      tytContent:
          'Mat: Denklem kurma sıfırdan — 1.derece denklem. "3 fazlası", "yarısı" gibi ifadeleri x\'e çevir. 20 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote:
          'Denklem kurarken verilenleri ve isteneni değişkenlerle göster.',
    ),
    DailyLog(
      date: DateTime(2026, 3, 31),
      dayName: 'Salı',
      tytContent:
          'Türkçe: Fiil ve fiilimsi devam + Cümle türleri giriş. Mat: Denklem pratik — 15 soru çöz.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: '2 hafta oldu! Artık temeller oturuyor.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 1),
      dayName: 'Çarşamba',
      tytContent:
          'Mat: Sayı problemleri — peş peşe sayılar, x+x+1+x+2 tipi. 20 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Temel konuları düzenli tekrar et.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 2),
      dayName: 'Perşembe',
      tytContent:
          'Fen: Periyodik tablo temeli — gruplar, periyotlar, metal/ametal. Kimya: Bağlar. Mat: Kesir problemleri. 15 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote:
          'Periyodik tabloda grup ve periyot ilişkilerini tekrar et.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 3),
      dayName: 'Cuma',
      tytContent:
          'Türkçe: Atasözü-deyim + Yazım kuralları + Noktalama. Kolay konular, hızlı bitir! Mat: Yaş problemleri.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Yazım+noktalama sınavda 2-3 kolay soru.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 4),
      dayName: 'Cumartesi',
      tytContent:
          'Mat: İşçi-havuz problemleri + Hız problemleri. 25 soru çöz; çözüm adımlarını ve birimlerini kontrol et.',
      aytContent: '—',
      studyHours: '7 saat',
      motivationNote: 'Cumartesi problem günü! Bol soru çöz.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 5),
      dayName: 'Pazar',
      tytContent:
          'Sosyal: Atatürk İnkılapları tarihleri + Coğrafya (Türkiye\'nin bölgeleri, iklim). Fen: Karışımlar+Asit-Baz (TYT Kimya).',
      aytContent: '—',
      studyHours: '7 saat',
      motivationNote: 'Pazar: Sosyal + Fen yoğun gün.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 6),
      dayName: 'Pazartesi',
      tytContent:
          'Mat: Kar-Zarar + Karışım problemleri. 20 soru. Türkçe: Anlatım bozukluklarını örnek cümlelerle çalış.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: '3 hafta oldu! Temeller güçleniyor.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 7),
      dayName: 'Salı',
      tytContent:
          'Mat: Mutlak değer + Üçgenler sıfırdan (iç açılar, alan formülü, eşkenar-ikizkenar). 20 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Geometri başlıyor! Şekil çizerek çalış.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 8),
      dayName: 'Çarşamba',
      tytContent:
          'Mat: Dik üçgen + Pisagor: a²+b²=c². 3-4-5, 5-12-13 üçgenlerini ezberle. 20 soru. Fen: Biyoloji — Prokaryot/Ökaryot + Sınıflandırma.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Pisagor her sınavda en az 1 soru!',
    ),
    DailyLog(
      date: DateTime(2026, 4, 9),
      dayName: 'Perşembe',
      tytContent:
          'Türkçe: Tüm paragraf tekrar (20 soru). Mat: Dörtgenler — kare, dikdörtgen, paralelkenar, yamuk. 15 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Paragraf tekrarı çok önemli, unutma!',
    ),
    DailyLog(
      date: DateTime(2026, 4, 10),
      dayName: 'Cuma',
      tytContent:
          'Mat: Çember-Daire + Kümeler. 20 soru. Sosyal: İslam\'ın temeli + Hz. Muhammed. Ezber!',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Çember formülleri ezber: 2πr, πr².',
    ),
    DailyLog(
      date: DateTime(2026, 4, 11),
      dayName: 'Cumartesi',
      tytContent:
          'GENEL TEKRAR — TYT Mat zayıf konular tekrar. 30 karışık soru çöz. Fen: Fizik (Kuvvet/Enerji).',
      aytContent: '—',
      studyHours: '7 saat',
      motivationNote: 'Yarın ilk deneme! Bugün tekrar yap.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 12),
      dayName: 'Pazar',
      tytContent:
          'GENEL TEKRAR — Türkçe 20 soru + Sosyal 10 soru. Fen: Biyoloji — Fotosentez/Solunum + Ekosistem.',
      aytContent: '—',
      studyHours: '7 saat',
      motivationNote: 'Yarın ilk deneme! Erken uyu.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 13),
      dayName: 'Pazartesi',
      tytContent:
          '📘 DENEME 1 — TYT tam (120 soru). Hedef yok, sadece ölç! Süre: 135 dk.',
      aytContent: '—',
      studyHours: '135 dk + analiz',
      motivationNote: 'İlk deneme! Stres yapma, sadece ne bildiğini gör.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 14),
      dayName: 'Salı',
      tytContent:
          'Deneme 1 analizi — her dersten kaç net? Türkçe hangi tip yanlış? Mat hangi konu? Zayıf konuları not al.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Analiz en az deneme kadar önemli!',
    ),
    DailyLog(
      date: DateTime(2026, 4, 15),
      dayName: 'Çarşamba',
      tytContent:
          'Mat: Mantık + Fonksiyonlar (temel). 20 soru. Türkçe: Cümlede anlam derinleştirme. 15 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: '1 ay oldu! Başlangıçtan çok iyi gidiyorsun.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 16),
      dayName: 'Perşembe',
      tytContent:
          'Mat: Olasılık giriş + İstatistik. 15 soru. Fen: Fizik — Basınç + Isı-Sıcaklık. 15 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Olasılık-İstatistik kolay ama dikkat ister.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 17),
      dayName: 'Cuma',
      tytContent:
          'Türkçe: Ses bilgisi (hafif) + Tüm dil bilgisi tekrar. Sosyal: Felsefe — Varlık + Bilgi + Ahlak felsefesi.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Felsefe sınavda 5 soru, kavramları anla.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 18),
      dayName: 'Cumartesi',
      tytContent:
          'TYT GENEL TEKRAR — Mat 30 + Türkçe 20 + Fen 10 + Sosyal 10 karışık soru. Süre tutarak çöz!',
      aytContent: '—',
      studyHours: '7 saat',
      motivationNote: 'Yarın deneme! Genel tekrar günü.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 19),
      dayName: 'Pazar',
      tytContent:
          '📘 DENEME 2 — TYT tam. Hedef: D1\'den +3 net fazla. Süre: 135 dk.',
      aytContent: '—',
      studyHours: '135 dk + analiz',
      motivationNote: 'D1 ile karşılaştır: hangi dersler yükseldi?',
    ),
    DailyLog(
      date: DateTime(2026, 4, 20),
      dayName: 'Pazartesi',
      tytContent:
          'Deneme 2 analizi. Aynı hataları tekrar mı yaptın? Süre yönetimi nasıldı? En az net dersi ertesi gün çalış.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Hata tekrarı en tehlikeli şey, düzelt!',
    ),
    DailyLog(
      date: DateTime(2026, 4, 21),
      dayName: 'Salı',
      tytContent:
          'Mat: TYT karışık problem tekrar — 30 soru. Deneme 2 zayıf konulara odaklan.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Zayıf konulara odaklanma haftası!',
    ),
    DailyLog(
      date: DateTime(2026, 4, 22),
      dayName: 'Çarşamba',
      tytContent:
          'Türkçe: Paragraf + sözcük anlamı karışık 30 soru. Mat: Geometri tekrar (üçgen+dörtgen+çember) 20 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Geometri tekrarı çok önemli!',
    ),
    DailyLog(
      date: DateTime(2026, 4, 23),
      dayName: 'Perşembe',
      tytContent:
          'Fen: TYT Fizik — Elektrik + Dalgalar/Optik. Kimya: Tepkimeler + Mol kavramı. 20 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Düzenli tekrar, bilgilerin kalıcı olmasına yardım eder.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 24),
      dayName: 'Cuma',
      tytContent:
          'Sosyal: Türkiye Tarım+Ekonomi + Dünya Coğrafyası + Kuran kavramları. Mat: Problem tekrar 20 soru.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: 'Sosyal bilgiler son tekrar!',
    ),
    DailyLog(
      date: DateTime(2026, 4, 25),
      dayName: 'Cumartesi',
      tytContent:
          'TYT GENEL TEKRAR — 40 Türkçe + 40 Mat süre tutarak. Hedef: Türkçe 45 dk, Mat 55 dk.',
      aytContent: '—',
      studyHours: '7 saat',
      motivationNote: 'Yarın deneme! Süre yönetimi pratiği.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 26),
      dayName: 'Pazar',
      tytContent: '📘 DENEME 3 — TYT tam. Hedef: TYT Toplam ~35 net.',
      aytContent: '—',
      studyHours: '135 dk + analiz',
      motivationNote: 'Her dersin net grafiğini çiz (D1-D2-D3).',
    ),
    DailyLog(
      date: DateTime(2026, 4, 27),
      dayName: 'Pazartesi',
      tytContent:
          'Deneme 3 analizi. Sürekli düşük olan dersi belirle → 1 hafta odaklan. Kolay sorularda hata varsa tekrar.',
      aytContent: '—',
      studyHours: '6 saat',
      motivationNote: '40. gün! Neredeyse yarıya geldin!',
    ),
    DailyLog(
      date: DateTime(2026, 4, 28),
      dayName: 'Salı',
      tytContent:
          'Mat: En zayıf konu tekrar + 25 soru. Türkçe: En zayıf konu tekrar + 15 soru.',
      aytContent:
          'AYT: Matematik — Fonksiyonlar giriş: f(x)=2x+1, bileşke, ters fonksiyon. 15 soru.',
      studyHours: '7 saat',
      motivationNote: 'AYT başlıyor! TYT + AYT birlikte çalışma başladı.',
    ),
    DailyLog(
      date: DateTime(2026, 4, 29),
      dayName: 'Çarşamba',
      tytContent:
          'Türkçe: Paragraf 15 soru + dil bilgisi 10 soru. Mat: Problem 15 soru.',
      aytContent:
          'AYT: Bio — Mitoz bölünme: Profaz→Metafaz→Anafaz→Telofaz. 15 soru.',
      studyHours: '7 saat',
      motivationNote: 'AYT Bio en kolay AYT dersi, iyi öğren!',
    ),
    DailyLog(
      date: DateTime(2026, 4, 30),
      dayName: 'Perşembe',
      tytContent:
          'Mat: Geometri karışık 20 soru. Fen: TYT Fen tekrar (Fizik+Kimya+Bio karışık 15 soru).',
      aytContent:
          'AYT: Mat — 2.Derece denklem ve Parabol: ax²+bx+c=0, delta, tepe noktası. 15 soru.',
      studyHours: '7 saat',
      motivationNote: 'Parabol AYT\'de en çok çıkan konu!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 1),
      dayName: 'Cuma',
      tytContent:
          'Sosyal: Tüm sosyal tekrar — 20 soru karışık. Mat: Denklem+problem 20 soru.',
      aytContent:
          'AYT: Bio — Mayoz bölünme: homolog ayrılma, crossing-over. 15 soru.',
      studyHours: '7 saat',
      motivationNote: 'Yoğun günlerde kısa molalar vermeyi unutma.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 2),
      dayName: 'Cumartesi',
      tytContent: 'TYT: Türkçe 40 + Mat 40 süre tutarak. Hedef: toplam 90 dk.',
      aytContent: 'AYT: Mat — Polinomlar: Bézout, bölme, kalan. 20 soru.',
      studyHours: '8 saat',
      motivationNote: 'Yarın deneme! Hazırlan.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 3),
      dayName: 'Pazar',
      tytContent: '📘 DENEME 4 — TYT tam. Hedef: TYT Toplam ~40 net.',
      aytContent: '—',
      studyHours: '135 dk + analiz',
      motivationNote:
          'Türkçede 30+ net tuttu mu? Mat hangi problem tipi hâlâ yanlış?',
    ),
    DailyLog(
      date: DateTime(2026, 5, 4),
      dayName: 'Pazartesi',
      tytContent:
          'Deneme 4 analizi. Fen\'de düşük ders hangisi? O dersin temel konusuna dön.',
      aytContent:
          'AYT: Mat — Logaritma sıfırdan: log kuralları, log denklemler. 20 soru.',
      studyHours: '7 saat',
      motivationNote: 'Logaritma ilk başta zor gelir ama çok mantıklı!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 5),
      dayName: 'Salı',
      tytContent: 'Mat: TYT problem tekrar 20 soru. Türkçe: Paragraf 15 soru.',
      aytContent:
          'AYT: Bio — Mendel Genetiği: dominant/resesif, çaprazlama. 20 soru.',
      studyHours: '7 saat',
      motivationNote: 'Mendel genetiği AYT Bio\'nun kalbi!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 6),
      dayName: 'Çarşamba',
      tytContent:
          'Fen: TYT Kimya tekrar + TYT Biyoloji tekrar. 15 soru. Mat: Geometri 15 soru.',
      aytContent:
          'AYT: Mat — Diziler: aritmetik+geometrik dizi, toplam formülleri. 20 soru.',
      studyHours: '7 saat',
      motivationNote: '50. gün! Yarısını geçtin, devam!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 7),
      dayName: 'Perşembe',
      tytContent:
          'Türkçe: Dil bilgisi karışık 20 soru. Mat: Fonksiyonlar TYT 15 soru.',
      aytContent:
          'AYT: Fizik — Dinamik: bağlı cisimler, eğik düzlem, sürtünme. 20 soru.',
      studyHours: '7 saat',
      motivationNote: 'AYT Fizik başlıyor! Şema çizerek çöz.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 8),
      dayName: 'Cuma',
      tytContent:
          'Sosyal: Felsefe tekrar + Din kültürü tekrar. 15 soru. Mat: Problem tekrar 15 soru.',
      aytContent: 'AYT: Kimya — Asit-Baz dengesi giriş, pH kavramı. 15 soru.',
      studyHours: '7 saat',
      motivationNote: 'AYT Kimya\'da mol+asit-baz en kritik!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 9),
      dayName: 'Cumartesi',
      tytContent:
          'TYT genel tekrar — 40 Türkçe + 40 Mat + 20 Fen + 20 Sosyal süre tutarak.',
      aytContent: 'AYT: Bio — Kan grupları + Cinsiyete bağlı kalıtım. 20 soru.',
      studyHours: '8 saat',
      motivationNote: 'Yarın ilk AYT\'li deneme!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 10),
      dayName: 'Pazar',
      tytContent: '📘 DENEME 5 — TYT tam + AYT kısa. Hedef: TYT ~43, AYT ~8.',
      aytContent: '—',
      studyHours: '195 dk + analiz',
      motivationNote: 'İlk AYT denemesi! Sadece bildiğin konuları çöz.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 11),
      dayName: 'Pazartesi',
      tytContent:
          'Deneme 5 analizi — AYT\'de hangi konular yabancı? TYT devam eden hatalar?',
      aytContent:
          'AYT: Mat — Trigonometri giriş: sin/cos/tan, birim çember. 20 soru.',
      studyHours: '7 saat',
      motivationNote: 'AYT analizi yap, yabancı konuları listele.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 12),
      dayName: 'Salı',
      tytContent:
          'Mat: TYT geometri tekrar 20 soru. Türkçe: Paragraf + sözcük anlamı 20 soru.',
      aytContent:
          'AYT: Mat — Analitik Geometri: uzaklık, doğru denklemi. 20 soru.',
      studyHours: '7 saat',
      motivationNote: 'Analitik geometri görsellik ister!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 13),
      dayName: 'Çarşamba',
      tytContent:
          'Fen: TYT Fizik tekrar (tüm konular hızlı). TYT Kimya: Mol kavramı.',
      aytContent:
          'AYT: Bio — Mendel genetiği: dominant/resesif, Aa×Aa → 3:1. 20 soru.',
      studyHours: '7 saat',
      motivationNote:
          'Mendel genetiğinde çaprazlama adımlarını örneklerle uygula.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 14),
      dayName: 'Perşembe',
      tytContent:
          'Mat: Olasılık giriş: P=istenen/toplam. 15 soru. Türkçe: Tüm dil bilgisi karışık.',
      aytContent:
          'AYT: Kimya — Mol hesabı sıfırdan: n=m/M, 1 mol=6.02×10²³. 20 soru.',
      studyHours: '7 saat',
      motivationNote: 'AYT Kimya\'da mol en kritik konu!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 15),
      dayName: 'Cuma',
      tytContent:
          'Sosyal: Tüm coğrafya tekrar + zayıf tarih konuları. Din kültürü tekrar.',
      aytContent:
          'AYT: Kimya — Mol denklem hesabı: sınırlayıcı reaktif. 20 soru.',
      studyHours: '7 saat',
      motivationNote: '60. gün! 35 gün kaldı!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 16),
      dayName: 'Cumartesi',
      tytContent:
          'Mat: TYT karışık 40 soru süre tutarak. Türkçe: 40 soru süre tutarak. Hedef: 45 dk + 55 dk.',
      aytContent:
          'AYT: Fizik — Dinamik: bağlı cisimler, eğik düzlem uygulamaları. 20 soru.',
      studyHours: '8 saat',
      motivationNote: 'Süre yönetimi çok önemli!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 17),
      dayName: 'Pazar',
      tytContent: '📘 DENEME 6 — TYT tam + AYT kısa. Hedef: TYT ~46, AYT ~12.',
      aytContent: '—',
      studyHours: '195 dk + analiz',
      motivationNote: 'AYT netleri yükseliyor mu?',
    ),
    DailyLog(
      date: DateTime(2026, 5, 18),
      dayName: 'Pazartesi',
      tytContent:
          'Deneme 6 analizi. TYT\'de sürekli düşük ders hangisi? Ona 2 saat ekstra.',
      aytContent: 'AYT: Fizik — Enerji-Momentum: impuls, çarpışmalar. 20 soru.',
      studyHours: '7 saat',
      motivationNote: 'Momentum çarpışma soruları çok çıkıyor.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 19),
      dayName: 'Salı',
      tytContent:
          'Türkçe: Paragraf + dil bilgisi karışık 30 soru. Mat: Analitik geometri TYT.',
      aytContent:
          'AYT: Bio — Kan grupları: A/B kodominant, O resesif. 20 soru.',
      studyHours: '7 saat',
      motivationNote: 'Kendini zorlandığın konularda küçük hedeflerle ilerlet.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 20),
      dayName: 'Çarşamba',
      tytContent: 'Mat: TYT sayı problemleri + geometri karışık 30 soru.',
      aytContent: 'AYT: Kimya — Asit-Baz: pH=-log[H⁺], Kw=10⁻¹⁴. 20 soru.',
      studyHours: '7 saat',
      motivationNote: 'pH hesabı en çok çıkan AYT kimya sorusu.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 21),
      dayName: 'Perşembe',
      tytContent:
          'Türkçe: Zayıf konular tekrar. Mat: Fonksiyon + denklem karışık 25 soru.',
      aytContent: 'AYT: Bio — Sinir sistemi: nöron, refleks yayı. 20 soru.',
      studyHours: '7 saat',
      motivationNote:
          'Sinir sisteminde yapıların görevlerini karşılaştırmalı tekrar et.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 22),
      dayName: 'Cuma',
      tytContent:
          'Sosyal: Tüm sosyal karışık 20 soru. Mat: Geometri son eksik konular.',
      aytContent: 'AYT: Kimya — Kimyasal Denge: Kc, Le Chatelier. 20 soru.',
      studyHours: '7 saat',
      motivationNote:
          'Le Chatelier ilkesini farklı denge değişimleri üzerinde uygula.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 23),
      dayName: 'Cumartesi',
      tytContent:
          'TYT Türkçe: 40 soru (45 dk). TYT Mat: 40 soru (55 dk). Analiz et.',
      aytContent: 'AYT: Fizik — Elektrik: Coulomb, kondansatör. 20 soru.',
      studyHours: '8 saat',
      motivationNote: 'Tam sınav hızında çözme pratiği.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 24),
      dayName: 'Pazar',
      tytContent:
          '📘 DENEME 7 — TYT tam + AYT TAM (180 dk). İlk tam AYT! Hedef: TYT ~48, AYT ~15.',
      aytContent: '—',
      studyHours: '135+180 dk',
      motivationNote: 'AYT sırasını uygula: Bio → Kim → Fiz → Mat!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 25),
      dayName: 'Pazartesi',
      tytContent:
          'Deneme 7 analizi — AYT\'de en düşük hangi ders? Ona bu hafta 3 gün ver.',
      aytContent: 'AYT: Düşük dersin zayıf konusu.',
      studyHours: '7 saat',
      motivationNote: '70. gün! 25 gün kaldı!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 26),
      dayName: 'Salı',
      tytContent:
          'Mat: TYT problem tekrar 30 soru. Türkçe: Paragraf 20 soru süre tutarak.',
      aytContent:
          'AYT: Bio — Hormonal sistem: hipofiz, tiroit, pankreas. 20 soru.',
      studyHours: '7 saat',
      motivationNote:
          'Pankreas hormonlarının görevlerini karşılaştırmalı çalış.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 27),
      dayName: 'Çarşamba',
      tytContent:
          'Fen: TYT Fen tam tekrar 20 soru. Sosyal: TYT Sosyal tam tekrar 20 soru.',
      aytContent: 'AYT: Mat — Türev sıfırdan: xⁿ→nxⁿ⁻¹. Kolay sorular sadece.',
      studyHours: '7 saat',
      motivationNote: 'Türev sadece kolay soruları çöz!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 28),
      dayName: 'Perşembe',
      tytContent:
          '📘 DENEME 8 — Sadece TYT. Hedef: ~50 net. Sabah erken başla!',
      aytContent: '—',
      studyHours: '135 dk + analiz',
      motivationNote: '50 net geçti mi? Büyük baraj bu!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 29),
      dayName: 'Cuma',
      tytContent:
          'Deneme 8 analizi. Türkçe: Zayıf konu tekrar. Mat: Geometri son eksikler.',
      aytContent: 'AYT: Kimya — Elektrokimya: oksidasyon/indirgeme. 15 soru.',
      studyHours: '7 saat',
      motivationNote: 'Yanlışlarını sınıflandır, benzer sorularla pekiştir.',
    ),
    DailyLog(
      date: DateTime(2026, 5, 30),
      dayName: 'Cumartesi',
      tytContent:
          'Mat: TYT karışık 40 soru. Türkçe: 40 soru. Her ikisi süre tutarak.',
      aytContent:
          'AYT: Bio — Fotosentez detay: ışık reaksiyonu, Calvin. 15 soru.',
      studyHours: '8 saat',
      motivationNote: '75. gün! 20 gün kaldı. Son sprint!',
    ),
    DailyLog(
      date: DateTime(2026, 5, 31),
      dayName: 'Pazar',
      tytContent:
          '📘 DENEME 9 — Sadece AYT tam (180 dk). Hedef: ~17 net. Bio>Kim>Fiz>Mat sırası!',
      aytContent: '—',
      studyHours: '180 dk + analiz',
      motivationNote: 'AYT\'yi ayrı da çözebiliyorsun artık.',
    ),
    DailyLog(
      date: DateTime(2026, 6, 1),
      dayName: 'Pazartesi',
      tytContent:
          'Deneme 9 AYT analizi — soru seçimi doğru mu? Kolay soruları atladın mı?',
      aytContent: 'AYT: Düşük dersin zayıf konusu tekrar.',
      studyHours: '7 saat',
      motivationNote: 'Soru seçimi becerisi çok önemli!',
    ),
    DailyLog(
      date: DateTime(2026, 6, 2),
      dayName: 'Salı',
      tytContent: 'TYT: Türkçe 30 + Mat 30 soru. Sadece orta zorluk sorular.',
      aytContent: 'AYT: Kimya — Organik kimya: alkan/alken/alkin. 15 soru.',
      studyHours: '7 saat',
      motivationNote:
          'Organik kimyada temel adlandırma ve yapı ilişkilerini örneklerle çalış.',
    ),
    DailyLog(
      date: DateTime(2026, 6, 3),
      dayName: 'Çarşamba',
      tytContent: 'TYT: Fen 20 + Sosyal 20 soru. Zayıf konulara odaklan.',
      aytContent:
          'AYT: Fizik — Dalgalar-Optik: mercekler, 1/f=1/do+1/di. 15 soru.',
      studyHours: '7 saat',
      motivationNote: 'Mercek formülünü mutlaka ezberle.',
    ),
    DailyLog(
      date: DateTime(2026, 6, 4),
      dayName: 'Perşembe',
      tytContent:
          '📘 DENEME 10 — TYT tam. Hedef: ~52 net. 50 geçtiyse çok iyi!',
      aytContent: '—',
      studyHours: '135 dk + analiz',
      motivationNote: '80. gün! 15 gün kaldı!',
    ),
    DailyLog(
      date: DateTime(2026, 6, 5),
      dayName: 'Cuma',
      tytContent:
          'Deneme 10 analizi. YENİ KONU BİTTİ — bundan sonra sadece tekrar!',
      aytContent:
          'AYT: Bio — Solunum detay: glikoliz, Krebs, ETS, 38 ATP. 15 soru.',
      studyHours: '7 saat',
      motivationNote: 'Bu haftadan sonra yeni konu çalışma!',
    ),
    DailyLog(
      date: DateTime(2026, 6, 6),
      dayName: 'Cumartesi',
      tytContent: 'TYT: Türkçe 40 + Mat 40 + Fen 20 + Sos 20 — tam süre.',
      aytContent:
          'AYT: Mat — Fonksiyon+Parabol+Logaritma karışık 25 soru tekrar.',
      studyHours: '8 saat',
      motivationNote: 'Son sprint başladı!',
    ),
    DailyLog(
      date: DateTime(2026, 6, 7),
      dayName: 'Pazar',
      tytContent:
          '📘 DENEME 11 — TYT TAM + AYT TAM. Tam gün sınav simülasyonu!',
      aytContent: '—',
      studyHours: '135+180 dk',
      motivationNote: 'Tam simülasyon! Araya 1 saat mola ver.',
    ),
    DailyLog(
      date: DateTime(2026, 6, 8),
      dayName: 'Pazartesi',
      tytContent:
          'Deneme 11 analizi — SAY puanını hesapla. Başlangıçla karşılaştır!',
      aytContent: 'AYT: Zayıf konu tekrar.',
      studyHours: '7 saat',
      motivationNote: 'Başlangıca göre ne kadar ilerlediğini gör!',
    ),
    DailyLog(
      date: DateTime(2026, 6, 9),
      dayName: 'Salı',
      tytContent:
          'TYT: Türkçe zayıf konu + 20 soru. Mat: Problemler tekrar + 20 soru.',
      aytContent: 'AYT: Kimya — Mol + Asit-Baz tekrar 20 soru.',
      studyHours: '7 saat',
      motivationNote: 'Son haftada sadece tekrar!',
    ),
    DailyLog(
      date: DateTime(2026, 6, 10),
      dayName: 'Çarşamba',
      tytContent: 'TYT: Fen 20 + Sosyal 20 soru tekrar. Mat: Geometri 20 soru.',
      aytContent: 'AYT: Bio — Mitoz+Mayoz+Mendel karışık 20 soru. Son tekrar.',
      studyHours: '7 saat',
      motivationNote: 'Kendin için yapılan her soru sayılır.',
    ),
    DailyLog(
      date: DateTime(2026, 6, 11),
      dayName: 'Perşembe',
      tytContent:
          '📘 DENEME 12 — TYT tam. Hedef: ~55 net. Bu haftanın son denemesi!',
      aytContent: '—',
      studyHours: '135 dk + analiz',
      motivationNote: '55 net = hedefe ulaştın demek!',
    ),
    DailyLog(
      date: DateTime(2026, 6, 12),
      dayName: 'Cuma',
      tytContent:
          'Deneme 12 analizi. Dikkatsizlik hatası mı, konu eksikliği mi?',
      aytContent: 'AYT: Fizik — Dinamik+Momentum karışık 20 soru. Son tekrar.',
      studyHours: '6 saat',
      motivationNote: 'Son hafta stresi normal, nefes al.',
    ),
    DailyLog(
      date: DateTime(2026, 6, 13),
      dayName: 'Cumartesi',
      tytContent:
          'TYT: Türkçe 40 soru (süre: 40 dk). Mat: 40 soru (süre: 50 dk). Hedefi tuttur.',
      aytContent: 'AYT: Mat — Fonksiyon+Parabol+Polinomlar tekrar 20 soru.',
      studyHours: '7 saat',
      motivationNote: 'Sınav hızını koru.',
    ),
    DailyLog(
      date: DateTime(2026, 6, 14),
      dayName: 'Pazar',
      tytContent:
          '📘 SON DENEME (D13) — TYT + AYT tam. Hedef: TYT ~55, AYT ~20.',
      aytContent: '—',
      studyHours: '135+180 dk',
      motivationNote: 'Son deneme! Başlangıçla karşılaştır 😊',
    ),
    DailyLog(
      date: DateTime(2026, 6, 15),
      dayName: 'Pazartesi',
      tytContent:
          'Son Deneme analizi. Formüller gözden geçir. YENİ KONU KESINLIKLE YOK.',
      aytContent: 'AYT: Sadece en sevdiğin AYT konusunu hafifçe tekrar.',
      studyHours: '5 saat',
      motivationNote: 'Artık strateji zamanı, yeni şey öğrenme!',
    ),
    DailyLog(
      date: DateTime(2026, 6, 16),
      dayName: 'Salı',
      tytContent:
          'TYT: Sadece en zayıf 1 konu, 15 soru. Türkçe: Paragraf 10 soru. Hafif çalışma.',
      aytContent: 'AYT: Bio veya Kim — sadece 10 soru. Beyin yorma.',
      studyHours: '4 saat',
      motivationNote: 'Sınava 4 gün kaldı. Beyin dinlenmeli!',
    ),
    DailyLog(
      date: DateTime(2026, 6, 17),
      dayName: 'Çarşamba',
      tytContent:
          'Formül kağıdı hazırla: Mat, Fizik, Kimya formülleri — tek sayfada.',
      aytContent:
          'AYT: Formüller tekrar — log, trig, dizi formülleri gözden geçir.',
      studyHours: '3 saat',
      motivationNote: 'Formül kağıdı çok işe yarar.',
    ),
    DailyLog(
      date: DateTime(2026, 6, 18),
      dayName: 'Perşembe',
      tytContent:
          'Çok hafif çalışma: sadece 10 Türkçe + 10 Mat soru. Erken uyu!',
      aytContent: 'AYT sırası = Bio→Kim→Fiz→Mat. Bunu aklına yerleştir.',
      studyHours: '2 saat',
      motivationNote: 'En önemli şey bugün iyi uyumak!',
    ),
    DailyLog(
      date: DateTime(2026, 6, 19),
      dayName: 'Cuma',
      tytContent:
          'SINAV HAZIRLIĞI: Sınav malzemeleri hazırla (kalem, silgi, kalemtıraş, nüfus cüzdanı).',
      aytContent: 'Hiçbir şey çalışma. Sadece dinlen.',
      studyHours: '0 saat',
      motivationNote: 'Yarın SINAV! Her şeyi yaptın. Güven kendine! 🏆',
    ),
  ];

  if (targetDate == null) return _withCoreProgressIds(logs);
  final normalizedTarget = DateTime(
    targetDate.year,
    targetDate.month,
    targetDate.day,
  );
  final shiftDays = normalizedTarget.difference(DateTime(2026, 6, 20)).inDays;
  return _withCoreProgressIds(
    logs.map((log) {
      final shiftedDate = log.date.add(Duration(days: shiftDays));
      final motivation = log.motivationNote.replaceAllMapped(
        RegExp(r'(\d+) gün kaldı'),
        (_) => '${normalizedTarget.difference(shiftedDate).inDays} gün kaldı',
      );
      return DailyLog(
        date: shiftedDate,
        dayName: turkishWeekdayName(shiftedDate),
        tytContent: log.tytContent,
        aytContent: log.aytContent,
        studyHours: log.studyHours,
        motivationNote: motivation,
      );
    }).toList(),
  );
}

List<DailyLog> getPersonalizedDailySchedule({
  required DateTime targetDate,
  required StudySchedulePreferences preferences,
  Set<String> completedTaskIds = const {},
  Set<String> completedTaskIdsForToday = const {},
  DateTime? today,
}) {
  final now = today ?? DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final target = DateTime(targetDate.year, targetDate.month, targetDate.day);
  if (target.isBefore(start)) return getDailySchedule(targetDate: target);

  final templateTasks = getDailySchedule();
  final completedTodaySummaries = templateTasks
      .where(
        (task) => completedTaskIdsForToday.contains(task.progressIds.single),
      )
      .map((task) {
        final sections = ['TYT: ${task.tytContent}'];
        if (task.aytContent != '—') sections.add('AYT: ${task.aytContent}');
        return sections.join('\n');
      })
      .toList();
  final core = templateTasks
      .where((task) => !completedTaskIds.contains(task.progressIds.single))
      .toList();
  final studyDates = <DateTime>[];
  final allDates = <DateTime>[];
  for (
    var date = start;
    !date.isAfter(target);
    date = DateTime(date.year, date.month, date.day + 1)
  ) {
    allDates.add(date);
    if (preferences.availableWeekdays.contains(date.weekday)) {
      studyDates.add(date);
    }
  }

  if (studyDates.isEmpty) {
    return [
      for (var index = 0; index < allDates.length; index++)
        _restDay(
          allDates[index],
          completedTaskSummaries: index == 0
              ? completedTodaySummaries
              : const [],
        ),
    ];
  }
  final tasksPerDate = <String, List<DailyLog>>{};
  if (studyDates.length >= core.length) {
    for (var i = 0; i < core.length; i++) {
      tasksPerDate[_dateKey(studyDates[i])] = [core[i]];
    }
  } else {
    // Compress all 95 existing sessions into the available study days without
    // dropping tasks or changing their stable day_001..day_095 identities.
    for (var slot = 0; slot < studyDates.length; slot++) {
      final first = slot * core.length ~/ studyDates.length;
      final afterLast = (slot + 1) * core.length ~/ studyDates.length;
      tasksPerDate[_dateKey(studyDates[slot])] = core.sublist(first, afterLast);
    }
  }

  final studyDateIndexes = {
    for (var i = 0; i < studyDates.length; i++) _dateKey(studyDates[i]): i,
  };
  final result = <DailyLog>[];
  for (final date in allDates) {
    final key = _dateKey(date);
    final assigned = tasksPerDate[key];
    if (assigned != null && assigned.isNotEmpty) {
      result.add(
        _combineCoreTasks(
          date,
          assigned,
          preferences.dailyStudyMinutes,
          completedTaskSummaries: key == _dateKey(start)
              ? completedTodaySummaries
              : const [],
        ),
      );
      continue;
    }

    final isAvailable = preferences.availableWeekdays.contains(date.weekday);
    if (!isAvailable) {
      result.add(
        _restDay(
          date,
          completedTaskSummaries: key == _dateKey(start)
              ? completedTodaySummaries
              : const [],
        ),
      );
      continue;
    }

    final slot = studyDateIndexes[key]!;
    final phase = slot % 3;
    final reviewId = 'review_$key';
    final content = switch (phase) {
      0 => (
        'Önceki konulardan kısa tekrar yap; takıldığın başlıkları not et.',
        'Dersler veya Zayıf Konular bölümünden bir eksik seçip çalış.',
      ),
      1 => (
        'TYT: Türkçe ve Matematikten süre tutarak soru çöz; yanlışlarını incele.',
        'AYT: Alan derslerinden soru çöz; yanlış yaptığın konuları belirle.',
      ),
      _ => (
        'Karma TYT mini denemesi çöz veya son denemedeki yanlışlarını tamamla.',
        'AYT konularını pekiştir; haftalık ilerlemeni gözden geçir.',
      ),
    };
    result.add(
      DailyLog(
        date: date,
        dayName: turkishWeekdayName(date),
        tytContent: content.$1,
        aytContent: content.$2,
        studyHours: _dailyTargetLabel(preferences.dailyStudyMinutes),
        motivationNote:
            'Sınava kadar kalan dönemi tekrar ve eksik kapatmaya ayır.',
        progressIds: [reviewId],
        completedTaskSummaries: key == _dateKey(start)
            ? completedTodaySummaries
            : const [],
      ),
    );
  }
  return result;
}

DailyLog _restDay(
  DateTime date, {
  List<String> completedTaskSummaries = const [],
}) => DailyLog(
  date: date,
  dayName: turkishWeekdayName(date),
  tytContent: 'Dinlenme günü. Enerjini toparla; istersen hafif tekrar yap.',
  aytContent: '—',
  studyHours: 'Dinlenme',
  motivationNote: 'Dinlenme de planın bir parçası.',
  isRestDay: true,
  completedTaskSummaries: completedTaskSummaries,
);

List<DailyLog> _withCoreProgressIds(List<DailyLog> logs) => [
  for (var i = 0; i < logs.length; i++)
    _copyWithProgressIds(logs[i], [
      'day_${(i + 1).toString().padLeft(3, '0')}',
    ]),
];

DailyLog _copyWithProgressIds(DailyLog log, List<String> progressIds) =>
    DailyLog(
      date: log.date,
      dayName: log.dayName,
      tytContent: log.tytContent,
      aytContent: log.aytContent,
      studyHours: log.studyHours,
      motivationNote: log.motivationNote,
      isCompleted: log.isCompleted,
      solvedQuestions: log.solvedQuestions,
      weakTopicNotes: log.weakTopicNotes,
      completedAt: log.completedAt,
      activityAt: log.activityAt,
      progressIds: progressIds,
      completedTaskSummaries: log.completedTaskSummaries,
      isRestDay: log.isRestDay,
    );

DailyLog _combineCoreTasks(
  DateTime date,
  List<DailyLog> tasks,
  int minutes, {
  List<String> completedTaskSummaries = const [],
}) {
  final label = _dailyTargetLabel(minutes);
  return DailyLog(
    date: date,
    dayName: turkishWeekdayName(date),
    tytContent: tasks.length == 1
        ? tasks.single.tytContent
        : tasks
              .asMap()
              .entries
              .map((e) => '${e.key + 1}. ${e.value.tytContent}')
              .join('\n\n'),
    aytContent: tasks.length == 1
        ? tasks.single.aytContent
        : tasks
              .asMap()
              .entries
              .map((e) => '${e.key + 1}. ${e.value.aytContent}')
              .where((text) => !text.endsWith('—'))
              .join('\n\n'),
    studyHours: tasks.length == 1 ? label : '$label · ${tasks.length} görev',
    motivationNote: tasks.length == 1
        ? tasks.single.motivationNote
        : 'Hedef tarihine göre görevler birleştirildi. Önceliği konu ve soru çalışmalarına ver.',
    progressIds: tasks.expand((task) => task.progressIds).toList(),
    completedTaskSummaries: completedTaskSummaries,
  );
}

String _dailyTargetLabel(int minutes) => minutes < 60
    ? 'Hedef $minutes dk'
    : 'Hedef ${minutes ~/ 60} sa${minutes % 60 == 0 ? '' : ' ${minutes % 60} dk'}';

String _dateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
