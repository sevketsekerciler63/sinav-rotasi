# Sınav Rotası — Luna ve Sol iş bölümü

Tarih: 16 Ekim 2026.
Karar: Kullanıcı Luna'nın uygulama işlerini, Sol'un kritik işleri ve sonraki incelemeyi ayrı listelerde takip etmek istiyor.
Güncel durum (17 Ekim): LUNA-01–06 kaynak işleri uygulandı ve Sol tarafından incelendi; kaynak/görev/plan, serbest deneme ve ortak hareket akışları çalışır modellerle bağlı. 60 otomatik kontrol geçti, analiz temiz. Fiziksel cihaz ve yayın kabulü açık. Bu not model değiştirmez ve arka planda ajan başlatmaz.

Güncel bulgular ve devam kaydı: [Sol incelemesi](sol-review-and-progress-2026-10-16.md).

## 1. Devralırken kısa bağlam

- Depo: bu deponun kök klasörü
- Ürün: öğrencinin kendi kitap/test/video/denemeleriyle çalışmasını yöneten, YKS ilk uygulama olmak üzere çok sınava genişleyecek kişisel çalışma sistemi.
- Kendi soru bankamızı ve yıllık özgün deneme üretimini yapmıyoruz. Yapay zekâ soru üretimi ilk sürümün dayanağı değil.
- Görsel yön: mevcut Rota Atlası; mürekkep yeşili, sıcak kâğıt, mint rota ve amber işaretler. Ana ekran öğrencinin sıradaki işini öne çıkarmalı.
- İlk devir noktası `9878621`; Luna `8b7c4ff` iş bölümü notundan başladı; mevcut kullanıcı değişikliği korunuyor. LUNA-01 teslimi `475721c`, LUNA-02 teslimi `2cc8c7e`, LUNA-03 teslimi `5a2eea4`, LUNA-04 teslimi `9c799d4`; depoda bunun dışındaki kullanıcı değişikliklerini koru, yalnız commit'e güvenip çalışma ağacını sıfırlama.
- Güncel şema 14. Kaynak/görev/aralık ilerlemesi, kapasite planı ve sabit günlük beklenti, sınırsız TYT/AYT/YDT deneme, profil yılı/içerik sürümü, kalıcı kayda bağlı geri bildirim, tekrar olay geçmişi ve kurtarma arşivi uygulandı. 60 otomatik kontrol geçti; fiziksel cihaz kurtarma kabulü açık.
- Gerçek kullanıcı verisi silinmez. Kontrollü örnekler gerçek öğrenci geçmişi gibi sunulmaz. Eksik altyapı için çalışanmış gibi düğme veya gösterge yapılmaz.

Önce bu notu ve docs/storage-backup-progress-2026-10-16.md dosyasını oku. Sonra yalnız seçilen görevin ilgili koduna ve gereken araştırma bölümüne git. Uzun sohbeti veya tüm raporları her küçük işte tekrar taramak gerekmez. Kullanıcının sonraki düzeltmeleri bu nottan önceliklidir.

## 2. İşleyiş ve sıra

1. Luna önce LUNA-01 → LUNA-02 → LUNA-03 → LUNA-04 işlerini sırayla yapabilir.
2. Her biri ayrı, incelenebilir değişiklik ve teslim kaydı olmalı. Hata/depolama/plan motoruna dokunma ihtiyacı çıkarsa ilgili kısmı SOL listesine bağlantısıyla yaz; bağımsız kalan Luna işine devam et.
3. Kullanıcı Sol'a geçtiğinde Sol önce kendi önceki veri değişikliklerini, ardından Luna teslimlerini inceler. Kendi kodu da aynı kabul ölçütlerine tabidir.
4. Sol veri/kurtarma, plan ve modelleri tamamlar. Luna'nın yeni modele bağlı arayüz işleri ancak gerçek API/model hazır olunca başlar.
5. Sol incelemesi sonrası düzeltme varsa küçük ve açık iş olarak Luna'ya veya Sol'a atanır. Bir iş yalnız “kod yazıldı” diye onaylanmış sayılmaz.

