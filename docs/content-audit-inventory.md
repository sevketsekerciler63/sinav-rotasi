# Eğitim içeriği kaynak ve koşul envanteri

Son kaynak sayımı: 2026-10-16. Bu dosya kapsam envanteridir; listedeki bir ifadenin doğru olduğunu veya alan uzmanı tarafından onaylandığını göstermez.

## Kaynak durumu

| İçerik grubu | Kaynakta sayılan kayıt | Kaynak etiketi/URL'si olan | Durum |
| --- | ---: | ---: | --- |
| TYT + AYT konu açıklamaları (`subjects_data.dart`) | 107 | 27 | TYT Matematik 25/25 kayıt kaynaklı; diğer 82 konuda kaynak bağı eksik |
| Matematik formül kartları | 14 | 14 | Tüm kartlara MEB OGM kaynak etiketi/URL'si eklendi; kapsam ve uzman incelemesi açık |
| Fizik formül kartları | 12 | 12 | Tüm kartlara MEB OGM kaynak etiketi/URL'si eklendi; konu kapsamı ve alan uzmanı incelemesi açık |
| Kimya formül kartları | 10 | 10 | Tüm kartlar MEB OGM/IUPAC kaynaklarına bağlandı; koşul ve kapsam uzman incelemesi açık |
| Biyoloji formül/kısa bilgi kartları | 8 | 8 | Tüm kartlara MEB OGM/IUPAC/OpenStax kaynakları bağlandı; Hardy–Weinberg'in hedef YKS kapsamı ayrıca teyit edilmeli |
| **Toplam formül kartı** | **44** | **44** | **Tüm kartlarda kaynak alanı var; içerik/kapsam uzman incelemesi açık** |

Sayılar kaynak kodundaki `Topic(`, `FormulaItem(` ve `sourceLabel:` kayıtlarının statik sayımıdır. Özel kullanıcı içeriği, kapsam doğruluğu veya sınav müfredatına uygunluk sonucu değildir.

## Formül kartı başlıkları

| Alan | Kartlar | Kaynak durumu |
| --- | --- | --- |
| Matematik (14) | Pisagor Teoremi; İkinci Dereceden Denklem; Aritmetik Dizi Toplamı; Geometrik Dizi Toplamı; Permütasyon; Kombinasyon; Binom Açılımı; Daire Alanı; Küre Hacmi; Silindir Hacmi; Koni Hacmi; Logaritma Kuralı; Türev Kuralı; İntegral Kuralı | 14 kartın tümü MEB OGM kaynağına etiketli; kaynak eşlemesi formülün tam kapsamını ve müfredat uygunluğunu tek başına kanıtlamaz |
| Fizik (12) | Newton'ın 2. Yasası; Kinetik Enerji; Potansiyel Enerji; İş; Hız Formülü; Yer Değiştirme Formülü; Ohm Yasası; Güç; Coulomb Yasası; Dalga Hızı; Esneklik Potansiyel Enerjisi; Tork (Kuvvet Momenti) | 12 kartın tümü MEB OGM kaynağına etiketli; her kaynak ve koşul uzman incelemesi bekliyor |
| Kimya (10) | Mol Hesabi; Ideal Gaz; Molarite; Molalite; pH Hesabi; pOH Hesabi; Denge Sabiti; Avogadro; Gibbs Serbest Enerjisi; Tepkime Entalpisi | 10 kartın tümü MEB OGM/IUPAC kaynağına etiketli; kaynak eşlemesi tam kapsamı ve güncel YKS uygunluğunu tek başına kanıtlamaz |
| Biyoloji (8) | Fotosentez; Oksijenli Solunum; DNA Baz Eşleşmesi; Chargaff Kuralı; Hardy–Weinberg; Osmotik Basınç; Hücresel Solunumda ATP; Mitoz | 8 kartın tümü kaynaklı. Hardy–Weinberg için bilimsel denklem OpenStax ile kaynaklandı; hedef YKS kohortunun güncel programında kapsam yeri teyit edilmeli. |

## Öncelikli koşul ve anlam denetimi

