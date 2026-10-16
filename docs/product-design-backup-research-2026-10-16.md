# Sınav Rotası — ürün kapsamı, tasarım, öğrenci ihtiyaçları ve veri kurtarma

Tarih: 16 Ekim 2026.
Durum: araştırma ve uygulanacak işlerin tanımı. Bu belge uygulamanın yeniden tasarlandığı veya bulut yedeklemenin kurulduğu anlamına gelmez.

## 1. Kullanıcının onayladığı kapsam düzeltmesi

Sınav Rotası, YKS, KPSS ve ileride desteklenen sınavlara hazırlanan öğrencinin kendi kaynaklarıyla çalışmasını yöneten kişisel çalışma sistemidir. YKS mevcut ilk uygulamadır; ürünün tamamı değildir.

- İlk sürümde özgün soru bankası veya her yıl yeni deneme üretimi yok.
- Yapay zekânın sınav kalitesinde soru üreteceği varsayımı yok.
- Öğrenci kendi kitap, soru bankası, video serisi ve denemelerini ekler.
- Uygulama kaynakları çalışma görevlerine bağlar; ilerleme, deneme sonuçları, yanlış konuları ve tekrarları takip eder.
- Güncel tutulacak çekirdek: desteklenen sınavın resmî kapsamı, kuralları, süreleri, yayımlanmış takvimi ve sürümlü ders/konu kataloğu. Tarihi bilinmeyen sınava resmî tarih uydurulmaz.
- Gelecekte lisanslı içerik ortaklığı ayrı bir genişleme olabilir; ilk sürümün bağımlılığı değildir.

Önceki konuşmadaki “kendi denemelerimizi sunmalıyız” önerisi bu kararla geri çekildi. Önceki denetimde mevcut bilgi/formül kartları için bulunan doğruluk açıkları devam ediyor; kapsam kararı bunları kendiliğinden kapatmaz.

## 2. İnceleme yöntemi ve sınırı

8795 adresindeki mevcut önizlemenin ana ekran ve deneme ekranı görsel olarak incelendi; lib/theme/app_theme.dart, lib/screens/dashboard_screen.dart, lib/main.dart, kaynak ekranı, profil modeli, yedek servisi ve Android manifesti okundu. Önizleme kaynakla tamamen aynı sürüm olmayabilir; bulguların kod karşılığı ayrıca kontrol edildi.

MyStudyLife, Todait, Focus To-Do ve Forest'ın resmî ürün anlatımları karşılaştırıldı. Bunlar ürünlerin kendi iddialarıdır; bağımsız etki araştırması veya öğrencilerle görüşme yerine geçmez. Öğrenci ihtiyaçları aşağıda ürün hipotezi olarak belirtilmiştir. EEF'nin planlama–izleme–değerlendirme rehberi dayanak olarak kullanıldı; bir rehberden uygulamanın öğrenme başarısı sağladığı sonucu çıkarılmadı.

Bu turda uygulama verisi değiştirilmedi, deneme sonucu kaydedilmedi, hesap bağlanmadı, dosya buluta yüklenmedi. Uygulama kodu değiştirilmedi; test veya yeni derleme çalıştırılmadı.

## 3. Tasarım iyi mi, özgün mü?

**Tasarım değerlendirmesi:** Kullanılabilir bir görsel temel var; henüz tamamlanmış ve ayırt edici bir öğrenci deneyimi değil. Tüm benzer uygulamaları taramadan “benzersiz” denemez.

Korunacaklar:
- Mürekkep yeşili, sıcak kâğıt, mint rota ve amber işaret renkleri.
- Mevcut Inter/Space Grotesk tipografi ve sade yüzeyler.
- “Rota Atlası” fikri; öğrencinin bir sonraki adımını görünür kılmak için kullanılabilir.
- Bilinen gezinme kalıpları; özgünlük uğruna düğmelerin anlamını gizlememek.

