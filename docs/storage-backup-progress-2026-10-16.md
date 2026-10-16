# Sınav Rotası — kayıt ve yedek düzeltmeleri, ilk uygulama dilimi

Tarih: 16 Ekim 2026.
Temel: ürün/tasarım/veri koruma araştırmasındaki ilk öncelik.
Durum: kaynak değişiklikleri uygulandı; otomatik regresyon ve gerçek cihaz kurtarma kabulü açık.

## Uygulanan kaynak değişiklikleri

- AUD-01: Yeni net güncellemesi tek kanonik haritaya dönüştürülüyor; çelişen eski/yeni anahtarlar reddediliyor. Yedek doğrulama aynı kanonikleştirmeyi kullanıyor. Aynı değerli eski takma adlar içe aktarmada birleşiyor. Eski bozuk kayıtlar silinmiyor; export kurtarma arşivine alınabiliyor.
- AUD-02: _writeProfileData artık başarı/başarısızlık sonucu dönüyor. Çalışma tercihi kalıcı yazılamazsa bellek planı değişmiyor ve Ayarlar hata gösteriyor. Deneme güncellemesi Future<bool>; kalıcı yazım başarılı olmadan sonuç nesnesi değişmiyor. Düğmede Kaydediliyor durumu, tekrar basış koruması ve gerçek başarı/hata bildirimi var. Pomodoro durumu da başarısız yazımdan sonra bellekte kaydedilmiş sayılmıyor; Pomodoro sayfasında kayıt hatası bildiriliyor.
- AUD-02 ek: Hatalar profil/veri grubu, deneme veya oturum kimliği bazında izleniyor. Başka bir başarılı kayıt önceki başarısız işlemin uyarısını temizlemiyor. Uyarıyı sessizce kapatan düğme kaldırıldı. Kullanıcı onaylı “kaydedilmiş veriyi yükle” eski taslakları bırakıp depodan yükler; bu sırada oluşan yeni hata korunur.
- AUD-03: ProfileStorage.mutateStringsForProfile ile oku → dönüştür → doğrula → yaz tek işlem kuyruğunda. Odak kaydı en son kalıcı listeye ekleniyor; aynı kimlik ve aynı içerik yeniden denendiğinde çoğaltılmıyor, aynı kimlik/farklı içerik reddediliyor. Farklı denemelerin kaydı da aynı saklama sözleşmesini kullanıyor.
- AUD-04: Export tek okunamayan/geçersiz veri grubunda tamamen durmuyor. Sağlam gruplar normal veride; sorunlu grubun özgün ham metni, anahtarı, sebebi ve zamanı recovery_records içinde korunuyor. İçerik ve profil/bağlantı doğrulaması uygulanıyor; export kendi importer önizlemesinden geçmeden döndürülmüyor.
- AUD-04 ek: İçe aktarma önizlemesinde ham arşiv sayısı ve bu kayıtların etkinleştirilmeyeceği açıklanıyor. İçe alınan arşiv Ayarlar'da görünür; sonraki yedeklerde korunur. Açılış hatası ekranından kurtarma dosyası oluşturulabilir. Profil metadatasının kendisi açılamıyorsa bu export yolu da çalışmayabilir; dosyadan başlangıç kurtarması mevcut.
- SAFE-01: Panoya kopyalama dosya yedeği zamanını güncellemiyor. Eski belirsiz “başarılı yedek” damgası yeni damgaya taşınmıyor. Yeni etiket “Son dosya dışa aktarımı”; web'de doğrulanmayan indirme yalnız istek olarak bildiriliyor. Dosya dışa aktarımının buluta yükleme kanıtı olmadığı açıklanıyor.
- AUD-05: 2026 kılavuzuna göre TYT 165, AYT 180, YDT 120 dakika tek YksExamRules yapılandırmasına alındı. Eski 135 dakikalık tam TYT metinleri, 225 dakikalık TYT+kısa AYT çalışması, 165+180 karma süre ve CSV envanteri birlikte güncellendi. Kısa AYT 60 dakika resmî oturum değil, çalışma egzersizi olarak adlandırıldı. Gerçekleşmiş net ve tarih alanları değiştirilmedi.

## Saklama biçimi ve kapsam

