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
              'Doğal sayılar: 0,1,2,3... Tam sayılar: ...,-2,-1,0,1,2... Rasyonel: kesir olarak yazılabilen (1/2, 0.75, -3/4). İrrasyonel: kök2 gibi, ondalık bitmez tekrarlamaz. Pi=3.14159... İrrasyonel. Sayı doğrusu: solda negatif, sağda pozitif. 0 her zaman ortada.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_2',
          name: 'Dört İşlem ve İşlem Önceliği',
          description:
              'Sıra: Parantez→Üs→Çarpma/Bölme→Toplama/Çıkarma. Negatif sayılarla çarpma: (-2)×(-3)=+6. Sıfırla bölme: TANIMSIZ. Sıfırla çarpma=0.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 1,
        ),
        Topic(
          id: 'tyt_mat_3',
          name: 'Kesirler',
          description:
              'Pay/payda. 3/4, dört eş parçaya bölünmüş bir bütünün üç parçasını gösterir. Ortak payda: sadeleştir veya genişlet. Toplama/çıkarma: ortak payda bul. Çarpma: payları çarp, paydaları çarp. Bölme: ikinci kesri ters çevirip çarp.',
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
              'a²=a×a. a≠0 için a⁰=1; 0⁰ bu kuralın dışındadır. a≠0 için a⁻¹=1/a. Kurallar: aᵐ×aⁿ=aᵐ⁺ⁿ. a≠0 için aᵐ÷aⁿ=aᵐ⁻ⁿ. (aᵐ)ⁿ=aᵐˣⁿ. Örnek: 2³=8, 3²=9, 5²=25, 10³=1000.',
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
              'Gerçek sayılarda a,b≥0 ise √a×√b=√(a×b); b>0 ise √(a/b)=√a/√b. Örnek: √4=2, √9=3, √16=4, √25=5, √100=10. Paydada 1/√2 varsa √2/2 biçiminde yazılabilir.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_6',
          name: 'EBOB-EKOK',
          description:
              'EBOB: en büyük ortak bölen. EKOK: en küçük ortak kat. Pozitif tam sayılar a ve b için EBOB(a,b)×EKOK(a,b)=a×b. Asal çarpanlarla bul.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_7',
          name: 'Bölme-Bölünebilme',
          description:
              '2\'ye bölünme: son rakam çift. 3\'e bölünme: rakamlar toplamı 3\'ün katı. 4\'e bölünme: son 2 basamak 4\'ün katı. 5\'e bölünme: son rakam 0 veya 5. 9\'a bölünme: rakamlar toplamı 9\'un katı.',
          questionCount: 1,
          difficulty: '🟢 Kolay',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_8',
          name: 'Oran-Orantı',
          description:
              'a/b = c/d → a×d = b×c (çapraz çarpım). Doğru orantı: biri artınca diğeri artar. Ters orantı: biri artınca diğeri azalır.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_9',
          name: 'Yüzde Problemleri',
          description:
              '%20 artış: ×1.20. %20 azalış: ×0.80. %10 KDV: fiyat×1.10. Ardışık yüzde: her yüzdeyi ayrı uygula.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_10',
          name: 'Denklem Kurma — 1. Derece',
          description:
              'Bilinmeyen=x koy. "5 fazlası" = x+5. "3 katı" = 3x. Her iki tarafı eşitle, x\'i yalnız bırak.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_11',
          name: 'Sayı ve Kesir Problemleri',
          description:
              'Peş peşe sayılar: x, x+1, x+2. Bir sayının 3/4\'ü: x×3/4. Problem çeviri tekniği: kelimeleri matematiğe çevir.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_12',
          name: 'Yaş Problemleri',
          description:
              'Şu anki yaş=x. 5 yıl sonra: x+5. 3 yıl önce: x-3. İki kişinin yaş farkı HEP SABİT kalır!',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_13',
          name: 'İşçi-Havuz Problemleri',
          description:
              'İşçi: 1 günde yapılan iş oranı. A 6 günde, B 3 günde bitiriyorsa birlikte: 1/6+1/3=1/2 → 2 gün.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_14',
          name: 'Hız Problemleri',
          description:
              'v=yol/zaman. Yol=hız×zaman. Karşıdan gelen: hızlar TOPLANIR. Aynı yöne giden: hızlar ÇIKARILIR.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_15',
          name: 'Kar-Zarar ve Karışım',
          description:
              'Kar = Satış - Maliyet. %Kar = Kar/Maliyet×100. Karışım: 1.sıvı×miktar + 2.sıvı×miktar = toplam×ortalama.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_16',
          name: 'Mutlak Değer',
          description:
              '|a| = a eğer a≥0, -a eğer a<0. |3|=3, |-3|=3. |a-b| = a ile b arası mesafe. |x|=5 → x=5 veya x=-5.',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_17',
          name: 'Üçgenler — Temel',
          description:
              'İç açılar toplamı = 180°. Alan = (taban×yükseklik)/2. Dış açı = karşısındaki iki iç açının toplamı. Eşkenar: 3 kenar eşit, açılar 60°.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_18',
          name: 'Dik Üçgen ve Pisagor',
          description:
              'a²+b²=c² (c=hipotenüs). 3-4-5, 5-12-13, 8-15-17 üçgenleri ezberle. 30-60-90: kenarlar 1-√3-2. 45-45-90: kenarlar 1-1-√2.',
          questionCount: 2,
          difficulty: '🟢 Kolay',
          priority: '🔴 ÇOK KRİTİK',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_19',
          name: 'Dörtgenler',
          description:
              'Kare: A=a², Ç=4a. Dikdörtgen: A=a×b, Ç=2(a+b). Paralelkenar: A=taban×yükseklik. Yamuk: A=(a+c)×h/2.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_20',
          name: 'Çember – Daire',
          description:
              'Çevre=2πr=πd. Alan=πr². Yay=(α/360)×2πr. Dilim=(α/360)×πr². Merkez açı=yay.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_21',
          name: 'Kümeler',
          description:
              'Birleşim (∪): birine ait. Kesişim (∩): ikisine ait. Fark (A-B): A\'da olup B\'de olmayan. n(A∪B)=n(A)+n(B)-n(A∩B).',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_22',
          name: 'Mantık',
          description:
              'p→q: "p ise q". Karşıt önermesi: (~q)→(~p). p∧q: ikisi de doğru. p∨q: en az biri doğru.',
          questionCount: 1,
          difficulty: '🟡 Orta',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_23',
          name: 'Fonksiyonlar (Temel)',
          description:
              'f(x) bir kural: x gir, sonuç çık. f(2)=5 demek x=2 girince 5 çıkar. f(x)=2x+1 ise f(3)=7.',
          questionCount: 2,
          difficulty: '🟡 Orta',
          priority: '🟠 ÖNEMLİ',
          estimatedDays: 3,
        ),
        Topic(
          id: 'tyt_mat_24',
          name: 'Olasılık',
          description:
              'P(A)=İstenen/Toplam. Zar: P(çift)=3/6=1/2. Bağımsız: P(A ve B)=P(A)×P(B).',
          questionCount: 1,
          difficulty: '🔴 Zor',
          priority: '🟡 ORTA',
          estimatedDays: 2,
        ),
        Topic(
          id: 'tyt_mat_25',
          name: 'İstatistik',
          description:
              'Ortalama=toplamı/adet. Ortanca=sıralayıp ortadaki. Mod=en çok tekrar eden.',
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
