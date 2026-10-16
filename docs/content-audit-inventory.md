# Eğitim içeriği kaynak ve koşul envanteri

Son kaynak sayımı: 2026-10-16. Bu dosya kapsam envanteridir; listedeki bir ifadenin doğru olduğunu veya alan uzmanı tarafından onaylandığını göstermez.

## Kaynak durumu

| İçerik grubu | Kaynakta sayılan kayıt | Kaynak etiketi/URL'si olan | Durum |
| --- | ---: | ---: | --- |
| TYT + AYT konu açıklamaları (`subjects_data.dart`) | 107 | 4 | 103 konu için kaynak ve sürüm bağı eksik |
| Matematik formül kartları | 14 | 14 | Tüm kartlara MEB OGM kaynak etiketi/URL'si eklendi; kapsam ve uzman incelemesi açık |
| Fizik formül kartları | 12 | 12 | Tüm kartlara MEB OGM kaynak etiketi/URL'si eklendi; konu kapsamı ve alan uzmanı incelemesi açık |
| Kimya formül kartları | 10 | 3 | pOH, denge sabiti ve tepkime entalpisi etiketli; kaynak içeriği yine kontrol edilmeli |
| Biyoloji formül/kısa bilgi kartları | 8 | 0 | Kaynak eşlemesi ve koşul denetimi açık |
| **Toplam formül kartı** | **44** | **29** | **15 kartta kaynak alanı yok** |

Sayılar kaynak kodundaki `Topic(`, `FormulaItem(` ve `sourceLabel:` kayıtlarının statik sayımıdır. Özel kullanıcı içeriği, kapsam doğruluğu veya sınav müfredatına uygunluk sonucu değildir.

## Formül kartı başlıkları

| Alan | Kartlar | Kaynak durumu |
| --- | --- | --- |
| Matematik (14) | Pisagor Teoremi; İkinci Dereceden Denklem; Aritmetik Dizi Toplamı; Geometrik Dizi Toplamı; Permütasyon; Kombinasyon; Binom Açılımı; Daire Alanı; Küre Hacmi; Silindir Hacmi; Koni Hacmi; Logaritma Kuralı; Türev Kuralı; İntegral Kuralı | 14 kartın tümü MEB OGM kaynağına etiketli; kaynak eşlemesi formülün tam kapsamını ve müfredat uygunluğunu tek başına kanıtlamaz |
| Fizik (12) | Newton'ın 2. Yasası; Kinetik Enerji; Potansiyel Enerji; İş; Hız Formülü; Yer Değiştirme Formülü; Ohm Yasası; Güç; Coulomb Yasası; Dalga Hızı; Esneklik Potansiyel Enerjisi; Tork (Kuvvet Momenti) | 12 kartın tümü MEB OGM kaynağına etiketli; her kaynak ve koşul uzman incelemesi bekliyor |
| Kimya (10) | Mol Hesabi; Ideal Gaz; Molarite; Molalite; pH Hesabi; pOH Hesabi; Denge Sabiti; Avogadro; Gibbs Serbest Enerjisi; Tepkime Entalpisi | pOH, denge sabiti ve tepkime entalpisi kaynaklı; kalan 7 kartta kaynak alanı yok |
| Biyoloji (8) | Fotosentez; Solunum; DNA Baz Eslesmesi; Chargaff Kurali; Hardy-Weinberg; Osmotik Basinc; Hücresel Solunumda ATP; Mitoz | Hepsinde kaynak alanı yok |

## Öncelikli koşul ve anlam denetimi

- **Matematik:** logaritma çarpım kartında `a > 0`, `a ≠ 1`, `x,y > 0`; ikinci derece denklemde `a ≠ 0` ve gerçek kök için `Δ ≥ 0`; geometrik toplamda `r = 1` özel durumu; permütasyon/kombinasyonda `n,r ∈ ℕ`, `r ≤ n` ve sıralama farkı; binomda pozitif tam sayı üssü; türevde pozitif tam sayı kuvveti; integralde `n ∈ ℚ`, `n ≠ −1` ve integral sabiti belirtiliyor. Matematik 14/14 kartın MEB OGM kaynağı eklendi; kaynakların içerik uzmanı tarafından ve güncel YKS kapsamına göre gözden geçirilmesi açık.
- **Fizik:** Newton kartı bileşke/net kuvveti `ΣF = ma` ile gösteriyor. İş formülünde sabit kuvvet ve açı; hareket denklemlerinde sabit ivme ve yer değiştirme; Coulomb yasasında noktasal yükler, ayırma uzaklığı ve ortam sabiti; güçte ortalama büyüklük; torkta dik moment kolu belirtiliyor. Fizik kartları 12/12 kaynak etiketli; konu kapsamı ve uzman incelemesi açık.
- **Kimya:** molarite/molalite birimleri; ideal gaz varsayımı; pH/pOH etkinlik ve okul düzeyi derişim yaklaşımı; `pKw` sıcaklık bağı; denge ifadesinde saf katı/sıvıların dışarıda kalması; standart oluşum entalpisi ve katsayılar.
- **Biyoloji:** hücresel solunumdaki ATP miktarının modele bağlılığı; Hardy–Weinberg varsayımları; ozmotik basınçta ideal/seyreltik çözelti; mitozda ana hücrenin kromozom yapısı ve yavru hücre sonucu.
- **Konu açıklamaları:** 107 başlığın tamamı için ders, sınıf, güncel sınav kapsamı, kaynak adı/sayfası ve inceleme durumu satır bazında eşleştirilmeli. Dört kaynak etiketi bütün kataloğun doğrulandığı anlamına gelmez.