Değiştirilecekler:
- Ana ekran sırası şu anda karşılama → motivasyon sözü → büyük hedef kartı → sayaçlar → günlük iş → ders ilerlemeleri → araçlar. Çalışmaya başlama eylemi gereksiz yere aşağıda.
- Geçmiş hedefte “118 gün önce” büyük başlık olurken öğrencinin bugünkü ihtiyacı geri planda. Hedef uyarısı kısa bir düzeltme satırı olmalı; yanlış resmî tarih otomatik atanmaz.
- Çok sayıda benzer yuvarlatılmış kart, renkli sayı ve emoji eşit önem taşıyor. Kart sadece gruplanması veya etkileşimi gereken yerde kullanılmalı; diğer içerik satır, bölüm ve ayırıcıyla düzenlenmeli.
- Emoji ve Material ikonları birlikte değişken bir dil oluşturuyor. İşlevsel ikonlar tek aileden; rota işareti az sayıda özgün çizgi öğesiyle kurulmalı.
- Uzun adlar ve yardımcı metinler dar önizlemede kesiliyor/sıkışıyor. Ekran görüntüsü tam responsive kabulü değildir; küçük telefon, büyük yazı, açık/koyu tema ve ekran okuyucu kabulü gerekiyor.
- Deneme ekranında tüm denemelerin form olarak peş peşe açılması uzun ve yorucu. Liste kısa özetlerden oluşmalı; seçilen denemenin ayrıntısı ayrı açılmalı.
- Net için slider ve alanı sürekli birlikte göstermek yoğunluğu artırıyor. Kesin değer girişine uygun sayısal alan öncelikli; isterse doğru/yanlış/boştan otomatik net hesaplama sunulmalı.
- “Güncellendi” gibi durumlar gerçek kalıcı kayıt sonucuna bağlanmalı. Mevcut AUD-02 çözülmeden animasyonla başarı hissi verilmemeli.

Önerilen ana ekran:
1. Kısa profil/sınav adı, tarih ve küçük yedek durumu.
2. **Bugünün rotası:** sıradaki görev, kaynak ve sayfa/test aralığı, tahmini süre, tek belirgin “Başla”.
3. Bugünkü diğer işler; tamamla, kısmi ilerleme, ertele ve geri al.
4. Yaklaşan tekrar veya öğrencinin kendi denemesi.
5. Haftalık kısa özet ve “Tüm ilerleme”.
6. İkincil araçlar ayrı alanda; motivasyon sözü isteğe bağlı ve aşağıda.

Örnek görev: “Fonksiyonlar · kendi matematik kitabın · Test 4–5 · yaklaşık 30 dk”. Bu yalnız arayüz örneğidir; mevcut kapasite motorunun böyle çalıştığı iddia edilmez.

Gezinme önerisi: Bugün / Plan / Kaynaklar / Denemeler / İlerleme. Ders-konular Kaynaklar altında, sınava göre ayrı sekme olabilir. Bu bilgi mimarisi kullanıcı denemesinde doğrulanmalı; mevcut Dersler sekmesi aceleyle yeniden adlandırılıp içeriği belirsizleştirilmemeli.

Özgünlük, kart köşelerinden çok şu davranışlarla kurulmalı: öğrencinin gerçek kitabını tanıyan görev, kapasitesine uyan gün, aksayan günü cezalandırmadan düzenleme ve net sonucundan açıklanabilir tekrar önerisi. Tam ekran harita veya süslü rota çizimi çalışma listesini gizlememeli.

## 4. Öğrencinin ihtiyaçları — öncelikli ürün hipotezleri

