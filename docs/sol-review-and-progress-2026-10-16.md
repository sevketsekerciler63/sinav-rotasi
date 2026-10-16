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

## SOL-04 · Kalıcı kaynak, görev ve ilerleme çekirdeği

Teslim: `ee3f45d`. [API ve ekran sözleşmesi](resource-api-v1.md). Güncel profil şeması 9; `learning_workspace` v1 grubu eklendi, eski veriler taşınmadan korunuyor.

- Kaynak → ayrılmış görev aralığı → çalışılmış birim aralığı ilişkisi gerçek kalıcı veridir. Arşiv ve geri alma geçmişi silmez. Örneğin 11–15 çalışması geri alınırken 21–25 çalışması korunur; kalan aralıklar doğru çıkarılır.
- Başarı kalıcı yazımdan sonra; çakışan görev/ilerleme, farklı olay içeriği, kopuk referans ve yabancı profil reddedilir.
- Depo/yedek doğrulaması yeni grafiği ve profil kimliğini kontrol eder. 7 model + 12 depolama testi birlikte geçti; analiz temiz.
- Kaynak ekranları şimdi bu API üzerine kuruluyor. Serbest deneme API'si ve ekranı, kapasite/plan geçmişi, kaynak ilerlemesinin rapor/timer bağı ve resmî ders takma adı AUD-12 henüz kapanmış değil. Bu dilim SOL-04'ün tamamı olarak işaretlenmedi.


## LUNA-05 / SOL-04 · Kaynak ekranı gerçek kayda bağlandı

- `StudyResourcesScreen`: kaynak/ders/birim/toplam/başlangıç ilerlemesi; görev aralığı, tahmini dakika ve isteğe bağlı hedef günü; kısmi çalışma, geçmişi koruyan geri alma ve arşivleme gerçek kalıcı API'yi kullanır.
- Kaynaklarım ana sayfada öne alındı. Önceki video/çalışma rehberi yardım düğmesinden açılır. Görevin odak düğmesi Pomodoro'ya kalıcı görev kimliği taşır; süre kendiliğinden birim tamamlamaz.
- Başarıdan önce pencere kapanmaz; hata taslağı korur, bekleyen yazımda düğmeler kilitlenir, profil değişirse eski form reddedilir. Arşivli kaynağa yeni görev/geri açma engellenir.
- Ekran kabulünde bulunan çıkış animasyonunda erken controller dispose hatası düzeltildi: dialog rotasının tamamen kapanması beklenir.
- `resource_screen_acceptance_test.dart`: gerçek depo hatası → taslağı koru → yeniden dene → görev ekle → 4/10 ilerleme → geri al → yeniden yükle akışı geçti. Önceki 28 test de bu dilim öncesinde geçti. Analiz sonucu ayrıca kaydedilecek.
- **Açık:** kaynak görevlerini kapasiteye göre günlük plana yerleştirme, geçmiş plan beklentileri, rapor toplamları; serbest deneme ekranı/API'si, hareket sözleşmesi ve cihaz/yedek sağlayıcısı kabulü. Hedef günü şu anda yalnız kayıttır; ekranda otomatik plana eklenmediği açıkça yazılıdır.


## SOL-03/04 · Kapasite, korunmuş gün beklentisi ve rapor entegrasyonu

