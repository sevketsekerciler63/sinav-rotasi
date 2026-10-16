# Sınav Rotası — Luna ve Sol iş bölümü

Tarih: 16 Ekim 2026.
Karar: Kullanıcı Luna'nın uygulama işlerini, Sol'un kritik işleri ve sonraki incelemeyi ayrı listelerde takip etmek istiyor.
Durum: LUNA-01 uygulandı ve Sol incelemesi bekliyor; LUNA-02–04 henüz uygulanmadı. Bu not model değiştirmez ve arka planda ajan başlatmaz.

## 1. Devralırken kısa bağlam

- Depo: C:\Users\PC\Desktop\sinav-rotasi
- Ürün: öğrencinin kendi kitap/test/video/denemeleriyle çalışmasını yöneten, YKS ilk uygulama olmak üzere çok sınava genişleyecek kişisel çalışma sistemi.
- Kendi soru bankamızı ve yıllık özgün deneme üretimini yapmıyoruz. Yapay zekâ soru üretimi ilk sürümün dayanağı değil.
- Görsel yön: mevcut Rota Atlası; mürekkep yeşili, sıcak kâğıt, mint rota ve amber işaretler. Ana ekran öğrencinin sıradaki işini öne çıkarmalı.
- İlk devir noktası `9878621`; Luna devrederken çalışma ağacı temizdi ve `8b7c4ff` iş bölümü notunu ekledi. LUNA-01 teslimi `475721c`; depoda bunun dışındaki kullanıcı değişikliklerini koru, yalnız commit'e güvenip çalışma ağacını sıfırlama.
- Kayıt/yedek ilk kaynak düzeltmeleri uygulandı; schema 7, recovery_records ve async updateMockExam mevcut. Statik analiz/web derlemesi başarılı; otomatik regresyon ve cihaz kurtarma kabulü henüz yok.
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

- [x] Durum: uygulandı; Sol incelemesi bekliyor (commit `475721c`).
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

- [ ] Durum: başlanmadı.
- Kapsam: özellikle deneme net alanlarına ders+oturum içeren etiketler (ör. TYT Matematik neti); ikon düğmelerine açıklamalar; odak sırası ve dokunma alanları.
- Alanlar: mock_exam_screen.dart ve ilgili ekran/widget sunumları.
- Sınır: async updateMockExam sözleşmesi, Kaydediliyor koruması, taslak girişleri ve hata bildirimleri korunur. Net doğrulama kuralları ve hesaplar değiştirilmez.
- Kabul: etiketler alanı tek başına tanımlar; klavye/ekran okuyucu yolu açıklanır; büyük yazıda temel eylemler okunur ve erişilebilir; kontrol edilmeyen cihaz koşulları açık yazılır.
- Sol incelemesi: aynı alanın yinelenen semantiği, yanlış ders etiketi, odak kaybı, kayıtta tekrar basış ve ekran daralması.

### LUNA-03 · Ortak görsel bileşenler

- [ ] Durum: başlanmadı.
- Kapsam: benzer bölüm başlığı, boş durum, kısa bilgi satırı ve birincil/ikincil eylem bileşenlerini küçük parçalar halinde ortaklaştır.
- Alanlar: lib/widgets ve lib/theme/app_theme.dart; yalnız bunları kullanan ekran sunumları.
- Sınır: mevcut renk/typografi kimliği korunur. Kapsamlı dosya yeniden yazımı, yeni tasarım paketi, gereksiz bağımlılık veya sayfa başına farklı stil eklenmez. Kart sayısı ihtiyaç olan yerlerde azaltılır.
- Kabul: açık/koyu tema, uzun Türkçe metin, dar ekran ve büyük yazı dikkate alınmış; bileşenler gerçek en az iki yerde kullanılmış; düğme anlamları aynı.
- Sol incelemesi: tema renkleri yerine sabit renk kaçakları, taşma, okunabilirlik, anlamsız soyutlama ve callback davranışının değişmesi.

### LUNA-04 · Ana ekranın bilgi sırası