## Kaynaklı düzeltmeler — 2026-10-16

- Logaritma çarpım kuralı ve geçerlilik koşulları: [MEB OGM Materyal · Matematik 12, Üstel ve Logaritmik Fonksiyonlar, s. 32](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/12/unite1/files/basic-html/page22.html).
- Newton'ın ikinci yasasında bileşke kuvvet: [MEB OGM Materyal · Fen Lisesi Fizik 9, Kuvvet ve Hareket, s. 18](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/9/unite3/files/basic-html/page18.html).
- İkinci derece denklemin diskriminantı ve kök formülü: [MEB OGM Materyal · Matematik, İkinci Dereceden Denklemler, s. 77](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/elazig-telafi/matematik/files/basic-html/page77.html).
- Geometrik dizinin ilk `n` terim toplamı: [MEB OGM Materyal · Matematik 12, s. 144](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/beceri_temelli/12/matematik/files/basic-html/page144.html).
- Sıralı seçim ve permütasyon formülü: [MEB OGM Materyal · Defterim Matematik 10, s. 18](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/10/matematik/files/basic-html/page18.html).
- Sırasız seçim ve kombinasyon formülü: [MEB OGM Materyal · Matematik 10, s. 20](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/10/unite1/files/basic-html/page20.html).
- Dik üçgende Pisagor bağıntısı: [MEB OGM Materyal · Fen Lisesi Matematik 9, s. 251](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/9/unite4/files/basic-html/page27.html).
- Aritmetik dizi ilk `n` terim toplamı: [MEB OGM Materyal · Fen Lisesi Matematik 12, s. 25](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/12/unite2/files/basic-html/page25.html).
- Binom açılımı ve binom katsayısı: [MEB OGM Materyal · Matematik 10 Kavram Öğretimi, s. 17](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kavram_calismalari/10/matematik/tek/files/basic-html/page17.html).
- Daire alanı: [MEB OGM Materyal · Matematik 11, s. 39](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/11/unite5/files/basic-html/page39.html).
- Küre hacmi: [MEB OGM Materyal · Temel Düzey Matematik 12, s. 138](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematiktemelduzey/12/unite1/files/basic-html/page138.html).
- Dik dairesel silindir hacmi: [MEB OGM Materyal · Temel Düzey Matematik 12, s. 131](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematiktemelduzey/12/unite1/files/basic-html/page131.html).
- Dik dairesel koni hacmi: [MEB OGM Materyal · Matematik 11 Çalışma Defteri, s. 5](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/calisma_defteri/f7/11/matematik/matematik.pdf).
- Polinom kuvvet fonksiyonunun türevi: [MEB OGM Materyal · Matematik 12, s. 46](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/12/unite5/files/basic-html/page46.html).
- Kuvvet fonksiyonunun belirsiz integrali ve `n ≠ −1` koşulu: [MEB OGM Materyal · Fen Lisesi Matematik 12, s. 6](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/12/unite6/files/basic-html/page6.html).
- Öteleme kinetik enerjisi, yer çekimi ve esneklik potansiyel enerjileri: [MEB OGM Materyal · Fizik 9, Kazanım Kavrama Etkinlik Kitabı](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kazanim_kavrama/pdf/9/fizik.pdf).
- Sabit kuvvetin yaptığı iş: [MEB OGM Materyal · Kuvvet ve Hareket](https://ogmmateryal.eba.gov.tr/panel/upload/pdf/bi5zk3rxz4f.pdf).
- Sabit ivmeli doğrusal harekette hız ve yer değiştirme denklemleri: [MEB OGM Materyal · Fen Lisesi Fizik 11, s. 54–55](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/11/unite1/bolum1/files/basic-html/page54.html).
- Ohm Yasası: [MEB OGM Materyal · Fen Lisesi Fizik 10, s. 52](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/10/unite1/files/basic-html/page52.html).
- Ortalama güç: [MEB OGM Materyal · Fizik 9 Çalışma Defteri](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/calisma_defteri/f5/9/fizik/fizik.pdf).
- Coulomb yasası: [MEB OGM Materyal · Fizik 9, Kazanım Kavrama Etkinlik Kitabı](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kazanim_kavrama/pdf/9/fizik.pdf).
- Dalga hızı: [MEB OGM Materyal · Fen Lisesi Fizik 10, s. 14](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/10/unite3/files/basic-html/page14.html).
- Tork ve dik moment kolu: [MEB OGM Materyal · Fen Lisesi Fizik 12, s. 43](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/12/unite1/files/basic-html/page43.html).

## Kapanış ölçütü

Her kayıt için güvenilir birincil/kurumsal kaynak, güncelleme tarihi, gerekli tanım koşulu, en az bir denetlenmiş örnek ve kapsam eşlemesi yazılmalı. Kaynağı bulunamayan veya uzman değerlendirmesi isteyen içerik “taslak/doğrulanmadı” diye işaretlenmeli. Matematik/fizik formüllerinde kaynak etiketi kapsam ve örnek doğrulamasını tamamlamaz. Tam editoryal onay yalnız bu envanter ve kaynakların içerik uzmanı tarafından kontrol edilmesiyle verilebilir.