Ortak dosyalarda aynı anda iki model çalışmayacak; model değişimiyle sırayla ilerlenir. Her paketi çok ajana dağıtmak bu planın şartı değildir. Kullanıcı ayrıca istemedikçe ayrı görev/ajan başlatılmaz.

## 3. Luna 6 — şimdi yapılabilecek işler

### LUNA-01 · Türkçe metinler ve ekran durumları

- [x] Durum: ilk teslim `475721c`; Sol kaynak/widget incelemesi ve düzeltmesi `02e6a76`. Fiziksel cihaz kabulü açık.
- Kapsam: ekran/widget metinlerindeki Zamanlayici, Ilerleme, Yapilacak, gun gibi kalıntıları düzelt; noktalama, düğme fiilleri ve başlık dilini tutarlı yap.
- Alanlar: lib/screens, lib/widgets. Verilerin kimlikleri, JSON anahtarları, eski takma adlar ve model enum değerleri kullanıcıya görünen metin diye değiştirilmez.
- Sınır: “kaydedildi”, “bulutta”, “kişiselleştirildi” gibi ifadeler yalnız gerçek davranış karşılıyorsa kullanılır. Netler resmî puan/sıralama gibi sunulmaz.
- Kabul: Türkçe ekran metinleri tutarlı; mevcut kayıt/hata akışlarının anlamı korunmuş; hangi metinlerin düzeltildiği teslimde listeli.
- Sol incelemesi: veri anahtarlarına dokunulmuş mu, başarısız işlem yanlış başarı gösteriyor mu, ürün kapsamı yanlış anlatılıyor mu?

#### LUNA-01 teslimi · 16 Ekim 2026