- [ ] Durum: başlanmadı.
- Kapsam: mevcut bugünkü görev/plan kartını üst sıraya taşı; motivasyon sözünü ve büyük hedef/sayaç yoğunluğunu aşağı al; geçmiş hedef uyarısını kısa ama erişilebilir tut.
- Alanlar: dashboard_screen.dart ve gerekirse LUNA-03 bileşenleri.
- Sınır: mevcut plan verisi kullanılır. Gerçek kaynak/sayfa/test/süre altyapısı hazır değilse bu bilgiler uydurulmaz; “30 dakikaya uygun” gibi doğrulanmayan kapasite iddiası gösterilmez. Görev yoksa dürüst boş durum ve mevcut plan sayfasına yol gösterilir.
- Kabul: öğrenci ilk görünümde sıradaki işi veya neden iş olmadığını anlayabiliyor; mevcut başlat/plan düğmesi çalışır akışa bağlı; hedef tarihi düzenleme yolu korunmuş; 0 ilerleme, geçmiş hedef ve boş gün durumları ele alınmış.
- Sol incelemesi: doğru profil/gün gösterimi, geçmiş hedef davranışı, yanlış plan önerisi, kaybolan araçlar ve taslak/veri değişikliği.

## 4. Luna 6 — Sol altyapısından sonra yapılacaklar

### LUNA-05 · Kişisel kaynak ve serbest deneme ekranları

- [ ] Durum: SOL-04 ve SOL-05 bekleniyor.
- Kapsam: Sol'un hazırladığı kalıcı model/API ile kişisel kaynak listesi/ayrıntısı, kısa deneme listesi ve ayrı sonuç formu.
- Kabul: kaynak ekleme/düzenleme, sayfa-test-soru birimi, kısmi ilerleme, deneme oturumuna uygun alanlar ve gerçek boş/hata durumları. AYT kaydında gereksiz TYT alanı yok.
- Sınır: geçici ekran listesiyle çalışanmış gibi kalıcılık sunma; model/veri şeması/net hesaplama/yedek geçişi yazma. Sabit 13 şablonu yeni serbest kayıt altyapısı sanma.
- Sol incelemesi: API uyumu, kayıt sonucu/taslak/yeniden deneme, profil izolasyonu, silme-düzenleme ve yedeğe girme davranışı.

### LUNA-06 · Ortak hareket tasarımını uygulama

- [ ] Durum: SOL-06 hareket sözleşmesi ve temel akışlar bekleniyor.
- Kapsam: basış, görev durumu, ayrıntı sayfası ve ölçülü ilerleme geçişleri; mevcut animasyonları ortaklaştırma.
- Kabul: sistemin hareketi azalt tercihi tüm ilgili alanlarda çalışır; ekran değişimi veri/timer durumunu sıfırlamaz; kalıcı sonuçtan önce başarı animasyonu yok; her rebuild'de liste yeniden uçuşmaz.
- Sınır: sürekli dikkat isteyen animasyon, zorunlu ses/titreşim, ağır paket veya işlevi bekleten görsel süre ekleme.
- Sol incelemesi: azaltılmış hareket, timer yaşam döngüsü, kaydetme başarısı, rebuild davranışı ve performans.

## 5. Sol — kendi uygulama işleri ve incelemeler

### SOL-01 · İlk veri diliminin ve Luna paketlerinin incelemesi

- [ ] Durum: açık.
- 9878621 içindeki net kanonikleştirme, işlem kuyruğu, async kayıt, hataların saklanması ve recovery_records sözleşmesini yeniden incele.
- Luna'nın her teslimini Git farkı ve gerçek davranış açısından kontrol et; gereksiz geniş değişiklikleri ayır.
- Sonuçları “onay / düzeltme gerekli / kontrol edilemedi” olarak, görev kimliği ve somut gerekçeyle yaz.
- Planlanan doğrulama: hata enjeksiyonu, eşzamanlı iki oturum, idempotent yeniden deneme, profil geçişi, yanlış net ve çok profilli yedek turu. Test/cihaz çalışmasının yapılmadığı durumda yapılmış gibi işaretleme.
- Bu görev, kullanıcının Sol sırası geldiğinde doğruluk incelemesi yapılması talebidir; bu belge hazırlanırken kontroller çalıştırılmadı.

### SOL-02 · Kayıt ve kurtarmanın kalanları

- [ ] Durum: kaynak ilk dilimi var, kabul açık.
- Diğer iyimser ekran eylemlerinin kalıcı sonuç/taslak/yeniden deneme sözleşmesi; yarım işlem, profil değişimi ve kapatıp açma.
- Schema 1–6 → 7 geçişi, iyi ve bozuk grupların kayıpsız export/importu, yanlış profile bağlı veriler, eski iyi kopya ve başlangıç kurtarması.
- Profil metadatası bozulduğunda acil dışa aktarma imkânını değerlendir; mevcut export'un initialize sınırını belgeleyip gider.
- İşlem destekli depo için aşamalı strateji; gereksiz toplu taşıma ve eski kayıt kaybı yok.
- Kabul: başarısız iş başarı görünmez; ilgili olmayan kayıt hatayı silmez; ham arşiv yeniden etkinleşmez; sağlam kayıtlar ve geçmiş korunur.

