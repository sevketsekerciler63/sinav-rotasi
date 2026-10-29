# Sınav Rotası Gizlilik Politikası (taslak)

> **Taslak — yayından önce doldurulacak:** `[GELİŞTİRİCİ ADI]`, `[İLETİŞİM E-POSTASI]` ve `[YÜRÜRLÜK TARİHİ]` alanları ile mağazada yayımlanacak kalıcı web adresi. Metin 2026-10-30 tarihindeki kaynak koda göre yazıldı (Android release manifesti, `pubspec.yaml`, Ayarlar → Veri ve gizlilik penceresi). Hukuki inceleme yapılmadı.

**Yürürlük tarihi:** `[YÜRÜRLÜK TARİHİ]`
**Geliştirici:** `[GELİŞTİRİCİ ADI]` · `[İLETİŞİM E-POSTASI]`

Sınav Rotası, sınava hazırlanan öğrencinin kendi çalışma planını, konu ilerlemesini ve deneme sonuçlarını kendi cihazında takip ettiği bir uygulamadır. Bu politika uygulamanın hangi verileri nerede tuttuğunu ve ne zaman dışarıyla bağlantı kurduğunu açıklar.

## 1. Geliştiriciye veri gönderilmez

- Uygulamada hesap, giriş veya bulut eşitleme yoktur.
- Uygulama geliştiricinin veya üçüncü bir tarafın sunucusuna veri göndermez.
- Reklam, analitik veya hata raporlama yazılımı içermez.
- Android sürümü İnternet erişimi izni (`INTERNET`) istemez.

## 2. Cihazda saklanan veriler

Aşağıdaki bilgiler yalnızca uygulamanın cihazdaki yerel deposunda tutulur:

- Profil bilgileri: profil adı, sınav türü, puan türü, başlangıç seviyesi öz değerlendirmesi, kişisel hedef tarihi ve isteğe bağlı sınav yılı
- Ders ve konu ilerlemesi, konu notları, öğrencinin eklediği kişisel ders ve konular
- Günlük plan, çözülen soru kayıtları, odak (Pomodoro) oturumları
- Deneme sonuçları ve netleri, zayıf konu ve tekrar kayıtları, hedefler, rozetler
- Kaynaklarım: öğrencinin eklediği kitap ve kaynak adları ile görev ilerlemesi
- Görünüm ve hatırlatıcı tercihleri

Uygulama ad-soyad, e-posta, telefon, konum, kişiler, fotoğraf veya cihaz kimliği istemez.

## 3. İzinler

| İzin | Neden |
|---|---|
| Bildirim gönderme (`POST_NOTIFICATIONS`) | Öğrenci isterse günlük çalışma hatırlatıcısı göstermek için. Hatırlatıcı varsayılan olarak kapalıdır. |
| Açılışta çalışma (`RECEIVE_BOOT_COMPLETED`) | Cihaz yeniden başladığında, açık olan hatırlatıcıyı yeniden kurmak için. |

Hatırlatıcı açıksa kilit ekranında etkin profil adı ve kişisel hedef görünebilir.

## 4. Dış bağlantılar

Uygulama yalnızca öğrenci bir düğmeye bastığında dış bir sayfayı **cihazın tarayıcısında** açar:

- "YouTube'da ara": arama ifadesi YouTube'da açılır.
- Konu, bilgi ve formül kartlarındaki "Kaynak": ilgili MEB OGM Materyal veya TDK sayfası açılır.

Bu bağlantılara profil veya çalışma verisi eklenmez. Açılan sitelerin kendi gizlilik politikaları geçerlidir. Yazı tipleri uygulamanın içindedir; görünüm için yazı tipi sunucusuna istek gönderilmez.

## 5. Yedekleme

- **Dosya yedeği:** Öğrenci Ayarlar'dan çalışma verisini JSON dosyası olarak dışa aktarabilir, panoya kopyalayabilir ve geri yükleyebilir. Dosyanın nerede saklanacağına öğrenci karar verir.
- **Android sistem yedeği:** Android'de çalışma deposu, cihazın sistem yedeğine ve cihazdan cihaza aktarıma dahil edilebilir. Bu yedek, öğrencinin cihaz ve Google hesabı ayarlarına bağlıdır; geliştirici bu yedeğe erişemez. Hatırlatıcı tercihleri ve son dışa aktarım bilgisi bu yedeğe dahil edilmez.

## 6. Verilerin silinmesi

- Ayarlar → "Çalışma Verilerini Sil" tüm profillerin çalışma ilerlemesini ve tercihlerini siler. İşlem geri alınamaz.
- Uygulamayı kaldırmak cihazdaki yerel verileri siler. Android sistem yedeğinde kalan kopya, cihazın veya Google hesabının yedek ayarlarından yönetilir.
- Geliştiricide öğrenciye ait veri bulunmadığı için geliştiriciden silinmesi gereken bir kayıt yoktur.

## 7. Yaş

Uygulama YKS ve benzeri sınavlara hazırlanan öğrenciler için tasarlanmıştır; bu öğrencilerin bir kısmı 18 yaşından küçük olabilir. Uygulama yaş bilgisi istemez ve kişisel veriyi geliştiriciye iletmez.

## 8. Değişiklikler

Bu politika değişirse güncel metin bu sayfada yayımlanır ve yürürlük tarihi güncellenir. Uygulamanın veri davranışı değişirse (ör. isteğe bağlı bulut yedeği eklenirse) politika önceden güncellenir.

## 9. İletişim

Sorular için: `[İLETİŞİM E-POSTASI]`

---

### Google Play "Veri güvenliği" formu için notlar (doğrulanacak)

- Kodda geliştiriciye veya üçüncü tarafa veri aktaran bir yol yok; bu nedenle formda büyük olasılıkla "veri toplanmıyor" ve "veri paylaşılmıyor" seçilecek. Yalnızca cihazda işlenen veri Play tanımında "toplanan veri" sayılmaz; formu doldururken Play'in güncel tanımları ayrıca kontrol edilmeli.
- Android sistem yedeğinin formdaki karşılığı Play yönergesinden doğrulanmalı.
- iOS sürümü yayımlanırsa App Store gizlilik etiketleri ayrıca hazırlanmalı; iOS davranışı gerçek cihazda doğrulanmadı.