| Öğrencinin sorusu | Gerekli davranış | Mevcut açık |
|---|---|---|
| Bugün nereden başlayayım? | Tek sıradaki görev ve doğrudan odak başlatma | Ana ekran öncelikleri dağınık |
| Elimdeki kitabı nasıl bitireyim? | Kendi kaynağı, toplam/biten sayfa-test-soru, hedef tarih | Kaynaklar şu an öneri/arama listesi; kişisel kaynak takibi yok |
| Bugün az zamanım var | Günlük müsait dakika, okul/iş günleri, kapasite aşımı uyarısı | Dakika hedefi gerçek sınır değil; AUD-06 |
| Görevin yarısını yaptım | Kısmi ilerleme, kaldığı yerden devam | İkili tamamlandı yaklaşımı yetersiz |
| Dün çalışamadım | Önizlemeli yeniden planlama, geçmişin korunması | AUD-07 |
| Denemem neden kötü geldi? | Serbest deneme ekle; kaynak/ad/tarih/oturum, net veya D-Y-B, isteğe bağlı süre | Sabit 13 şablon; AUD-11 |
| Yanlışımı nasıl düzelteyim? | Konu + bilgi/dikkat/süre gibi isteğe bağlı neden; tekrar görevi | Sonuç-plan-tekrar bağlantısı eksik |
| Gerçekten ilerliyor muyum? | Kendi geçmişiyle ders/oturum bazlı karşılaştırma; eksik veri ve gerçek sıfır ayrımı | Güvenilir metrik ve karşılaştırma kapsamı eksik |
| Verim güvende mi? | Dış kopya, görünen son doğrulanmış yedek, kolay geri yükleme | Yerel kayıt ve elle export var; otomatik dış kopya yok |
| İnternetsiz kullanabilir miyim? | Günlük çekirdek akış yerelde; dış kopya beklemede durumu | Yedek kuyruğu/durum modeli yok |

Günlük soru/çalışma kaydı için kısa yol, toplu giriş, düzenleme ve geri alma gerekir. Öğrenciden her soru için ayrıntılı form doldurması beklenmemeli. Yanlış fotoğrafı daha sonra değerlendirilebilir; ilk sürüm için zorunlu değil, yedek hacmini de büyütür.

Onboarding: sınav/oturum, hedef tarihi (resmî mi kişisel mi), uygun günler ve ilk kaynak/görev. Seviye seçimi yalnız davranışı gerçekten etkiliyorsa zorunlu olmalı. Dönem değiştirirken geçmiş dönem korunmalı.

Seri kaybı, suçlayıcı mesaj ve zorunlu rekabet varsayılan motivasyon mekanizması olmamalı. Hatırlatıcılar kullanıcı kontrollü olmalı. Öncelik sosyal akış, sıralama veya yapay zekâ sohbet ekranı değil, bu döngünün güvenilir tamamlanması.

