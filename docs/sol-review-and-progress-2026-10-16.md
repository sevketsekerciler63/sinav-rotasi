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
- SOL-01'in önceki `9878621` veri dilimi için depolama/hata/eşzamanlılık kontrolleri sırada; Luna incelemesinin bitmesi veri dilimini onaylamaz.
- Ardından SOL-02/03 kayıt ve plan açıkları, SOL-04/05 kalıcı kaynak/serbest deneme; bu modeller hazır olunca LUNA-05 ekranları. Hareket sözleşmesinden sonra LUNA-06.
- Kullanıcıya ait `docs/research-audit-2026-10-16.md` içindeki mevcut değişiklik korunuyor, teslim commit'lerine katılmıyor.