ProfileStorage şeması 7. Yeni recovery_records veri grubu sürüm 1 biçiminde; records listesinde dataKey/rawValue/reason/capturedAt var. Ham veriler otomatik etkinleştirilmez. Eski sürüm 1–6 yedeklerin okunma yolları korunuyor; v7 yedeği eski v6 uygulamaya yüklemek desteklenmez. Sürüm düşürme/dağıtım kararı öncesinde ayrıca geçiş kabulü gerekir.

Bu, sunucu veya otomatik bulut yedeği kurulması değildir. Mevcut dosya seçici kullanıcıya sağlayıcı seçme yolu sunar; Drive/iCloud sağlayıcılarında gerçek yükleme ve farklı cihazdan dönme henüz doğrulanmadı.

## Kontrol kanıtı

- Güncel kaynakta flutter analyze --no-pub temiz.
- Flutter web release derlemesi başarılı; son değişikliklerin derleme sonucu çalışma kaydında belirtilir.
- Otomatik test eklenmedi/çalıştırılmadı. Önceki teşhis dosyası artık async olan updateMockExam API'sine uyarlanmalı; eski teşhis çıktısı bu düzeltmelerin kanıtı değildir.
- Gerçek kullanıcı çalışma deposuna yazılmadı; kaldırma/yeniden kurma yapılmadı.
- Uygulama kaynakları biçimlendirildi ve farkları incelendi. Statik analiz/derleme, eşzamanlılık ve kurtarma kabulünün yerine geçmez.

## Açık kabul işleri

- [ ] Kayıt hatası enjeksiyonu: tercih/deneme/timer belleği ile kalıcı depo, hata bildirimi ve yeniden deneme.
- [ ] Aynı anda iki farklı oturum; aynı oturuma tekrar; aynı kimlik/farklı içerik; profil geçişi sırasında kayıt.
- [ ] Çelişen net anahtarlarının iki sırası, çeyrek net sınırları ve aynı değerli eski takma ad.
- [ ] Çok profilli export → preview → import → export; sürüm 1–6'dan 7'ye geçiş.
- [ ] Bozuk JSON, yapısal hata, kopuk konu referansı, yanlış profile bağlı kayıt; ham arşivin byte/metin düzeyinde korunması.
- [ ] Kurtarma dosyasının bozuk olmayan grupları açması; ham arşivin otomatik etkinleşmemesi; eski iyi kopyaya dönme.
- [ ] Android dosya sağlayıcısı, iptal ve bulut kotası; web indirme; iOS sağlayıcısı.
- [ ] Kontrollü veriyle kaldırma/yeniden kurma ve farklı cihazdan geri yükleme.
- [ ] AUD-02'nin diğer iyimser ekran eylemlerindeki taslak/yeniden deneme davranışının tamamı; genel hata uyarısı korunuyor ama bütün ekranlar kalıcı yazımdan sonra güncelleme düzenine geçirilmiş değil.

## Sıradaki uygulama işleri

Kayıt/kurtarma kabulünden sonra AUD-06/07/08 kapasite, tarihsel plan ve tekrar kimliği; PROD-02/03 kişisel kaynak-görev-kısmi ilerleme; PROD-04 serbest deneme; ardından günlük ekran tasarımı, ortak hareket tasarımı ve açık Android backup/transfer kuralları. Otomatik Drive yedeği OAuth/platform kurulumu gerektiren ayrı dilim.

## Model değişirse devam notu

Ekonomik küçük işler için Luna 6 denenebilir. Bu depoda Luna ile karşılaştırmalı sonuç ölçülmedi. Kritik veri tasarımı, taşıma ve inceleme için Sol; sınırı net ekran/metin işleri için Luna + odaklı inceleme önerisi bir iş bölümü değerlendirmesidir, garanti değildir. Çok ajan kullanımı kendiliğinden token tasarrufu sağlamaz; ortak uzun bağlam ve tekrar incelemeleri maliyeti artırabilir.

Devralacak model önce bu notu, product-design-backup-research-2026-10-16.md ve research-audit-2026-10-16.md dosyalarını okusun. Gerçek veri silinmesin; eski teşhis raporu yeni kabul sayılmasın; tüm proje tamamlandı denmesin.

