import '../models/topic.dart';
import '../models/subject.dart';

List<Subject> getAllSubjects() {
  return [
    // ═══════════════════════════════════════════════
    // TYT MATEMATİK — 25 Konu, 40 Soru
    // ═══════════════════════════════════════════════
    Subject(
      name: 'TYT Matematik',
      emoji: '📐',
      type: 'TYT',
      totalQuestions: 40,
      tip:
          'Sayılar→Kesirler→Üslü-Köklü→EBOB-EKOK→Oran-Yüzde→Denklem→Problemler sırasını izleyebilirsin. Deneme sonuçlarına göre konuların sırasını değiştirebilirsin.',
      topics: [
        Topic(
          id: 'tyt_mat_1',
          name: 'Sayılar — Doğal, Tam, Rasyonel',
          description:
              'Doğal sayılar 0, 1, 2, ...; tam sayılar negatif tam sayılar, 0 ve pozitif tam sayılardır. Rasyonel sayılar a/b biçiminde yazılır (a,b tam sayı; b≠0); irrasyonel sayılar bu biçimde yazılamaz ve ondalık gösterimleri sonsuz, devirsizdir. π ve √2 irrasyoneldir. Sayı doğrusunda negatifler 0\'ın solunda, pozitifler sağındadır; 0 orijin noktasıdır.',
          sourceLabel: 'MEB OGM Materyal · Dört Dörtlük TYT Matematik, Sayı Kümeleri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page54.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_2',
          name: 'Dört İşlem ve İşlem Önceliği',
          description:
              'İşlem sırası: parantez, üs, çarpma/bölme, toplama/çıkarma. Aynı öncelikteki işlemler soldan sağa yapılır. Negatif iki sayının çarpımı pozitiftir: (−2)×(−3)=6. Sıfıra bölme tanımsızdır; sıfırla çarpım sıfırdır.',
          sourceLabel: 'MEB OGM Materyal · Matematik 9, İşlem Önceliği',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/hzr/unite1/files/basic-html/page46.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 1,
        ),
        Topic(
          id: 'tyt_mat_3',
          name: 'Kesirler',
          description:
              'a/b kesrinde b≠0; a pay, b paydadır. Toplama ve çıkarmada ortak payda kullanılır; çarpmada paylar ve paydalar çarpılır. Bölmede ikinci kesir sıfır olmadığında ters çevrilip çarpılır. Sadeleştirme ve genişletme kesrin değerini değiştirmez.',
          sourceLabel: 'MEB OGM Materyal · Matematik 9',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kavram_calismalari/9y/matematik/files/basic-html/page57.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_4',
          name: 'Üslü Sayılar',
          description:
              'Tam sayı üslerinde aᵐ, a\'nın m kez çarpımını gösterir (m>0). a≠0 için a⁰=1 ve a⁻ⁿ=1/aⁿ. Aynı tabanda çarpmada üsler toplanır, bölmede (a≠0) çıkarılır; kuvvetin kuvvetinde üsler çarpılır. Örnek: 2³=8, 3²=9, 10³=1000.',
          sourceLabel: 'MEB OGM Materyal · Matematik 9',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/fasikul/55qeme0jn1g.pdf',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_5',
          name: 'Köklü Sayılar',
          description:
              '√a, a≥0 için karesi a olan negatif olmayan gerçek sayıyı gösterir. a,b≥0 iken √a·√b=√(ab); a≥0 ve b>0 iken √(a/b)=√a/√b. Örnek: √4=2, √9=3, √25=5. 1/√2, payda sıfır olmadığı için √2/2 biçiminde yazılabilir.',
          sourceLabel: 'MEB OGM Materyal · Matematik 9 Beceri Temelli Etkinlikler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/beceri_temelli/pdf/9/matematik.pdf',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_6',
          name: 'EBOB-EKOK',
          description:
              'EBOB, iki pozitif tam sayının en büyük ortak böleni; EKOK, en küçük ortak katıdır. Pozitif tam sayılar a,b için EBOB(a,b)·EKOK(a,b)=a·b. Asal çarpanlara ayırma iki değeri bulma yöntemlerinden biridir.',
          sourceLabel: 'MEB OGM Materyal · Dört Dörtlük TYT Matematik, EBOB-EKOK',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page78.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_7',
          name: 'Bölme-Bölünebilme',
          description:
              'Bir tam sayının 2\'ye bölünmesi için son rakamı çift; 3 veya 9\'a bölünmesi için rakamları toplamı sırasıyla 3 veya 9\'un katı olmalıdır. 4\'te son iki basamak, 5\'te son rakam 0 veya 5, 10\'da son rakam 0 olmalıdır.',
          sourceLabel: 'MEB OGM Materyal · Dört Dörtlük TYT Matematik, Bölünebilme Kuralları',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page72.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_8',
          name: 'Oran-Orantı',
          description:
              'b,d≠0 iken a/b=c/d eşitliği ad=bc sonucunu verir. Doğru orantıda oran sabittir; ters orantıda çarpım sabittir. Değişkenlerden birinin artmasının diğerini azaltması tek başına ters orantıyı kanıtlamaz.',
          sourceLabel: 'MEB OGM Materyal · Matematik 9, Oran ve Orantı',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/09/unite3/files/basic-html/page77.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_9',
          name: 'Yüzde Problemleri',
          description:
              'Bir niceliğin %p\'si, niceliğin p/100 ile çarpımıdır. %20 artış başlangıç değerini 1,20 ile; %20 azalış 0,80 ile çarpar. Ardışık yüzde değişimleri her adımda güncel değer üzerinden uygulanır; yüzdeler doğrudan toplanmaz.',
          sourceLabel: 'MEB OGM Materyal · Temel Düzey Matematik 12, Yüzde Hesapları',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematiktemelduzey/12/unite1/files/basic-html/page46.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_10',
          name: 'Denklem Kurma — 1. Derece',
          description:
              'Bilinmeyeni x ile göster; “5 fazlası” x+5, “3 katı” 3x olur. Eşitliğin iki tarafına aynı işlemi uygulayarak bilinmeyeni yalnız bırak. Örnek: 3x+5=20 ise x=5.',
          sourceLabel: 'MEB OGM Materyal · Dört Dörtlük TYT Matematik, Birinci Dereceden Denklemler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page105.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_11',
          name: 'Sayı ve Kesir Problemleri',
          description:
              'Ardışık tam sayılar x, x+1, x+2; ardışık çift veya tek tam sayılar x, x+2, x+4 biçiminde modellenebilir. Bir sayının 3/4\'ü 3x/4\'tür. Verilen ilişkileri değişkenlerle ifade edip kurulan denklemi çöz.',
          sourceLabel: 'MEB OGM Materyal · Fen Lisesi Matematik 9, Problemler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/9/unite3/files/basic-html/page101.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_12',
          name: 'Yaş Problemleri',
          description:
              'Bugünkü yaşı x olan kişinin n yıl sonraki yaşı x+n, n yıl önceki yaşı x−n olur (geçmiş yaşlar soruda anlamlı olmalıdır). İki kişinin aynı tarihteki yaş farkı zamanla değişmez.',
          sourceLabel: 'MEB OGM Materyal · Defterim Matematik 9, Yaş Problemleri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/9/matematik/files/basic-html/page175.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_13',
          name: 'İşçi-Havuz Problemleri',
          description:
              'Sabit hızla çalışan bir kişi/boru için birim zamandaki iş miktarı 1/toplam bitirme süresidir. Aynı işte birlikte çalışma hızları toplanır: 6 günde ve 3 günde bitiren iki işçi, sabit hız varsayımıyla işi 1/(1/6+1/3)=2 günde bitirir.',
          sourceLabel: 'MEB OGM Materyal · Fen Lisesi Matematik 9, Problemler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/9/unite3/files/basic-html/page101.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_14',
          name: 'Hız Problemleri',
          description:
              'Sabit hızlı harekette sürat=yol/zaman; yol=sürat×zaman. Aynı doğrultuda karşılıklı yaklaşan iki cismin bağıl sürati süratlerin toplamı, aynı yönde hareket edenlerin bağıl sürati farklarının mutlak değeridir. Birimleri tutarlı kullan.',
          sourceLabel: 'MEB OGM Materyal · Fen Lisesi Matematik 9, Problemler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/9/unite3/files/basic-html/page101.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_15',
          name: 'Kar-Zarar ve Karışım',
          description:
              'Kâr=satış fiyatı−maliyet; maliyete göre kâr yüzdesi=kâr/maliyet×100\'dür. Aynı tür ve birimdeki iki karışımın derişimi c₁,c₂ ve miktarları m₁,m₂ ise son derişim (c₁m₁+c₂m₂)/(m₁+m₂) olur; bu ortalama, miktar birimleri ve derişim tanımları uyumluysa kullanılır.',
          sourceLabel: 'MEB OGM Materyal · Defterim Matematik 9, Karışım Problemleri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/9/matematik/files/basic-html/page200.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_16',
          name: 'Mutlak Değer',
          description:
              '|a|, a≥0 ise a; a<0 ise −a değeridir. Sayı doğrusunda |a−b|, a ile b arasındaki uzaklıktır. |x|=5 denkleminin çözümleri x=5 ve x=−5\'tir.',
          sourceLabel: 'MEB OGM Materyal · Matematik 9, Mutlak Değer',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/09/unite3/files/basic-html/page43.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_17',
          name: 'Üçgenler — Temel',
          description:
              'Öklid düzlemindeki üçgende iç açıların toplamı 180°; alan=(taban×tabana dik yükseklik)/2\'dir. Bir dış açı, kendisine komşu olmayan iki iç açının toplamına eşittir. Eşkenar üçgende üç kenar eşit ve her iç açı 60°\'dir.',
          sourceLabel: 'MEB OGM Materyal · Matematik, Üçgenler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/elazig-telafi/matematik/files/basic-html/page21.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_18',
          name: 'Dik Üçgen ve Pisagor',
          description:
              'Dik üçgende dik kenarlar a,b ve hipotenüs c ise a²+b²=c². Özel dik üçgen oranları: 3–4–5; 5–12–13; 30°–60°–90° açılarının karşısındaki kenarlar 1:√3:2; 45°–45°–90° üçgeninde 1:1:√2.',
          sourceLabel: 'MEB OGM Materyal · Fen Lisesi Matematik 9, Pisagor Teoremi',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/9/unite4/files/basic-html/page89.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_19',
          name: 'Dörtgenler',
          description:
              'A alanı, Ç çevreyi gösterir. Karenin alanı a² ve çevresi 4a; dikdörtgenin alanı ab ve çevresi 2(a+b); paralelkenarın alanı taban×tabana dik yükseklik; yamuğun alanı paralel kenarların toplamı×yükseklik/2\'dir.',
          sourceLabel: 'MEB OGM Materyal · Matematik, Dörtgenler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/elazig-telafi/matematik/files/basic-html/page98.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_20',
          name: 'Çember – Daire',
          description:
              'Yarıçapı r olan çemberin çevresi 2πr; dairenin alanı πr²\'dir. Merkez açısı α derece olan yay uzunluğu (α/360)·2πr, daire dilimi alanı (α/360)·πr²\'dir. Merkez açı ölçüsü, gördüğü yayın derece ölçüsüne eşittir.',
          sourceLabel: 'MEB OGM Materyal · Matematik 11, Çember ve Daire',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/11/unite5/files/basic-html/page34.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_21',
          name: 'Kümeler',
          description:
              'A∪B, A veya B\'de (ya da ikisinde) bulunan elemanları; A∩B ortak elemanları; A\\B yalnız A\'da bulunan elemanları içerir. Sonlu iki küme için n(A∪B)=n(A)+n(B)−n(A∩B).',
          sourceLabel: 'MEB OGM Materyal · Matematik 9, Kümeler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/09/unite2/files/basic-html/page12.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_22',
          name: 'Mantık',
          description:
              'p→q, “p ise q” koşullu önermesidir; karşıt tersi ¬q→¬p\'dir ve p→q ile denktir. p∧q iki önerme de doğruysa; p∨q en az biri doğruysa doğrudur (veya kapsayıcıdır).',
          sourceLabel: 'MEB OGM Materyal · Matematik 9, Mantık',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/09/unite1/files/basic-html/page2.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_23',
          name: 'Fonksiyonlar (Temel)',
          description:
              'Fonksiyon, tanım kümesindeki her girdiyi değer kümesinde tam bir çıktıyla eşler. f(2)=5, 2 girdisinin görüntüsünün 5 olduğunu söyler. Örnek: f(x)=2x+1 ise f(3)=7.',
          sourceLabel: 'MEB OGM Materyal · Matematik 10, Fonksiyon Kavramı ve Gösterimi',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/10/unite2/files/basic-html/page4.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_24',
          name: 'Olasılık',
          description:
              'Sonlu ve eş olasılıklı sonuçlarda P(A)=A\'yı sağlayan sonuç sayısı/tüm sonuç sayısı. Dengeli zar atışında çift gelme olasılığı 3/6=1/2\'dir. Bağımsız A ve B olayları için P(A∩B)=P(A)·P(B).',
          sourceLabel: 'MEB OGM Materyal · Dört Dörtlük TYT Matematik, Olasılık',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page332.html',
          questionCount: 1,
          difficulty: '🔴 Zor',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_25',
          name: 'İstatistik',
          description:
              'Aritmetik ortalama=verilerin toplamı/veri sayısı. Medyan (ortanca), veriler sıralandığında ortada kalan değerdir; veri sayısı çiftse ortadaki iki değerin aritmetik ortalaması alınır. Mod, en sık görülen değerdir; bir veri grubunun birden fazla modu olabilir.',
          sourceLabel: 'MEB OGM Materyal · Dört Dörtlük TYT Matematik, Merkezi Eğilim Ölçüleri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page283.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟡 ORTA',
          estimatedDays: 1,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // TYT TÜRKÇE — 17 Konu, 40 Soru
    // ═══════════════════════════════════════════════
    Subject(
      name: 'TYT Türkçe',
      emoji: '📖',
      type: 'TYT',
      totalQuestions: 40,
      tip:
          'Ana Fikir+Sözcük Anlamı+Sözcük Türleri = en çok soru! Her gün 5 paragraf çöz.',
      topics: [
        Topic(
          id: 'tyt_tur_1',
          name: 'Ana Fikir / Başlık Bulma',
          description:
              'Parçanın tamamını oku. "Yazar ne anlatmak istiyor?" diye sor. En genel, en kapsayıcı ifade ana fikirdir.',
          questionCount: 4,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_2',
          name: 'Boşluğa Uygun Cümle',
          description:
              'Önceki cümle ne diyor? Sonraki ne? İkisini bağlayan cümle. Bağlaçlara dikkat.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_3',
          name: 'Paragraftan Çıkarılacak Sonuç',
          description:
              'Parçada YAZILMAYAN ama ANLAŞILAN şeyi bul. Seçenekleri dene.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_4',
          name: 'Paragrafın Açıklama Yöntemi',
          description:
              'Tanımlama: "X şudur". Örnekleme: "örneğin, mesela" var. Karşılaştırma: iki şey yan yana.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_5',
          name: 'Anlam Bütünlüğünü Bozan Cümle',
          description:
              '5 cümle var, biri konudan sapıyor. Her cümleyi ana fikre bağla, bağlanmayanı bul.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_6',
          name: 'Paragrafın Planı (Sıralama)',
          description:
              'Karışık cümleler verilir, sırala. "Bu/şu/o" zamiri önceki cümleye bağlar.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_7',
          name: 'Sözcükte Anlam (Gerçek-Mecaz-Terim)',
          description:
              'Gerçek: ilk ve temel anlam. Mecaz: başka anlamda kullanma ("göz" = kapı gözü). Terim: bilim dalı anlamı.',
          questionCount: 3,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_8',
          name: 'Eş Anlamlı Sözcükler',
          description:
              'Cümledeki sözcüğü çıkar, yerine seçenekleri koy. En az anlam kaybıyla değiştireni bul.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_9',
          name: 'Cümlede Anlam (İlgi-Koşul-Amaç)',
          description:
              'Koşul: -se/-sa. Amaç: için/diye. Neden-sonuç: çünkü/bu yüzden.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_10',
          name: 'Atasözü ve Deyim',
          description:
              'Atasözü: kalıp, ders içerir, tümcedir. Deyim: fiil var, kalıp, bir durumu anlatır.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_11',
          name: 'Sözcük Türleri — Sıfırdan',
          description:
              'İsim: varlık adı. Sıfat: ismi niteler (kırmızı elma). Zamir: ismin yerini tutar. Zarf: fiili/sıfatı niteler.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'tyt_tur_12',
          name: 'Fiil ve Fiilimsi — Sıfırdan',
          description:
              'Fiil: kişi eki alır (gidiyorum). Fiilimsi: kişi eki almaz. İsim-fiil: -mak,-ma,-ış. Sıfat-fiil: -an,-en,-dik,-acak.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'tyt_tur_13',
          name: 'Cümle Türleri',
          description:
              'Yüklemine göre: fiil cümlesi, isim cümlesi. Anlamına göre: olumlu, olumsuz, soru.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_14',
          name: 'Yazım Kuralları',
          description:
              'Büyük harf: cümle başı ve özel isim. Bağlaç olan de/da ayrı yazılır; bulunma hâl eki -de/-da bitişiktir (evde, okulda). Bağlaç olan ki ayrı, -ki eki bitişik yazılır (evdeki).',
          sourceLabel: 'Türk Dil Kurumu · Yazım Kılavuzu',
          sourceUrl:
              'https://yazim.tdk.gov.tr/content/03-bazi-kelime-ve-eklerin-yazilisi.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_15',
          name: 'Noktalama',
          description:
              'Virgül: sıralama, hitap, yan cümle. Noktalı virgül: bağımsız cümleleri bağlar. İki nokta: açıklama getirir.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_16',
          name: 'Anlatım Bozuklukları',
          description:
              'Özne-yüklem uyumsuzluğu, gereksiz kelime, anlam belirsizliği, sıralama hatası.',
          questionCount: 2,
          difficulty: '🔴 Zor',
          priority: '🟡 ORTA',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_17',
          name: 'Ses Bilgisi',
          description:
              'Ünsüz yumuşaması: p/ç/t/k → b/c/d/g (kitap→kitabı). Ünlü düşmesi: ağız→ağzı.',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🔵 DÜŞÜK',
          estimatedDays: 1,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // TYT FİZİK — 7 Konu, 7 Soru
    // ═══════════════════════════════════════════════
    Subject(
      name: 'TYT Fizik',
      emoji: '⚡',
      type: 'TYT',
      totalQuestions: 7,
      tip:
          'Kuvvet, enerji ve basınç konularını kavramlar ve birimlerle birlikte çalış; ardından farklı soru türleriyle kendini yokla.',
      topics: [
        Topic(
          id: 'tyt_fiz_1',
          name: 'Ölçme ve Birimler',
          description:
              'SI birimleri: uzunluk=m, kütle=kg, zaman=s, akım=A. Türetilmiş birimler: Newton(N)=kg×m/s², Joule(J)=N×m.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 1,
        ),
        Topic(
          id: 'tyt_fiz_2',
          name: 'Kuvvet ve Hareket — Newton Kanunları',
          description:
              '1.Kanun: kuvvet yoksa hareket değişmez (atalet). 2.Kanun: F=m×a. 3.Kanun: etki-tepki.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_fiz_3',
          name: 'Enerji – İş – Güç',
          description:
              'İş: W=F×d×cosθ. Kinetik enerji: Ek=½mv². Potansiyel: Ep=mgh. Güç=İş/zaman.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_fiz_4',
          name: 'Basınç',
          description: 'Katıda: P=F/A. Sıvıda: P=ρgh. Atmosfer basıncı.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_fiz_5',
          name: 'Isı ve Sıcaklık',
          description:
              'Sıcaklık: tanecik ortalama enerjisi (°C, K). Isı: aktarılan enerji. Q=m×c×ΔT.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_fiz_6',
          name: 'Elektrik Temeli',
          description:
              'Akım I (Amper): elektronların hareketi. Gerilim V (Volt): itici güç. Direnç R (Ohm). Ohm: V=I×R.',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_fiz_7',
          name: 'Dalgalar ve Optik',
          description:
              'Dalga: enerji taşır madde taşımaz. v=λ×f. Yansıma: gelen=yansıyan açı. Kırılma: ortam değişince yön değişir.',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // TYT KİMYA — 7 Konu, 7 Soru
    // ═══════════════════════════════════════════════
    Subject(
      name: 'TYT Kimya',
      emoji: '🧪',
      type: 'TYT',
      totalQuestions: 7,
      tip:
          'Atom, periyodik tablo, karışımlar ve asit-baz başlıklarını örneklerle çalış; ezberin yanında kavramlar arasındaki ilişkilere odaklan.',
      topics: [
        Topic(
          id: 'tyt_kim_1',
          name: 'Atom Modeli — Sıfırdan',
          description:
              'Proton (+, çekirdekte), Nötron (yüksüz, çekirdekte), Elektron (-, çekirdek etrafı). Atom numarası=proton sayısı. Kütle numarası=proton+nötron.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_kim_2',
          name: 'Periyodik Tablo — Temeli',
          description:
              'Gruplar (sütun): benzer özellik. Periyotlar (satır): enerji seviyesi. Metal: sol taraf. Ametal: sağ taraf. Halojenler: 7A. Soy gazlar: 8A.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_kim_3',
          name: 'Kimyasal Bağlar',
          description:
              'İyonik: metal+ametal, elektron transferi (NaCl). Kovalent: ametal+ametal, elektron paylaşımı (H₂O). Metalik: metaller arası.',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_kim_4',
          name: 'Madde ve Karışımlar',
          description:
              'Saf madde: element+bileşik. Karışım: homojen (çözelti)+heterojen. Ayırma: süzme, damıtma, buharlaştırma.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_kim_5',
          name: 'Asit-Baz (TYT)',
          description:
              'Asit: H⁺ verir (pH<7), ekşi. Baz: OH⁻ verir (pH>7), acı. Nötr: pH=7. İndikatör: turnusol (asit→kırmızı, baz→mavi).',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_kim_6',
          name: 'Kimyasal Tepkimeler',
          description:
              'Kütle korunumu: tepkimeye giren=çıkan kütle. Denkleştirme: katsayılarla atom sayılarını eşitle.',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_kim_7',
          name: 'Mol Kavramı (Temel TYT)',
          description:
              '1 mol = 6.02×10²³ tanecik (Avogadro sayısı). n=m/M (mol=kütle÷mol kütlesi). H₂O mol kütlesi: 2+16=18 g/mol.',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // TYT BİYOLOJİ — 6 Konu, 6 Soru
    // ═══════════════════════════════════════════════
    Subject(
      name: 'TYT Biyoloji',
      emoji: '🧬',
      type: 'TYT',
      totalQuestions: 6,
      tip:
          'Hücre ve sınıflandırma konularında şema ve kavram haritası kullan; organellerin görevlerini karşılaştırmalı tekrar et.',
      topics: [
        Topic(
          id: 'tyt_bio_1',
          name: 'Hücre — Sıfırdan',
          description:
              'Hücre = yaşamın temel birimi. Hücre zarı: kontrollü geçiş. Sitoplazma: organeller burada. Çekirdek: DNA var. Mitokondri: ATP üretir. Ribozom: protein üretir. Kloroplast, bitkilerde ve algler gibi fotosentez yapan bazı ökaryotlarda bulunur.',
          sourceLabel: 'MEB OGM Materyal · Defterim Biyoloji 9',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/9/biyoloji/files/basic-html/page100.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'tyt_bio_2',
          name: 'Prokaryot – Ökaryot',
          description:
              'Prokaryot hücrelerde zarla çevrili çekirdek yoktur; DNA nükleoit bölgede bulunur (ör. bakteriler). Ökaryot hücrelerde çekirdek vardır (bitki, hayvan, mantar ve protist hücreleri). Virüsler hücre yapısında değildir.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_bio_3',
          name: 'Canlıların Sınıflandırılması',
          description:
              'Alem→Şube→Sınıf→Takım→Aile→Cins→Tür. Virüs cansız. Bakteri prokaryot. Mantar ayrıştırıcı. Bitki kloroplast var. Hayvan kloroplast yok.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_bio_4',
          name: 'Fotosentez ve Solunum',
          description:
              'Fotosentez: 6CO₂+6H₂O+ışık→C₆H₁₂O₆+6O₂. Solunum: C₆H₁₂O₆+6O₂→6CO₂+6H₂O+38ATP.',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_bio_5',
          name: 'Ekosistem ve Besin Zinciri',
          description:
              'Üretici: bitki. Tüketici: hayvan. Ayrıştırıcı: bakteri/mantar. Enerji yukarıya gidince AZALIR (%10 kuralı).',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 1,
        ),
        Topic(
          id: 'tyt_bio_6',
          name: 'Kalıtım Temeli (TYT)',
          description:
              'DNA: kalıtım materyali. Gen: DNA bölümü. Kromozom: DNA+protein. İnsan: 46 kromozom (23 çift).',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // TYT SOSYAL — 14 Konu, 20 Soru
    // ═══════════════════════════════════════════════
    Subject(
      name: 'TYT Sosyal',
      emoji: '🌍',
      type: 'TYT',
      totalQuestions: 20,
      tip:
          'Kurtuluş Savaşı+İnkılaplar tarihleri + Türkiye coğrafyası + İslam\'ın şartları = ~8-10 soru kolay net!',
      topics: [
        Topic(
          id: 'tyt_sos_1',
          name: 'Osmanlı Kuruluş ve Yükselme',
          description:
              'Kuruluş: 1299. Fatih: 1453 İstanbul. Yavuz: Mısır, Halifelik. Kanuni: en geniş sınır.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_2',
          name: 'Osmanlı Gerileme ve Reform',
          description:
              'Tanzimat (1839). 1.Meşrutiyet (1876). 2.Meşrutiyet (1908). 1.Dünya Savaşı. Sevr (1920).',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_3',
          name: 'Kurtuluş Savaşı — ÇOK KRİTİK!',
          description:
              '19 Mayıs 1919: Samsun. Erzurum+Sivas Kongreleri. 23 Nisan 1920: TBMM. Sakarya. Büyük Taarruz. Lozan.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_sos_4',
          name: 'Atatürk İnkılapları — EZBER ŞART!',
          description:
              'Saltanat: 1922. Cumhuriyet: 29 Ekim 1923. Halifelik: 1924. Harf devrimi: 1928. Kadına oy: 1934.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_sos_5',
          name: 'Türkiye\'nin Coğrafi Özellikleri',
          description:
              '7 bölge. En büyük: Doğu Anadolu. En kalabalık: Marmara. En yüksek: Ağrı Dağı. En uzun nehir: Kızılırmak.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_sos_6',
          name: 'Türkiye\'de İklim',
          description:
              'Akdeniz: yazı kurak, kışı ılık. Karadeniz: her mevsim yağışlı. Karasal: yazı sıcak, kışı soğuk.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_7',
          name: 'Türkiye\'de Tarım ve Ekonomi',
          description:
              'Buğday-arpa: İç Anadolu. Fındık: Karadeniz. Pamuk: Ege+Çukurova. Çay: Rize. Zeytin: Ege.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_8',
          name: 'Dünya Coğrafyası Temeli',
          description:
              '6 kıta: Asya en büyük. 4 okyanus. Ekvator: tropikal. Kutup: tundra-buzul.',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 1,
        ),
        Topic(
          id: 'tyt_sos_9',
          name: 'Felsefeye Giriş ve Varlık Felsefesi',
          description:
              'Felsefe: merak, sorgulama. İdealizm: sadece zihin var. Materyalizm: sadece madde var. Dualizm: ikisi de var.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_10',
          name: 'Bilgi Felsefesi — Akımlar',
          description:
              'Rasyonalizm: bilgi akıldan (Descartes). Empirizm: bilgi deneyden (Locke). Kant: akıl+deney.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_11',
          name: 'Ahlak ve Siyaset Felsefesi',
          description:
              'Hedonizm: haz amaç. Erdem ahlakı: Aristo. Ödev ahlakı: Kant. Faydacılık: Mill.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_12',
          name: 'İslam\'ın Temel İlkeleri',
          description:
              'İmanın 6 şartı. İslam\'ın 5 şartı: Kelime-i şahadet, namaz, oruç, zekat, hac.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_13',
          name: 'Hz. Muhammed\'in Hayatı',
          description:
              '570: Mekke. 610: İlk vahiy. 622: Hicret. 630: Mekke fethi. 632: Vefat.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_14',
          name: 'Kuran ve Temel Kavramlar',
          description:
              '114 sure, 6236 ayet. İlk inen: Alak. En uzun: Bakara. Meal, tefsir, hadis, sünnet, fıkıh, siyer.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 1,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // AYT MATEMATİK — 10 Konu, 40 Soru
    // ═══════════════════════════════════════════════
    Subject(
      name: 'AYT Matematik',
      emoji: '🔢',
      type: 'AYT',
      totalQuestions: 40,
      tip:
          'Fonksiyon, parabol, polinom, logaritma ve dizileri örnek soru çözerek pekiştir; deneme yanlışlarına göre tekrar sırasını belirle.',
      topics: [
        Topic(
          id: 'ayt_mat_1',
          name: 'Fonksiyonlar — AYT Seviyesi',
          description:
              'Doğrusal: f(x)=ax+b. Parabolik: f(x)=ax²+bx+c. Bileşke: (fog)(x)=f(g(x)). Ters fonksiyon: f⁻¹.',
          questionCount: 4,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 5,
        ),
        Topic(
          id: 'ayt_mat_2',
          name: '2. Derece Denklem ve Parabol',
          description:
              'ax²+bx+c=0. Delta=b²-4ac. Tepe noktası: (-b/2a, f(-b/2a)). Köklerin çarpımı: c/a. Köklerin toplamı: -b/a.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 5,
        ),
        Topic(
          id: 'ayt_mat_3',
          name: 'Polinomlar',
          description:
              'Polinom: aₙxⁿ+...+a₁x+a₀. Bézout teoremi: P(a)=0 ise (x-a) çarpanıdır. Bölme ve kalan.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_mat_4',
          name: 'Logaritma — Sıfırdan',
          description:
              'log_a(x)=y ↔ aʸ=x. Kurallar: log(AB)=logA+logB. log(A/B)=logA-logB. log(Aⁿ)=n×logA.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_mat_5',
          name: 'Diziler',
          description:
              'Aritmetik: aₙ=a₁+(n-1)d. Toplam: Sₙ=n/2×(a₁+aₙ). Geometrik: aₙ=a₁×rⁿ⁻¹.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_mat_6',
          name: 'Trigonometri',
          description:
              'sin/cos/tan. sin²α+cos²α=1. Birim çember. Trigonometrik denklemler.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_mat_7',
          name: 'Analitik Geometri',
          description:
              'Uzaklık: d=√((x₂-x₁)²+(y₂-y₁)²). Doğru denklemi: y-y₁=m(x-x₁). Çemberin denklemi.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_mat_8',
          name: 'Türev (Kolay Kısımlar)',
          description:
              '(xⁿ)\'=nxⁿ⁻¹. Çarpım: (fg)\'=f\'g+fg\'. Teğet doğrusu. Artan/azalan aralıklar.',
          questionCount: 2,
          difficulty: '🔴 Zor',
          priority: '🟡 ORTA',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_mat_9',
          name: 'İntegral (Sadece Temel)',
          description:
              '∫xⁿdx=xⁿ⁺¹/(n+1)+C. Belirli integral: ∫[a,b] f(x)dx. Alan hesabı.',
          questionCount: 1,
          difficulty: '🔴 Zor',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_mat_10',
          name: 'Limit (Temel)',
          description:
              'lim x→a f(x). Polinom limiti: direkt yerine koy. 0/0 belirsizliği: sadeleştir.',
          questionCount: 1,
          difficulty: '🔴 Zor',
          priority: '🔵 DÜŞÜK',
          estimatedDays: 1,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // AYT FİZİK — 7 Konu, 14 Soru
    // ═══════════════════════════════════════════════
    Subject(
      name: 'AYT Fizik',
      emoji: '⚡',
      type: 'AYT',
      totalQuestions: 14,
      tip:
          'Dinamik, enerji-momentum ve elektrik konularında önce temel ilkeleri öğren, sonra farklı soru türleriyle uygulama yap.',
      topics: [
        Topic(
          id: 'ayt_fiz_1',
          name: 'Dinamik — Bağlı Cisimler ve Eğik Düzlem',
          description:
              'F=ma genişletildi. İp gerilmesi. Eğik düzlem: W×sinθ (harekete yönde), W×cosθ (yüzeye dik). Sürtünme: f=μN.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_fiz_2',
          name: 'Enerji ve Momentum',
          description:
              'İmpuls: J=F×t=Δ(mv). Momentum: p=mv. Korunumu: m₁v₁+m₂v₂=m₁v₁\'+m₂v₂\'. Elastik vs plastik çarpışma.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_fiz_3',
          name: 'Basit Harmonik Hareket',
          description:
              'Yay-kütle: T=2π√(m/k). Sarkaç: T=2π√(L/g). Genlik, hız max denge noktası, ivme max uç nokta.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_fiz_4',
          name: 'Elektrik ve Manyetizma',
          description:
              'Coulomb: F=k×q₁q₂/r². Elektrik alan. Kondansatör: C=Q/V. Manyetik kuvvet. Lenz kanunu.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_fiz_5',
          name: 'Dalgalar ve Optik (AYT)',
          description:
              '1/f=1/do+1/di. Büyütme: m=-di/do. Yakınsak/ıraksak mercek. Girişim, çift yarık.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_fiz_6',
          name: 'Çembersel Hareket',
          description:
              'ac=v²/r. F_merkezcil=mv²/r. ω=v/r. Kepler: T²/R³=sabit.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_fiz_7',
          name: 'Modern Fizik',
          description:
              'Fotoelektrik: E=hf. Dalga-tanecik ikiliği: λ=h/mv. Radyoaktivite: alfa, beta, gama. Yarılanma.',
          questionCount: 1,
          difficulty: '🔴 Zor',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // AYT KİMYA — 6 Konu, 13 Soru
    // ═══════════════════════════════════════════════
    Subject(
      name: 'AYT Kimya',
      emoji: '🧪',
      type: 'AYT',
      totalQuestions: 13,
      tip:
          'Mol hesabı, asit-baz ve kimyasal denge konularını işlem adımlarını yazarak çalış; sonuçlarını birimleriyle kontrol et.',
      topics: [
        Topic(
          id: 'ayt_kim_1',
          name: 'Mol Hesabı — AYT',
          description:
              'n=m/M. 1 mol=22.4L (STP gaz). Sınırlayıcı reaktif. Yüzde verim: gerçek/teorik×100.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 5,
        ),
        Topic(
          id: 'ayt_kim_2',
          name: 'Asit-Baz Dengesi (AYT)',
          description:
              'pH=-log[H⁺]. Kw=10⁻¹⁴. Güçlü/zayıf asit. Titrasyon. Tampon çözeltiler.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_kim_3',
          name: 'Kimyasal Denge',
          description:
              'Kc=[ürünler]/[reaktifler]. Le Chatelier prensibi. Basınç, sıcaklık, konsantrasyon etkisi.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_kim_4',
          name: 'Elektrokimya',
          description:
              'Oksidasyon: elektron verir. İndirgeme: elektron alır. Galvanik hücre. Elektroliz. Anot/Katot.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_kim_5',
          name: 'Organik Kimya Temeli',
          description:
              'Alkan: CₙH₂ₙ₊₂. Alken: CₙH₂ₙ. Alkin: CₙH₂ₙ₋₂. Fonksiyonlu gruplar. İzomeri.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_kim_6',
          name: 'Termodinamik Temeli',
          description:
              'Entalpi (ΔH): ekzotermik (<0), endotermik (>0). Hess kanunu. Entropi. Gibbs: ΔG=ΔH-TΔS.',
          questionCount: 1,
          difficulty: '🔴 Zor',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // AYT BİYOLOJİ — 8 Konu, 13 Soru
    // ═══════════════════════════════════════════════
    Subject(
      name: 'AYT Biyoloji',
      emoji: '🧬',
      type: 'AYT',
      totalQuestions: 13,
      tip:
          'Mitoz, mayoz, Mendel genetiği ve kan gruplarını şema ve çaprazlamalarla tekrar et; ezberlediğin kuralları yeni örneklere uygula.',
      topics: [
        Topic(
          id: 'ayt_bio_1',
          name: 'Hücre Bölünmesi — Mitoz',
          description:
              'Profaz→Metafaz→Anafaz→Telofaz→Sitokinez. Sonuç: 2 diploid (2n). Büyüme, onarım, eşeysiz üreme.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_bio_2',
          name: 'Mayoz Bölünme',
          description:
              'Mayoz I: homologlar ayrılır (2n→n). Crossing-over: genetik çeşitlilik. Mayoz II: mitoz gibi. Sonuç: 4 haploid (n).',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_bio_3',
          name: 'Kalıtım — Mendel Genetiği',
          description:
              'Dominant (AA/Aa): görünür. Resesif (aa). Monohibrit: Aa×Aa → 3:1. Test çaprazı. Dihybrid: 9:3:3:1.',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_bio_4',
          name: 'Kan Grupları ve Cinsiyete Bağlı Kalıtım',
          description:
              'A ve B kodominant, O resesif. Cinsiyete bağlı: X\'e bağlı kalıtım (renk körlüğü).',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_bio_5',
          name: 'Sinir Sistemi',
          description:
              'Nöron: dendrit+akson. SSS: beyin+omurilik. PNS. Otonom: sempatik/parasempatik. Refleks yayı.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_bio_6',
          name: 'Hormonal Sistem',
          description:
              'Hipofiz, tiroit (tiroksin), paratiroit, adrenal, pankreas (insülin/glukagon). Diyabet.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_bio_7',
          name: 'Fotosentez Detay (AYT)',
          description:
              'Işık reaksiyonları (tilakoid). Calvin Döngüsü (stroma). C₃ vs C₄ bitkiler.',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_bio_8',
          name: 'Solunum Detay (AYT)',
          description:
              'Glikoliz→pirüvat oksidasyonu→Krebs→ETS. ATP verimi hücreye ve hesaplama modeline göre değişir; tek bir sabit toplam gibi sunulmaz. Anaerobik süreçte son ürün organizmaya ve koşullara bağlıdır.',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
      ],
    ),
  ];
}
