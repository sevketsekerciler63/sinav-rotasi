# Eğitim içeriği kaynak ve koşul envanteri

Son kaynak sayımı: 2026-10-16. Bu dosya kapsam envanteridir; listedeki bir ifadenin doğru olduğunu veya alan uzmanı tarafından onaylandığını göstermez.

## Kaynak durumu

| İçerik grubu | Kaynakta sayılan kayıt | Kaynak etiketi/URL'si olan | Durum |
| --- | ---: | ---: | --- |
| TYT + AYT konu açıklamaları (`subjects_data.dart`) | 107 | 4 | 103 konu için kaynak ve sürüm bağı eksik |
| Matematik formül kartları | 14 | 0 | Kaynak eşlemesi ve koşul denetimi açık |
| Fizik formül kartları | 12 | 0 | Kaynak eşlemesi ve koşul denetimi açık |
| Kimya formül kartları | 10 | 3 | pOH, denge sabiti ve tepkime entalpisi etiketli; kaynak içeriği yine kontrol edilmeli |
| Biyoloji formül/kısa bilgi kartları | 8 | 0 | Kaynak eşlemesi ve koşul denetimi açık |
| **Toplam formül kartı** | **44** | **3** | **41 kartta kaynak alanı yok** |

Sayılar kaynak kodundaki `Topic(`, `FormulaItem(` ve `sourceLabel:` kayıtlarının statik sayımıdır. Özel kullanıcı içeriği, kapsam doğruluğu veya sınav müfredatına uygunluk sonucu değildir.

## Formül kartı başlıkları

| Alan | Kartlar | Kaynak durumu |
| --- | --- | --- |
| Matematik (14) | Pisagor Teoremi; Ikinci Derece Denklem; Aritmetik Dizi Toplami; Geometrik Dizi Toplami; Permutasyon; Kombinasyon; Binom Acilimi; Daire Alani; Kure Hacmi; Silindir Hacmi; Koni Hacmi; Logaritma Kurali; Turev Kural; Integral Kural | Hepsinde kaynak alanı yok |
| Fizik (12) | Newton 2. Yasa; Kinetik Enerji; Potansiyel Enerji; Is-Enerji; Hiz Formulu; Yol Formulu; Ohm Yasasi; Guc; Coulomb Yasasi; Dalga Hizi; Elastik PE; Moment | Hepsinde kaynak alanı yok |
| Kimya (10) | Mol Hesabi; Ideal Gaz; Molarite; Molalite; pH Hesabi; pOH Hesabi; Denge Sabiti; Avogadro; Gibbs Serbest Enerjisi; Tepkime Entalpisi | pOH, denge sabiti ve tepkime entalpisi kaynaklı; kalan 7 kartta kaynak alanı yok |
| Biyoloji (8) | Fotosentez; Solunum; DNA Baz Eslesmesi; Chargaff Kurali; Hardy-Weinberg; Osmotik Basinc; Hücresel Solunumda ATP; Mitoz | Hepsinde kaynak alanı yok |

## Öncelikli koşul ve anlam denetimi

- **Matematik:** ikinci derece denklemde `a ≠ 0`; logaritmada taban ve argüman koşulları; geometrik toplamda `r = 1` özel durumu; permütasyon/kombinasyonda tam sayı ve aralık sınırları; integral kuvvet kuralının `n = −1` istisnası.
- **Fizik:** Newton yasasında net kuvvet; işte sabit kuvvet ve açı; konum formülünde başlangıç konumu veya yer değiştirme; Coulomb kuvvetinde büyüklük/ortam; güçte ortalama ve anlık büyüklük ayrımı; momentte dik kuvvet kolu.
- **Kimya:** molarite/molalite birimleri; ideal gaz varsayımı; pH/pOH etkinlik ve okul düzeyi derişim yaklaşımı; `pKw` sıcaklık bağı; denge ifadesinde saf katı/sıvıların dışarıda kalması; standart oluşum entalpisi ve katsayılar.
- **Biyoloji:** hücresel solunumdaki ATP miktarının modele bağlılığı; Hardy–Weinberg varsayımları; ozmotik basınçta ideal/seyreltik çözelti; mitozda ana hücrenin kromozom yapısı ve yavru hücre sonucu.
- **Konu açıklamaları:** 107 başlığın tamamı için ders, sınıf, güncel sınav kapsamı, kaynak adı/sayfası ve inceleme durumu satır bazında eşleştirilmeli. Dört kaynak etiketi bütün kataloğun doğrulandığı anlamına gelmez.

## Kapanış ölçütü

Her kayıt için güvenilir birincil/kurumsal kaynak, güncelleme tarihi, gerekli tanım koşulu, en az bir denetlenmiş örnek ve kapsam eşlemesi yazılmalı. Kaynağı bulunamayan veya uzman değerlendirmesi isteyen içerik “taslak/doğrulanmadı” diye işaretlenmeli. Tam editoryal onay yalnız bu envanter ve kaynakların içerik uzmanı tarafından kontrol edilmesiyle verilebilir.