Dayanak: [EEF rehberi](https://educationendowmentfoundation.org.uk/education-evidence/guidance-reports/metacognition). Rehber planlama, izleme ve değerlendirmeyi destekliyor; bu tablo Türkiye'deki öğrencilerin tamamının talebi olduğu anlamına gelmez.

Rakip örnekleri: [MyStudyLife](https://mystudylife.com/tour/) kısmi görev ilerlemesi, takvim ve hatırlatıcıları; [Todait](https://todait.com/) miktar/hedef tarihinden günlük işe bölmeyi; [Focus To-Do](https://www.focustodo.cn/) görev ile odak seansını; [Forest](https://www.forestapp.cc/) odak etrafında tutarlı görsel temayı öne çıkarıyor. Aynı özellikler veya renkler kopyalanmayacak; hangi ihtiyacın nasıl karşılandığı karşılaştırıldı.

Doğrulama planı (henüz yapılmadı): 5–8 farklı adayla ilk nitel tur; YKS SAY/EA/SÖZ/DİL, çalışan KPSS adayı, düşük donanım/büyük yazı ihtiyacı gibi farklı kullanım durumları. Kendi kaynağını ekleme, ilk güne başlama, yarım görev kaydı, deneme girişi, bir günü kaçırma ve yedekten dönme görevleri. Tamamlama, hata, yardım ihtiyacı ve öğrencinin yorumunu kaydet. Bu sayı istatistiksel temsil iddiası değildir.

## 5. Animasyon — mevcut durum ve öneri

Animasyon hiç yok değil: ana ekran girişinde kayma/solma, sayaç geçişleri, bazı düğmelerde basılma ölçeği ve Pomodoro nabız animasyonu mevcut. Düğmelerin bir kısmı azaltılmış hareket tercihini okuyor. Tüm ekranlar için ortak bir hareket sözleşmesi yok; ana ekrandaki bazı giriş/sayaç animasyonları açıkça aynı tercihe bağlanmamış.

Aşağıdakiler tasarım başlangıç değerleridir; evrensel standart süre iddiası değildir:
- Düğme basışı: 100–140 ms, hafif renk/ölçek geri bildirimi.
- Görev tamamlanması: 160–220 ms, tik ve satır durumu; ardından geri al.
- Ayrıntı sayfası: 180–240 ms, yönü belli platforma uygun geçiş.
- Alt sekmeler: kısa solma veya anlık değişim; her geçişte bütün listeyi yeniden sırayla uçurma yok.
- İlerleme: yalnız değer değişince 200–300 ms; her state bildirimiyle sıfırdan sayma yok.
- Kayıt/yedek: gerçek işlem süresince bekliyor, sonra başarı veya yeniden dene. Başarı animasyonu kalıcı sonuçtan önce oynatılmaz.

Azaltılmış hareket açıkken gereksiz kayma, büyüme, nabız ve konfeti kaldırılmalı; anlam metin/ikonla korunmalı. Ses ve titreşim ayrı tercihler olmalı. Pomodoro ekranında sürekli dikkat isteyen hareket varsayılan olmak zorunda değil. Liste yenileme konumu ve zamanlayıcı durumu geçişte korunmalı.

[W3C hareket rehberi](https://www.w3.org/WAI/WCAG21/Understanding/animation-from-interactions) ve [Flutter disableAnimations](https://api.flutter.dev/flutter/widgets/MediaQueryData/disableAnimations.html) bu yönü destekliyor. Bu rapor WCAG uyumluluk sertifikası değildir. Animasyon, bilgi mimarisi ve kayıt güvenilirliğinden sonra uygulanmalı.

## 6. Sunucu işletmeden veri koruma

**Temel sınır:** Telefon kırılırsa, yalnız o telefonun içinde duran hiçbir dosya tek başına kurtarma sağlamaz. Kopya önceden başka bir cihazda, haricî ortamda veya kullanıcının bulut alanında bulunmalı. Kendi sunucumuzu işletmemek mümkündür; Drive/iCloud seçilirse onların sunucuları ve internet kullanılır.

| Seçenek | Uygulama silinmesi | Telefon kaybı/değişimi | Maliyet ve sınır |
|---|---|---|---|
| Uygulama içi yerel kayıt | Tek başına korumaz | Korumaz | Günlük çalışma deposu |
| Uygulama dışına seçilen yerel dosya | Dosya kalırsa elle dönülebilir | Başka kopya yoksa korumaz | Kendi altyapı bedelimiz yok; kullanıcı dosyayı korur |
| Sistem seçicisinden Drive/iCloud/başka sağlayıcıya dosya | Kalıcı dış dosyadan elle dönülebilir | Dosya gerçekten yüklenmiş ve hesap erişilebilir ise | Kendi sunucumuz/API entegrasyonumuz gerekmez; kullanıcının depolama sınırı var |
| Android Auto Backup | Koşullar sağlanırsa yeniden kurulumda dönebilir | Uygun hesap/cihaz geri yüklemesiyle | Ücretsiz 25 MB/uygulama; zamanını biz garanti edemeyiz |
| Doğrudan Drive API yedeği | Aynı hesap ve uygulama kimliğiyle kurtarma tasarlanabilir | Aynı hesapla kurtarma tasarlanabilir | OAuth ve kota yönetimi gerekir; sınırsız/daima ücretsiz sözü yok |
| iCloud uygulama entegrasyonu | Entegrasyon türüne bağlı | Uyumlu Apple cihazlarında | Kullanıcı kotası ve Apple yapılandırması; Android'e tek başına ortak çözüm değil |

### İlk sürüm için önerilen yol

1. Mevcut AUD-01/02/03/04 veri ve export hatalarını düzelt.
2. Mevcut JSON dışa/içe aktarma akışını **yedek merkezi** yap: dosya oluştur, başka yerde saklama açıklaması, yedekten geri yükle.
3. Sistem dosya seçicisi üzerinden kullanıcının mevcut Drive/iCloud sağlayıcısını seçmesine izin ver. Sağlayıcı kurulu, oturum açık ve dosya seçicide kullanılabilir olmalı; gerçek Android/iOS cihazlarda doğrulanmalı. Mevcut file_picker kullanımı sağlayıcıya başarılı ve kalıcı yüklemeyi tek başına kanıtlamaz.
4. Android Auto Backup ve cihaz aktarımı kapsamını açık manifest/XML kurallarıyla tanımla; geçici dosya, bildirim cihaz durumu ve gelecekteki kimlik bilgilerini çalışma verisinden ayır. Mevcut manifestte allowBackup=false yok; “şu an yedekleme kesin kapalı” denemez. Ancak açık kurallar ve gerçek geri yükleme kabulü de yok.
5. İsteğe bağlı doğrudan Drive otomatik yedekleme, temel kurtarma çalıştıktan sonra ayrı dilim olsun. Kullanıcı uygulama hesabı açmadan Google hesabını yalnız yedekleme için bağlayabilir. Cloud Console/OAuth istemci ve platform yapılandırması gerekir; kendi backend'imiz zorunlu değildir.

Android'in resmî belgesi ücretsiz 25 MB kotayı, koşullu zamanlamayı ve geri yüklemeyi açıklıyor: [Auto Backup](https://developer.android.com/identity/data/autobackup). Bu mekanizma anlık, her cihazda garantili veya Android–iPhone ortak eşitleme değildir.

Dosya sağlayıcısı yolu: [Android Storage Access Framework](https://developer.android.com/training/data-storage/shared/documents-files), [Apple belge sağlayıcıları](https://developer.apple.com/documentation/uikit/providing-access-to-directories). Apple'ın [iCloud cihaz yedeği](https://support.apple.com/en-ie/108770) uygulama verisini içerebilir; cihaz yedeğinden dönmek ile uygulamayı silip tekrar kurunca tek uygulamanın verisinin otomatik gelmesi aynı şey değildir.

Doğrudan Drive seçeneğinde yalnız gerekli kapsam kullanılmalı: appDataFolder için drive.appdata veya uygulamanın oluşturduğu/gerekli seçilen dosyalar için uygun drive.file tasarımı. appDataFolder görünmez; telefon uygulamasını silmek ile Drive'dan uygulama bağlantısını/verisini kaldırmak farklıdır. Kullanıcı Drive'daki uygulama verisini ayrıca silebilir. [Drive uygulama verisi](https://developers.google.com/workspace/drive/api/guides/appdata).

16 Ekim araştırmasında resmî fiyat sayfası standart API kullanımının ek ücret olmadan sunulduğunu, kota aşımında 2026 içinde ücret planlandığını belirtiyor. Bu nedenle ticari koşul yeniden kontrol edilmeli; kota aşımını satın almak yerine bekletme/yeniden deneme sınırı seçilmeli. Öğrencinin depolama alanı da sınırsız değil. [Drive kullanım sınırları](https://developers.google.com/workspace/drive/api/guides/limits).

### Yedek güvenilirliği için eksik sözleşmeler

- Panoya kopyalama = dışa aktarma; kalıcı dış yedek doğrulaması değil. Mevcut settings_screen.dart aynı “son başarılı yedek” zamanını panoya kopyalamada da güncelliyor. Bu ayrılmalı.
- Durumlar: yalnız cihazda / dışa aktarıldı / yükleme bekliyor / uzak kopya doğrulandı / hata / geri yüklenebilirlik denendi. Sistem Auto Backup için doğrulanmayan “bugün bulutta” etiketi gösterilmez.
- İlk kurulumda “Yeni başla” ve “Yedeğim var”. Uzaktaki eski dolu kopya, yeni boş profil açıldığı için otomatik ezilmez.
- Sürüm, oluşturulma tarihi, profil/kayıt sayıları ve bütünlük kontrolü; şema geçişi ve profil bazında önizleme.
- İçe aktarmadan önce mevcut verinin geri dönülebilir kopyası; bozuk grubun iyi verileri engellememesi. Birleştirme varsa olay kimlikleriyle çoğalma önlenmeli.
- Günlük sınırlı snapshot geçmişi, örneğin son 7 başarılı sürüm (öneri); son iyi sürüm bozuk/boş payload ile ezilmez.
- Otomatik modda kalıcı değişiklik sonrası bekleyen iş; çevrimdışında bekle, ağ gelince kontrollü dene. Arka plan saati ve bağlantı başarısı garanti edilmez.
- İlk aşama yedek/geri yükleme; eşzamanlı çok cihaz düzenlemesi değildir. Çok cihaz eşitlemesi ayrıca çatışma protokolü gerektirir.
- Şifreli taşınabilir yedek sunulursa anahtar yalnız silinebilen uygulama deposunda tutulmaz; yeni telefonda kullanılabilecek kurtarma parolası/anahtarı gerekir. Kurtarma tasarlanmadan “şifreledik, güvende” denmez.
- Gizlilik metni gerçek uygulamaya göre güncellenir. Bulut bağlantısı isteğe bağlı; otomatik kişisel veri gönderimi bu araştırmada yapılmadı.

Kabul senaryoları (henüz uygulanmadı): gerçek yedek → uygulamayı kaldır/yeniden kur → geri yükle; farklı telefonda aynı hesap/dosya; internetsiz çalışma ve sonra yedekleme; kota dolu/izin iptali/hesap değişimi; dosya sağlayıcısının yükleyememesi; şema eskimesi; bozuk son kopyadan önceki iyi sürüme dönme; yeni boş kurulumun dolu yedeği ezmemesi. Bunlar gerçek kullanıcı verisi yerine kontrollü veriyle yapılmalı.

## 7. Uygulanacak işler ve sıra

- [ ] PROD-01: Onaylı kapsamı ürün akışına taşı; deneme üretimi yerine kişisel kaynaklarla çalışma.
- [ ] PROD-02: Kaynak modeli: kimlik, kullanıcı adı/yayınevi isteğe bağlı, sınav-ders, birim (sayfa/test/soru/video), toplam ve ilerleme. Basılı kaynağın içeriğini kopyalama zorunluluğu yok.
- [ ] PROD-03: Kaynak → konu → görev → çalışma kaydı bağlantısı; kısmi ilerleme ve geri alma.
- [ ] PROD-04: Serbest deneme sonucu; ad/yayınevi isteğe bağlı, tarih, oturum, D-Y-B veya doğrudan net, süre, zayıf konu bağlantısı. Oturuma uygun alanlar; AYT-only kayıtta gereksiz TYT formu yok.
- [ ] PROD-05: Çok sınav çekirdeği ve sürümlü katalog; mevcut YKS profillerini koruyan geçiş.
- [ ] UX-01: Bugünün rotasını ilk sıraya taşı; sayaç ve motivasyon yoğunluğunu azalt.
- [ ] UX-02: Kaynak/deneme kısa liste + ayrıntı akışı; tutarlı ikon/metin/boş durum dili.
- [ ] UX-03: Açık/koyu tema, dar ekran, büyük yazı ve ekran okuyucu kabulü.
- [ ] MOTION-01: Ortak süre/eğri/azaltılmış hareket sözleşmesi; kayıt durumuyla uyumlu mikro etkileşimler.
- [ ] SAFE-01: AUD veri hataları + yedek durumlarının doğru anlamı.
- [ ] SAFE-02: Sistem dosya sağlayıcısından dış yedek ve yeni kurulum kurtarması.
- [ ] SAFE-03: Android açık backup/transfer kuralları ve cihaz kabulü.
- [ ] SAFE-04: İsteğe bağlı doğrudan Drive yedeği için OAuth/kota/boş kopya koruması.
- [ ] RESEARCH-01: İlk nitel öğrenci turu ve bulgulara göre akış düzeltmeleri.

Önce veri doğruluğu ve kurtarma; ardından kişisel kaynak-serbest deneme modeli ve kapasite; sonra günlük ekran ve gezinme; ardından hareket tasarımı ve cihaz kabulü. Araştırmanın yazılması bu kutuları tamamlamaz.

