# Eğitim içeriği kaynak ve koşul envanteri

Son kaynak sayımı: 2026-10-16. Bu dosya kapsam envanteridir; listedeki bir ifadenin doğru olduğunu veya alan uzmanı tarafından onaylandığını göstermez.

## 2026-10-21 katalog güncellemesi

MEB OGM *Dört Dörtlük* TYT ve AYT Matematik kitaplarının alt öğrenme alanı tablosuyla karşılaştırıldı; katalogda olmayan 8 konu eklendi (107 → 115). Kaynak: [AYT tablosu](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page8.html), [TYT tablosu](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/matematik/files/basic-html/page8.html).

| Topic ID | Konu |
| --- | --- |
| `ayt_mat_11` | Çember ve Daire (AYT Geometri) |
| `ayt_mat_12` | Katı Cisimler (AYT Geometri) |
| `ayt_mat_13` | Koşullu Olasılık |
| `ayt_mat_14` | Analitik Düzlemde Dönüşümler |
| `ayt_mat_15` | Denklem ve Eşitsizlik Sistemleri |
| `ayt_mat_16` | Üçgen ve Çokgenler (AYT Geometri) |
| `tyt_mat_26` | Sıralama ve Seçme (Permütasyon-Kombinasyon) |
| `tyt_mat_27` | Katı Cisimler (TYT Geometri) |