- `learning_workspace` v2 / uygulama şeması 10. v1 kaynak kayıtları boş plan geçmişiyle açılır; geçmiş günlere beklenti uydurulmaz.
- Kaynak görevleri birim başına kullanıcı süre tahminine göre tam birimlerle bölünür. Günlük kapasite aşılmaz; tek birim daha uzunsa sığmamış iş olarak kalır. Çalışılmayan hafta günleri ve görevin en erken hedef günü dikkate alınır.
- Plan oluşturma/güncelleme kalıcıdır. Bugün ve geçmiş korunur; yalnız gelecek yeniden dağıtılır. Bugünü tamamlayınca aynı güne yeni yük atanmaz. Önceki günde yetişmeyen aralık gelecek dağıtımına dönerken eski günün beklentisi kalır.
- Gününde tamamlanma, olayın yerel takvim günüyle hesaplanır. Sonraki günkü çalışma geçmiş eksik günü başarıya dönüştürmez. Geri alma kaynak, günlük aralık, soru toplamı ve seri görünümünü aynı olaydan düzeltir.
- Kaynak kullanan profilde ana sayfa ve günlük plan kişisel kaynak planını açar. Önceki şablon ve kayıtlar ayrı bağlantıyla korunur.
- İlk kaynak planı gününden sonraki rapor/seri beklentileri kaydedilmiş kaynak planından alınır; önceki tarihli eski başarılar korunur. Soru birimindeki ilerleme soru toplamlarına türetilmiş olay olarak katılır, ayrıca kalıcı sayaç kopyalanmaz. Sayfa/test/video sayısı soru sayısı varsayılmaz. Aynı çalışma ayrıca elle girilmemeli.
- 4 kapasite/geçmiş model kontrolü ve depo hata/yeniden deneme/export-import kabulü eklendi. 34 test geçti; ardından 320 px / yüzde 200 yazıda gerçek plan tamamlama ve kaynak formu kontrolü de geçti (toplam 35). Son analiz yeniden çalıştırılacak.
- **Açık/sınır:** eski hazır şablonun sıkıştırma motoru kişisel kapasite kabulü sayılmıyor; eski kayıtlar için korunuyor. Otomatik gece yeniden dağıtımı yok, kullanıcı geleceği günceller. Önceden tutulan beklentisi olmayan eski sürüm günleri için kaçırılan görev geçmişi geriye dönük hesaplanamaz. Serbest denemeler, hareket ve gerçek cihaz/provider kabulü sırada.


## SOL-05 / LUNA-05 · Serbest deneme defteri