### SOL-03 · Plan motoru, geçmiş ve tekrar

- [ ] Durum: başlanmadı.
- AUD-06/07/08: gerçek dakika kapasitesi; bölünebilir atomik görevler; taşan işi açıklama; tarihsel plan beklentisi; tekrar olay kimliği ve geri alma anlamı.
- Seviye ve uygun gün tercihlerinin gerçek etkisi; hedef değişiminde geçmişin yeniden yazılmaması.
- Kabul: 30 dakikalık gün 95 görevi uygulanabilir diye sunmaz; yeni başlayanla dört gün kaçıran aday ayrılır; tamamla–geri al–tamamla tekrar sayısını yapay artırmaz.

### SOL-04 · Kişisel kaynak ve çalışma modelleri

- [ ] Durum: başlanmadı.
- PROD-02/03: kaynak kimliği, sınav/ders/konu, birim, toplam/ilerleme; kaynak → görev → çalışma kaydı; kısmi ilerleme ve geri alma.
- AUD-12: özel derslerin görünen adları/takma adları resmî ders kimliğiyle karışmaz; resmî toplamlar korunur.
- Depolama, şema geçişi, yedek ve profil izolasyonu dahil hazırlanır.
- Kabul: gerçek kaydı ve yedeği olmayan taslak model tamamlandı sayılmaz. Luna için API, örnek çağrı, hata ve boş durum sözleşmesi kısa yazılır.

### SOL-05 · Serbest deneme ve çok sınav altyapısı

- [ ] Durum: başlanmadı.
- PROD-04/05 ve AUD-10/11/15: şablon/planlanan deneme/gerçek giriş ayrımı; serbest yeni deneme; oturum ve ders kimlikleri; sınava göre net kuralları.
- YKS'nin desteklenen puan türleri ile katalog kapsamını dürüst göster; KPSS ve sonraki sınavlar için çekirdeği ayır, eksik içerik varmış gibi sunma.
- Sınav yılı/müfredat/kaynak sürümü; resmî süre ve tarihlerin tek yapılandırması. Mevcut bilgi/formül/flashcard doğruluk açıklarının kaynakla düzeltilmesi (AUD-09).
- Kabul: mevcut sonuçlar/tarihler/profiller korunur; 14. ve sonraki deneme kaydı gerçek kalıcı veri olur; farklı sınavın hesabı YKS sabitlerine dayanmaz.
- Luna'ya ekran işi açmadan API ve veri örnekleri teslim edilir.

### SOL-06 · Tasarım ve hareket sözleşmesi, bütünleşme incelemesi

- [ ] Durum: kısmi araştırma var; uygulama sözleşmesi açık.
- LUNA-01/04 çıktılarının ürün hedefiyle uyumu; gezinme, boş/hata/bekleme durumları ve kişisel kaynak akışı.
- LUNA-06 için süre/eğri/azaltılmış hareket kararlarını, timer/rota durumunun korunmasını ve başarı geri bildiriminin kayıt sonucuna bağını tanımla.
- Sonraki Luna ekranlarını gerçek modellerle bütünleştir; hesaplamaların ekranda kopyalanmasını önle.
- Öğrenci görüşmesi sonuçlarını hipotezlerden ayır; yapılmayan kullanıcı araştırmasını tamamlandı sayma.

### SOL-07 · Cihaz yedeği, isteğe bağlı bulut ve yayın kabulü

- [ ] Durum: başlanmadı; cihaz/hesap yapılandırması gerektiren kısımlar ayrıca kayıtlı tutulacak.
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
| LUNA-01 | Uygulandı, Sol incelemesi bekliyor | İncelenmedi | Commit `475721c`; cihaz/ekran okuyucu kabulü açık |
| LUNA-02 | Başlanmadı | İncelenmedi | — |
| LUNA-03 | Başlanmadı | İncelenmedi | — |
| LUNA-04 | Başlanmadı | İncelenmedi | — |
| LUNA-05 | Altyapı bekliyor | İncelenmedi | SOL-04/05 |
| LUNA-06 | Sözleşme bekliyor | İncelenmedi | SOL-06 |
| SOL-01/02 önceki veri dilimi | Kaynak uygulandı | Kabul açık | Otomatik regresyon/cihaz kurtarma |

Durumlar: başlanmadı → çalışılıyor → uygulandı/inceleme bekliyor → düzeltme gerekli veya kabul edildi. Sonradan gelen inceleme mevcut kabulü geçersiz kılabilir. Bu dosyanın oluşturulması hiçbir uygulama görevini tamamlamaz.