Kaynak bağı tablo sayfasıdır (konu sayfası değil); konu bazlı sayfa eşlemesi ve uzman incelemesi açıktır. Aynı adla daha önce kişisel konu eklemiş öğrencinin konusu silinmez, `(kişisel)` ekiyle gösterilir (`test/catalog_update_test.dart`). Aynı gün üç açıklama düzeltildi: `tyt_mat_5` (paydayı rasyonel yapma), `tyt_mat_7` (4'e bölünme kuralı), `ayt_bio_6` (bezlere "hormon" denmesi).

## Kaynak durumu

| İçerik grubu | Kaynakta sayılan kayıt | Kaynak etiketi/URL'si olan | Durum |
| --- | ---: | ---: | --- |
| TYT + AYT konu açıklamaları (`subjects_data.dart`) | 107 | 107 | TYT 76/76, AYT Matematik 10/10, AYT Fizik 7/7, AYT Kimya 6/6 ve AYT Biyoloji 8/8 kayıtlarında kaynak bağı var; bu, kapsam veya uzman onayı değildir |
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
- **Konu açıklamaları:** 107 başlığın hepsinde kaynak adı ve bağlantısı var; bu, içerik iddialarının bütünüyle doğrulandığı veya hedef YKS kapsamının tamamlandığı anlamına gelmez. TYT 76/76, AYT Matematik 10/10, AYT Fizik 7/7, AYT Kimya 6/6 ve AYT Biyoloji 8/8 satırları kaynaklı.

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

## TYT Türkçe konu kaynak turu — 2026-10-16

TYT Türkçe kataloğundaki 17/17 kaydın tamamına kaynak eklendi veya mevcut TDK yazım kaynağı korundu. Paragraf/sözcük/cümle anlamı, sözcük türleri, fiil-fiilimsi, cümle türleri, noktalama, anlatım bozukluğu ve ses bilgisi açıklamaları MEB OGM'nin Dört Dörtlük TYT Türkçe konu-pekiştirme materyalinin ilgili bölümüne bağlandı. Yazım kuralları TDK Yazım Kılavuzu'na bağlı.

| Topic ID | Konu | Kaynak |
| --- | --- | --- |
| `tyt_tur_1`–`tyt_tur_6` | Ana düşünce/başlık, cümle tamamlama, çıkarım, anlatım yolu, bütünlüğü bozan cümle, sıralama | [MEB OGM · Paragrafta Anlam, s. 33'ten başlayan bölüm](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page33.html) |
| `tyt_tur_7`, `tyt_tur_8`, `tyt_tur_10` | Sözcükte anlam, eş anlam, atasözü/deyim | [MEB OGM · Sözcükte Anlam, s. 9'dan başlayan bölüm](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page9.html) |
| `tyt_tur_9` | Cümlede anlam | [MEB OGM · Cümlede Anlam, s. 21'den başlayan bölüm](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page21.html) |
| `tyt_tur_11` | Sözcük türleri | [MEB OGM · İsim Soylu Sözcükler, s. 109'dan başlayan bölüm](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page109.html) |
| `tyt_tur_12` | Fiil ve fiilimsi | [MEB OGM · Fiiller, s. 123'ten başlayan bölüm](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page123.html) |
| `tyt_tur_13` | Cümle türleri | [MEB OGM · Cümle Türleri, s. 159'dan başlayan bölüm](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page159.html) |
| `tyt_tur_14` | Yazım kuralları | [Türk Dil Kurumu · Yazım Kılavuzu](https://yazim.tdk.gov.tr/content/03-bazi-kelime-ve-eklerin-yazilisi.html) |
| `tyt_tur_15` | Noktalama | [MEB OGM · Noktalama İşaretleri, s. 87'den başlayan bölüm](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page87.html) |
| `tyt_tur_16` | Anlatım bozuklukları | [MEB OGM · Anlatım Bozuklukları, s. 169'dan başlayan bölüm](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page169.html) |
| `tyt_tur_17` | Ses bilgisi | [MEB OGM · Ses Bilgisi, s. 45'ten başlayan bölüm](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tde/files/basic-html/page45.html) |

Bu turda genelleme oluşturan sorunlu ipuçları kaldırıldı: başlık için “en genel cümle”, deyimde mutlaka fiil bulunması, tüm cümle tamamlama sorularının yalnız iki komşu cümleye dayanması ve p/ç/t/k sonlarının her durumda yumuşaması gibi katı kurallar kullanılmıyor. Çekimli fiil/fiilimsi ayrımı, sözcük türünde bağlam, atasözü/deyim tanımı, cümle türlerinin sınıflandırma ölçütleri ve noktalama işaretlerinin işlevleri kapsamlılaştırıldı.

**Açık takip:** 17 başlığın hedef YKS yılı/kohortuna göre resmi kapsam eşlemesi; gramer terimlerinin güncel program sürümü; konu örneklerinin satır bazlı doğrulanması ve Türkçe alan uzmanı kabulü. OGM materyalinin bölüm başı URL'leri konu kaynağını gösterir; her kısa açıklamadaki her alt kural için sayfa/soru denetimi değildir.

## TYT Fizik konu kaynak turu — 2026-10-16

TYT Fizik kataloğundaki 7/7 kayda MEB OGM Materyal kaynak etiketi ve URL eklendi. Birimlerde SI'nın yedi temel birimi tamamlandı; Newton yasalarında net kuvvet ve etki-tepki kuvvetlerinin farklı cisimler üzerindeki etkisi netleştirildi. İş, basınç, ısı/sıcaklık, elektrik akımı ve dalga/optik açıklamalarına gerekli model/ortam koşulları işlendi.

| Topic ID | Konu | MEB OGM kaynak |
| --- | --- | --- |
| `tyt_fiz_1` | Ölçme ve birimler | [Dört Dörtlük TYT Fizik, Fizik Bilimine Giriş](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/fizik/files/basic-html/page12.html) |
| `tyt_fiz_2` | Newton kanunları | [Fizik 11, Newton’ın Hareket Yasaları](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fizik/11/unite1/files/basic-html/page32.html) |
| `tyt_fiz_3` | İş, güç ve enerji | [Dört Dörtlük TYT Fizik, İş-Güç-Enerji](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/fizik/files/basic-html/page79.html) |
| `tyt_fiz_4` | Basınç | [Defterim Fizik 10, Basınç](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/10/fizik/files/basic-html/page88.html) |
| `tyt_fiz_5` | Isı ve sıcaklık | [Dört Dörtlük TYT Fizik, Isı ve Sıcaklık](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/fizik/files/basic-html/page113.html) |
| `tyt_fiz_6` | Elektrik temeli | [Dört Dörtlük TYT Fizik, Elektrik ve Manyetizma](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/fizik/files/basic-html/page155.html) |
| `tyt_fiz_7` | Dalgalar ve optik | [Dört Dörtlük TYT Fizik, Dalgalar s. 247](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/fizik/files/basic-html/page247.html); [Optik s. 299](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/fizik/files/basic-html/page299.html) |

**Açık takip:** TYT Fizik başlıklarının güncel hedef sınav yılı/kohortuna göre resmi kapsam eşlemesi; açıklama örneklerinin alan uzmanı denetimi; iş ve enerji formüllerinde okul düzeyindeki model kabullerinin örneklerle gösterilmesi; “Dalgalar ve Optik” birleşik başlığının öğrenciler için kapsam/yük bakımından uygunluğunun incelenmesi.

## TYT Kimya konu kaynak turu — 2026-10-16

TYT Kimya kataloğundaki 7/7 kayda MEB OGM'nin Dört Dörtlük TYT Kimya konu bölümleri kaynak olarak eklendi. Atom tanecikleri/numara-kütle sayısı, grup numaralandırması ve metal/metalloid dağılımı, kimyasal bağların kesin olmayan tür eşlemesi, fiziksel ayırma, 25 °C pH koşulu, kapalı sistemde kütle korunumu ve molün Avogadro sabiti tanımı açıklığa kavuşturuldu.

| Topic ID | Konu | MEB OGM kaynak |
| --- | --- | --- |
| `tyt_kim_1` | Atom modelleri ve yapı | [Dört Dörtlük TYT Kimya, s. 51'den başlayan bölüm](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page51.html) |
| `tyt_kim_2` | Periyodik sistem | [Dört Dörtlük TYT Kimya, s. 67'den başlayan bölüm](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page67.html) |
| `tyt_kim_3` | Kimyasal bağlar | [Dört Dörtlük TYT Kimya, Kimyasal Türler Arası Etkileşimler](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page93.html) |
| `tyt_kim_4` | Madde ve karışımlar | [Dört Dörtlük TYT Kimya, Karışımlar ve Ayırma Teknikleri](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page219.html) |
| `tyt_kim_5` | Asit-baz | [Dört Dörtlük TYT Kimya, Asitler, Bazlar ve Tuzlar](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page251.html) |
| `tyt_kim_6` | Kimyasal tepkimeler | [Dört Dörtlük TYT Kimya, Kimyasal Tepkimeler](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page201.html) |
| `tyt_kim_7` | Mol kavramı | [Dört Dörtlük TYT Kimya, Kimyanın Temel Kanunları ve Mol Kavramı](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/kimya/files/basic-html/page181.html) |

**Açık takip:** yedi konu başlığının hedef sınav yılı/kohortunun resmi kapsamıyla eşleştirilmesi; asit-baz kapsam derinliği ve bağ ayrıntılarının YKS seviyesine uygunluğu; kısa açıklamaların örneklerinin kimya alan uzmanı tarafından denetlenmesi.

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

## TYT Biyoloji konu kaynak turu — 2026-10-16

TYT Biyoloji kataloğundaki 6/6 kaydın kaynak bağı mevcut. Bu turda beş yeni konu kaydı OGM/MEB materyaline bağlandı; Hücre kaydının var olan bağlantısı korundu ve açıklaması hücre tipleri arasındaki farkı gösterecek biçimde düzeltildi. Bu bağlantılar kavramsal dayanak sağlar; güncel YKS kapsamını, alan uzmanı onayını veya her örneğin denetimini tek başına kanıtlamaz.

| Topic ID | Konu | MEB OGM kaynak |
| --- | --- | --- |
| `tyt_bio_1` | Hücre — Sıfırdan | [Defterim Biyoloji 9, s. 100](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/9/biyoloji/files/basic-html/page100.html) |
| `tyt_bio_2` | Prokaryot – Ökaryot | [Biyoloji 9, Hücrenin Yapısı, s. 9–10](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/9/unite2/files/basic-html/page9.html) |
| `tyt_bio_3` | Canlıların Sınıflandırılması | [Dört Dörtlük TYT Biyoloji, Sınıflandırma, s. 101](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/biyoloji/files/basic-html/page101.html) |
| `tyt_bio_4` | Fotosentez ve Solunum | [Biyoloji 12, Ünite 2 — fotosentez ve hücresel solunum](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/12/unite2/index.html) · [Fotosentez denklemi, s. 11](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/12/unite2/files/basic-html/page11.html) · [Hücresel solunum, s. 29](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/12/unite2/files/basic-html/page29.html) |
| `tyt_bio_5` | Ekosistem ve Besin Zinciri | [Dört Dörtlük TYT Biyoloji, Ekosistem Ekolojisi, s. 231](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/biyoloji/files/basic-html/page231.html) |
| `tyt_bio_6` | Kalıtım Temeli (TYT) | [Biyoloji 10, Mitoz ve Eşeysiz Üreme, s. 6](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/biyoloji/10/unite1/files/basic-html/page6.html) · [Biyoloji 10, gametlerde n=23](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/calisma_defteri/f2/10/biyoloji/biyoloji.pdf) |

### Düzeltilen biyoloji koşulları ve açık kapsam kararı

- Hücre zarı, sitoplazma, DNA ve ribozomun hücrelerdeki ortaklığı belirtildi; çekirdek ve zarla çevrili organeller yalnız ökaryotlara atfedildi. Mitokondri/kloroplastın tüm hücrelerde bulunduğu izlenimi kaldırıldı.
- Prokaryot açıklamasına arkeler eklendi; sınıflandırma açıklamasındaki “virüs cansız”, “mantarların tümü ayrıştırıcı” ve “bitkilerin tümünde kloroplast” biçimindeki genellemeler kaldırıldı.
- Oksijenli fotosentez eşitliği sadeleştirilmiş net denklem olarak etiketlendi. Solunum denkleminden evrenselmiş gibi verilen `38 ATP` çıkarıldı; ATP veriminin hücre ve hesap modeline göre değiştiği belirtildi.
- Besin basamakları için enerji aktarımının azaldığı korundu; “%10 kuralı” sabit ve evrensel oran gibi sunulmadı.
- Kalıtım açıklamasında gen tanımı işlevsel ürünle ilişkilendirildi; 46 kromozom bilgisi diploit insan vücut hücresiyle sınırlandı ve gametlerdeki 23 kromozom ayrıca belirtildi.
- **Kapsam doğrulaması bekliyor:** OGM Dört Dörtlük TYT Biyoloji'nin konu dizininde sınıflandırma, hücre, kalıtım ve ekosistem başlıkları yer alırken Fotosentez ve Solunum aynı dizinde görünmüyor. Bu, tek başına YKS dışı olduğuna kanıt değildir. Hedef YKS yılı için resmi/kohort kapsamı teyit edilene kadar `tyt_bio_4` kataloğunda korunacak, fakat uygulama kapsamı uzman incelemesinde açık kalacak. [Dört Dörtlük TYT Biyoloji konu dizini](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/biyoloji/files/basic-html/page8.html).

## TYT Sosyal konu kaynak turu — 2026-10-16

TYT Sosyal kataloğundaki 14/14 kayıt MEB OGM veya kurumsal kaynaklarla eşleştirildi. Bu turda kronoloji, kavram tanımları ve coğrafi dağılım açıklamaları gözden geçirildi; soru tahmini gibi sunulan çalışma ipucu kaldırıldı. Bağlantılar kavram dayanağıdır; hedef YKS yılı/kohort kapsamı ve alan uzmanı onayı ayrıca gerekir.

| Topic ID | Konu | Kaynak |
| --- | --- | --- |
| `tyt_sos_1` | Osmanlı kuruluş ve yükseliş | [Tarih 10, Osmanlı Devleti](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/tarih/10/unite2/files/basic-html/page4.html) · [Tarih 10, Osmanlı'nın dünya gücü](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/tarih/10/unite5/files/basic-html/page15.html) |
| `tyt_sos_2` | Osmanlı'da yenileşme ve son dönem | [Tarih 11 Çalışma Defteri, kronoloji](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/calisma_defteri/f7/11/tarih/tarih.pdf) |
| `tyt_sos_3` | Millî Mücadele | [Dört Dörtlük TYT Tarih, Millî Mücadele, s. 230](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tarih/files/basic-html/page230.html) |
| `tyt_sos_4` | Atatürk dönemi inkılapları | [Dört Dörtlük TYT Tarih, Atatürkçülük, s. 238](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/tarih/files/basic-html/page238.html) · [MEB, kadınların siyasal hakları](https://www.meb.gov.tr/belirligunler/10kasim/inkilaplari/toplumsal/kadin_haklari.htm) |
| `tyt_sos_5` | Türkiye'nin coğrafi özellikleri | [Dört Dörtlük TYT Coğrafya, konum, s. 48](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/cografya/files/basic-html/page48.html) · [Dört Dörtlük TYT Coğrafya, yer şekilleri, s. 169](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/cografya/files/basic-html/page169.html) |
| `tyt_sos_6` | Türkiye'de iklim | [Dört Dörtlük TYT Coğrafya, Türkiye iklimi, s. 101](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/cografya/files/basic-html/page101.html) |
| `tyt_sos_7` | Türkiye'de tarım ve ekonomi | [Coğrafya 11 Beceri Temelli, tarım ürünleri, s. 69](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/beceri_temelli/11/cografya/files/basic-html/page69.html) |
| `tyt_sos_8` | Dünya coğrafyası | [Coğrafya 10, okyanuslar ve denizler, s. 64](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/cografya/10/unite1/files/basic-html/page64.html) · [Coğrafya 9, dünya iklimleri](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/cografya/9/usak/unite3/files/basic-html/page5.html) |
| `tyt_sos_9` | Varlık felsefesi | [Dört Dörtlük TYT Felsefe, varlık, s. 45](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/felsefe/files/basic-html/page45.html) |
| `tyt_sos_10` | Bilgi felsefesi | [Dört Dörtlük TYT Felsefe, bilgi, s. 71](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/felsefe/files/basic-html/page71.html) |
| `tyt_sos_11` | Ahlak ve siyaset felsefesi | [Dört Dörtlük TYT Felsefe](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/tyt/felsefe/felsefe.pdf) · [Defterim Felsefe 10, ahlak](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/defterim/10/felsefe/files/basic-html/page188.html) |
| `tyt_sos_12` | İslam'ın temel ilkeleri | [Diyanet, Dinimi Öğreniyorum](https://yazkurankurslari.diyanet.gov.tr/evrak/kitap/dinimi_ogreniyorum.pdf) |
| `tyt_sos_13` | Hz. Muhammed'in hayatı | [TDV İslâm Ansiklopedisi, Muhammed](https://islamansiklopedisi.org.tr/muhammed) |
| `tyt_sos_14` | Kur'an ve temel kavramlar | [Diyanet Kur'an portalı, Bakara](https://kuran.diyanet.gov.tr/tefsir/sure/2) · [Alak suresi](https://dijital.diyanet.gov.tr/Dinle/hatm-i-serif-sureler/alak-suresi?id=3255) · [TÜBİTAK, hadis ve sünnet](https://ansiklopedi.tubitak.gov.tr/ansiklopedi/hadis_ve_sunnet) · [TDV, dinî terimler sözlüğü](https://www.isam.org.tr/yayin/tdv-islam-ansiklopedisi-dini-terimler-sozlugu) |

### Kapsam ve dağılım için açık kararlar

- `tyt_sos_8` açıklaması kıta/okyanus sayısını sabitlemez. OGM Coğrafya 10 kaynağı üç ana okyanus sınıflandırmasını kullanıyor; farklı atlas ve öğretim modelleri farklı sayım yapabildiği için uygulamada hedef müfredat modeline göre uzman kararı bekleniyor.
- `tyt_sos_1` kuruluş tarihi olarak 1299'u mutlaklaştırmaz; bu tarih geleneksel tarihlemedir ve kuruluş süreci farklı görüşlerle incelenir.
- `tyt_sos_4` kadınların siyasal haklarını aşamalı tarihlerle verir: belediye seçimleri 1930, köy muhtarlığı 1933, milletvekili seçme-seçilme 1934.
- Bu 14 başlığın tahmini soru ağırlıkları resmî dağılım değildir. TYT Sosyal alt başlıklarında kodlanan soru sayıları 20 soruluk ders toplamına eşleştirildi; uzman/kohort onayı bekliyor.

## AYT Matematik konu kaynak turu — 2026-10-16

Mevcut AYT Matematik kataloğundaki 10/10 kayda MEB OGM kaynak bağlantısı eklendi. Tanım koşulları, kök/tepe noktası bilgisi, polinom kalan teoremi, dizi toplamı, trigonometri tanım aralığı, eğimli doğru, türev ve integral koşulları ile `0/0` limit belirsizliği netleştirildi. Bu tur mevcut kartları kaynaklandırır; aşağıdaki kapsam eşlemesi açığı kapanmış sayılmaz.

| Topic ID | Konu | MEB OGM kaynak |
| --- | --- | --- |
| `ayt_mat_1` | Fonksiyonlar | [Dört Dörtlük AYT Matematik, Fonksiyonlar ile İlgili Uygulamalar, s. 93](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page93.html) |
| `ayt_mat_2` | İkinci derece denklem ve parabol | [Dört Dörtlük AYT Matematik, İkinci Dereceden Fonksiyonlar ve Grafikleri, s. 115](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page115.html) · [Matematik 11, parabol tanımı ve `a≠0`](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/11/unite3/files/basic-html/page13.html) |
| `ayt_mat_3` | Polinomlar | [Dört Dörtlük Matematik 10, polinomlar, s. 107](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/10/matematik/files/basic-html/page107.html) · [Fen Lisesi Matematik 10, polinom bölmesi](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesimatematik/10/unite3/files/basic-html/page15.html) |
| `ayt_mat_4` | Logaritma | [Dört Dörtlük AYT Matematik, Logaritma, s. 291–292](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page291.html) |
| `ayt_mat_5` | Diziler | [Dört Dörtlük AYT Matematik, Gerçek Sayı Dizileri, s. 313](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page313.html) |
| `ayt_mat_6` | Trigonometri | [Dört Dörtlük AYT Matematik, Trigonometrik Fonksiyonlar, s. 30](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page30.html) · [Toplam-fark ve iki kat açı, s. 331](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page331.html) · [Trigonometrik denklemler, s. 353](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page353.html) |
| `ayt_mat_7` | Analitik geometri | [Dört Dörtlük AYT Matematik, doğrunun analitik incelenmesi, s. 67](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page67.html) · [Çemberin analitik incelenmesi, s. 499](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page499.html) |
| `ayt_mat_8` | Türev ve uygulamaları | [Dört Dörtlük AYT Matematik, türevin uygulamaları, s. 429](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page429.html) · [Türev, s. 407](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page407.html) |
| `ayt_mat_9` | İntegral ve uygulamaları | [Dört Dörtlük AYT Matematik, belirsiz integral, s. 449](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page449.html) · [Belirli integral ve uygulamaları, s. 471](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page471.html) |
| `ayt_mat_10` | Limit ve süreklilik | [Dört Dörtlük AYT Matematik, Limit ve Süreklilik, s. 395](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page395.html) |

### Sonraki kapsam işi — kaynağı mevcut, eşlemesi tamamlanmadı

- [Dört Dörtlük AYT Matematik içindekiler, s. 6](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/matematik/files/basic-html/page6.html) ve konu tablosu s. 8, uygulamadaki 10 geniş karttan ayrı olarak ikinci derece denklem sistemleri/eşitsizlikler, çember-daire, katı cisimler ve olasılık gibi başlıkları listeliyor. Fonksiyon dönüşümleri, üstel fonksiyon, trigonometrik bağıntılar/denklemler ve integral alt başlıkları da ayrık verilmiş.
- Bu nedenle `AYT Matematik` kartları kaynağa bağlanmış olsa da YKS kapsamının tamamını temsil ettikleri henüz gösterilmedi. Kodda mevcut `questionCount` toplamı 25 iken branş `totalQuestions` değeri 40; aradaki 15 soru için kapsam ve çalışma ağırlığı açıklanmalı.
- Sonraki editoryal karar: hedef YKS kohortunun resmi programı ve seçilen yılın ÖSYM kitapçığı üzerinden kartları bölmek/birleştirmek, kaynak dışı kapsamı eklemek ve ağırlıkları açıkça “tahmini çalışma dağılımı” diye etiketlemek. Şimdilik bu fark uygulamada gizlenmemeli ve 10 kaynaklı kart 10/10 kapsam onayı gibi değerlendirilmemeli.

## AYT Fizik konu kaynak turu — 2026-10-16

AYT Fizik kataloğundaki 7/7 kayıt MEB OGM veya Fen Lisesi Fizik kaynağına bağlandı. Kısa formüller gerekli koşullarla genişletildi: eğik düzlem bileşenleri ve statik/kinetik sürtünme, net itme ve momentum korunumu, basit sarkaç küçük açı yaklaşımı, manyetik kuvvet açısı, çift yarık koşulları, merkezcil bileşke kuvvet ve fotoelektrik eşik işi.

| Topic ID | Konu | MEB OGM kaynak |
| --- | --- | --- |
| `ayt_fiz_1` | Dinamik, bağlı cisimler ve eğik düzlem | [Fen Lisesi Fizik 11, eğik düzlem ve sürtünmeli sistemler](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/11/unite1/bolum2/files/basic-html/page129.html) · [Dört Dörtlük AYT Fizik, Newton yasaları, s. 39](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page39.html) |
| `ayt_fiz_2` | Enerji ve momentum | [Dört Dörtlük AYT Fizik, Enerji ve Hareket, s. 97](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page97.html) · [İtme ve Çizgisel Momentum, s. 115](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page115.html) |
| `ayt_fiz_3` | Basit harmonik hareket | [Dört Dörtlük AYT Fizik, Basit Harmonik Hareket, s. 279](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page279.html) · [Fen Lisesi Fizik 12, ünite 2](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/12/unite2/files/basic-html/page2.html) |
| `ayt_fiz_4` | Elektrik ve manyetizma | [Elektriksel Kuvvet ve Alan, s. 165](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page165.html) · [Sığa, s. 197](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page197.html) · [Manyetizma ve Elektromanyetik İndüklenme, s. 211](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page211.html) |
| `ayt_fiz_5` | Dalgalar ve optik | [Dört Dörtlük AYT Fizik, dalgalarda kırınım ve girişim, s. 299](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page299.html) · [Elektromanyetik dalgalar, s. 317](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page317.html) |
| `ayt_fiz_6` | Çembersel hareket | [Dört Dörtlük AYT Fizik, çembersel hareket, s. 247](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page247.html) · [Açısal momentum, kütle çekimi ve Kepler, s. 265](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page265.html) |
| `ayt_fiz_7` | Modern fizik | [Atom kavramının tarihsel gelişimi, s. 327](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page327.html) · [Radyoaktivite, s. 351](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page351.html) · [Özel görelilik ve kuantum fiziğine giriş, s. 363](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page363.html) · [Fotoelektrik olay, s. 375](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page375.html) · [Compton ve de Broglie, s. 391](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page391.html) |

### Sonraki kapsam işi — konu kataloğu ve AYT kohortu

- [Dört Dörtlük AYT Fizik içindekiler, s. 6](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/fizik/files/basic-html/page6.html) vektörler, bağıl hareket, bir/iki boyutta sabit ivme, enerji, itme-momentum, tork-denge, basit makineler, elektrik, çembersel/açısal hareket, basit harmonik hareket, dalgalar ve modern fizik alanlarında 26 başlık listeliyor. Uygulamadaki 7 kart bu alanların bir bölümünü bir araya getiriyor; her resmi alt başlığın hangi karta ve hangi çalışma görevine girdiği satır bazında eşlenmedi.
- 7 kartın `questionCount` toplamı 14 ve branş toplamı da 14. Bu eşitlik kart başına soru adetlerinin güncel ÖSYM dağılımını yansıttığını kanıtlamaz. Hedef YKS kohortu ve seçilen sınav kitapçığına göre kapsam/soru ağırlığı kabulü açık.
- “Dalgalar ve Optik” başlığındaki mercek bağıntısı için optik kaynak ve hedef kohort kapsamı ayrıca kontrol edilmeli; OGM AYT Matematik/Fizik içerik dizininde dalga optiği belirgin, fakat geometrik optik alt konusu TYT veya başka resmi program yerleşimiyle karışabilir.

## AYT Kimya konu kaynak turu — 2026-10-16

AYT Kimya kataloğundaki 6/6 kayda MEB OGM kaynağı eklendi. Gaz hacmi için sıcaklık-basınç koşulu, Kw sıcaklığı, denge sabiti ifadesi ve saf faz istisnaları, elektrot tepkimeleri, hidrokarbon genel formüllerinin sınırları ve termodinamik sıcaklık/birim koşulları açıklığa kavuşturuldu. Bu kitabın HTML sayfa dizini ile basılı sayfa numarası iki sayfa farklı; bağlantılar konu başlığı ve içerikten kontrol edildi.

| Topic ID | Konu | MEB OGM / kurumsal kaynak |
| --- | --- | --- |
| `ayt_kim_1` | Mol hesabı ve ideal gaz | [Dört Dörtlük AYT Kimya, Gaz Yasaları ve İdeal Gaz, s. 49](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page51.html) · [Kimya 10, sınırlayıcı bileşen, s. 63](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kimya/10/elazig/unite1/files/basic-html/page63.html) · [Yüzde verim, s. 67](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kimya/10/elazig/unite1/files/basic-html/page67.html) |
| `ayt_kim_2` | Sulu çözeltide asit-baz dengesi | [Dört Dörtlük AYT Kimya, Sulu Çözelti Dengeleri, s. 227](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page229.html) |
| `ayt_kim_3` | Kimyasal denge | [Dört Dörtlük AYT Kimya, Kimyasal Denge ve Dengeyi Etkileyen Faktörler, s. 211](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page213.html) |
| `ayt_kim_4` | Elektrokimya | [Dört Dörtlük AYT Kimya, Elektrokimyasal Hücreler, s. 283](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page285.html) · [Kimya 12, galvanik ve elektrolitik hücre farkları, s. 49](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kimya/12/unite1/files/basic-html/page49.html) |
| `ayt_kim_5` | Organik kimya temeli | [Dört Dörtlük AYT Kimya, Hidrokarbonlar, s. 361](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page363.html) · [Organik bileşik sınıfları, s. 393](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page393.html) |
| `ayt_kim_6` | Tepkime ısısı ve termodinamik | [Dört Dörtlük AYT Kimya, tepkime entalpisi ve Hess yasası, s. 137](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page139.html) · [IUPAC Gold Book, Gibbs enerjisi](https://goldbook.iupac.org/terms/view/G02629) |

### AYT Biyoloji konu kaynakları

| Konu ID | Konu | Kaynak |
|---|---|---|
| `ayt_bio_1` | Hücre Bölünmesi — Mitoz | [Dört Dörtlük 10. Sınıf Biyoloji, Mitoz ve Eşeysiz Üreme, basılı s. 10](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/10/biyoloji/files/basic-html/page12.html) |
| `ayt_bio_2` | Mayoz Bölünme | [Dört Dörtlük 10. Sınıf Biyoloji, Mayoz ve Eşeyli Üreme, basılı s. 24](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/10/biyoloji/files/basic-html/page26.html) |
| `ayt_bio_3` | Kalıtım — Mendel Genetiği | [Dört Dörtlük 10. Sınıf Biyoloji, Mendel İlkeleri ve Çaprazlamalar, basılı s. 38](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/10/biyoloji/files/basic-html/page40.html) |
| `ayt_bio_4` | Kan Grupları ve Cinsiyete Bağlı Kalıtım | [Dört Dörtlük 10. Sınıf Biyoloji, Kan Grupları, basılı s. 54](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/10/biyoloji/files/basic-html/page56.html) · [Eşeye Bağlı Kalıtım, basılı s. 66](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/10/biyoloji/files/basic-html/page68.html) |
| `ayt_bio_5` | Sinir Sistemi | [Dört Dörtlük AYT Biyoloji, Sinir Sistemi, s. 9](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/biyoloji/files/basic-html/page9.html) |
| `ayt_bio_6` | Hormonal Sistem | [Dört Dörtlük AYT Biyoloji, Endokrin Sistem, s. 24](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/biyoloji/files/basic-html/page24.html) |
| `ayt_bio_7` | Fotosentez Detay (AYT) | [Dört Dörtlük AYT Biyoloji, Fotosentez ve Kemosentez, s. 207](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/biyoloji/files/basic-html/page207.html) |
| `ayt_bio_8` | Solunum Detay (AYT) | [Dört Dörtlük AYT Biyoloji, Hücresel Solunum ve Fermantasyon, s. 221](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/biyoloji/files/basic-html/page221.html) |

### Sonraki kapsam işi — kart kataloğu ve termodinamik

- [Dört Dörtlük AYT Kimya içindekiler, s. 8](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/kimya/files/basic-html/page8.html) 17 başlık listeliyor. Uygulamadaki 6 geniş karta ayrıca kuantum atom modeli, periyodik özellikler, gaz karışımları/gerçek gazlar, çözelti-derişim ve koligatif özellikler, tepkime hızı, Lewis/hibritleşme, organik sınıflar ve enerji kaynakları gibi alt kapsamlar eşlenmeli.
- Altı kartın `questionCount` toplamı 13 ve branş toplamı 13; bu yalnız aritmetik tutarlılık sağlar, güncel ÖSYM konu/soru dağılımını kanıtlamaz. Hedef YKS kohortu ve seçilen kitapçıkla kart/görev eşlemesi açık.
- Dört Dörtlük AYT Kimya içindekilerinde tepkime ısısı, oluşum entalpisi ve Hess yasası var; entropy ve Gibbs ifadesi aynı dizinde görünmüyor. Uygulamadaki `ΔG=ΔH−TΔS` ve ilgili formül kartı bilimsel bağıntı olarak kaynaklı olsa da hedef YKS kohortundaki kapsamı uzman/program incelemesi bekliyor.
- [Dört Dörtlük AYT Biyoloji içindekiler, s. 6](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/konu-pekistirme/ayt/biyoloji/files/basic-html/page6.html) ile soru dağılımı, s. 8, 20 başlık listeliyor; uygulamada 8 geniş kart bulunuyor. Duyu organları, destek-hareket, sindirim, dolaşım, bağışıklık, solunum/üriner/üreme sistemleri, ekoloji, nükleik asitler/protein sentezi, biyoteknoloji ve bitki biyolojisinin alt başlıkları ayrı kartlara veya açık eşlemeye ihtiyaç duyuyor. Başlıktaki soru adetleri uygulama ağırlığına aktarılmadı; bu kitap tek başına hedef 2026/2027 YKS kapsam belgesi değildir.
- Mitoz/mayoz ve Mendel içerikleri MEB'in 10. sınıf materyalinde yer alıyor; AYT kartı olarak hangi derinlikte çalışma görevi gerektirdikleri hedef kohort ve alan uzmanı tarafından ayrıca kabul edilmeli. Fotosentez kartının önceki C₃/C₄ karşılaştırması kaynakta teyit edilmediği için kaldırıldı; gerekirse uygun ders kitabı ve kapsamla yeniden eşleştirilecek.