- `exam_attempts` v1 / profil şeması 11: öğrencinin istediği sayıda gerçek denemesi; ad/yayınevi/gün, ayrı TYT/AYT/YDT, AYT SAY/EA/SÖZ ve YDT dil alanı. Önceki 13 takvim kaydı ayrı tarihçe bağlantısında korunur.
- Doğrudan net veya doğru/yanlış/boş. Soru sınırı, çeyrek net, doğru+yanlış+boş toplamı, tarih ve oturum/test kimlikleri doğrulanır. AYT kaydı TYT gerektirmez. SÖZ din muafiyetinde 18 felsefe/0 din seçimi bulunur.
- Kalıcı yazımdan sonra başarı; başarısız kayıtta taslak korunur, profil değişimi eski formu durdurur. Arşiv geri açılabilir. Eşzamanlı farklı denemeler son veriye birleşir; yedek/import profil kimliği denetlenir.
- Ana deneme ve karşılaştırma girişleri yeni deftere yönlendirildi. Aynı katalog/oturum/alan/dil/muafiyet grubunda son iki sonuç ve ders farkları karşılaştırılır; SAY/EA/YDT toplamı tek trende karıştırılmaz. Haftalık rapor yeni denemeleri ayrıca gösterir; genel tamamlanan deneme sayısına katılır.
- Resmî katalog sürümü `yks-2026-v1`. Kaynak: [ÖSYM 2026 YKS başvuru kılavuzu](https://dokuman.osym.gov.tr/pdfdokuman/2026/YKS/basvuru_kilavuz06022026.pdf), PDF s. 50 / basılı s. 46 Tablo 1A–1B; süreler PDF s. 2. Gelecek yılın kuralları doğrulanmış gibi etiketlenmez.
- 3 model kabulü (EA/SÖZ/YDT ayrılığı, sayım/net/tarih sınırları, 20 kayıt/retry/arşiv), gerçek depo hata/eşzamanlılık/profil/yedek kontrolü ve 320px yüzde 200 yazıda AYT-only 20,5 net + başarısız yazım sonrası taslağı yeniden kaydetme geçti. Toplam 40 test bekleniyor; tam son çalışma aşağıda güncellenecek.
- **Açık:** eski net isimlerinin tüm tarihsel/custom ders varyasyonlarını birleştiren AUD-12 geçişi; YKS dışı sınav adaptörleri; gerçek öğrenci/device kabulü. Eski takvim grafiklerinde serbest kayıtlar varmış gibi gösterilmiyor; yeni defter kendi doğrulanmış gruplarını karşılaştırıyor.


## SOL-06 / LUNA-06 · Ortak hareket ve sayaç gezinmesi

- [Hareket sözleşmesi](motion-contract.md) uygulandı: ortak 120/180/240 ms süreler, Flutter platform rotaları, azaltılmış hareket; dashboard liste uçuşu kaldırıldı, kalan kart/ilerleme/odak/onboarding geçişleri ortak süreyi kullanır. Zorunlu 2,8 saniyelik açılış beklemesi ve gerçek başlatmayı temsil etmeyen dekoratif dolum kaldırıldı.
- **Yeni gerçek hata:** Pomodoro `dispose` ekrandan çıkışı iptal seansı sayıyordu. Artık süre/görev/olay kimliği korunur. Süresi dolan seans geri açınca kaydedilir. Seans sonucu yazılmadan önce bekleyen durum/tarih/süre saklanır; hata veya gezinmeden sonra aynı kayıt tam aynı içerikle denenir.
- 3 yeni ekran kabulü geçti: azaltılmış hareketle beklemeden açılış; geri çık/gir aynı çalışan sayaç/son tarih/görev; seans yazımı hatası → geri çık/gir → aynı seans bir kez tamamlanmış ve mola durumuna geçmiş.
- Gerçek cihaz jest/performance ve eski iyimser eylemler için kapsam açık; yeni hareket sözleşmesi bunların tamamlandığı anlamına gelmez.

Son ortak kabul: 43 test geçti; `flutter analyze --no-pub` temiz.


## SOL-07 · Android veri ayrımı ve dış kabul engelleri

Android yedek kuralları ve ayrı cihaz tercihi deposu uygulandı; hatırlatıcı snapshot/hata düzeltmesi ve iki kontrol geçti. Debug APK derlendi. [Yapılanlar ve somut cihaz/OAuth/iOS/yayın engelleri](platform-backup-acceptance.md). CI tanımı eklendi, uzak CI çalışması iddia edilmiyor. Tam proje veya gerçek cihaz kurtarma tamamlandı sayılmıyor.


## SOL-02 · Konu / hedef / zayıf konu kalıcı sonucu

- Eski konu tamamlaması/notu, hedef ekle/ilerlet/sil/geri al ve zayıf konu ekle/durum/tekrar/sil/geri al son kalıcı grubu kuyruk içinde değiştirir. Bellek ve kutlama yalnız başarılı yazımdan sonra; ilgisiz kaydın başarısı başka olayın hatasını temizlemez. Aynı olay beklerken çift basış reddedilir.
- Hedef ve konu notu formu, zayıf konu ekleme ortak `ProfileSaveForm` kullanır: profil kimliği sabit, yazarken giriş/geri kapalı, hata taslağı korur, yeniden dene aynı ekranda; kapatmak için Vazgeç. Controller'lar alt sayfa çıkış animasyonundan sonra bırakılır.
- Sil/geri al bildirimi gerçek yazım sonucundan sonra; kaydırma başarısız kaydı görünümden gizlemez. Korunan bozuk eski hedefler diğer hedef kaydında ham arşiv olarak kalır.
- 3 yeni depo kabulü geçti; 320px yüzde 200 yazıda gerçek hedef formu → disk hatası → açık taslak → yeniden kaydet kontrolü geçti. Bu kontrolde bulunan miktar/birim satırı taşması dikey düzenle düzeltildi.
- **Açık:** eski hazır günlük şablon işlemleri, özel müfredat ekle/düzenle/sil işlemleri ve rozet/flashcard kayıtlarının aynı kalıcı sonuç sözleşmesine tamamlanması. Bunlar bu teslimde bitmiş işaretlenmedi.


## SOL-02 · Özel müfredat değişiklikleri

- Özel ders/konu ekleme, düzenleme ve silme ayrı katalog taslağında hazırlanır. Başarılı kalıcı yazımdan önce etkin katalog değişmez. Konu silme ile ilgili ilerleme anahtarının temizliği tek işlemdir; son diğer konu notları üzerine eski snapshot yazılmaz.
- Kaynak geçmişi veya hata/tekrar kaydı bağlı dersi/konuyu silmek engellenir; ilgili geçmiş kendiliğinden kaldırılmaz. Form hata metni gösterir, kalıcı kayıt bekler ve eski profil formu yeni profile yazmaz. Controller ömrü çıkış animasyonunu kapsar.
- 2 yeni depo kabulü geçti: başarısız ekle/düzenle eski tanım/notu korur, bağlı kaynak dersi silinmez; silmede ikinci grup hatası hem müfredatı hem ilerlemeyi geri alır, sonraki başarılı silme yeniden yüklenir.
- Açık kalan bu veri dilimi: eski günlük şablon tamamla/soru, rozet ve flashcard kalıcı başarı sırası. Son ortak test sayısı önceki 49'a ek 2 = 51; tam çalışma yeniden yapılacak.


## SOL-02 · Eski günlük kayıt işlemleri

Eski şablonda gün tamamlama, soru sayımı ve bağlı tekrar olayı artık son kalıcı veri üzerinde tek işlemde yazılır; başarısızlıkta ekrandaki gün/soru/tekrar sayısı değişmez. Kimlikli tamamla → geri al → tamamla kabulü yeni async sonuçla yeniden geçti. Günlük ve soru gruplarından birinin yazımı başarısızken diğerinin de geri alınması ve yeniden yükleme testi geçti. İlgili sayaçlar yazım sırasında kilitli. Kalan bu dilim: rozet ve flashcard sonuç sırası.


## 17 Ekim · SOL-02 kart ve rozet sonucu

- Kart değerlendirmesi ve sıfırlaması ayrı bekleyen taslakla yazılır. Yazılamazsa kart, bilinen sayısı ve tekrar geçmişi değişmez; “Yeniden kaydet” aynı taslağı yazar. Başarıdan sonra sonraki karta geçilir. Profil değişiminde eski bekleyen sonuç yeni profile uygulanmaz.
- Rozetler ayrı aday listesinde hesaplanır, son kalıcı rozetlerle birleştirilir; yazılamayan rozet açılmış görünmez ve başarı başlığı yayımlanmaz. Kaynak günü, yeni serbest deneme ve zayıf konu başarısı da rozet hesabını tetikler. Eski 13 takvim rozetinin adı, sınırsız yeni denemeler bitmiş gibi anlaşılmayacak şekilde açıklandı.
- Gerçek kart ekranında ikinci grup yazımı hatası → kart değişmedi → aynı değerlendirmeyi yeniden yaz → sonraki kart kabulü geçti. Rozet disk hatası → temel konu kaydı korunur fakat rozet kapalı → kalıcı retry → yeniden açılış kabulü geçti.
- Odaklı 22 test geçti (21 depolama + 1 kart ekranı). Tam son çalışma/derlemeler ayrıca yapılacak. AUD-12 eski görünen ad net kimlikleri sonraki kaynak işi.


## 17 Ekim · AUD-12 eski net adlarının ders kimliğine geçişi

- Profil şeması 12. Eski takvim sonuçları da `subject:<storageId>` ile saklanır; gösterim adı değişmez kimliğin yerine kullanılmaz. Kişisel ders alanı, karşılaştırma, resmî toplam ve yedek doğrulaması aynı kimliği kullanır. Gösterilen etiketler okunur ders adıdır.
- Yeni özel derste Türkçe/ASCII, boşluk, harf ve oturum öneki varyasyonları resmî adla çakışıyorsa ekleme reddedilir.
- Eski belirsiz özel/resmî ad değerleri `legacy-unmapped:<eski anahtar>` altında korunur, resmî/kişisel toplamlara katılmaz. Eski takvim ekranı eşleştirilemeyen netleri açıkça listeler. Kullanıcı doğru sonucu biliyorsa ilgili kimlikli alana yeniden girebilir; ham eski değer yedekte kalır. Hangi derse ait olduğu bilinmeyen eski değer tahminle dağıtılmaz.
- Açılışta son kalıcı deneme haritası kuyruk içinde dönüştürülür; hata işaretlenir ve eski ham değer kaybolmaz. Backup/import da aynı adaptörü kullanır. Deneme geçmişi bağlı kişisel dersin silinmesi engellenir.
- Alias/çelişki sınırları, eşzamanlı iki deneme, eski düz yedek, gerçek etiket semantiği ve belirsiz özel ders → ID ile yeni net → export/import kabulü geçti. **Toplam 55 test geçti; analiz temiz.**


## 17 Ekim · Alan kaynakları ve kopuk eski hata kayıtları

- Kişisel kaynak ve hata kaydına AYT EA/SÖZ dersleri ve beş YDT dili için sabit ders kimlikleri eklendi. Bu bağlar tam hazır konu/kazanım listesi sunduğu iddiası taşımaz. EA/SÖZ/DİL profilinde konu rehberinin TYT + AYT Sayısal ile sınırlı olduğu açıkça yazılır; öğrenci kendi kaynak/görev/manuel konusunu kullanabilir.
- Puan türünü seçmiş profilde boş başlangıç da kaynak planına yönelir ve ilk kaynak ekleme çağrısı gösterir. Eski hazır şablon arşiv bağlantısında korunur.
- Yeni kabulde ilk kez kaynak dersleri için yedek referans denetiminin eksik olduğu bulundu/düzeltildi; EA/SÖZ/YDT kaynak + manuel hata → export/import → yeniden yükle geçti.
- Ek veri kaybı önlendi: eski hata kaydının ders/konu bağlantısı bulunamayınca kayıt silinmiyor. Not, tekrar geçmişi ve özgün kopuk kimlikler korunuyor; etkin olmayan bağ ayrılıyor ve ekranda açıklanıyor. Export/import kabulü geçti.
- Güncel profil şeması 13. Tam hazır EA/SÖZ/YDT kazanım envanteri ve akademik editoryal doğrulama ayrı açık kapsamdır. Kaynak bağlarıyla tamamlanmış müfredat iddiası yapılmıyor.


## 17 Ekim · Sınav yılı ve içerik sürümü (AUD-15)
- Profilde isteğe bağlı sınav yılı, kişisel hedef tarihinden ayrı tutuluyor. Eski profillerin yılı bilinmiyor olarak kalır; hedeften tahmin edilmez.
- Sabit içerik sürümü `yks-reference-2026-v1`, şema 14. Yıl değişimi ders/konu kimliklerini, ilerlemeyi ve içerik sürümünü değiştirmez. Bilinmeyen içerik sürümü sessizce açılmaz.
- Kurulum ve profil formlarında yıl seçimi; ayarlarda içerik kapsamı var. Eski “YDT yok” metni düzeltildi: YDT kaynak/deneme takibi var, tam hazır konu rehberi yok.
- Tam paket: 58 test geçti; `flutter analyze --no-pub` temiz. Yıl değişimi + eski metadata + yedek geri yükleme testi dahil.
- Açık: 2027 resmi kapsamının ve bütün akademik içeriğin editoryal doğrulaması; EA/SÖZ/YDT tam hazır konu rehberi. Yıl seçimi güncellik garantisi değildir.


## 17 Ekim · Profil formu kayıt kaybı
- Yeni profil ve profil düzenleme formu artık kalıcı kayıt bitmeden kapanmıyor. Yazma hatasında tüm alanlar korunuyor, aynı formdan tekrar deneniyor. Kaydetme sırasında düzenleme/geri çıkış engelleniyor; dışarıdan profil değiştiyse yanlış profile yazılmıyor.
- Yeni profil listesi + başlangıç programı + aktif profil seçimi aynı depolama işlemi. Aktifleştirme öncesi yarım profil bırakıp yeniden denemede kopya üretme yolu kaldırıldı.
- Denetim: depolama hatasında oluşturma/etkinleştirme birlikte geri alınıyor, tekrar deneyince tek profil oluşuyor; widget testi başarısız profil düzenleme taslağının korunmasını ve başarı sonrası kapanmasını doğruluyor.