- **Matematik:** logaritma çarpım kartında `a > 0`, `a ≠ 1`, `x,y > 0`; ikinci derece denklemde `a ≠ 0` ve gerçek kök için `Δ ≥ 0`; geometrik toplamda `r = 1` özel durumu; permütasyon/kombinasyonda `n,r ∈ ℕ`, `r ≤ n` ve sıralama farkı; binomda pozitif tam sayı üssü; türevde pozitif tam sayı kuvveti; integralde `n ∈ ℚ`, `n ≠ −1` ve integral sabiti belirtiliyor. Matematik 14/14 kartın MEB OGM kaynağı eklendi; kaynakların içerik uzmanı tarafından ve güncel YKS kapsamına göre gözden geçirilmesi açık.
- **Fizik:** Newton kartı bileşke/net kuvveti `ΣF = ma` ile gösteriyor. İş formülünde sabit kuvvet ve açı; hareket denklemlerinde sabit ivme ve yer değiştirme; Coulomb yasasında noktasal yükler, ayırma uzaklığı ve ortam sabiti; güçte ortalama büyüklük; torkta dik moment kolu belirtiliyor. Fizik kartları 12/12 kaynak etiketli; konu kapsamı ve uzman incelemesi açık.
- **Kimya:** molarite/molalite birimleri; ideal gaz varsayımı ve gaz sabiti birimleri; pH/pOH etkinlik ve okul düzeyi derişim yaklaşımı; `pKw` sıcaklık bağı; denge ifadesinde saf katı/sıvıların dışarıda kalması; standart oluşum entalpisi ve katsayılar; Gibbs bağıntısında mutlak sıcaklık ve aynı sistem değişimleri. Bu koşullar ilgili kart açıklamalarında belirtildi, 10/10 karta kaynak eklendi; güncel YKS kapsamı ve alan uzmanı incelemesi açık.
- **Biyoloji:** oksijenli ve oksijensiz solunum ayrımı; hücresel solunum ATP miktarının modele bağlılığı; Hardy–Weinberg'in büyük popülasyon ve kuvvetlerin yokluğu varsayımları; ozmotik basınçta seyreltik ideal çözelti ve osmotik etkin tanecik derişimi; mitozda diploit ana hücre için kromozom sayısı ve yavru hücre sonucu. İlgili koşullar açıklamalara işlendi, 8/8 karta kaynak eklendi. Hardy–Weinberg'in hedef YKS kohortuna uygulanabilirliği ayrı kapsam kararı bekliyor.
- **Konu açıklamaları:** 107 başlığın tamamı için ders, sınıf, güncel sınav kapsamı, kaynak adı/sayfası ve inceleme durumu satır bazında eşleştirilmeli. 27 kaynak etiketi de bütün kataloğun veya YKS kapsamının doğrulandığı anlamına gelmez; TYT Matematik dışındaki 82 kayıt için kaynak bağı eksik.

## TYT Matematik konu kaynak turu — 2026-10-16

TYT Matematik kataloğundaki 25/25 kayda MEB OGM Materyal kaynak etiketi ve URL eklendi. İki eski kaynak korunup açıklamaları koşullandırıldı; 23 kayıt bu turda kaynaklandırıldı. Bu kaynaklar kavramları ve örnek alanlarını dayanaklandırır; güncel YKS kapsam eşlemesi, sınıf/sürüm kontrolü ve tüm örneklerin uzman denetimi henüz tamamlanmadı.

