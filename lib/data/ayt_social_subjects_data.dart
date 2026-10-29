import '../models/subject.dart';
import '../models/topic.dart';

// EA/SÖZ AYT dersleri. Kimlikler Kaynaklarım'daki ders bağlarıyla aynıdır
// (yks_course_<test>); böylece önceden eklenen kaynaklar bu derslere bağlanır.
// Konu başlıkları MEB OGM yardımcı kaynaklarının içindekiler sayfalarından
// alındı. Soru sayıları ÖSYM dağılımı değil, planlama ağırlığıdır.

const _tdeUrl =
    'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/tde/files/basic-html/page6.html';
const _tdeLabel = 'MEB OGM Materyal · 3 Adım AYT Türk Dili ve Edebiyatı';
const _tarihUrl =
    'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/tarih/files/basic-html/page6.html';
const _tarihLabel = 'MEB OGM Materyal · Dört Dörtlük AYT Tarih';
const _cografyaUrl =
    'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/cografya/files/basic-html/page8.html';
const _cografyaLabel = 'MEB OGM Materyal · Dört Dörtlük AYT Coğrafya';

List<Subject> getAytSocialSubjects() {
  return [
    // ═══════════════════════════════════════════════
    // AYT EDEBİYAT — 13 Konu, 24 Soru (EA, SÖZ)
    // ═══════════════════════════════════════════════
    Subject(
      id: 'yks_course_ayt_edebiyat',
      name: 'AYT Edebiyat',
      emoji: '📜',
      type: 'AYT',
      totalQuestions: 24,
      areas: const {'ea', 'soz'},
      tip:
          'Şiir bilgisi ve edebî sanatları önce öğren; ardından dönemleri sırayla çalışıp her dönem için temsilci, eser ve özellik tablosu çıkar. Soru ağırlıkları planlama tahminidir.',
      topics: [
        Topic(
          id: 'ayt_edb_1',
          name: 'Edebiyatın Temel Kavramları ve Metin Türleri',
          description:
              'Edebiyat dili sanat amacı taşır, öğretici dil bilgi aktarır. Metinler coşku ve heyecanı dile getiren (şiir), olay çevresinde gelişen (masal, hikâye, roman), göstermeye bağlı (tiyatro) ve öğretici metinler olarak sınıflandırılır. Bir metni incelerken tür, dönem, tema ve dil özellikleri birlikte değerlendirilir.',
          sourceLabel: '$_tdeLabel, İçindekiler: Giriş (s. 11)',
          sourceUrl: _tdeUrl,
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟡 ORTA',
          estimatedDays: 1,
        ),
        Topic(
          id: 'ayt_edb_2',
          name: 'Şiir Bilgisi ve Edebî Sanatlar',
          description:
              'Nazım birimi beyit, dörtlük veya benttir. Ölçü hece, aruz ya da serbest olabilir. Kafiye dize sonlarındaki ses benzerliğidir (yarım, tam, zengin, cinaslı); redif aynı görevdeki ek veya sözcüklerin tekrarıdır. Başlıca sanatlar: teşbih, istiare, mecazımürsel, kinaye, tevriye, teşhis, intak, tezat, tenasüp, telmih, hüsnütalil, tecahülüarif ve mübalağa.',
          sourceLabel: '$_tdeLabel, İçindekiler: Şiir Bilgisi (s. 29)',
          sourceUrl: _tdeUrl,
          questionCount: 4,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_edb_3',
          name: 'İslamiyet Öncesi Türk Şiiri ve Geçiş Dönemi',
          description:
              'Sözlü dönem türleri koşuk, sagu ve savdır; ölçü hecedir. Yazılı dönemin ilk örnekleri Göktürk (Orhun) Kitabeleri ve Uygur metinleridir. Geçiş dönemi eserleri: Kutadgu Bilig (Yusuf Has Hacib, aruzla yazılmış mesnevi), Divanu Lugati\'t-Türk (Kaşgarlı Mahmud), Atabetü\'l-Hakayık (Edip Ahmet) ve Divan-ı Hikmet (Ahmet Yesevi).',
          sourceLabel:
              '$_tdeLabel, İçindekiler: İslamiyet Öncesi Türk Şiiri - Geçiş Dönemi Eserleri (s. 63)',
          sourceUrl: _tdeUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_edb_4',
          name: 'Halk Şiiri',
          description:
              'Halk şiiri anonim, âşık ve tekke-tasavvuf olmak üzere üç kolda incelenir; genellikle hece ölçüsü ve dörtlük kullanılır. Anonim türler: mani, türkü, ninni, ağıt. Âşık şiiri türleri: koşma, semai, varsağı, destan (Karacaoğlan, Dadaloğlu). Tekke şiiri türleri: ilahi, nefes, nutuk, devriye, şathiye (Yunus Emre, Pir Sultan Abdal).',
          sourceLabel: '$_tdeLabel, İçindekiler: Halk Şiiri (s. 75)',
          sourceUrl: _tdeUrl,
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_edb_5',
          name: 'Divan Şiiri',
          description:
              'Divan şiirinde aruz ölçüsü, beyit nazım birimi ve kalıplaşmış mazmunlar kullanılır; dil Arapça ve Farsça unsurlarla yoğundur. Nazım şekilleri: gazel, kaside, mesnevi, rubai, tuyuğ, murabba, şarkı. Başlıca şairler Fuzuli, Baki, Nef\'i, Nedim ve Şeyh Galip\'tir.',
          sourceLabel: '$_tdeLabel, İçindekiler: Divan Şiiri (s. 97)',
          sourceUrl: _tdeUrl,
          questionCount: 2,
          difficulty: '🔴 Zor',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_edb_6',
          name: 'Tanzimat, Servetifünun ve Fecriati Şiiri',
          description:
              'Tanzimat edebiyatı 1860\'ta Tercüman-ı Ahval ile başlar; I. kuşak (Şinasi, Namık Kemal, Ziya Paşa) toplum için sanatı, II. kuşak (Recaizade Mahmut Ekrem, Abdülhak Hâmit) sanat için sanatı benimser. Servetifünun (1896-1901) şairleri Tevfik Fikret ve Cenap Şahabettin ağır bir dil, sone ve serbest müstezat kullanır. Fecriati (1909) "Sanat şahsi ve muhteremdir" görüşünü savunur; Ahmet Haşim sembolizme yakındır.',
          sourceLabel:
              '$_tdeLabel, İçindekiler: Tanzimat, Servetifünun ve Fecriati Dönemi Şiiri (s. 109-133)',
          sourceUrl: _tdeUrl,
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_edb_7',
          name: 'Millî Edebiyat ve Cumhuriyet Dönemi Şiiri',
          description:
              'Millî Edebiyat 1911\'de Genç Kalemler dergisi ve "Yeni Lisan" makalesiyle sade Türkçeyi ve hece ölçüsünü öne çıkarır. Cumhuriyet döneminde Beş Hececiler, saf şiir (Ahmet Hamdi Tanpınar), toplumcu şiir (Nâzım Hikmet), Garip hareketi (Orhan Veli, Oktay Rifat, Melih Cevdet Anday; ölçü ve kafiyeye karşı) ve II. Yeni (Cemal Süreya, Edip Cansever; imge ve anlam kapalılığı) başlıca eğilimlerdir.',
          sourceLabel:
              '$_tdeLabel, İçindekiler: Millî Edebiyat ve Cumhuriyet Dönemi Şiiri (s. 133-193)',
          sourceUrl: _tdeUrl,
          questionCount: 2,
          difficulty: '🔴 Zor',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_edb_8',
          name: 'Masal, Fabl, Destan ve Efsane',
          description:
              'Masal olağanüstü olayları kalıp ifadelerle anlatır; fablda hayvanlar konuşturularak ders verilir. Destan bir milletin ortak hafızasındaki kahramanlık olaylarını anlatır; doğal destanlar halk arasında oluşur (Oğuz Kağan, Ergenekon), yapay destanlar bir şair tarafından yazılır. Efsane bir yer, varlık veya olayın inanışla açıklanmasıdır.',
          sourceLabel:
              '$_tdeLabel, İçindekiler: Masal - Fabl; Destan - Efsane (s. 205-217)',
          sourceUrl: _tdeUrl,
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟡 ORTA',
          estimatedDays: 1,
        ),
        Topic(
          id: 'ayt_edb_9',
          name: 'Hikâye ve Halk Hikâyesi Geleneği',
          description:
              'Olay hikâyesi (Maupassant tarzı) serim-düğüm-çözüm planına dayanır; durum hikâyesi (Çehov tarzı) bir kesiti anlatır, Türk edebiyatında Sait Faik ile öne çıkar. Dede Korkut Hikâyeleri Oğuzların hayatını anlatır. Halk hikâyeleri (Kerem ile Aslı) nazım-nesir karışıktır. Modern hikâyenin ilk örnekleri Ahmet Mithat\'ın Letâif-i Rivâyât\'ıdır; Millî Edebiyat\'ta Ömer Seyfettin öne çıkar.',
          sourceLabel:
              '$_tdeLabel, İçindekiler: Hikâye ve dönemlere göre hikâye (s. 229-287)',
          sourceUrl: _tdeUrl,
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_edb_10',
          name: 'Roman',
          description:
              'İlk çeviri roman Telemak (Yusuf Kamil Paşa), ilk yerli roman Taaşşuk-ı Talat ve Fitnat (Şemsettin Sami), ilk edebî roman İntibah (Namık Kemal), ilk realist roman Araba Sevdası\'dır (Recaizade Mahmut Ekrem). Servetifünun\'da Halit Ziya Uşaklıgil (Mai ve Siyah, Aşk-ı Memnu) Batılı teknikte roman yazar. Cumhuriyet döneminde toplumcu gerçekçi, millî-dinî, bireyin iç dünyasını esas alan ve modernist/postmodern romanlar ayrılır.',
          sourceLabel:
              '$_tdeLabel, İçindekiler: Roman ve dönemlere göre roman (s. 297-355)',
          sourceUrl: _tdeUrl,
          questionCount: 3,
          difficulty: '🔴 Zor',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_edb_11',
          name: 'Tiyatro',
          description:
              'Geleneksel Türk tiyatrosu Karagöz, ortaoyunu, meddah ve köy seyirlik oyunlarından oluşur. Batılı anlamda ilk yerli oyun Şinasi\'nin Şair Evlenmesi\'dir; Namık Kemal\'in Vatan yahut Silistre\'si sahnelenen önemli bir eserdir. Tragedya, komedi ve dram temel türlerdir; Cumhuriyet ve 1950 sonrası tiyatroda toplumsal ve bireysel temalar işlenir.',
          sourceLabel:
              '$_tdeLabel, İçindekiler: Tiyatro ve dönemlere göre tiyatro (s. 367-403)',
          sourceUrl: _tdeUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_edb_12',
          name: 'Öğretici Metinler',
          description:
              'Makale bir düşünceyi kanıtlarla savunur; deneme kişisel görüşü kesinlik iddia etmeden anlatır (Montaigne). Fıkra gazete köşe yazısıdır; eleştiri bir eseri değerlendirir; söyleşi sohbet havasında yazılır. Anı yaşanmış olayları, gezi yazısı gezilen yerleri, biyografi bir kişinin hayatını anlatır; mektup ve günlük de öğretici türlerdendir.',
          sourceLabel: '$_tdeLabel, İçindekiler: Öğretici Metinler (s. 415)',
          sourceUrl: _tdeUrl,
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_edb_13',
          name: 'Edebî Akımlar',
          description:
              'Klasisizm akla ve kurallara bağlıdır (Racine, Molière); romantizm duyguyu ve özgürlüğü öne çıkarır (Victor Hugo). Realizm gözleme dayanır (Balzac, Flaubert); natüralizm deneysel yöntemi edebiyata uygular (Zola). Parnasizm şiirde biçim kusursuzluğunu, sembolizm ise telkin ve musikiyi önemser (Baudelaire, Mallarmé).',
          sourceLabel: '$_tdeLabel, İçindekiler: Edebî Akımlar (s. 453)',
          sourceUrl: _tdeUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // AYT TARİH-1 — 10 Konu, 10 Soru (EA, SÖZ)
    // ═══════════════════════════════════════════════
    Subject(
      id: 'yks_course_ayt_tarih1',
      name: 'AYT Tarih-1',
      emoji: '🏛️',
      type: 'AYT',
      totalQuestions: 10,
      areas: const {'ea', 'soz'},
      tip:
          'Olayları kronolojik sırayla ve neden-sonuç ilişkisiyle çalış; antlaşmaları tarih, taraf ve sonuçlarıyla tablo hâline getir. Soru ağırlıkları planlama tahminidir.',
      topics: [
        Topic(
          id: 'ayt_tar1_1',
          name: 'Tarih Bilimi ve İlk Uygarlıklar',
          description:
              'Tarih, olayları yer ve zaman göstererek kaynaklara dayanarak inceler; birinci el ve ikinci el kaynaklar ayrılır. Yazının Sümerlerce bulunması (MÖ 3200 dolayı) tarih çağlarını başlatır. Mezopotamya, Mısır ve Anadolu uygarlıkları (Hititler, Frigler, Lidyalılar) siyasi, hukuki ve ekonomik katkılarıyla incelenir.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: Tarih ve Zaman; İnsanlığın İlk Dönemleri (s. 9-19)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_tar1_2',
          name: 'Orta Çağ\'da Dünya ve İlk Türk Devletleri',
          description:
              'Kavimler Göçü (375) ve Batı Roma\'nın yıkılışı (476) Orta Çağ Avrupa\'sını şekillendirir; feodalite ve kilisenin gücü belirleyicidir. Asya Hun, Göktürk ve Uygur devletleri Türk siyasi tarihinin temelidir: Türk adı ilk kez Göktürklerde devlet adı olarak kullanılır, Uygurlar yerleşik hayata geçer.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: Orta Çağ\'da Dünya; İlk ve Orta Çağlarda Türk Dünyası (s. 29-41)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_tar1_3',
          name: 'İslam Medeniyeti ve İlk Türk-İslam Devletleri',
          description:
              'Hicret (622) İslam takviminin başlangıcıdır; Dört Halife, Emeviler ve Abbasiler dönemi izlenir. Talas Savaşı (751) Türk-Arap ilişkilerinde dönüm noktasıdır. Karahanlılar ilk Müslüman Türk devletidir; Gazneliler ve Büyük Selçuklular (Dandanakan 1040, Malazgirt 1071) Türk-İslam tarihinin temel devletleridir.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: İslam Medeniyetinin Doğuşu; Türklerin İslamiyet\'i Kabulü (s. 53-65)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_tar1_4',
          name: 'Selçuklu Türkiyesi',
          description:
              'Malazgirt sonrası Anadolu\'da kurulan Türkiye Selçukluları, Miryokefalon (1176) ile Anadolu\'nun Türk yurdu olduğunu pekiştirir; Kösedağ (1243) Moğol hâkimiyetini başlatır. Kervansaraylar, ahilik teşkilatı ve vakıflar ekonomik ve toplumsal hayatın temel kurumlarıdır.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: Yerleşme ve Devletleşme Sürecinde Selçuklu Türkiyesi (s. 79)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_tar1_5',
          name: 'Beylikten Devlete Osmanlı (1302-1453)',
          description:
              'Koyunhisar (1302) ilk önemli zaferdir; Rumeli\'ye geçiş, Kosova (1389) ve Ankara Savaşı (1402) ile başlayan Fetret Devri kuruluşun dönüm noktalarıdır. İstanbul\'un fethi (1453) dönemi kapatır. Tımar sistemi, devşirme ve Kapıkulu ordusu askerî yapının; medrese ve vakıflar medeniyetin temelidir.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: Beylikten Devlete Osmanlı Siyaseti, Savaşçılar ve Askerler, Medeniyeti (s. 91-115)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_tar1_6',
          name: 'Dünya Gücü Osmanlı ve Klasik Düzen (1453-1595)',
          description:
              'Mercidabık (1516) ve Ridaniye (1517) ile Mısır alınır ve halifelik Osmanlı\'ya geçer; Mohaç (1526) ve Preveze (1538) Kanuni dönemi zaferleridir. Divan-ı Hümayun merkez teşkilatın, millet sistemi ve askerî-reaya ayrımı klasik toplum düzeninin temelidir.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: Dünya Gücü Osmanlı; Sultan ve Merkez Teşkilatı; Klasik Çağda Toplum Düzeni (s. 127-153)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_tar1_7',
          name: 'Değişen Dünya Dengeleri ve Avrupa (1595-1774)',
          description:
              'Zitvatorok (1606) Avusturya ile eşitliği, Karlofça (1699) ilk büyük toprak kaybını getirir; Küçük Kaynarca (1774) Kırım\'ın bağımsızlığı ve Rusya\'ya ayrıcalıklarla dönemi kapatır. Avrupa\'da Rönesans, Reform, coğrafi keşifler ve bilimsel gelişmeler Osmanlı\'yı ekonomik ve askerî açıdan etkiler.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: Değişen Dünya Dengeleri Karşısında Osmanlı; Değişim Çağında Avrupa ve Osmanlı (s. 165-175)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_tar1_8',
          name: 'Devrimler Çağı ve Denge Stratejisi (1774-1914)',
          description:
              'Fransız İhtilali milliyetçiliği, Sanayi Devrimi ham madde ve pazar arayışını yayar. Osmanlı\'da Nizam-ı Cedid, Sened-i İttifak (1808), Tanzimat (1839), Islahat (1856) ve I. Meşrutiyet (1876) devlet-toplum ilişkisini değiştirir. Dış politikada denge stratejisi izlenir: Hünkâr İskelesi (1833), Paris (1856), Berlin (1878).',
          sourceLabel:
              '$_tarihLabel, İçindekiler: Devrimler Çağı; Denge Stratejisi; XIX. ve XX. Yüzyılda Sosyo-Ekonomik Hayat (s. 185-211)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🔴 Zor',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_tar1_9',
          name: '20. Yüzyıl Başında Osmanlı ve Millî Mücadele',
          description:
              'II. Meşrutiyet (1908), Trablusgarp ve Balkan Savaşları ile I. Dünya Savaşı cepheleri Mondros Mütarekesi\'ne (30 Ekim 1918) götürür. Millî Mücadele: Samsun (19 Mayıs 1919), Amasya Genelgesi, Erzurum ve Sivas Kongreleri, Misak-ı Millî, TBMM\'nin açılışı (23 Nisan 1920), Sakarya ve Büyük Taarruz, Mudanya ve Lozan (24 Temmuz 1923).',
          sourceLabel:
              '$_tarihLabel, İçindekiler: 20. Yüzyıl Başlarında Osmanlı Devleti ve Dünya; Millî Mücadele (s. 225-235)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_tar1_10',
          name: 'Atatürkçülük ve Türk İnkılabı',
          description:
              'Saltanatın kaldırılması (1 Kasım 1922), Cumhuriyetin ilanı (29 Ekim 1923), halifeliğin kaldırılması ve Tevhid-i Tedrisat (1924), harf inkılabı (1928), Soyadı Kanunu ve kadınlara milletvekili seçme-seçilme hakkı (1934) başlıca inkılaplardır. Atatürk ilkeleri: cumhuriyetçilik, milliyetçilik, halkçılık, devletçilik, laiklik, inkılapçılık.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: Atatürkçülük ve Türk İnkılabı (s. 245)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // AYT COĞRAFYA-1 — 6 Konu, 6 Soru (EA, SÖZ)
    // ═══════════════════════════════════════════════
    Subject(
      id: 'yks_course_ayt_cografya1',
      name: 'AYT Coğrafya-1',
      emoji: '🗺️',
      type: 'AYT',
      totalQuestions: 6,
      areas: const {'ea', 'soz'},
      tip:
          'Türkiye ekonomisi konularını harita ve grafik üzerinde çalış; ürünlerin yetişme koşullarını ve yayılış alanlarını birlikte öğren. Soru ağırlıkları planlama tahminidir.',
      topics: [
        Topic(
          id: 'ayt_cog1_1',
          name: 'Biyoçeşitlilik, Ekosistem ve Çevre Sorunları',
          description:
              'Ekosistem canlılar ile cansız çevrenin etkileşimidir; enerji akışı üreticiden tüketicilere ve ayrıştırıcılara doğrudur. Biyoçeşitlilik iklim, yer şekilleri ve toprak gibi etkenlere bağlıdır. Hava, su ve toprak kirliliği, ormansızlaşma ve erozyon başlıca çevre sorunlarıdır.',
          sourceLabel:
              '$_cografyaLabel, İçindekiler: Biyoçeşitlilik ve Ekosistem; Çevre Sorunları (s. 9, 117)',
          sourceUrl: _cografyaUrl,
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_cog1_2',
          name: 'Nüfus Politikaları, Yerleşme ve Şehirler',
          description:
              'Ülkeler nüfus artışını hızlandıran veya yavaşlatan politikalar uygular; nüfus piramitleri bu politikaların sonuçlarını gösterir. Şehirlerin fonksiyonları (sanayi, ticaret, liman, turizm, yönetim) ve yerleşmelerin kuruluş yerini etkileyen doğal ve beşerî faktörler incelenir.',
          sourceLabel:
              '$_cografyaLabel, İçindekiler: Nüfus Politikaları, Yerleşme Özellikleri ve Şehirler (s. 23)',
          sourceUrl: _cografyaUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_cog1_3',
          name: 'Ekonomik Faaliyetler ve Doğal Kaynaklar',
          description:
              'Ekonomik faaliyetler birincil (tarım, madencilik), ikincil (sanayi) ve üçüncül (hizmet) olarak ayrılır. Üretim, dağıtım ve tüketim; doğal kaynakların dağılışı, ulaşım ve pazar koşullarıyla birlikte değerlendirilir.',
          sourceLabel:
              '$_cografyaLabel, İçindekiler: Üretim, Dağıtım, Tüketim ve Doğal Kaynaklar (s. 37)',
          sourceUrl: _cografyaUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_cog1_4',
          name: 'Türkiye\'de Tarım, Hayvancılık ve Ormancılık',
          description:
              'Tarımı iklim, yer şekilleri, toprak ve sulama olanakları etkiler. Ürünlerin yetişme koşulları ve başlıca üretim alanları (örneğin çay Doğu Karadeniz\'de, fındık Karadeniz kıyılarında, pamuk Çukurova, Ege ve Güneydoğu\'da) ile mera hayvancılığı ve orman varlığının dağılışı incelenir.',
          sourceLabel:
              '$_cografyaLabel, İçindekiler: Türkiye\'nin Ekonomi Politikaları; Tarım Ürünleri, Hayvancılık ve Ormancılık (s. 49-61)',
          sourceUrl: _cografyaUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_cog1_5',
          name: 'Türkiye\'de Madencilik, Enerji ve Sanayi',
          description:
              'Maden ve enerji kaynaklarının (kömür, bor, krom, petrol, hidroelektrik, rüzgâr, güneş, jeotermal) dağılışı ve kullanımı incelenir. Sanayinin kuruluş yerini ham madde, enerji, ulaşım, pazar ve iş gücü belirler; sanayi bölgeleri bu etkenlere göre yorumlanır.',
          sourceLabel:
              '$_cografyaLabel, İçindekiler: Türkiye\'de Madencilik, Enerji Kaynakları ve Sanayi (s. 75)',
          sourceUrl: _cografyaUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_cog1_6',
          name: 'Kültür Bölgeleri, Küresel Ticaret ve Uluslararası Örgütler',
          description:
              'Türk kültürünün yayılış alanları ve dünyadaki kültür bölgeleri; dil, din ve yaşam biçimi ölçütleriyle ayrılır. Küresel ticaret ve turizm akışları ile BM, NATO, AB, OECD ve İİT gibi uluslararası örgütlerin amaçları incelenir.',
          sourceLabel:
              '$_cografyaLabel, İçindekiler: Türk Kültürü ve Kültür Bölgeleri; Küresel Ticaret, Turizm ve Uluslararası Örgütler (s. 89-103)',
          sourceUrl: _cografyaUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // AYT TARİH-2 — 5 Konu (SÖZ)
    // ═══════════════════════════════════════════════
    Subject(
      id: 'yks_course_ayt_tarih2',
      name: 'AYT Tarih-2',
      emoji: '🌐',
      type: 'AYT',
      totalQuestions: 11,
      areas: const {'soz'},
      tip:
          'Tarih-2 testi Tarih-1 konularını da kapsar; bu bölüm yalnızca Çağdaş Türk ve Dünya Tarihi konularını ekler. Soru ağırlıkları planlama tahminidir.',
      topics: [
        Topic(
          id: 'ayt_tar2_1',
          name: 'İki Savaş Arasında Türkiye ve Dünya',
          description:
              '1929 Dünya Ekonomik Buhranı ve totaliter rejimlerin yükselişi dönemin temel gelişmeleridir. Türkiye Balkan Antantı (1934), Montrö Boğazlar Sözleşmesi (1936) ve Sadabat Paktı (1937) ile güvenlik arar; Hatay 1939\'da Türkiye\'ye katılır.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: İki Savaş Arasındaki Dönemde Türkiye ve Dünya (s. 257)',
          sourceUrl: _tarihUrl,
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_tar2_2',
          name: 'II. Dünya Savaşı Sürecinde Türkiye ve Dünya',
          description:
              'Savaş 1939\'da Almanya\'nın Polonya\'yı işgaliyle başlar, 1945\'te sona erer. Türkiye savaş boyunca tarafsızlığını korumaya çalışır ve savaşın sonunda Almanya\'ya savaş ilan eder. Savaşın sonunda Birleşmiş Milletler kurulur.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: II. Dünya Savaşı Sürecinde Türkiye ve Dünya (s. 267)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_tar2_3',
          name: 'II. Dünya Savaşı Sonrası ve Soğuk Savaş',
          description:
              'ABD ve SSCB arasındaki Soğuk Savaş\'ta Truman Doktrini ve Marshall Planı Batı blokunu destekler; NATO ve Varşova Paktı karşı karşıya gelir. Türkiye 1952\'de NATO\'ya girer; 1946\'da çok partili hayata geçilir, 1950 seçimleriyle iktidar değişir.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: II. Dünya Savaşı Sonrasında Türkiye ve Dünya (s. 277)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_tar2_4',
          name: 'Toplumsal Devrim Çağında Dünya ve Türkiye',
          description:
              '1960\'lar ve 1970\'lerde öğrenci hareketleri, bağımsızlık mücadeleleri ve 1973 petrol krizi dünyayı etkiler. Türkiye\'de bu dönemin önemli olaylarından biri 1974 Kıbrıs Barış Harekâtı\'dır; toplumsal ve ekonomik dönüşümler birlikte değerlendirilir.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: Toplumsal Devrim Çağında Dünya ve Türkiye (s. 287)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_tar2_5',
          name: '21. Yüzyılın Eşiğinde Türkiye ve Dünya',
          description:
              'SSCB\'nin 1991\'de dağılmasıyla Soğuk Savaş sona erer ve Orta Asya\'da bağımsız Türk cumhuriyetleri kurulur. Küreselleşme, bölgesel çatışmalar ve Türkiye\'nin Avrupa Birliği süreci dönemin başlıca konularıdır.',
          sourceLabel:
              '$_tarihLabel, İçindekiler: 21. Yüzyılın Eşiğinde Türkiye ve Dünya (s. 297)',
          sourceUrl: _tarihUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // AYT COĞRAFYA-2 — 6 Konu (SÖZ)
    // ═══════════════════════════════════════════════
    Subject(
      id: 'yks_course_ayt_cografya2',
      name: 'AYT Coğrafya-2',
      emoji: '🧭',
      type: 'AYT',
      totalQuestions: 11,
      areas: const {'soz'},
      tip:
          'Coğrafya-2 testi Coğrafya-1 konularını da kapsar; bu bölüm 12. sınıf konularını ekler. Soru ağırlıkları planlama tahminidir.',
      topics: [
        Topic(
          id: 'ayt_cog2_1',
          name: 'Ekstrem Doğa Olayları ve Küresel İklim Değişimi',
          description:
              'Kasırga, hortum, sel, kuraklık ve aşırı sıcaklık gibi ekstrem doğa olaylarının oluşumu ve etkileri incelenir. Sera gazlarının artışına bağlı küresel iklim değişimi; buzulların erimesi ve deniz seviyesinin yükselmesi gibi sonuçlarla değerlendirilir.',
          sourceLabel:
              '$_cografyaLabel, İçindekiler: Ekstrem Doğa Olayları ve Doğadaki Değişim (s. 131)',
          sourceUrl: _cografyaUrl,
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟡 ORTA',
          estimatedDays: 1,
        ),
        Topic(
          id: 'ayt_cog2_2',
          name: 'Geçmişten Geleceğe Şehir ve Ekonomi',
          description:
              'Şehirlerin tarihsel gelişimi, şehirleşmenin ekonomik faaliyetlerle ilişkisi ve geleceğin şehirlerine yönelik eğilimler incelenir. Türkiye\'de şehirlerin büyüme süreci ekonomik dönüşümle birlikte yorumlanır.',
          sourceLabel:
              '$_cografyaLabel, İçindekiler: Geçmişten Geleceğe Şehir ve Ekonomi (s. 143)',
          sourceUrl: _cografyaUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_cog2_3',
          name: 'Türkiye\'nin İşlevsel Bölgeleri ve Kalkınma Projeleri',
          description:
              'İşlevsel bölgeler bir merkezin çevresiyle kurduğu ekonomik ve sosyal ilişkilere göre belirlenir. GAP, DAP, KOP ve DOKAP gibi bölgesel kalkınma projelerinin amaçları ve etkileri incelenir.',
          sourceLabel:
              '$_cografyaLabel, İçindekiler: Türkiye\'nin İşlevsel Bölgeleri ve Kalkınma Projeleri (s. 157)',
          sourceUrl: _cografyaUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_cog2_4',
          name: 'Hizmet Sektörü, Ticaret ve Türkiye Turizmi',
          description:
              'Ulaşım, ticaret, turizm, eğitim ve sağlık hizmet sektörünü oluşturur. Dünyada ve Türkiye\'de ticaretin yönü ve başlıca ürünleri ile Türkiye\'nin doğal ve kültürel turizm değerleri incelenir.',
          sourceLabel:
              '$_cografyaLabel, İçindekiler: Hizmet Sektörü; Dünyada ve Türkiye\'de Ticaret; Türkiye Turizmi (s. 171-197)',
          sourceUrl: _cografyaUrl,
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_cog2_5',
          name: 'Jeopolitik Konum, Gelişmişlik ve Çatışma Alanları',
          description:
              'Jeopolitik konum bir ülkenin coğrafi özelliklerinin siyasi ve ekonomik gücüne etkisidir. Ülkelerin gelişmişlik ölçütleri, enerji nakil hatlarının güzergâhları ve günümüzün çatışma alanları birlikte incelenir.',
          sourceLabel:
              '$_cografyaLabel, İçindekiler: Jeopolitik Konum; Enerji Nakil Hatları ve Günümüz Çatışma Alanları (s. 211-223)',
          sourceUrl: _cografyaUrl,
          questionCount: 1,
          difficulty: '🔴 Zor',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_cog2_6',
          name: 'Doğal Çevrenin Sınırlılığı ve Çevresel Anlaşmalar',
          description:
              'Doğal kaynakların sınırlı olması sürdürülebilir kullanımı zorunlu kılar. Çevre koruma amacıyla kurulan örgütler ve iklim değişikliğiyle ilgili uluslararası anlaşmalar (örneğin Kyoto Protokolü, Paris Anlaşması) incelenir.',
          sourceLabel:
              '$_cografyaLabel, İçindekiler: Doğal Çevrenin Sınırlılığı, Çevresel Örgüt ve Anlaşmalar (s. 237)',
          sourceUrl: _cografyaUrl,
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟡 ORTA',
          estimatedDays: 1,
        ),
      ],
    ),
  ];
}