- Başlangıç commit'i: `8b7c4ff`; teslim commit'i: `475721c`.
- Değişen dosyalar: `lib/screens/weak_topics_screen.dart`, `pomodoro_screen.dart`, `daily_plan_screen.dart`, `subjects_screen.dart`, `flashcard_screen.dart`, `mock_exam_screen.dart`.
- Zayıf konu boş/list/form metinleri, Pomodoro başlığı, günlük plan deneme etiketi, konu gün bilgisi, bilgi kartlarındaki Türkçe karakterler ve deneme kayıt düğmesinin cümle biçimi düzeltildi.
- Kayıt kimlikleri, JSON, model enumları ve işlem akışları değiştirilmedi.
- Kontrol: `dart format` (6 dosyadan 1'ini biçimlendirdi), `git diff --check` temiz, `flutter analyze --no-pub` temiz.
- Yapılmayan kontrol: otomatik test, ekran okuyucu, cihaz ve büyük yazı görünümü çalıştırılmadı.
- Sol özellikle yazı düzeltmelerinin anlamı değiştirmediğini ve kullanıcıya görünen bütün eski transliterasyonların temizlendiğini gözden geçirsin. Bilgi kartı içeriğinin bilimsel doğruluğu AUD-09/SOL-05 kapsamındadır; bu teslim içerik denetimi sayılmaz.
- Sonraki bağımsız iş: LUNA-02.

### LUNA-02 · Alan etiketleri ve erişilebilirlik

- [x] Durum: ilk teslim `2cc8c7e`; Sol kaynak/widget incelemesi ve düzeltmesi `02e6a76`. Fiziksel cihaz kabulü açık.
- Kapsam: özellikle deneme net alanlarına ders+oturum içeren etiketler (ör. TYT Matematik neti); ikon düğmelerine açıklamalar; odak sırası ve dokunma alanları.
- Alanlar: mock_exam_screen.dart ve ilgili ekran/widget sunumları.
- Sınır: async updateMockExam sözleşmesi, Kaydediliyor koruması, taslak girişleri ve hata bildirimleri korunur. Net doğrulama kuralları ve hesaplar değiştirilmez.
- Kabul: etiketler alanı tek başına tanımlar; klavye/ekran okuyucu yolu açıklanır; büyük yazıda temel eylemler okunur ve erişilebilir; kontrol edilmeyen cihaz koşulları açık yazılır.
- Sol incelemesi: aynı alanın yinelenen semantiği, yanlış ders etiketi, odak kaybı, kayıtta tekrar basış ve ekran daralması.

#### LUNA-02 teslimi · 16 Ekim 2026

- Başlangıç commit'i: `8a97f6d`; teslim commit'i: `2cc8c7e`.
- Değişen dosya: `lib/screens/mock_exam_screen.dart`.
- Net kaydırıcılarının erişilebilir değer metni tam oturum ve ders adını içeriyor (ör. “TYT Matematik neti”); sayısal giriş alanı da aynı tam etiketi taşıyor. Kaydetme sürerken aynı denemenin slider ve alanı düzenlenemiyor; giriş taslağı ve kayıt hata bildirimi davranışı korunuyor.
- Mevcut trend grafiği zaten ekran okuyucu için tarih/değer özeti taşıyordu; deneme tarihi seçiminde görünür metinli düğme bulunduğu için değiştirilmedi.
- Kontrol: `dart format` değişiklik üretmedi; `git diff --check` temiz; `flutter analyze --no-pub` temiz.
- Yapılmayan kontrol: ekran okuyucu, klavye, büyük yazı, dar ekran ve fiziksel cihaz denemesi yapılmadı.
- Sol özellikle TextField semantiğinin tam etiketi gereksiz tekrar edip etmediğini; focus/klavye akışını; save sırasında taslağın ve retry durumunun korunmasını incelesin.
- Sonraki bağımsız iş: LUNA-03.

### LUNA-03 · Ortak görsel bileşenler

- [x] Durum: ilk teslim `5a2eea4`; Sol kaynak/widget incelemesi ve düzeltmesi `02e6a76`. Fiziksel cihaz kabulü açık.
- Kapsam: benzer bölüm başlığı, boş durum, kısa bilgi satırı ve birincil/ikincil eylem bileşenlerini küçük parçalar halinde ortaklaştır.
- Alanlar: lib/widgets ve lib/theme/app_theme.dart; yalnız bunları kullanan ekran sunumları.
- Sınır: mevcut renk/typografi kimliği korunur. Kapsamlı dosya yeniden yazımı, yeni tasarım paketi, gereksiz bağımlılık veya sayfa başına farklı stil eklenmez. Kart sayısı ihtiyaç olan yerlerde azaltılır.
- Kabul: açık/koyu tema, uzun Türkçe metin, dar ekran ve büyük yazı dikkate alınmış; bileşenler gerçek en az iki yerde kullanılmış; düğme anlamları aynı.
- Sol incelemesi: tema renkleri yerine sabit renk kaçakları, taşma, okunabilirlik, anlamsız soyutlama ve callback davranışının değişmesi.

#### LUNA-03 teslimi · 16 Ekim 2026

- Başlangıç commit'i: `08ecd83`; teslim commit'i: `5a2eea4`.
- Yeni ortak sunum parçaları: `lib/widgets/app_primitives.dart` içindeki `AppSectionHeader`, `AppEmptyState`, `AppInfoBanner`.
- Gerçek kullanımlar: bölüm başlığı dashboard ve deneme ekranlarında; boş durum Zayıf Konular ve Deneme Takvimi ekranlarında; açıklama bandı günlük plan, deneme takibi ve takvim ekranlarında.
- Açık/koyu renkler `ColorScheme`'den, başlık/gövde yazıları mevcut tema tipografisinden alınıyor. Birincil/ikincil düğme stilleri zaten `app_theme.dart` içinde ortak olduğundan yeni sarmalayıcı eklenmedi.
- Kontrol: `dart format` yeni widget dosyasını biçimlendirdi; `git diff --check` temiz; `flutter analyze --no-pub` temiz.
- Yapılmayan kontrol: ekran görüntüsü, dar cihaz, büyük yazı ve görsel koyu/açık tema kabulü yapılmadı. Deneme Takvimi boş durumu mevcut sabit deneme kataloğuyla her profilde erişilebilir olmayabilir; veri boşsa ortak bileşen orada kullanılır.
- Sol uzun Türkçe metinlerde taşmayı, koyu/açık tema karşıtlığını, küçük ekran yerleşimini ve yeni bileşenlerin gereksiz soyutlama olup olmadığını kontrol etsin.
- Sonraki bağımsız iş: LUNA-04.

### LUNA-04 · Ana ekranın bilgi sırası

- [x] Durum: ilk teslim `9c799d4`; Sol kaynak/widget incelemesi ve düzeltmesi `02e6a76`. Fiziksel cihaz kabulü açık.
- Kapsam: mevcut bugünkü görev/plan kartını üst sıraya taşı; motivasyon sözünü ve büyük hedef/sayaç yoğunluğunu aşağı al; geçmiş hedef uyarısını kısa ama erişilebilir tut.
- Alanlar: dashboard_screen.dart ve gerekirse LUNA-03 bileşenleri.
- Sınır: mevcut plan verisi kullanılır. Gerçek kaynak/sayfa/test/süre altyapısı hazır değilse bu bilgiler uydurulmaz; “30 dakikaya uygun” gibi doğrulanmayan kapasite iddiası gösterilmez. Görev yoksa dürüst boş durum ve mevcut plan sayfasına yol gösterilir.
- Kabul: öğrenci ilk görünümde sıradaki işi veya neden iş olmadığını anlayabiliyor; mevcut başlat/plan düğmesi çalışır akışa bağlı; hedef tarihi düzenleme yolu korunmuş; 0 ilerleme, geçmiş hedef ve boş gün durumları ele alınmış.
- Sol incelemesi: doğru profil/gün gösterimi, geçmiş hedef davranışı, yanlış plan önerisi, kaybolan araçlar ve taslak/veri değişikliği.

#### LUNA-04 teslimi · 16 Ekim 2026

- Başlangıç commit'i: `49679f2`; teslim commit'i: `9c799d4`.
- Değişen dosya: `lib/screens/dashboard_screen.dart`.
- İlk görünümde sıra: başlık → gerekiyorsa geçmiş hedef uyarısı → bugünkü plan/görev → bildirim/başarı → gelecekteki hedef sayacı → istatistikler → motivasyon kartı.
- Geçmiş hedefte büyük sayaç gizlendi; kısa uyarı ve Ayarlar içindeki hedef tarihi düzenleme yolu kaldı. Bugün kaydı yoksa görev uydurulmadan Günlük Plan bağlantısı gösteriliyor. Günlük kaydı varsa mevcut sıradaki görev başlatılıyor; eşleşen görev yok ve gün tamamlanmamışsa Pomodoro başlatılmıyor, Günlük Plan açılıyor. Tamamlanmış günde serbest odak seçeneği ve dinlenme gününde kapalı eylem korunuyor.
- Kontrol: `dart format` uygulandı; `git diff --check` temiz; `flutter analyze --no-pub` temiz; `flutter build web --release --no-pub` başarılı.
- Yapılmayan kontrol: görsel ekran görüntüsü, gerçek profilde 0 ilerleme/boş gün/geçmiş hedef akışı, dar cihaz, büyük yazı ve açık/koyu tema cihaz kabulü çalıştırılmadı.
- Sol, `todayLog` null ve boş görev dallarını, hedef düzenleme bağlantısını, geçmiş hedefte sayaç/başlık tutarlılığını ve kalan alt araçlara erişimi incelesin. Özellikle dashboard ilk ekranının gerçek web/telefon görünümünü kontrol etsin.
- Sonraki uygulama işi: LUNA-05 için SOL-04/05 API'leri bekleniyor; bu arada kullanıcı Sol'a geçerse SOL-01 ve LUNA-01–04 incelemesini yapabilir.

## 4. Luna 6 — Sol altyapısından sonra yapılacaklar

### LUNA-05 · Kişisel kaynak ve serbest deneme ekranları

- [x] Durum: Sol kaynak/görev/ilerleme, kapasite planı ve sınırsız TYT/AYT/YDT deneme ekranlarını gerçek kalıcı API ile tamamladı; otomatik kabul geçti.
- Kapsam: Sol'un hazırladığı kalıcı model/API ile kişisel kaynak listesi/ayrıntısı, kısa deneme listesi ve ayrı sonuç formu.
- Kabul: kaynak ekleme/düzenleme, sayfa-test-soru birimi, kısmi ilerleme, deneme oturumuna uygun alanlar ve gerçek boş/hata durumları. AYT kaydında gereksiz TYT alanı yok.
- Sınır: geçici ekran listesiyle çalışanmış gibi kalıcılık sunma; model/veri şeması/net hesaplama/yedek geçişi yazma. Sabit 13 şablonu yeni serbest kayıt altyapısı sanma.
- Sol incelemesi: API uyumu, kayıt sonucu/taslak/yeniden deneme, profil izolasyonu, silme-düzenleme ve yedeğe girme davranışı.

### LUNA-06 · Ortak hareket tasarımını uygulama

- [x] Durum: ortak hareket sözleşmesi, azaltılmış hareket, rota geçişleri ve sayaç durumunun korunması uygulandı; otomatik kabul geçti. Fiziksel cihaz hareket/performance kabulü açık.
- Kapsam: basış, görev durumu, ayrıntı sayfası ve ölçülü ilerleme geçişleri; mevcut animasyonları ortaklaştırma.
- Kabul: sistemin hareketi azalt tercihi tüm ilgili alanlarda çalışır; ekran değişimi veri/timer durumunu sıfırlamaz; kalıcı sonuçtan önce başarı animasyonu yok; her rebuild'de liste yeniden uçuşmaz.
- Sınır: sürekli dikkat isteyen animasyon, zorunlu ses/titreşim, ağır paket veya işlevi bekleten görsel süre ekleme.
- Sol incelemesi: azaltılmış hareket, timer yaşam döngüsü, kaydetme başarısı, rebuild davranışı ve performans.

## 5. Sol — kendi uygulama işleri ve incelemeler

### SOL-01 · İlk veri diliminin ve Luna paketlerinin incelemesi

- [ ] Durum: Kaynak incelemesi ve otomatik regresyon tamamlandı. Fiziksel cihaz ve gerçek eski yedek kabulü açık.
- 9878621 içindeki net kanonikleştirme, işlem kuyruğu, async kayıt, hataların saklanması ve recovery_records sözleşmesini yeniden incele.
- Luna'nın her teslimini Git farkı ve gerçek davranış açısından kontrol et; gereksiz geniş değişiklikleri ayır.
- Sonuçları “onay / düzeltme gerekli / kontrol edilemedi” olarak, görev kimliği ve somut gerekçeyle yaz.
- Planlanan doğrulama: hata enjeksiyonu, eşzamanlı iki oturum, idempotent yeniden deneme, profil geçişi, yanlış net ve çok profilli yedek turu. Test/cihaz çalışmasının yapılmadığı durumda yapılmış gibi işaretleme.
- Bu görev, kullanıcının Sol sırası geldiğinde doğruluk incelemesi yapılması talebidir; bu belge hazırlanırken kontroller çalıştırılmadı.

### SOL-02 · Kayıt ve kurtarmanın kalanları

- [ ] Durum: Kalıcı kayda bağlı ekranlar, atomik profil oluşturma, ham kurtarma arşivi ve bozuk kayıt koruması uygulandı. Seçmeli arşiv onarımı, büyük veri performansı ve gerçek cihaz kabulü açık.
- Diğer iyimser ekran eylemlerinin kalıcı sonuç/taslak/yeniden deneme sözleşmesi; yarım işlem, profil değişimi ve kapatıp açma.
- Schema 1–6 → 7 geçişi, iyi ve bozuk grupların kayıpsız export/importu, yanlış profile bağlı veriler, eski iyi kopya ve başlangıç kurtarması.
- Profil metadatası bozulduğunda acil dışa aktarma imkânını değerlendir; mevcut export'un initialize sınırını belgeleyip gider.
- İşlem destekli depo için aşamalı strateji; gereksiz toplu taşıma ve eski kayıt kaybı yok.
- Kabul: başarısız iş başarı görünmez; ilgili olmayan kayıt hatayı silmez; ham arşiv yeniden etkinleşmez; sağlam kayıtlar ve geçmiş korunur.

### SOL-03 · Plan motoru, geçmiş ve tekrar

- [ ] Durum: Kaynak kapasitesi, tarihsel gün beklentisi, geri alma/yeniden yapma ve tekrar olay geçmişi uygulandı. Eski statik şablon arşiv yolunda; geçmişte hiç saklanmamış beklenti uydurulmaz.
- AUD-06/07/08: gerçek dakika kapasitesi; bölünebilir atomik görevler; taşan işi açıklama; tarihsel plan beklentisi; tekrar olay kimliği ve geri alma anlamı.
- Seviye ve uygun gün tercihlerinin gerçek etkisi; hedef değişiminde geçmişin yeniden yazılmaması.
- Kabul: 30 dakikalık gün 95 görevi uygulanabilir diye sunmaz; yeni başlayanla dört gün kaçıran aday ayrılır; tamamla–geri al–tamamla tekrar sayısını yapay artırmaz.

### SOL-04 · Kişisel kaynak ve çalışma modelleri

- [ ] Durum: Model, ekran, plan ve rapor bağları uygulandı; AUD-12 ders kimliği/ambiguous eski ad koruması tamamlandı. Cihaz kabulü açık. API: [resource-api-v1.md](resource-api-v1.md).
- PROD-02/03: kaynak kimliği, sınav/ders/konu, birim, toplam/ilerleme; kaynak → görev → çalışma kaydı; kısmi ilerleme ve geri alma.
- AUD-12: özel derslerin görünen adları/takma adları resmî ders kimliğiyle karışmaz; resmî toplamlar korunur.
- Depolama, şema geçişi, yedek ve profil izolasyonu dahil hazırlanır.
- Kabul: gerçek kaydı ve yedeği olmayan taslak model tamamlandı sayılmaz. Luna için API, örnek çağrı, hata ve boş durum sözleşmesi kısa yazılır.

### SOL-05 · Serbest deneme ve çok sınav altyapısı

- [ ] Durum: Sınırsız TYT/AYT/YDT ve alan/dil ayrımlı karşılaştırma, sınav yılı + içerik sürümü uygulandı. 2027 kapsam doğrulaması, tam EA/SÖZ/YDT hazır konu rehberi ve sonraki sınav adaptörleri açık.
- PROD-04/05 ve AUD-10/11/15: şablon/planlanan deneme/gerçek giriş ayrımı; serbest yeni deneme; oturum ve ders kimlikleri; sınava göre net kuralları.
- YKS'nin desteklenen puan türleri ile katalog kapsamını dürüst göster; KPSS ve sonraki sınavlar için çekirdeği ayır, eksik içerik varmış gibi sunma.
- Sınav yılı/müfredat/kaynak sürümü; resmî süre ve tarihlerin tek yapılandırması. Mevcut bilgi/formül/flashcard doğruluk açıklarının kaynakla düzeltilmesi (AUD-09).
- Kabul: mevcut sonuçlar/tarihler/profiller korunur; 14. ve sonraki deneme kaydı gerçek kalıcı veri olur; farklı sınavın hesabı YKS sabitlerine dayanmaz.
- Luna'ya ekran işi açmadan API ve veri örnekleri teslim edilir.

### SOL-06 · Tasarım ve hareket sözleşmesi, bütünleşme incelemesi

- [ ] Durum: Hareket sözleşmesi ve bütünleşme düzeltmeleri uygulandı; otomatik kabul geçti. Gerçek öğrenci görüşmeleri, cihaz erişilebilirliği ve performansı açık.
- LUNA-01/04 çıktılarının ürün hedefiyle uyumu; gezinme, boş/hata/bekleme durumları ve kişisel kaynak akışı.
- LUNA-06 için süre/eğri/azaltılmış hareket kararlarını, timer/rota durumunun korunmasını ve başarı geri bildiriminin kayıt sonucuna bağını tanımla.
- Sonraki Luna ekranlarını gerçek modellerle bütünleştir; hesaplamaların ekranda kopyalanmasını önle.
- Öğrenci görüşmesi sonuçlarını hipotezlerden ayır; yapılmayan kullanıcı araştırmasını tamamlandı sayma.

### SOL-07 · Cihaz yedeği, isteğe bağlı bulut ve yayın kabulü

- [ ] Durum: Android cihaz tercihleri ayrıldı, OS yedek kapsamı ve CI yapılandırıldı. Gerçek cihaz, OAuth, iOS, imzalı yayın ve uzak CI kabulü açık.
- Android Auto Backup/transfer kapsamı; uygun veriyi dahil etme, cihaz bilgilerini ayırma; kontrollü kaldırma/yeniden kurma ve farklı cihazdan kurtarma.
- Dosya sağlayıcıları ve gerçek yükleme; isteğe bağlı doğrudan Drive için OAuth/kota/iyi sürüm geçmişi/boş kurulumun dolu yedeği ezmemesi.
- iOS davranışı, çevrimdışı kuyruk, hesap değişimi, erişim iptali ve depolama sınırı.
- Kabul: dosya dışa aktarımı, uzak kopya doğrulaması ve çok cihaz eşitlemesi ayrı durumlar. Kendi sunucumuz işletilmez; sınırsız/daima ücretsiz garanti verilmez. Gerekli dış erişim yoksa somut engel ve sonra yapılacak adım not edilir.
- Kritik senaryolar için sürdürülebilir regresyon/CI ve yayın kabulü de Sol sorumluluğunda.

## 6. Luna teslim şablonu

Her işin altında veya bu nota bağlı kısa teslim notunda:

- Görev kimliği:
- Durum: uygulandı, Sol incelemesi bekliyor / engel var / ertelendi.
- Başlangıç ve teslim commit'i:
- Değişen dosyalar:
- Ne değişti ve neden:
- Korunan veri/API sözleşmesi:
- Yapılan kontrol ve gerçek sonucu:
- Yapılmayan kontrol/cihaz koşulları:
- Ekran işi ise gerçek görünüm kanıtı veya incelenemeyen koşul:
- Sol'un özellikle bakması gereken yer:
- Sonraki bağımlılık:

Yalnız değişen dosyaları ve sonucu özetle; bütün sohbeti tekrar yazma. Başarısız veya yapılmamış kontrolü “geçti” sayma. İlgisiz kullanıcı değişikliklerini commit'e katma.

## 7. Sol inceleme ve kapanış kaydı

| İş | Uygulama durumu | Sol sonucu | Açık düzeltme/kanıt |
|---|---|---|---|
| LUNA-01 | Uygulandı, Sol düzeltmeleri eklendi | Kaynak/widget kabulü; cihaz açık | `02e6a76`; ayrıntı Sol inceleme kaydında |
| LUNA-02 | Uygulandı, Sol düzeltmeleri eklendi | Kaynak/widget kabulü; cihaz açık | `02e6a76`; ayrıntı Sol inceleme kaydında |
| LUNA-03 | Uygulandı, Sol düzeltmeleri eklendi | Kaynak/widget kabulü; cihaz açık | `02e6a76`; ayrıntı Sol inceleme kaydında |
| LUNA-04 | Uygulandı, Sol düzeltmeleri eklendi | Kaynak/widget kabulü; cihaz açık | `02e6a76`; ayrıntı Sol inceleme kaydında |
| LUNA-05 | Kaynak ve serbest deneme ekranları uygulandı | Otomatik kabul geçti | Cihaz kabulü açık |
| LUNA-06 | Hareket sözleşmesi uygulandı | Otomatik kabul geçti | Cihaz performansı açık |
| SOL-01/02 veri dilimi | Kayıt ve kurtarma düzeltildi | Otomatik regresyon geçti | Gerçek yedek/cihaz kurtarma açık |

Durumlar: başlanmadı → çalışılıyor → uygulandı/inceleme bekliyor → düzeltme gerekli veya kabul edildi. Sonradan gelen inceleme mevcut kabulü geçersiz kılabilir. Bu dosyanın oluşturulması hiçbir uygulama görevini tamamlamaz.



### Güncel kaynak ekranı teslimi
LUNA-05 kaynak yarısı gerçek kalıcı API ile uygulandı; kaynak/görev/kısmi ilerleme/geri alma kabulü geçti. Serbest deneme yarısı ve kapasite/rapor entegrasyonu açık. Ayrıntı: [Sol ilerleme kaydı](sol-review-and-progress-2026-10-16.md).


### SOL devamı: LUNA-05 iki ekran dilimi
Kaynak/görev/ilerleme ekranı, kapasite ve gün beklentisi, serbest TYT/AYT/YDT deneme defteri uygulandı. Eski takvim kayıtları korunur. Sonraki dilim SOL-06 hareket sözleşmesi / LUNA-06; gerçek cihaz, OAuth ve eski gerçek yedek kabulü ayrıca açık. [Kanıtlar ve sınırlar](sol-review-and-progress-2026-10-16.md).


## 17 Ekim · Sonraki işler ve dış bağımlılıklar
Bu bölüm güncel durumdur; üstteki tarihli teslim kayıtları kendi zamanının kanıtını korur.
1. Akademik içerik: 2027 resmi kapsamını doğrulama, tam EA/SÖZ/YDT konu rehberini hazırlama ve bütün bilgi kartlarını kaynaklarıyla editoryal denetleme. Yıl seçmek bunu otomatik yapmaz.
2. Veri: gerçek eski yedek örnekleriyle kabul, seçmeli ham kurtarma arşivi onarımı, büyük geçmiş için ölçüm ve depolama mimarisi. Mevcut JSON işlem günlüğü gerçek veritabanı garantisi olarak sunulmaz.
3. Android: bağlı cihaz/emülatör yok (`adb devices` boş). Silme/yeniden kurma, telefon değiştirme ve dosya sağlayıcısı iptal/çevrimdışı kabulü yapılamadı.
4. iOS: Windows ortamında Xcode/cihaz yok; cihaz tercihlerini OS yedeğinden ayırma ve gerçek geri yükleme açık.
5. Drive: OAuth istemcisi, paket/imza yapılandırması ve test hesabı yok. Çalışıyormuş gibi bulut eşitleme gösterilmiyor.
6. Yayın: imza anahtarı, mağaza hesabı, gerçek cihaz kabulü ve uzak CI çalıştırması yok. Debug APK yayın sürümü değildir.
7. Kullanıcı araştırması: gerçek öğrenci görüşmesi yapılmadı. Fiziksel ekran okuyucu, geri kaydırma hareketleri ve düşük cihaz performansı ayrıca kabul ister.
