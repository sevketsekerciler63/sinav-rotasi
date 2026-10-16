# Sınav Rotası — Sol incelemesi ve devam kaydı

Tarih: 16 Ekim 2026. İş bölümü: [Luna ve Sol](luna-sol-work-plan-2026-10-16.md).

## Luna teslimlerinin inceleme sonucu

İncelenen kod aralığı: `8b7c4ff..9c799d4`. Düzeltme: `02e6a76`.
Luna dört pakette gerçek kod değişikliği yapmış; bütün kabul koşulları tamamlanmamıştı. Şema, kayıt kimlikleri ve yedek alanları bu paketlerde değiştirilmemiş.

| Görev | Bulgu | Yapılan düzeltme / kanıt |
|---|---|---|
| LUNA-01 | Metin temizliği kısmiydi. Bilgi kartlarında Turev, Hucre, bolunme vb. kalmıştı. | Kart kimlikleri korunarak 42 görünen metin parçası düzeltildi. AUD-09 kapsamındaki logaritma tanım koşulları, integral/alan ayrımı ve Kalvin döngüsündeki NADPH eksikliği kaynaklarla düzeltildi. |
| LUNA-02 | Tam ders/oturum etiketi gerçekten eklenmiş; odaklanan TextField'in semantik etiketi testte doğrulandı. Kayıt sırasında tarih seçimi açık kalıyordu. | Tarih seçimi de bekleyen kayıtta kilitlendi. Başarısız kayıt sonrası 20,5 taslağı ve yeniden düzenleme korunuyor; başarı bildirimi çıkmıyor. Başlık ikonları klavyeden erişilebilen standart düğmelere dönüştürüldü. |
| LUNA-03 | Bileşenler gerçekten birden çok ekranda kullanılmış. Boş durum, 320×320 ve %200 yazıda koyu temada 96 px, açık temada 120 px taşıyordu. | Ortak boş durum kısa ekranda kaydırılabilir ve geniş alanda ortalanır hale getirildi. Her iki tema testi geçti. |
| LUNA-04 | Bugün kartı, plansız gün ve geçmiş hedef dalları gerçekten var. Ana ekranda %200 yazı ve 320 px genişlikte başlık/sayaç satırları taşıyordu; bu satırların bir bölümü eski koddan kalmıştı. | Başlık ve gün satırı gerektiğinde alt satıra geçiyor; sayaç başlığı, ana değeri ve tarih açıklaması sınırlandırılıyor. Görev düğmesi ilk ekran içinde. Plansız gün bağlantısı gerçek Günlük Plan ekranını açıyor; geçmiş hedefte büyük sayaç yok. |

## Çalıştırılan kontroller

- `flutter test --no-pub test/ui_delivery_acceptance_test.dart --reporter expanded`: 5 test geçti.
- `flutter analyze --no-pub`: hata yok.
- `git diff --check`: boşluk hatası yok.
- Ekran testleri gerçek AppTheme ve yalnız test belleğindeki örnek AppState ile çalışır; kişisel profil deposu yüklenmez/yazılmaz.
- İlk koşuda eksikler yeniden üretildi; son koşuda düzeltmelerle geçti. Gerçek cihaz/TalkBack/VoiceOver kontrolü yerine geçmiş sayılmaz.

## İçerik kaynakları

- [MEB Matematik 12 — logaritma tanım koşulları](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/12/unite1/files/basic-html/page11.html).
- [MEB Matematik 12 — integral ile geometrik alan](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/12/unite6/files/basic-html/page49.html).
- [MEB Biyoloji 12 — Kalvin döngüsü ve ATP/NADPH](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesibiyoloji/12/unite2/files/basic-html/page12.html).
- [MEB Fizik 11 — enerji korunumu](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/kavram_calismalari/11/fizik/files/basic-html/page112.html).

## Açık koşullar ve sonraki sıra

- Fiziksel telefon, gerçek ekran okuyucu, platform dosya sağlayıcısı, hesap/OAuth ve farklı cihazdan kurtarma koşulları henüz uygulanmadı. Bunlar SOL-07 kabulünde ayrıca izlenecek.
- Mevcut 8795 tarayıcı sayfası yenilenmesine rağmen eski motivasyon/sayaç sırasını gösteriyordu. Bu görünüm yeni kaynak için kabul kanıtı olarak kullanılmadı. Güncel uygulama için yeni derlemeyle çalışan sunucu ve taze sayfa ayrıca doğrulanacak.
- SOL-01'in önceki `9878621` veri dilimi için ilk 9 depolama/hata/eşzamanlılık kontrolü geçti; aşağıdaki sınırlar ve fiziksel cihaz kabulü açık.
- Ardından SOL-02/03 kayıt ve plan açıkları, SOL-04/05 kalıcı kaynak/serbest deneme; bu modeller hazır olunca LUNA-05 ekranları. Hareket sözleşmesinden sonra LUNA-06.
- Kullanıcıya ait `docs/research-audit-2026-10-16.md` içindeki mevcut değişiklik korunuyor, teslim commit'lerine katılmıyor.

