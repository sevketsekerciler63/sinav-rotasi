# Sınav Rotası

YKS adaylarının hedef, ders ve konu ilerlemesi, deneme sonuçları ve çalışma düzenini yerel olarak takip etmesi için Flutter uygulaması.

## Mevcut kapsam

- TYT/AYT ders ve konu takibi; profile özel ders ve konu ekleme
- Haftalık uygun gün ve süre hedefiyle bugünden sınava kadar oluşturulan plan; 95 temel görev, dinlenme günleri ve zayıf konulara göre tekrar dönemi
- Hedefler, zayıf konular, istatistik, rozet ve Pomodoro
- Bilgi kartı ve zayıf konularda yerel aralıklı tekrar; tamamlanan günlük tekrar görevi bağlı zayıf konunun tarihini ilerletir
- Profil bazlı yerel saklama ve JSON yedekleme/geri yükleme
- Yerel profil yazmaları sıraya alınır; yarıda kesilmiş çok anahtarlı güncelleme açılışta önceki değerlere döndürülür
- Hedeflerde pozitif sayı ve gerçek bitiş tarihi; tamamlanma mevcut ilerlemeden hesaplanır
- Denemelerde planlanan tarih, gerçekleşme tarihi ve son düzenleme zamanı ayrı tutulur
- Soru artışları olay tarihiyle, odak seansları tamamlandı/atlandı/iptal edildi durumu ve süreyle ayrı saklanır; etkin Pomodoro profilde saklanıp yeniden açılışta sürdürülür
- Şablon dışındaki korunmuş eski günlük faaliyetler haftalık raporda ayrı arşiv bölümünde görünür; güncel hafta toplamına eklenmez
- Yerel kayıtlar yüklenmeden çalışma ekranı açılmaz; yükleme ve kayıt hataları kullanıcıya gösterilir
- Deneme netlerini profil derslerine göre toplama; −soru/4 ile soru sayısı arasında 0,25 adımlı giriş; resmî puan ve sıralama tahmini gösterilmez
- Rota Atlası görsel kimliği, açık/koyu görünüm ve web ön izlemesi
- Aynı rota-hedef simgesi web/PWA, Android launcher ve iOS App Store ikon boyutlarında kullanılır; düzenlenebilir kaynak `web/icons/sinar-rotasi.svg` dosyasıdır

## Çalıştırma

Flutter SDK ile proje kökünde `flutter pub get`, ardından `flutter run` kullanın.

## Bilinen durum

- Veri `SharedPreferences` içinde saklanır. Profil saklama şeması sürüm 5'tir; sürüm 1–4 yedekler geriye uyumlu okunur. Eski kayıtların ilk gerçek cihaz açılışında taşındığı henüz doğrulanmadı.
- 95 temel plan görevi `day_001`–`day_095` kimlikleriyle saklanır. Uygun çalışma günleri değişince tarihler yeniden düzenlenir; görev ilerlemesi kimliğini korur. Daha fazla uygun gün varsa ek günlere tekrar/deneme analizi gelir; daha az gün varsa temel görevler bazı günlerde birlikte gösterilir.
- Tamamlanmamış görev, uygulama yeni günde açıldığında veya öne geldiğinde sıradaki uygun çalışma gününe taşınır; tamamlanan görevler yeniden planlanmaz.
- Günlük dakika tercihi hedef olarak gösterilir; mevcut görevlerin gerçek süre tahmini bu tercihe göre henüz yeniden hesaplanmıyor. Temel görevleri bir güne sığdırmak için birleştirme gerekebilir.
- Yeni kurulumun kişisel plan hedefi kurulum anından 180 gün sonrasına ayarlanır; kayıtlı profiller otomatik değişmez. Bu tarih resmî sınav tarihi değildir. Kullanıcı Ayarlar'dan kendi hedefini güncelleyebilir; resmî tarih açıklanmadan YKS tarihi uydurulmamalıdır.
- YKS kataloğu tüm puan türlerini kapsamaz; KPSS şablonu ve ekranları henüz yoktur.
- Yedek dışa/içe aktarma panoya kopyalama ve JSON yapıştırma ile çalışır.
- Eski toplam soru sayısı korunur fakat tarih bilgisi olmadığı için günlük/haftalık soru raporuna katılmaz; tarih anahtarı korunmuş eski plan kayıtları raporda ayrı gösterilir.
- Profil geçişi, çok anahtarlı yazma ve Pomodoro devamı için kaynak korumaları eklendi. Net girişleri negatif/çeyrek değerleri koruyup soru sınırlarını doğrular; kaydedilmemiş Pomodoro sonucu kararlı kimlik ve bitiş bilgisiyle yeniden denenir. Analyzer ve web release derlemesi temiz. Davranış/regresyon testleri, işlem kesintisi enjeksiyonu, yedek round-trip ve gerçek cihazdaki zorla kapatıp açma doğrulaması bekliyor.
- Günlük plan kartındaki soru sayısı yalnız seçilen günün tarihli soru olaylarından hesaplanır; tarihi belirsiz eski toplamlar haftalık raporda ayrıca belirtilir. Haftalık ayrıntı, mevcut şablondan çıkmış eski tamamlanma tarihlerini de gösterebilir.
- Kart ve zayıf konu tekrarları cihaz içinde tarihlendirilir; bildirim gönderilmez. Eski tamamlanmış günlük tekrarların konu bağlantısı bulunmayabilir, yeni bağlı görevler bu tarihe göre planlanır.
- Yedek JSON panoya kopyalanabilir ve içe aktarma sırasında panodan yapıştırılabilir; dosya seçerek aktarma ve zaman damgalı yedek henüz yoktur.
- Ayarlarındaki “Veri ve gizlilik” özeti yerel veri alanını, kullanıcı seçtiğinde açılan YouTube ve kart kaynak bağlantılarını, yedek kapsamını ve silme etkisini açıklar. Inter ve Space Grotesk lisanslarıyla uygulamaya gömülüdür; fontlar için çalışma anında ağ isteği yapılmaz.
- `test/widget_test.dart` henüz çalıştırılabilir test içermiyor.
- Android uygulama kimliği mevcut cihaz verisini korumak için `com.yks.yks_study_app` olarak bırakılmıştır.
- `flutter build apk --release --no-pub` yerel paketleme kontrolünden geçer; mevcut Gradle release yapılandırması debug anahtarı kullandığından bu APK mağazaya yüklenemez. iOS artefaktı macOS/Xcode üzerinde derlenip doğrulanmalıdır.
- `arsiv/eski-yks-kaynaklari` klasöründe eski MTOK Excel kaynakları vardır.
