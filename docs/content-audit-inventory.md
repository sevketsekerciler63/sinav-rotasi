# Eğitim içeriği kaynak ve koşul envanteri

Son kaynak sayımı: 2026-10-16. Bu dosya kapsam envanteridir; listedeki bir ifadenin doğru olduğunu veya alan uzmanı tarafından onaylandığını göstermez.

## Kaynak durumu

| İçerik grubu | Kaynakta sayılan kayıt | Kaynak etiketi/URL'si olan | Durum |
| --- | ---: | ---: | --- |
| TYT + AYT konu açıklamaları (`subjects_data.dart`) | 107 | 4 | 103 konu için kaynak ve sürüm bağı eksik |
| Matematik formül kartları | 14 | 1 | Logaritma çarpım kuralı kaynaklı; kalan kartlarda kaynak eşlemesi açık |
| Fizik formül kartları | 12 | 1 | Newton 2. yasa net kuvvet koşuluyla kaynaklı; kalan kartlarda kaynak eşlemesi açık |
| Kimya formül kartları | 10 | 3 | pOH, denge sabiti ve tepkime entalpisi etiketli; kaynak içeriği yine kontrol edilmeli |
| Biyoloji formül/kısa bilgi kartları | 8 | 0 | Kaynak eşlemesi ve koşul denetimi açık |
| **Toplam formül kartı** | **44** | **5** | **39 kartta kaynak alanı yok** |

Sayılar kaynak kodundaki `Topic(`, `FormulaItem(` ve `sourceLabel:` kayıtlarının statik sayımıdır. Özel kullanıcı içeriği, kapsam doğruluğu veya sınav müfredatına uygunluk sonucu değildir.

## Formül kartı başlıkları

| Alan | Kartlar | Kaynak durumu |
| --- | --- | --- |
| Matematik (14) | Pisagor Teoremi; Ikinci Derece Denklem; Aritmetik Dizi Toplami; Geometrik Dizi Toplami; Permutasyon; Kombinasyon; Binom Acilimi; Daire Alani; Kure Hacmi; Silindir Hacmi; Koni Hacmi; Logaritma Kuralı; Turev Kural; Integral Kural | Logaritma çarpım kuralı MEB OGM Matematik 12 p.32 ile kaynaklı; kalan 13 kartta kaynak alanı yok |
| Fizik (12) | Newton'ın 2. Yasası; Kinetik Enerji; Potansiyel Enerji; Is-Enerji; Hiz Formulu; Yol Formulu; Ohm Yasasi; Guc; Coulomb Yasasi; Dalga Hizi; Elastik PE; Moment | Newton 2. yasa MEB OGM Fen Lisesi Fizik 9 p.18 ile kaynaklı; kalan 11 kartta kaynak alanı yok |
| Kimya (10) | Mol Hesabi; Ideal Gaz; Molarite; Molalite; pH Hesabi; pOH Hesabi; Denge Sabiti; Avogadro; Gibbs Serbest Enerjisi; Tepkime Entalpisi | pOH, denge sabiti ve tepkime entalpisi kaynaklı; kalan 7 kartta kaynak alanı yok |
| Biyoloji (8) | Fotosentez; Solunum; DNA Baz Eslesmesi; Chargaff Kurali; Hardy-Weinberg; Osmotik Basinc; Hücresel Solunumda ATP; Mitoz | Hepsinde kaynak alanı yok |

## Öncelikli koşul ve anlam denetimi

- **Matematik:** logaritma çarpım kartına `a > 0`, `a ≠ 1`, `x,y > 0` koşulları ve MEB kaynağı eklendi. Kalan inceleme: ikinci derece denklemde `a ≠ 0`; geometrik toplamda `r = 1` özel durumu; permütasyon/kombinasyonda tam sayı ve aralık sınırları; integral kuvvet kuralının `n = −1` istisnası.
- **Fizik:** Newton kartı artık bileşke/net kuvveti `ΣF = ma` ile gösteriyor ve MEB OGM kaynağına bağlı. Kalan inceleme: işte sabit kuvvet ve açı; konum formülünde başlangıç konumu veya yer değiştirme; Coulomb kuvvetinde büyüklük/ortam; güçte ortalama ve anlık büyüklük ayrımı; momentte dik kuvvet kolu.
- **Kimya:** molarite/molalite birimleri; ideal gaz varsayımı; pH/pOH etkinlik ve okul düzeyi derişim yaklaşımı; `pKw` sıcaklık bağı; denge ifadesinde saf katı/sıvıların dışarıda kalması; standart oluşum entalpisi ve katsayılar.
- **Biyoloji:** hücresel solunumdaki ATP miktarının modele bağlılığı; Hardy–Weinberg varsayımları; ozmotik basınçta ideal/seyreltik çözelti; mitozda ana hücrenin kromozom yapısı ve yavru hücre sonucu.
- **Konu açıklamaları:** 107 başlığın tamamı için ders, sınıf, güncel sınav kapsamı, kaynak adı/sayfası ve inceleme durumu satır bazında eşleştirilmeli. Dört kaynak etiketi bütün kataloğun doğrulandığı anlamına gelmez.

## Kaynaklı düzeltmeler — 2026-10-16

- Logaritma çarpım kuralı ve geçerlilik koşulları: [MEB OGM Materyal · Matematik 12, Üstel ve Logaritmik Fonksiyonlar, s. 32](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/12/unite1/files/basic-html/page22.html).
- Newton'ın ikinci yasasında bileşke kuvvet: [MEB OGM Materyal · Fen Lisesi Fizik 9, Kuvvet ve Hareket, s. 18](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesifizik/9/unite3/files/basic-html/page18.html).

## Kapanış ölçütü

Her kayıt için güvenilir birincil/kurumsal kaynak, güncelleme tarihi, gerekli tanım koşulu, en az bir denetlenmiş örnek ve kapsam eşlemesi yazılmalı. Kaynağı bulunamayan veya uzman değerlendirmesi isteyen içerik “taslak/doğrulanmadı” diye işaretlenmeli. Tam editoryal onay yalnız bu envanter ve kaynakların içerik uzmanı tarafından kontrol edilmesiyle verilebilir.