## SOL-01/02 · Veri kabulü ve acil arşiv, ikinci dilim

Teslim: `bfd7b11`. `test/storage_recovery_test.dart` içinde 9 kontrol geçti; UI ile toplam 14 test geçti. Statik analiz temiz.

- Eşzamanlı iki farklı odak kaydı korunuyor; aynı kayıt yeniden denenince çoğalmıyor, aynı kimlik/farklı içerik reddediliyor.
- Çalışma tercihi yazımı başarısızsa eski bellek ve kalıcı değer korunuyor. İlgisiz başarılı kayıt hatayı gizlemiyor; ilgili başarılı yeniden deneme temizliyor.
- Çelişen/eski net anahtarları, eşzamanlı farklı denemeler, başarısız deneme yazımı ve yeniden yükleme kontrol edildi.
- Bekleyen kayıt sırasında yeni profile geçişte eski oturum eski profile yazılıyor, yeni profile sızmıyor.
- Çok profilli yedek, bozuk ham grubun arşivi, iki export/import turu ve arşivin etkinleşmemesi kontrol edildi.
- Sürüm 1–7 işaretleriyle temsilî tam yedek ve eski düz net yedeği okundu. Bu, bütün tarihsel sürümlerin gerçek cihaz yedekleriyle tam geçiş kabulü değildir.
- Kesilmiş işlem günlüğü eski değeri geri yükleyerek açıldı.
- Yeni hata bulundu/düzeltildi: `StudySchedulePreferences.fromJson` çağıranın veya const varsayılan gün listesini sıralayıp değiştirmeye çalışıyordu. Artık kopya sıralanıyor; varsayılan profille yeni profil oluşturma testi geçiyor.
- Yeni `exportEmergencyArchive`: profil metadatası veya işlem günlüğü açılamasa da yalnız yönetilen ham tercihleri okumadan/değiştirmeden arşivler. Başlangıç ekranı normal export başarısızsa bu yola geçer. Ham arşiv normal importer tarafından kabul edilmez; ekranda doğrudan yüklenemeyeceği belirtilir.
- Test izolasyonu için bağımsız ProfileStorage ve AppState depo enjeksiyonu eklendi. Üretimde varsayılan singleton akışı aynı.

Açık: ham acil arşivden seçici insan denetimli onarım aracı; gerçek cihazda dosya seçici/Drive/iCloud sağlayıcısı; kaldırıp yeniden kurma/farklı cihaz; eski gerçek yedekler. Diğer iyimser konu/hedef/gün eylemlerinin kalıcı sonuç sözleşmesi SOL-02 içinde açık kalıyor.

## SOL-03 · Tekrar olaylarının geri alınması

Teslim: `6df0300`. Veri şeması artık 8; eski 1–7 işaretleri okunur, yeni v8 yedeği eski uygulamaya yüklenmez.

- AUD-08: tekrar olayları kalıcı kimlikle kaydedilir. Aynı planı tamamla → geri al → tamamla yeni bir tekrar eklemez. Eski olayı geri almak, sonradan yapılmış diğer tekrarları ve durum değişikliklerini silmez; çizelge etkin olaylardan yeniden kurulur.
- Gün tamamlaması ile ona bağlı zayıf konu tekrarı aynı yerel işlemde yazılır. Diğer iyimser eylemler için genel kalıcı sonuç/taslak işi açık kalır.
- Eski tamamlanmış plan kayıtları mevcut tekrar sayısı/tarihi korunarak işaretlenir. Önceki sürümde olaya ait başlangıç durumu tutulmadığından eski aralığı geri alırken tahmin edilmez; aynı eski olayı yeniden işaretlemek sayıyı artırmaz.
- 4 model kontrolü ve kalıcı AppState/export/import kontrolü geçti. Tekrar + depolama için 14 odaklı test geçti; statik analiz temiz.
- Kalan SOL-03: güncel günlük dakika kapasitesi ve bölünebilir kişisel görevler; geçmişte beklenen planın korunması. Kimlikleri rastgele bölüp eski çalışma kayıtlarını kaybetmemek için kaynak/görev modeliyle birlikte uygulanacak.