| Topic ID | Konu | MEB OGM kaynak |
| --- | --- | --- |
| `tyt_mat_1` | Sayı kümeleri | [Dört Dörtlük TYT Matematik, Sayı Kümeleri](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page54.html) |
| `tyt_mat_2` | İşlem önceliği | [Matematik 9, İşlem Önceliği](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/hzr/unite1/files/basic-html/page46.html) |
| `tyt_mat_3` | Kesirler | [Matematik 9, Kavram Çalışmaları](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kavram_calismalari/9y/matematik/files/basic-html/page57.html) |
| `tyt_mat_4` | Üslü sayılar | [Matematik 9, OGM fasikülü](https://ogmmateryal.eba.gov.tr/panel/upload/fasikul/55qeme0jn1g.pdf) |
| `tyt_mat_5` | Köklü sayılar | [Matematik 9, Beceri Temelli Etkinlikler](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/beceri_temelli/pdf/9/matematik.pdf) |
| `tyt_mat_6` | EBOB-EKOK | [Dört Dörtlük TYT Matematik, EBOB-EKOK](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page78.html) |
| `tyt_mat_7` | Bölünebilme | [Dört Dörtlük TYT Matematik, Bölünebilme Kuralları](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page72.html) |
| `tyt_mat_8` | Oran-orantı | [Matematik 9, Oran ve Orantı](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/09/unite3/files/basic-html/page77.html) |
| `tyt_mat_9` | Yüzde | [Temel Düzey Matematik 12, Yüzde Hesapları](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematiktemelduzey/12/unite1/files/basic-html/page46.html) |
| `tyt_mat_10` | Birinci dereceden denklem | [Dört Dörtlük TYT Matematik, Birinci Dereceden Denklemler](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page105.html) |
| `tyt_mat_11` | Sayı ve kesir problemleri | [Fen Lisesi Matematik 9, Problemler](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/9/unite3/files/basic-html/page101.html) |
| `tyt_mat_12` | Yaş problemleri | [Defterim Matematik 9, Yaş Problemleri](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/9/matematik/files/basic-html/page175.html) |
| `tyt_mat_13` | İşçi-havuz problemleri | [Fen Lisesi Matematik 9, Problemler](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/9/unite3/files/basic-html/page101.html) |
| `tyt_mat_14` | Hız problemleri | [Fen Lisesi Matematik 9, Problemler](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/9/unite3/files/basic-html/page101.html) |
| `tyt_mat_15` | Kâr-zarar ve karışım | [Defterim Matematik 9, Karışım Problemleri](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/9/matematik/files/basic-html/page200.html) |
| `tyt_mat_16` | Mutlak değer | [Matematik 9, Mutlak Değer](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/09/unite3/files/basic-html/page43.html) |
| `tyt_mat_17` | Üçgenler | [Matematik, Üçgenler](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/elazig-telafi/matematik/files/basic-html/page21.html) |
| `tyt_mat_18` | Dik üçgen ve Pisagor | [Fen Lisesi Matematik 9, Pisagor](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/9/unite4/files/basic-html/page89.html) |
| `tyt_mat_19` | Dörtgenler | [Matematik, Dörtgenler](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/elazig-telafi/matematik/files/basic-html/page98.html) |
| `tyt_mat_20` | Çember ve daire | [Matematik 11, Dairenin Çevresi ve Alanı](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/11/unite5/files/basic-html/page34.html) |
| `tyt_mat_21` | Kümeler | [Matematik 9, Kümelerde İşlemler](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/09/unite2/files/basic-html/page12.html) |
| `tyt_mat_22` | Mantık | [Matematik 9, Mantık](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/09/unite1/files/basic-html/page2.html) |
| `tyt_mat_23` | Fonksiyonlar (temel) | [Matematik 10, Fonksiyon Kavramı ve Gösterimi](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/10/unite2/files/basic-html/page4.html) |
| `tyt_mat_24` | Olasılık | [Dört Dörtlük TYT Matematik, Olasılık](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page332.html) |
| `tyt_mat_25` | İstatistik | [Dört Dörtlük TYT Matematik, Merkezi Eğilim Ölçüleri](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page283.html) |

Bu turda ifadeler özellikle şu durumlarda daraltıldı/koşullandırıldı: sayı doğrusunda 0'ın konumu; aynı öncelikli işlemlerin soldan sağa yapılması; kesir ve köklerde payda/işlem koşulları; doğru/ters orantı tanımları; art arda yüzde değişimi; sabit iş ve hız varsayımları; karışımda derişim ve birim uyumu; üçgen alanında dik yükseklik; özel üçgen oranları; daire çevresi/alanı ve derece cinsinden merkez açı; sonlu kümelerde birleşim sayımı; bağımsız olay koşulu ve çift sayıda veride medyan.

**Açık takip:** güncel hedef sınav yılı/kohortunun resmi kapsam belgesiyle 25 başlığın tek tek eşleştirilmesi; TYT'de yer alıp almadığı belirsiz ayrıntıların (özellikle fonksiyon/mantık/kümeler alt kazanımları ve özel üçgen oranları) işaretlenmesi; kaynakların içerik sürüm/tarihinin kaydı; örnek çözümlerin alan uzmanı kontrolü.

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
- Mol hesabı `n = m/M`: [MEB OGM Materyal · Kimya 10, s. 27](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kimya/10/elazig/unite1/files/basic-html/page27.html).
- İdeal gaz bağıntısı ve gaz sabiti: [MEB OGM Materyal · Kimya 11, s. 20](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kimya/11/kimya11_2unite/files/basic-html/page20.html).
- Molarite tanımı ve çözelti hacmi: [MEB OGM Materyal · Fen Lisesi Kimya 11, s. 11](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesikimya/11/unite3/files/basic-html/page11.html).
- Molalite tanımı ve çözücü kütlesi: [MEB OGM Materyal · Fen Lisesi Kimya 11, s. 13](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesikimya/11/unite3/files/basic-html/page13.html).
- pH ve hidrojen iyonu derişimi: [MEB OGM Materyal · Fen Lisesi Kimya 11, s. 34](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesikimya/11/unite6/files/basic-html/page34.html).
- Avogadro sabiti, mol başına tanecik sayısı: [MEB OGM Materyal · Defterim Kimya 10, s. 25](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/10/kimya/files/basic-html/page25.html).
- Gibbs enerjisinin entalpi ve entropi bağıntısı: [IUPAC Gold Book · Gibbs energy](https://goldbook.iupac.org/terms/view/G02629).
- Oksijenli fotosentezin net denklemi, ışık ve klorofil koşulu: [MEB OGM Materyal · Biyoloji 12, s. 11](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/12/unite2/files/basic-html/page11.html).
- Oksijenli solunumun ürünleri ve ATP üretimi: [MEB OGM Materyal · Biyoloji 12, Çalışma Defteri 5, s. 6](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/calisma_defteri/f5/12/biyoloji/biyoloji.pdf).
- Çift iplikli DNA'da A–T ve G–C eşleşmesi: [MEB OGM Materyal · Biyoloji 9, s. 54](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/9/unite1/files/basic-html/page54.html).
- Chargaff oranları ve tür özgü A+T/G+C oranı: [MEB OGM Materyal · Fen Lisesi Biyoloji 12, s. 10](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesibiyoloji/12/unite1/files/basic-html/page10.html).
- Hardy–Weinberg alel/genotip sıklıkları ve denge ilkesi: [OpenStax · Biology 2e, 19.1 Population Evolution](https://openstax.org/books/biology-2e/pages/19-1-population-evolution). MEB'in 2026 biyoloji programında terim eşlemesi bulunamadı; hedef YKS kohortu için kapsam kararı açık.
- Seyreltik ideal çözelti için ozmotik basınç: [IUPAC Gold Book · Osmotic pressure](https://goldbook.iupac.org/terms/view/O04344).
- Oksijenli solunumun glikoliz, pirüvat oksidasyonu, Krebs ve ETS aşamaları: [MEB OGM Materyal · Fen Lisesi Biyoloji 12, s. 26](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesibiyoloji/12/unite2/files/basic-html/page26.html).
- Mitozda kromozom yapısının korunması ve iki yavru hücre: [MEB OGM Materyal · Biyoloji 10, s. 8](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/10/unite1/files/basic-html/page8.html).

## Kapanış ölçütü

Her kayıt için güvenilir birincil/kurumsal kaynak, güncelleme tarihi, gerekli tanım koşulu, en az bir denetlenmiş örnek ve kapsam eşlemesi yazılmalı. Kaynağı bulunamayan veya uzman değerlendirmesi isteyen içerik “taslak/doğrulanmadı” diye işaretlenmeli. 44/44 kartta URL bulunması içerik, kapsam, örnek veya editoryal doğrulamayı tamamlamaz. Tam editoryal onay yalnız bu envanter ve kaynakların içerik uzmanı tarafından kontrol edilmesiyle verilebilir.
