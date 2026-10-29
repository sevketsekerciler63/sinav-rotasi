import '../models/topic.dart';
import '../models/subject.dart';

List<Subject> getAllSubjects() {
  return [
    // ═══════════════════════════════════════════════
    // TYT MATEMATİK — 27 Konu, 40 Soru
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
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Matematik, Sayı Kümeleri',
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
              '√a, a≥0 için karesi a olan negatif olmayan gerçek sayıyı gösterir. a,b≥0 iken √a·√b=√(ab); a≥0 ve b>0 iken √(a/b)=√a/√b. Örnek: √4=2, √9=3, √25=5. 1/√2, paydası rasyonel yapılarak (pay ve payda √2 ile çarpılarak) √2/2 biçiminde yazılabilir.',
          sourceLabel:
              'MEB OGM Materyal · Matematik 9 Beceri Temelli Etkinlikler',
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
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Matematik, EBOB-EKOK',
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
              'Bir tam sayının 2\'ye bölünmesi için son rakamı çift; 3 veya 9\'a bölünmesi için rakamları toplamı sırasıyla 3 veya 9\'un katı olmalıdır. 4\'e bölünmede son iki basamağın oluşturduğu sayı 4\'ün katı; 5\'te son rakam 0 veya 5; 10\'da son rakam 0 olmalıdır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Matematik, Bölünebilme Kuralları',
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
          sourceLabel:
              'MEB OGM Materyal · Temel Düzey Matematik 12, Yüzde Hesapları',
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
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Matematik, Birinci Dereceden Denklemler',
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
          sourceLabel:
              'MEB OGM Materyal · Defterim Matematik 9, Yaş Problemleri',
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
          sourceLabel:
              'MEB OGM Materyal · Defterim Matematik 9, Karışım Problemleri',
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
          sourceLabel:
              'MEB OGM Materyal · Fen Lisesi Matematik 9, Pisagor Teoremi',
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
          sourceLabel:
              'MEB OGM Materyal · Matematik 10, Fonksiyon Kavramı ve Gösterimi',
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
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Matematik, Olasılık',
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
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Matematik, Merkezi Eğilim Ölçüleri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page283.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟡 ORTA',
          estimatedDays: 1,
        ),
        Topic(
          id: 'tyt_mat_26',
          name: 'Sıralama ve Seçme (Permütasyon-Kombinasyon)',
          description:
              'Sayma, toplama ve çarpma ilkelerine dayanır. n farklı nesneden r tanesinin sıralamalarının sayısı P(n,r)=n!/(n−r)!, sıranın önemsiz olduğu seçimlerin sayısı C(n,r)=n!/(r!(n−r)!)\'dir (r≤n; 0!=1). Önce sıranın önemli olup olmadığına ve tekrarın serbest olup olmadığına karar ver.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Matematik, alt öğrenme alanı ve konu dağılım tablosu',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page8.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_27',
          name: 'Katı Cisimler (TYT Geometri)',
          description:
              'Ayrıtları a, b, c olan dikdörtgenler prizmasının hacmi a·b·c, yüzey alanı 2(ab+ac+bc)\'dir; küpte hacim a³, yüzey alanı 6a²\'dir. Dik prizma ve dik dairesel silindirde hacim taban alanı×yüksekliktir. Birimleri tutarlı kullan: hacim cm³, alan cm² gibi küp ve kare birimlerle ifade edilir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Matematik, alt öğrenme alanı ve konu dağılım tablosu',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page8.html',
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
          'Paragraf, anlam ve dil bilgisi çalışmalarını birlikte sürdür; konu önceliğini deneme sonuçlarına göre ayarla. Her gün düzenli paragraf sorusu çöz.',
      topics: [
        Topic(
          id: 'tyt_tur_1',
          name: 'Ana Fikir / Başlık Bulma',
          description:
              'Ana düşünce, metnin bütünüyle ilettiği temel yargıdır; başlık metnin konusunu veya ana düşüncesini kısa ve kapsayıcı biçimde yansıtır. Seçeneğin metnin tamamıyla uyumunu kontrol et.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Paragrafta Anlam',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page33.html',
          questionCount: 4,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_2',
          name: 'Boşluğa Uygun Cümle',
          description:
              'Boşluğun öncesi ve sonrasındaki düşünce akışını birlikte değerlendir. Bağlaçlar, zamirler ve tekrar edilen kavramlar ilişkiyi gösterebilir; uygun cümle paragrafın anlam ve bütünlüğünü sürdürür.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Paragrafta Anlam',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page33.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_3',
          name: 'Paragraftan Çıkarılacak Sonuç',
          description:
              'Çıkarım, metinde doğrudan söylenmeyen ancak verilen bilgilerden desteklenen sonuçtur. Metin dışı varsayım ekleme; seçeneğin bütün dayanaklarını paragrafta ara.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Paragrafta Anlam',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page33.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_4',
          name: 'Paragrafın Açıklama Yöntemi',
          description:
              'Paragrafta düşünce tanımlama, örnekleme, karşılaştırma, tanık gösterme, sayısal verilerden yararlanma veya betimleme gibi yollarla açıklanabilir. Yalnızca anahtar sözcüğe değil, cümlelerin paragraftaki işlevine bak.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Paragrafta Anlam',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page33.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_5',
          name: 'Anlam Bütünlüğünü Bozan Cümle',
          description:
              'Paragrafın konusu ve ana düşüncesiyle doğrudan ilişkisi kurulamayan, düşünce akışını başka yöne çeviren cümleyi bul. Cümle sayısı değişebilir; ortak sözcük bulunması tek başına anlam bütünlüğü sağlamaz.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Paragrafta Anlam',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page33.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_6',
          name: 'Paragrafın Planı (Sıralama)',
          description:
              'Cümleleri giriş, gelişme ve sonuç ilişkilerine göre sırala. Bağlaçlar ve gönderim sözleri (bu, şu, o gibi) önceki bağlama işaret edebilir; ilişkiyi cümle anlamıyla doğrula.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Paragrafta Anlam',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page33.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_7',
          name: 'Sözcükte Anlam (Gerçek-Mecaz-Terim)',
          description:
              'Gerçek anlam sözcüğün temel anlamıdır; mecaz anlam, sözcüğün gerçek anlamından uzaklaşarak kazandığı anlamdır. Terim anlam belirli bir bilim, sanat, spor veya meslek alanına özgüdür. Anlamı cümle bağlamında belirle.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Sözcükte Anlam',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page9.html',
          questionCount: 3,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_8',
          name: 'Eş Anlamlı Sözcükler',
          description:
              'Eş anlamlı sözcükler bazı bağlamlarda aynı veya yakın anlamı karşılayabilir; her kullanımda birbirinin yerine geçmeyebilir. Seçimi cümledeki anlam ve kullanıma göre yap.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Sözcükte Anlam',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page9.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_9',
          name: 'Cümlede Anlam (İlgi-Koşul-Amaç)',
          description:
              'Koşul, bir yargının gerçekleşmesini başka bir duruma bağlar; amaç, eylemin hedefini; neden-sonuç ise eylemin gerekçesini bildirir. “-se/-sa”, “için” veya “çünkü” ipucu olabilir ama ilişkiyi cümlenin anlamından belirle.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Cümlede Anlam',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page21.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_10',
          name: 'Atasözü ve Deyim',
          description:
              'Atasözü, deneyim ve gözleme dayalı, genellikle öğüt veya genel yargı bildiren kalıplaşmış sözdür. Deyim, çoğunlukla gerçek anlamından uzaklaşmış, kalıplaşmış söz öbeğidir; mutlaka fiil biçiminde veya tam cümle olmak zorunda değildir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Sözcükte Anlam',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page9.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_11',
          name: 'Sözcük Türleri — Sıfırdan',
          description:
              'Sözcük türünü cümledeki görevine göre belirle: isim varlık/kavramı adlandırır; sıfat ismi niteler veya belirtir; zamir ismin yerini tutar; zarf fiil, sıfat ya da başka bir zarfı etkiler. Edat, bağlaç ve ünlem de ayrı türlerdir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, İsim Soylu Sözcükler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page109.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'tyt_tur_12',
          name: 'Fiil ve Fiilimsi — Sıfırdan',
          description:
              'Fiiller iş, oluş veya durum bildirir; çekimli fiiller kip/zaman ve kişi özellikleriyle yüklem olabilir. Fiilimsiler fiil kök veya gövdelerinden türeyip isim, sıfat ya da zarf görevinde kullanılır; isim-fiil, sıfat-fiil ve zarf-fiil olarak incelenir. Eklerin görevini sözcüğün bağlamında belirle.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Fiiller ve Fiilimsiler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page123.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'tyt_tur_13',
          name: 'Cümle Türleri',
          description:
              'Cümleler yüklemin türüne göre fiil/isim; yüklemin yerine göre kurallı/devrik; anlamına göre olumlu/olumsuz, soru, ünlem veya emir; yapısına göre basit, birleşik, sıralı ya da bağlı olarak sınıflandırılabilir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Cümle Türleri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page159.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_14',
          name: 'Yazım Kuralları',
          description:
              'Yazım kuralları büyük harf kullanımı, birleşik sözcükler ve eklerin yazımını kapsar. Bağlaç olan de/da ayrı; bulunma hâli eki -de/-da bitişik yazılır. Bağlaç olan ki ayrı, ek olan -ki bitişik yazılır. Bu örnekler kuralların tamamı değildir; tereddütte TDK Yazım Kılavuzu’na bak.',
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
              'Virgül eş görevli sözcük ve söz öbeklerini ayırabilir; noktalı virgül, içinde virgül bulunan grupları veya sıralı cümleleri ayırmada kullanılabilir. İki nokta açıklama/örnekten önce gelebilir. İşaret seçimini cümlenin yapısına ve TDK kurallarına göre yap.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Noktalama İşaretleri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page87.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_tur_16',
          name: 'Anlatım Bozuklukları',
          description:
              'Anlatım bozukluklarında özne-yüklem uyumsuzluğu, öge eksikliği, gereksiz/yanlış sözcük kullanımı, anlamca çelişen ifadeler ve tamlama/çatı uyumsuzluğu gibi sorunları ara. Düzeltmenin cümledeki anlamı koruduğunu kontrol et.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Anlatım Bozuklukları',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page169.html',
          questionCount: 2,
          difficulty: '🔴 Zor',
          priority: '🟡 ORTA',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_tur_17',
          name: 'Ses Bilgisi',
          description:
              'Ses olayları arasında ünsüz yumuşaması (kitap→kitabı) ve bazı sözcüklerde ünlü düşmesi (ağız→ağzı) bulunur. Ses değişimleri ekin/sözcüğün yapısına ve kullanımına bağlıdır; her p/ç/t/k ile biten sözcük yumuşamaz ve istisnalar vardır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Türkçe, Ses Bilgisi',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page45.html',
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
              'SI temel birimleri: uzunluk metre (m), kütle kilogram (kg), zaman saniye (s), elektrik akımı amper (A), sıcaklık kelvin (K), madde miktarı mol (mol), ışık şiddeti kandela (cd). Türetilmiş birim örnekleri: kuvvet newton (N=kg·m/s²), enerji joule (J=N·m).',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Fizik, Fizik Bilimine Giriş',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/fizik/files/basic-html/page12.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 1,
        ),
        Topic(
          id: 'tyt_fiz_2',
          name: 'Kuvvet ve Hareket — Newton Kanunları',
          description:
              'Newton I: net kuvvet sıfırsa cisim durur veya sabit hızla hareket eder. Newton II: net kuvvet ΣF=ma bağıntısını sağlar. Newton III: etki-tepki kuvvetleri eşit büyüklükte, zıt yönlü ve farklı cisimler üzerindedir; birbirini aynı cisim üzerinde yok etmez.',
          sourceLabel:
              'MEB OGM Materyal · Fizik 11, Newton’ın Hareket Yasaları',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fizik/11/unite1/files/basic-html/page32.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_fiz_3',
          name: 'Enerji – İş – Güç',
          description:
              'Sabit kuvvetin yaptığı iş W=Fd cosθ (θ, kuvvet ile yer değiştirme arasındaki açı); kinetik enerji Eₖ=½mv² (Newton mekaniğinde). Dünya yüzeyine yakın ve g yaklaşık sabitken, seçilen referans düzeyine göre çekim potansiyel enerjisi Eₚ=mgh; ortalama güç yapılan iş/zamandır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Fizik, İş, Güç ve Enerji',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/fizik/files/basic-html/page79.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_fiz_4',
          name: 'Basınç',
          description:
              'Basınç, yüzeye dik kuvvetin alana oranıdır: P=F⊥/A. Durgun, homojen sıvıda g sabitken serbest yüzeyden h derinlikteki gösterge basıncı p=ρgh; mutlak basınçta açık yüzey basıncı da eklenir. SI birimi pascal (Pa=N/m²).',
          sourceLabel: 'MEB OGM Materyal · Defterim Fizik 10, Basınç',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/10/fizik/files/basic-html/page88.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_fiz_5',
          name: 'Isı ve Sıcaklık',
          description:
              'Sıcaklık, taneciklerin ortalama kinetik enerjisiyle ilişkili bir ölçüdür; °C veya K ile ifade edilir. Isı, sıcaklık farkı nedeniyle sistemler arasında aktarılan enerjidir. Hal değişimi olmayan ve c sabit kabul edilen durumda Q=mcΔT kullanılabilir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Fizik, Isı ve Sıcaklık',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/fizik/files/basic-html/page113.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_fiz_6',
          name: 'Elektrik Temeli',
          description:
              'Elektrik akımı, yüklerin yönlü hareketidir; metal iletkende hareketli yükler elektronlardır, geleneksel akım yönü elektronların sürüklenme yönüne terstir. Potansiyel farkı birim yük başına enerji değişimidir. Ohm yasası, ohmik iletkende fiziksel koşullar sabitken V=IR bağıntısıdır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Fizik, Elektrik ve Manyetizma',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/fizik/files/basic-html/page155.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_fiz_7',
          name: 'Dalgalar ve Optik',
          description:
              'İdeal mekanik dalgada ortam tanecikleri denge konumu çevresinde titreşirken dalga enerji taşır; aynı ortamda dalga hızı v=fλ. Yansıma açısı gelme açısına eşittir (açılar normale göre ölçülür). Işık, yansıma ve kırılmanın yanında gölge, ayna ve merceklerle incelenir; kırılmada ışının yönü her gelişte değişmek zorunda değildir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Fizik, Dalgalar ve Optik',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/fizik/index.html',
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
              'Proton (+) ve nötron (yüksüz) çekirdekte; elektronlar çekirdek çevresindeki orbitallerde bulunur. Atom numarası proton sayısıdır; kütle numarası proton+nötron sayısıdır. Nötron sayısı=kütle numarası−atom numarası; nötr atomda elektron sayısı proton sayısına eşittir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Kimya, Atom Modelleri ve Atomun Yapısı',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page51.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_kim_2',
          name: 'Periyodik Tablo — Temeli',
          description:
              'Periyodik tabloda gruplar sütun, periyotlar satırdır. Aynı ana grup elementleri benzer kimyasal özellikler gösterebilir. Modern numaralandırmada gruplar 1–18’dir; halojenler 17., soy gazlar 18. gruptadır. Metaller çoğunlukla sol/orta, ametaller sağ üst bölgede; yarı metaller arada yer alır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Kimya, Periyodik Sistem',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page67.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_kim_3',
          name: 'Kimyasal Bağlar',
          description:
              'İyonik bağ zıt yüklü iyonlar arasındaki elektrostatik çekimdir (NaCl); kovalent bağ atomların elektron çiftlerini paylaşmasıyla oluşur (H₂O’da polar kovalent bağ); metalik bağ, metal örgüsündeki tanecikler ve delokalize elektronlar arasındaki etkileşimle açıklanır. “Metal+ametal” ve “ametal+ametal” tipik örüntüdür, mutlak sınıflandırma kuralı değildir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Kimya, Kimyasal Türler Arası Etkileşimler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page93.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_kim_4',
          name: 'Madde ve Karışımlar',
          description:
              'Saf maddeler element veya bileşiktir; belirli bileşimleri vardır. Karışımlar, maddelerin kimyasal kimlikleri korunarak fiziksel olarak bir araya gelmesiyle oluşur; homojen veya heterojen olabilir. Ayırma yöntemi bileşenlerin fiziksel özellik farkına göre seçilir (süzme, damıtma, buharlaştırma gibi).',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Kimya, Karışımlar ve Ayırma Teknikleri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page219.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_kim_5',
          name: 'Asit-Baz (TYT)',
          description:
              'Sulu çözeltide asit H₃O⁺ derişimini, baz OH⁻ derişimini artırır; Brønsted tanımında asit proton verir, baz proton alır. 25 °C’de pH<7 asidik, pH=7 nötr, pH>7 bazik çözeltiyi gösterir. İndikatörler renk değiştirir; maddeleri tatma veya dokunarak tanıma yöntemi değildir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Kimya, Asitler, Bazlar ve Tuzlar',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page251.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_kim_6',
          name: 'Kimyasal Tepkimeler',
          description:
              'Kapalı sistemde kimyasal tepkimede toplam kütle korunur. Denklem denkleştirilirken formüllerin indisleri değiştirilmez; katsayılar, her elementin atom sayıları tepkime öncesi ve sonrasında eşit olacak şekilde seçilir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Kimya, Kimyasal Tepkimeler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page201.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_kim_7',
          name: 'Mol Kavramı (Temel TYT)',
          description:
              '1 mol, tam olarak 6,02214076×10²³ belirtilmiş temel varlık içerir. Kütlesi m ve mol kütlesi M olan örnek için n=m/M (M g/mol, m g ise n mol). Okul düzeyinde H₂O’nun mol kütlesi yaklaşık 18 g/mol’dür (2×1+16).',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Kimya, Kimyanın Temel Kanunları ve Mol Kavramı',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page181.html',
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
              'Hücre, canlıların yapısal ve işlevsel temel birimidir. Tipik prokaryot ve ökaryot hücrelerde hücre zarı, sitoplazma, DNA ve ribozom bulunur. Ökaryotların tipik hücrelerinde çekirdek ve zarla çevrili organeller yer alır. Ribozom protein sentezler; mitokondri hücresel solunumla ATP üretiminde görevlidir. Kloroplast, fotosentez yapan bitki ve alg gibi bazı ökaryotlarda bulunur.',
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
              'Her iki hücre tipinde de hücre zarı, sitoplazma, DNA ve ribozom bulunur. Prokaryotlarda zarla çevrili çekirdek ve organeller yoktur; DNA nükleoit bölgede bulunur. Bakteriler ve arkeler prokaryottur. Ökaryotlarda çekirdek ve zarla çevrili organeller vardır; protist, bitki, mantar ve hayvanlar ökaryottur. Virüsler hücresel yapıda değildir.',
          sourceLabel: 'MEB OGM Materyal · Biyoloji 9, Hücrenin Yapısı',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/9/unite2/files/basic-html/page9.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_bio_3',
          name: 'Canlıların Sınıflandırılması',
          description:
              'Sınıflandırma basamakları büyükten küçüğe âlem → şube → sınıf → takım → familya (aile) → cins → türdür. Türden âleme doğru gidildikçe ortak özellik ve akrabalık azalırken kapsanan canlı çeşitliliği artar. Bakteriler prokaryot hücrelidir; mantarlar arasında ayrıştırıcılar bulunur. Virüsler hücresel canlı gruplarına dâhil edilmez.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Biyoloji, Sınıflandırma',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/biyoloji/files/basic-html/page101.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_bio_4',
          name: 'Fotosentez ve Solunum',
          description:
              'Oksijenli fotosentezin sadeleştirilmiş net denklemi: 6CO₂ + 6H₂O + ışık enerjisi → C₆H₁₂O₆ + 6O₂. Oksijenli solunumun genel denklemi: C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + enerji; açığa çıkan enerji ATP sentezinde kullanılır. ATP verimi sabit bir katsayı değildir; hücreye ve kullanılan hesaplama modeline göre değişir.',
          sourceLabel:
              'MEB OGM Materyal · Biyoloji 12, Canlılarda Enerji Dönüşümleri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/12/unite2/index.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_bio_5',
          name: 'Ekosistem ve Besin Zinciri',
          description:
              'Üreticiler kendi organik besinini üreten ototroflardır; tüketiciler besinini dışarıdan alan heterotroflardır. Bazı bakteri ve mantarlar ayrıştırıcıdır. Enerji beslenme basamakları arasında tek yönlü aktarılır ve bir üst basamağa aktarılabilen enerji azalır; oran ekosisteme göre değişir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Biyoloji, Ekosistem Ekolojisi',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/biyoloji/files/basic-html/page231.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 1,
        ),
        Topic(
          id: 'tyt_bio_6',
          name: 'Kalıtım Temeli (TYT)',
          description:
              'DNA kalıtsal bilgiyi taşır. Gen, DNA üzerindeki işlevsel bir RNA veya polipeptit ürününün oluşumuyla ilişkili nükleotit dizisidir. Ökaryot kromozomları DNA ve proteinlerden oluşur. İnsanın diploit vücut hücrelerinde 46 kromozom (23 çift), gametlerinde 23 kromozom bulunur.',
          sourceLabel: 'MEB OGM Materyal · Biyoloji 10, Mitoz ve Eşeysiz Üreme',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/10/unite1/files/basic-html/page6.html',
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
          'Tarih konularında neden-sonuç ve kronoloji kur; coğrafyada harita yorumla; felsefe ve din kavramlarını kısa tanım ve örneklerle ayırt et.',
      topics: [
        Topic(
          id: 'tyt_sos_1',
          name: 'Osmanlı Kuruluş ve Yükselme',
          description:
              'Osmanlı Beyliği’nin kuruluşu geleneksel olarak 1299’a tarihlenir; kuruluş süreci ve tarihlemesi farklı görüşlerle ele alınır. II. Mehmed 1453’te İstanbul’u aldı. Yavuz Sultan Selim döneminde 1517 Ridaniye Savaşı’yla Mısır Osmanlı topraklarına katıldı. Olayları dönemleri ve sonuçlarıyla birlikte değerlendir.',
          sourceLabel: 'MEB OGM Materyal · Tarih 10, Osmanlı Devleti',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/tarih/10/unite2/files/basic-html/page4.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_2',
          name: 'Osmanlı’da Yenileşme ve Son Dönem',
          description:
              'Tanzimat Fermanı 1839’da, Islahat Fermanı 1856’da ilan edildi. I. Meşrutiyet ve Kanun-ı Esasi 1876’da; II. Meşrutiyet 1908’de ilan edildi. Osmanlı Devleti I. Dünya Savaşı’na 1914’te girdi; Mondros Ateşkes Antlaşması 1918’de, Sevr Antlaşması 1920’de imzalandı. Bu dönemi tek bir “gerileme” nedeni ile açıklama.',
          sourceLabel: 'MEB OGM Materyal · Tarih 11, Osmanlı’da Yenileşme',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/calisma_defteri/f7/11/tarih/tarih.pdf',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_3',
          name: 'Kurtuluş Savaşı — ÇOK KRİTİK!',
          description:
              'Mustafa Kemal 19 Mayıs 1919’da Samsun’a çıktı; Erzurum ve Sivas kongreleri millî irade ve bağımsızlık hedefini örgütledi. TBMM 23 Nisan 1920’de açıldı. Sakarya Zaferi (1921) ve Büyük Taarruz (1922) sonrasında Mudanya Ateşkesi yapıldı; Lozan Barış Antlaşması 24 Temmuz 1923’te imzalandı.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Tarih, Millî Mücadele',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tarih/files/basic-html/page230.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_sos_4',
          name: 'Atatürk Dönemi İnkılapları',
          description:
              'Saltanat 1 Kasım 1922’de kaldırıldı; Cumhuriyet 29 Ekim 1923’te ilan edildi; halifelik 3 Mart 1924’te kaldırıldı. Yeni Türk harfleri 1928’de kabul edildi. Kadınlara seçme ve seçilme hakkı belediye seçimlerinde 1930’da, muhtarlık seçimlerinde 1933’te, milletvekili seçimlerinde 1934’te tanındı.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Tarih, Atatürkçülük',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tarih/files/basic-html/page238.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_sos_5',
          name: 'Türkiye\'nin Coğrafi Özellikleri',
          description:
              'Türkiye Kuzey Yarım Küre’de 36°–42° kuzey enlemleri ve 26°–45° doğu boylamları arasında, orta kuşakta yer alır. Yükselti batıdan doğuya genel olarak artar; dağların uzanışı ve yer şekilleri iklimi, ulaşımı ve yerleşmeyi etkiler. Mutlak konum ile göreceli konumun sonuçlarını harita üzerinde karşılaştır.',
          sourceLabel: 'MEB OGM Materyal · Dört Dörtlük TYT Coğrafya, Konum',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/cografya/files/basic-html/page48.html',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_sos_6',
          name: 'Türkiye\'de İklim',
          description:
              'Türkiye’de iklim; enlem, yükselti, denizellik-karasallık, dağların uzanışı ve bakı gibi etkenlerle çeşitlenir. Akdeniz ikliminde yazlar genellikle sıcak-kurak, kışlar ılık-yağışlıdır. Karadeniz kıyılarında yağış yıl geneline yayılır; iç ve doğu kesimlerde karasallık ve yükselti kış koşullarını sertleştirir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Coğrafya, Türkiye İklimi',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/cografya/files/basic-html/page101.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_7',
          name: 'Türkiye\'de Tarım ve Ekonomi',
          description:
              'Tarım ürünlerinin dağılışını iklim, su, toprak, yer şekilleri ve üretim teknolojisi birlikte belirler. Tahıllar İç Anadolu’da yaygındır; çay Doğu Karadeniz’de, fındık Karadeniz kıyılarında, zeytin Ege ve Akdeniz kuşağında, pamuk ise sulamanın elverdiği Ege, Çukurova ve Güneydoğu alanlarında yetiştirilir. Ürün-bölge eşleştirmelerini değişmez sınırlar gibi düşünme.',
          sourceLabel:
              'MEB OGM Materyal · Coğrafya 11, Türkiye’de Tarım Ürünleri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/beceri_temelli/11/cografya/files/basic-html/page69.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_8',
          name: 'Dünya Coğrafyası Temeli',
          description:
              'Dünya haritasında kıtaları ve okyanusları konumlarıyla tanı; Asya yüzölçümü en büyük kıtadır. Ekvator çevresinde ekvatoral iklim, yüksek enlemlerde tundra ve kutup iklimleri görülür. Kıta ve okyanus sayımı kullanılan coğrafi sınıflandırmaya göre değişebildiğinden kaynakta benimsenen modeli belirt.',
          sourceLabel: 'MEB OGM Materyal · Coğrafya 10, Okyanuslar ve Denizler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/cografya/10/unite1/files/basic-html/page64.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 1,
        ),
        Topic(
          id: 'tyt_sos_9',
          name: 'Felsefeye Giriş ve Varlık Felsefesi',
          description:
              'Felsefe, kavramları ve varsayımları gerekçeleriyle sorgular. Varlık felsefesi “Varlık var mıdır, temeli nedir?” gibi soruları ele alır. Materyalizm varlığın temelinde maddeyi, idealizm ideayı, düalizm madde ve ideayı birlikte görür; bu görüşler “yalnızca ... vardır” diye özetlenmemelidir.',
          sourceLabel: 'MEB OGM Materyal · Dört Dörtlük TYT Felsefe, Varlık',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/felsefe/files/basic-html/page45.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_10',
          name: 'Bilgi Felsefesi — Akımlar',
          description:
              'Rasyonalizm aklı, empirizm deneyimi bilginin kaynağı olarak öne çıkarır. Kant’ın kritisizmi, deneyimin sağladığı içeriğin zihnin a priori biçim ve kategorileriyle işlendiğini savunarak iki yaklaşımın rolünü birlikte değerlendirir.',
          sourceLabel: 'MEB OGM Materyal · Dört Dörtlük TYT Felsefe, Bilgi',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/felsefe/files/basic-html/page71.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_11',
          name: 'Ahlak ve Siyaset Felsefesi',
          description:
              'Ahlak felsefesi iyi-kötü ve doğru eylemin ölçütlerini sorgular: hazcılık hazzı, erdem etiği karakter ve erdemi, Kant’ın ödev etiği evrenselleştirilebilir ilkeyi, faydacılık eylemlerin sonuçlarını öne çıkarır. Siyaset felsefesi devletin kaynağını, iktidarın sınırlarını, adalet ve özgürlük sorunlarını inceler.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük TYT Felsefe, Ahlak ve Siyaset',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/felsefe/felsefe.pdf',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_12',
          name: 'İslam\'ın Temel İlkeleri',
          description:
              'İmanın esasları altıdır: Allah’a, meleklere, kitaplara, peygamberlere, ahiret gününe ve kadere inanmak. İslam’ın beş şartı kelime-i şehadet, namaz, oruç, zekât ve hacdır. İman esasları ile ibadet şartlarını aynı liste olarak karıştırma.',
          sourceLabel: 'Diyanet İşleri Başkanlığı · Dinimi Öğreniyorum',
          sourceUrl:
              'https://yazkurankurslari.diyanet.gov.tr/evrak/kitap/dinimi_ogreniyorum.pdf',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_13',
          name: 'Hz. Muhammed\'in Hayatı',
          description:
              'Hz. Muhammed yaklaşık 570/571’de Mekke’de doğdu. İslamî kaynaklarda ilk vahiy 610’a, Hicret 622’ye, Mekke’nin fethi 630’a, vefatı 632’ye tarihlenir. Doğum yılının 570 veya 571 verilmesi kaynaklarda görülen farklı tarihleme geleneğindendir.',
          sourceLabel: 'Türkiye Diyanet Vakfı İslâm Ansiklopedisi · Muhammed',
          sourceUrl: 'https://islamansiklopedisi.org.tr/muhammed',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_sos_14',
          name: 'Kuran ve Temel Kavramlar',
          description:
              'Kur’an 114 sureden oluşur; yaygın Kûfî sayımında 6.236 ayet kabul edilir. İlk vahiy olarak Alak suresinin ilk ayetleri kabul edilir; Bakara 286 ayetle en uzun suredir. Meal anlam aktarımı, tefsir açıklama ve yorum, hadis Hz. Peygamber’e nispet edilen söz-fiil-onay rivayetleri, sünnet örnek yaşayışı, fıkıh amelî hükümleri konu edinir; siyer Hz. Muhammed’in hayatını inceler.',
          sourceLabel: 'Diyanet · Kur’an-ı Kerim ve Temel Kavramlar',
          sourceUrl: 'https://kuran.diyanet.gov.tr/tefsir/sure/2',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 1,
        ),
      ],
    ),

    // ═══════════════════════════════════════════════
    // AYT MATEMATİK — 16 Konu, 40 Soru
    // ═══════════════════════════════════════════════
    Subject(
      name: 'AYT Matematik',
      emoji: '🔢',
      type: 'AYT',
      totalQuestions: 40,
      tip:
          'Yeni konuyu tanım koşullarıyla öğren, bağıntıları farklı soru türlerinde uygula ve deneme yanlışlarına göre tekrar sırasını belirle.',
      topics: [
        Topic(
          id: 'ayt_mat_1',
          name: 'Fonksiyonlar — AYT Seviyesi',
          description:
              'Fonksiyon, tanım kümesindeki her girdiye tek bir değer eşler. Bileşke (f∘g)(x)=f(g(x)) şeklindedir. Ters fonksiyonun varlığı için fonksiyon birebir ve örten olmalı; uygun bir alt kümeye kısıtlanarak da terslenebilir. İkinci dereceden fonksiyonda a≠0.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Matematik, Fonksiyonlar',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page93.html',
          questionCount: 4,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 5,
        ),
        Topic(
          id: 'ayt_mat_2',
          name: '2. Derece Denklem ve Parabol',
          description:
              'ax²+bx+c=0 ve a≠0. Δ=b²−4ac; Δ>0 iki, Δ=0 çakışık iki, Δ<0 gerçek kök olmadığını gösterir. Kökler toplamı −b/a, çarpımı c/a’dır. y=ax²+bx+c parabolünün tepe noktasının apsisi −b/(2a), ordinatı f(−b/(2a)) olur.',
          sourceLabel: 'MEB OGM Materyal · Dört Dörtlük AYT Matematik, Parabol',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page115.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 5,
        ),
        Topic(
          id: 'ayt_mat_3',
          name: 'Polinomlar',
          description:
              'Bir değişkenli polinom, değişkenin negatif olmayan tam sayı kuvvetlerinin sonlu toplamıdır. P(x), x−a ile bölündüğünde kalan P(a)’dır; dolayısıyla P(a)=0 ise x−a polinomun çarpanıdır. Polinom bölmesinde kalan derecesi bölenin derecesinden küçüktür.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük Matematik 10, Polinomlar',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/10/matematik/files/basic-html/page107.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_mat_4',
          name: 'Logaritma — Sıfırdan',
          description:
              'logₐ(x)=y ancak a>0, a≠1 ve x>0 iken tanımlıdır; aʸ=x eşdeğerliği geçerlidir. Çarpım ve bölüm kuralları pozitif argümanlar için uygulanır: logₐ(xy)=logₐx+logₐy, logₐ(x/y)=logₐx−logₐy. Üstel fonksiyon logaritmanın tersidir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Matematik, Logaritma',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page291.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_mat_5',
          name: 'Diziler',
          description:
              'Aritmetik dizide aₙ=a₁+(n−1)d ve Sₙ=n(a₁+aₙ)/2’dir. Geometrik dizide aₙ=a₁rⁿ⁻¹; r≠1 için ilk n terim toplamı Sₙ=a₁(1−rⁿ)/(1−r), r=1 ise Sₙ=na₁ olur.',
          sourceLabel: 'MEB OGM Materyal · Dört Dörtlük AYT Matematik, Diziler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page313.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_mat_6',
          name: 'Trigonometri',
          description:
              'Birim çember açıların sinüs ve kosinüsünü tanımlar; sin²x+cos²x=1’dir. tan x=sin x/cos x yalnız cos x≠0 iken tanımlıdır. Yönlü açı, toplam-fark ve iki kat açı bağıntıları ile trigonometrik denklemlerde çözüm aralık ve periyot koşullarına göre belirlenir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Matematik, Trigonometri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page30.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_mat_7',
          name: 'Analitik Geometri',
          description:
              'İki nokta arası uzaklık d=√((x₂−x₁)²+(y₂−y₁)²). Eğimli doğru y−y₁=m(x−x₁) biçiminde yazılır; düşey doğruların eğimi tanımsızdır. Merkezi (h,k), yarıçapı r>0 olan çemberin denklemi (x−h)²+(y−k)²=r²’dir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Matematik, Analitik Geometri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page67.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_mat_8',
          name: 'Türev ve Uygulamaları',
          description:
              'Pozitif tam sayı n için (xⁿ)′=nxⁿ⁻¹; türevlenebilir f ve g için (fg)′=f′g+fg′. Teğet eğimi f′(a)’dır. Türevin işareti artma-azalma aralıklarını ve yerel ekstremumları incelemeye yardım eder; sonuçlar tanım aralığı ve türev koşullarıyla birlikte değerlendirilir.',
          sourceLabel: 'MEB OGM Materyal · Dört Dörtlük AYT Matematik, Türev',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page429.html',
          questionCount: 2,
          difficulty: '🔴 Zor',
          priority: '🟡 ORTA',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_mat_9',
          name: 'İntegral ve Uygulamaları',
          description:
              'n≠−1 için ∫xⁿdx=xⁿ⁺¹/(n+1)+C; belirsiz integral ailesinde sabit C bulunur. Belirli integral net işaretli alanı verir; geometrik alan için eksenin altında kalan parçalar pozitif alınarak aralık gerekirse bölünür.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Matematik, İntegral',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page449.html',
          questionCount: 1,
          difficulty: '🔴 Zor',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_mat_10',
          name: 'Limit (Temel)',
          description:
              'Bir noktadaki limit için sağ ve sol yaklaşım aynı değere gitmelidir. Polinomlar sürekli olduğundan limitte yerine koyma yapılabilir. 0/0 bir belirsizliktir, limitin varlığını veya değerini tek başına göstermez; çarpanlara ayırma, eşlenikle çarpma ve uygun limit bağıntıları kullanılabilir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Matematik, Limit ve Süreklilik',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page395.html',
          questionCount: 1,
          difficulty: '🔴 Zor',
          priority: '🔵 DÜŞÜK',
          estimatedDays: 1,
        ),
        Topic(
          id: 'ayt_mat_11',
          name: 'Çember ve Daire (AYT Geometri)',
          description:
              'Merkez açının ölçüsü gördüğü yayın ölçüsüne, çevre açının ölçüsü gördüğü yayın ölçüsünün yarısına eşittir; çapı gören çevre açı 90°\'dir. Teğet, değme noktasında yarıçapa diktir ve dışarıdaki bir noktadan çizilen iki teğet parçasının uzunlukları eşittir. Yarıçapı r olan çemberin çevresi 2πr, dairenin alanı πr²\'dir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Matematik, alt öğrenme alanı ve konu dağılım tablosu',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page8.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_mat_12',
          name: 'Katı Cisimler (AYT Geometri)',
          description:
              'Dik prizma ve dik dairesel silindirde hacim taban alanı×yükseklik; piramit ve dik dairesel konide hacim taban alanı×yükseklik/3\'tür. Yarıçapı r olan kürenin hacmi 4πr³/3, yüzey alanı 4πr²\'dir. Ayrıtı a olan küpte hacim a³, yüzey alanı 6a²\'dir. Yüzey alanında açınımı çizmek hangi yüzlerin sayılacağını netleştirir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Matematik, alt öğrenme alanı ve konu dağılım tablosu',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page8.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_mat_13',
          name: 'Koşullu Olasılık',
          description:
              'P(B)>0 iken A\'nın B verildiğinde koşullu olasılığı P(A|B)=P(A∩B)/P(B)\'dir. A ve B bağımsızsa P(A∩B)=P(A)·P(B) ve P(A|B)=P(A) olur. Teorik olasılık eş olasılıklı örnek uzaydan, deneysel olasılık gözlenen sıklıktan hesaplanır; deneme sayısı arttıkça deneysel olasılık genellikle teorik değere yaklaşır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Matematik, alt öğrenme alanı ve konu dağılım tablosu',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page8.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_mat_14',
          name: 'Analitik Düzlemde Dönüşümler',
          description:
              '(x,y) noktası (a,b) kadar ötelenince (x+a, y+b) olur. x eksenine göre yansıması (x,−y), y eksenine göre (−x,y), orijine göre (−x,−y), y=x doğrusuna göre (y,x)\'tir. Orijin etrafında pozitif yönde 90° dönme (x,y)→(−y,x) dönüşümüdür. Öteleme, yansıma ve dönme uzunlukları ve açı ölçülerini korur.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Matematik, alt öğrenme alanı ve konu dağılım tablosu',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page8.html',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟡 ORTA',
          estimatedDays: 1,
        ),
        Topic(
          id: 'ayt_mat_15',
          name: 'Denklem ve Eşitsizlik Sistemleri',
          description:
              'İkinci dereceden iki bilinmeyenli denklem sistemlerinde yerine koyma veya yok etme yöntemiyle ortak çözümler bulunur; gerçek ortak çözümler grafiklerin kesişim noktalarına karşılık gelir. İkinci dereceden bir bilinmeyenli eşitsizlikte kökler bulunup işaret tablosu yapılır; eşitsizlik sisteminin çözüm kümesi, her eşitsizliğin çözüm kümelerinin kesişimidir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Matematik, alt öğrenme alanı ve konu dağılım tablosu',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page8.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'ayt_mat_16',
          name: 'Üçgen ve Çokgenler (AYT Geometri)',
          description:
              'AYT geometri soruları TYT üçgen ve çokgen bilgisini de kullanır. Benzer üçgenlerde benzerlik oranı k ise karşılık gelen uzunlukların oranı k, alanların oranı k²\'dir. Açıortay, kenarortay ve yükseklik üçgenin yardımcı elemanlarıdır. n kenarlı dışbükey çokgende iç açıların toplamı (n−2)·180°, dış açıların toplamı 360°\'dir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Matematik, alt öğrenme alanı ve konu dağılım tablosu',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page8.html',
          questionCount: 2,
          difficulty: '🔴 Zor',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
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
              'Her cisim için serbest cisim diyagramı çiz ve ΣF=ma uygula. Eğik düzlemde ağırlığın bileşenleri mg sinθ (eğim boyunca aşağı) ve mg cosθ (yüzeye dik) olur. Kinetik sürtünme fₖ=μₖN; statik sürtünme gerektiği kadar değer alır ve |fₛ|≤μₛN koşulunu sağlar.',
          sourceLabel:
              'MEB OGM Materyal · Fen Lisesi Fizik 11, Eğik Düzlem ve Sürtünme',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/11/unite1/bolum2/files/basic-html/page129.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_fiz_2',
          name: 'Enerji ve Momentum',
          description:
              'Momentum p=mv; net itme I=∫F dt=Δp, sabit net kuvvette I=FΔt olur. Dış net itmenin ihmal edildiği sistemde toplam momentum korunur. Esnek çarpışmada kinetik enerji de korunur; esnek olmayan çarpışmada korunmaz. Mekanik enerji korunumu için kayıplara yol açan iş ayrıca hesaba katılır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Fizik, Enerji ve Momentum',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page115.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_fiz_3',
          name: 'Basit Harmonik Hareket',
          description:
              'İdeal yay-kütle sisteminde T=2π√(m/k); basit sarkaçta küçük açı yaklaşımıyla T=2π√(L/g). Hız denge noktasında, ivme ve geri çağırıcı kuvvet uç noktalarda en büyük büyüklüktedir. Genlik, denge noktasından en büyük uzaklıktır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Fizik, Basit Harmonik Hareket',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page279.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_fiz_4',
          name: 'Elektrik ve Manyetizma',
          description:
              'Noktasal yükler için Coulomb kuvveti F=k|q₁q₂|/r²; elektrik alan E=F/q₀’dır. Sığa C=Q/|ΔV| olarak tanımlanır. Manyetik alandaki yüklü parçacığa kuvvetin büyüklüğü |q|vB sinθ’dir. Lenz yasası indüksiyon akımının, manyetik akıdaki değişime karşı koyacak yönde oluştuğunu söyler.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Fizik, Elektrik ve Manyetizma',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page211.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_fiz_5',
          name: 'Dalgalar ve Optik (AYT)',
          description:
              'Dalgalarda kırınım ve girişim, yarık genişliği ile dalga boyuna bağlıdır. Çift yarıkta aydınlık saçak için yol farkı mλ, karanlık saçak için (m+1/2)λ olur. İnce mercek bağıntısı 1/f=1/dₒ+1/dᵢ ve büyütme m=−dᵢ/dₒ, kullanılan işaret uzlaşımına göre uygulanır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Fizik, Dalga Girişimi',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page299.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_fiz_6',
          name: 'Çembersel Hareket',
          description:
              'Düzgün çembersel harekette merkezcil ivme aᶜ=v²/r=ω²r ve net radyal kuvvet ΣFᵣ=mv²/r’dir; merkezcil kuvvet ayrı bir etkileşim kuvveti değil, radyal bileşkedir. Aynı merkezî kütle çevresindeki dairesel yörüngelerde Kepler bağıntısı T²/r³ sabittir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Fizik, Çembersel Hareket',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page247.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_fiz_7',
          name: 'Modern Fizik',
          description:
              'Fotoelektrik olayda foton enerjisi hf, maksimum elektron kinetik enerjisi Kₘₐₓ=hf−W₀’dır. de Broglie dalga boyu λ=h/p (klasik hızlarda p=mv). Radyoaktif bozunmada alfa, beta ve gama ışımaları ayırt edilir; yarı ömür, örnek miktarının yarıya inme süresidir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Fizik, Fotoelektrik Olay',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page375.html',
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
              'Mol sayısı n=m/M ile bulunur. İdeal gazlar için PV=nRT; 0 °C ve 1 atm koşullarında yaklaşık 22,4 L gaz 1 mol eder, bu değeri başka koşullarda sabit alma. Sınırlayıcı bileşen dengelenmiş tepkimeye göre belirlenir; yüzde verim=(gerçek ürün/kuramsal ürün)×100.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Kimya, İdeal Gaz Yasası',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page51.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 5,
        ),
        Topic(
          id: 'ayt_kim_2',
          name: 'Asit-Baz Dengesi (AYT)',
          description:
              'Seyreltik sulu çözeltilerde pH≈−log[H₃O⁺]. Suyun iyon çarpımı Kw=[H₃O⁺][OH⁻] sıcaklığa bağlıdır ve 25 °C’de yaklaşık 1,0×10⁻¹⁴’tür. Güçlü/zayıf asit-baz ayrımı, titrasyon ve tampon hesaplarında derişim ile tepkime koşullarını birlikte değerlendir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Kimya, Sulu Çözelti Dengeleri',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page229.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_kim_3',
          name: 'Kimyasal Denge',
          description:
              'aA+bB⇌cC+dD için denge derişimleriyle Kc=[C]ᶜ[D]ᵈ/([A]ᵃ[B]ᵇ); saf katı ve sıvılar ifadeye yazılmaz. Derişim ve basınç değişimleri denge konumunu etkileyebilir; basınç etkisi gaz mol sayılarına bağlıdır. Sıcaklık denge sabitini değiştirir; katalizör denge konumunu değiştirmez.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Kimya, Kimyasal Denge',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page213.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_kim_4',
          name: 'Elektrokimya',
          description:
              'Yükseltgenme elektron verme, indirgenme elektron almadır. Her iki hücre türünde de yükseltgenme anotta, indirgenme katotta gerçekleşir; galvanik hücre kendiliğinden tepkimeyle elektrik üretir, elektroliz dışarıdan elektrik enerjisi gerektirir. Elektrot kutupları hücre türüne göre değişir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Kimya, Elektrokimyasal Hücreler',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page285.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_kim_5',
          name: 'Organik Kimya Temeli',
          description:
              'Açık zincirli, tek bağ içeren alkanlar CₙH₂ₙ₊₂; bir çift bağ içeren alkenler CₙH₂ₙ; bir üçlü bağ içeren alkinler CₙH₂ₙ₋₂ genel formülündedir. Bu formüller halkalı veya birden fazla doymamış bağ içeren yapılara doğrudan uygulanmaz. Fonksiyonel grupları ve yapı izomerliğini ayırt et.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Kimya, Hidrokarbonlar',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page363.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_kim_6',
          name: 'Termodinamik Temeli',
          description:
              'Ekzotermik süreçte ΔH<0, endotermik süreçte ΔH>0; Hess yasasında tepkime denklemleri toplanırken entalpi değişimleri de toplanır. ΔG=ΔH−TΔS bağıntısında T mutlak sıcaklık (K), enerji birimleri tutarlı olmalıdır. Sabit sıcaklık ve basınçta ΔG<0 ileri yöndeki sürecin istemli olduğunu gösterir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Kimya, Tepkime Isıları',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page139.html',
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
              'Profaz, metafaz, anafaz ve telofazı sitokinez izler. Diploit ana hücrede DNA eşlenmesini bir mitoz izlerse genetik açıdan ana hücreyle aynı iki diploit hücre oluşur; büyüme, onarım ve bazı eşeysiz üreme biçimlerinde görev alır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük 10. Sınıf Biyoloji, Mitoz ve Eşeysiz Üreme',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/10/biyoloji/files/basic-html/page12.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_bio_2',
          name: 'Mayoz Bölünme',
          description:
              'Mayoz I’de homolog kromozomlar ayrılır ve ploidlik yarıya iner; profaz I’de crossing-over çeşitliliğe katkı verir. Mayoz II kardeş kromatitleri ayırır. Mayoz, haploit ürünler oluşturur; oogenezde sitoplazma bölünmesi eşit olmadığından tek büyük yumurta ve kutup hücreleri gelişir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük 10. Sınıf Biyoloji, Mayoz ve Eşeyli Üreme',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/10/biyoloji/files/basic-html/page26.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_bio_3',
          name: 'Kalıtım — Mendel Genetiği',
          description:
              'Tam baskınlıkta Aa×Aa monohibrit çaprazının fenotip oranı 3:1, genotip oranı 1:2:1’dir. Bağımsız dağılım ve diğer Mendel varsayımları sağlanırsa AaBb×AaBb çaprazında 9:3:3:1 fenotip oranı beklenir. Test çaprazı baskın fenotipli bireyin genotipini ayırt etmeye yardım eder.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük 10. Sınıf Biyoloji, Kalıtımın Genel Esasları',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/10/biyoloji/files/basic-html/page40.html',
          questionCount: 3,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 4,
        ),
        Topic(
          id: 'ayt_bio_4',
          name: 'Kan Grupları ve Cinsiyete Bağlı Kalıtım',
          description:
              'ABO sisteminde A ve B alelleri eş baskın, O aleli bu ikisine çekiniktir. X’e bağlı kalıtım, cinsiyete bağlı kalıtımın örneklerinden biridir; renk körlüğü bu örneklerdendir. Genotip ve olasılık yorumlarında ebeveyn genotipleri açıkça kurulmalıdır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük 10. Sınıf Biyoloji, Kan Grupları ve Eşeye Bağlı Kalıtım',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/10/biyoloji/files/basic-html/page56.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_bio_5',
          name: 'Sinir Sistemi',
          description:
              'Nöronlar dendrit, hücre gövdesi ve aksonla uyarı iletir. Merkezî sinir sistemi beyin ve omurilikten; çevresel sinir sistemi somatik ve otonom bölümlerden oluşur. Otonom sistem sempatik ve parasempatik kısımları içerir; refleks yayında omurilik rol alabilir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Biyoloji, Sinir Sistemi',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/biyoloji/files/basic-html/page9.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_bio_6',
          name: 'Hormonal Sistem',
          description:
              'Endokrin bezler hormonlarını kana verir. Hipofiz, tiroit, paratiroit, böbrek üstü bezleri ve pankreasın endokrin bölümü endokrin bez örnekleridir; insülin ve glukagon kan glikozunun düzenlenmesinde zıt etkiler gösterir.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Biyoloji, Endokrin Sistem',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/biyoloji/files/basic-html/page24.html',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_bio_7',
          name: 'Fotosentez Detay (AYT)',
          description:
              'Bitki kloroplastında ışığa bağımlı tepkimeler tilakoit zarında; Calvin döngüsü stromada gerçekleşir. Işık tepkimelerinin ATP ve NADPH ürünleri karbon bağlama basamaklarında kullanılır; Calvin döngüsü ışığı doğrudan kullanmasa da bu ürünlere bağlıdır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Biyoloji, Fotosentez ve Kemosentez',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/biyoloji/files/basic-html/page207.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'ayt_bio_8',
          name: 'Solunum Detay (AYT)',
          description:
              'Ökaryot hücrelerde glikoliz sitoplazmada; pirüvat oksidasyonu ve Krebs döngüsü mitokondri matriksinde; oksidatif fosforilasyon iç zarda gerçekleşir. ATP verimi hücreye ve hesaplama modeline göre değişir; fermantasyon ürünleri organizmaya ve koşullara bağlıdır.',
          sourceLabel:
              'MEB OGM Materyal · Dört Dörtlük AYT Biyoloji, Hücresel Solunum ve Fermantasyon',
          sourceUrl:
              'https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/biyoloji/files/basic-html/page221.html',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
      ],
    ),
  ];
}
