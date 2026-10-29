# Sınav Rotası — yeniden teknik ve ürün denetimi

Tarih: 16 Ekim 2026. İncelenen kaynak: `cd33aee`. Bu belge araştırma sonucudur; aşağıdaki hatalar henüz düzeltilmedi.

## Sonuç ve araştırmanın sınırı

Uygulamada kaynak kodla düzeltilebilecek işler kalmış. Önceki “uygulanabilir kaynak işleri tamamlandı, kalanlar dış doğrulama” kapanış değerlendirmesi bu bulgularla geçerliliğini kaybediyor. Özellikle kayıt sonucu, net anahtarı, eşzamanlı oturum ve geçmiş plan beklentisi üzerinde çalışma gerekiyor. Yeni ekran eklemekten önce bu sözleşmeler düzeltilmeli.

Yöntem: uygulama, model, planlayıcı, rapor, depolama ve yedek kodu okundu; ÖSYM/MEB/OGM, Flutter paket belgeleri ve W3C kaynakları kontrol edildi. Gerçek kullanıcı deposuna yazılmadan `SharedPreferences` bellek taklidiyle izole teşhis senaryosu çalıştırıldı. Tarayıcıdaki 8795 önizlemesi okundu; mevcut build/web ayrıca 8812 geçici kökeninde boş profille açıldı. Görsel örnekler tam cihaz kabulü sayılmadı. 320 px viewport çıktısı ölçekleme açısından güvenilir olmadığı için sağ şerit/taşma uygulama hatası olarak raporlanmadı.

`flutter analyze --no-pub` temiz. İzole teşhis koşusu tamamlandı; bu, uygulamanın regresyon testlerini geçtiği anlamına gelmiyor. Depodaki `test/widget_test.dart` yalnız boş `main` içeriyor. Uygulama kaynakları bu araştırmada değiştirilmedi.

Öncelik: **P1**, kayıt/hesap doğruluğu veya sınav yönlendirmesi için ilk düzeltilecek iş; **P2**, güvenilir günlük kullanım için gerekli davranış/ürün açığı; **karar**, tek doğru davranışı henüz tanımlanmamış konu. “Doğrulandı” izole koşuyu veya doğrudan kaynak kanıtını ifade eder; gerçek kullanıcı verisinin kaybolduğu iddia edilmez.

## AUD-01 · P1 · Çelişen net takma adları sınırı aşabiliyor ve kendi yedeğini bozuyor

**Doğrulandı.** `updateMockExam` çağrısına sırasıyla `{'TYT Türkçe': 100, 'TYT Turkce': 0}` verildiğinde dönüş `true`, gösterilen resmî toplam `100.0` oldu. Türkçe kataloğunun sınırı 40 soru. Aynı uygulamanın ürettiği yedek `previewBackup` tarafından geçersiz net nedeniyle reddedildi.

**Neden:** `MockExamMetrics.areNetUpdatesValid` aynı normalize anahtarı son değerle eziyor. `MockExam.normalizedNets` ve doğrudan net okuması ise kanonik anahtarı tercih ediyor. Doğrulanan değer ile kullanılan değer farklı. Normal kayıt yazmaları da yedek doğrulayıcısını çağırmıyor.

**Kanıt:** `lib/services/mock_exam_metrics.dart:31`, `lib/models/mock_exam.dart:50`, `lib/providers/app_state.dart:1401`, `lib/services/profile_storage.dart:614`.

**Yapılmalı:** tek bir kanonikleştirme sözleşmesi kullan; aynı derse gelen çelişen anahtarları yazmadan reddet; doğrulanan haritayı kaydet. Eski takma adların içe aktarımı için açık migrasyon uygula.

**Kabul:** anahtar sırası değişse de sonuç aynı; 40 üstü net reddedilir; çelişen takma ad reddedilir; geçerli netli çok profilli export → preview → import → export korunur.

## AUD-02 · P1 · Başarısız kayıt başarılı işlem gibi devam edebiliyor

**Doğrulandı.** Depolamada 180 dakika varken sonraki tercih yazımı yapay olarak başarısız bırakıldı. `updateSchedulePreferences` normal döndü; bellek 30, depo 180 dakika oldu. `persistenceError` doluydu. Ayarlar, yöntem normal döndüğü için yeşil “güncellendi” mesajı üretecek durumda.

**Neden:** `_writeProfileData` hatayı yakalıyor ve çağırana başarısızlık sonucu iletmiyor. `updateSchedulePreferences` ardından bellek planını güncelliyor. Deneme düğmesi de `updateMockExam` çağrısının senkron `true` sonucuyla “Güncellendi” oluyor; kalıcı yazım hâlâ bekliyor. Pomodoro durum kaydı da aynı hata sözleşmesini tüketiyor.

**Kanıt:** `lib/providers/app_state.dart:1297`, `:778`, `:1401`, `:733`; `lib/screens/settings_screen.dart:477`; `lib/screens/mock_exam_screen.dart:768` ve `:797`.

**Yapılmalı:** kayıt sonucu `Future<SaveResult>` benzeri açık sözleşmeyle dönmeli. Arayüz “kaydediliyor / kaydedildi / kaydedilemedi” durumlarını ayırmalı. Hata halinde ya son kalıcı duruma dönülmeli ya da yeniden denenecek taslak açıkça tutulmalı. Başka bir başarılı yazım önceki başarısız değişikliği kaydedilmiş saymamalı.

**Kabul:** hata enjeksiyonunda başarı mesajı çıkmaz; bellek ve depo farkı kullanıcıya görünür; yeniden deneme aynı değişikliği bir kere kaydeder; kapatıp açınca durum açıklanabilir.

## AUD-03 · P1 · Eşzamanlı iki odak kaydı birbirini ezebiliyor

**Doğrulandı.** İki farklı `StudySession` aynı anda `Future.wait` ile kaydedildi. İki çağrı da `true` döndü; kalıcı listede bir kayıt kaldı.

**Neden:** `recordStudySession` kayıt listesini depolama kuyruğuna girmeden önce kopyalıyor. İki çağrı aynı eski listeyi okuyup ayrı birer yeni liste üretiyor. Yazmaları sıralamak, eski listeyle hazırlanmış ipekikinci yazmanın birinciyi ezmesini engellemiyor. Bu gözlem eşzamanlı çağrı koşuluna aittir; normal her seansın kaybolduğu anlamına gelmez.

**Kanıt:** `lib/providers/app_state.dart:683`; `ProfileStorage._enqueueMutation` yalnız hazır güncellemenin yazımını sıralıyor.

**Yapılmalı:** oku → kimlik kontrol et → ekle → yaz işleminin tamamını aynı profil kuyruğuna taşı. Oturumları benzersiz kimlikli satırlar olarak saklamak daha sağlam bir temel sağlar.

**Kabul:** eşzamanlı iki farklı kimlik iki kayıt üretir; aynı kimliğin yeniden denenmesi tek kayıt bırakır; profil geçişinde başlangıç profili korunur.

## AUD-04 · P1 · Tek bozuk veri grubu tüm yedek dışa aktarımını engelliyor

**Doğrulandı.** İzole depoda tek `mock_exams` değeri bozuk JSON yapıldığında `exportBackup` tamamen başarısız oldu. Sağlam diğer veri gruplarını dışarı almak için ayrı kurtarma çıktısı yok.

**Neden:** dışa aktarma tüm profillerde her değeri doğrudan `jsonDecode` ediyor; yalnız hedefler için özel koruma var. Günlük plan karantinası bu genel durumu çözmüyor. Etkin olmayan bir profildeki bozuk alan da tüm profilli yedeği engelleyebilir.

**Kanıt:** `lib/services/profile_storage.dart:315`; `lib/providers/app_state.dart:368` günlük planla sınırlı kurtarma akışı.

**Yapılmalı:** sağlam veriler ve okunamayan ham kayıtları ayrı bölümlerle taşıyan kayıpsız kurtarma yedeği; profil/grup bazında hata özeti; yazma öncesi içe aktarma doğrulaması. Normal yedek ile kurtarma yedeğinin etkisi anlaşılır olmalı.

**Kabul:** tek bozuk grup sağlam verilerin dışa aktarımını engellemez; ham içerik korunur; kurtarma içe aktarımı doğrulanmadan mevcut depo değişmez.

## AUD-05 · P1 · TYT tam deneme süresi yanlış

**Resmî kaynakla doğrulandı.** Uygulamada tam TYT için 135 dakika, karma günlerde 135+180 ve TYT+kısa AYT için 195 dakika etiketleri var. ÖSYM 2026 kılavuzu TYT için 165, AYT için 180, YDT için 120 dakika veriyor. 135 dakika özel bir hız antrenmanı olarak seçilebilir; mevcut metinler bunu “tam TYT” diye sunuyor.

**Kanıt:** `lib/data/exam_calendar_data.dart:12`, `:55`, `:78`; `lib/data/daily_schedule_data.dart:256`, `:637`. Güncel boş profil tarayıcı önizlemesinde “Süre: 135 dk” da görüldü.

**Kaynak:** [ÖSYM 2026 YKS kılavuzu, PDF s. 2 ve 30](https://dokuman.osym.gov.tr/pdfdokuman/2026/YKS/basvuru_kilavuz06022026.pdf#page=2). PDF resmî kılavuz sayfasındaki bağlantıdan indirilip metni okundu. Bu doğrulama 2026 içindir; 2027 kılavuzu çıkınca tekrar kontrol edilmeli.

**Yapılmalı:** süreleri tek sınav yapılandırmasından üret; günlük plan, deneme takvimi, toplam süre ve arşiv envanteri birlikte güncellensin. Özel kısa çalışma ayrı adlandırılsın.

**Kabul:** tam TYT tüm ekranlarda aynı süreyi gösterir; karma gün toplamları doğru; eski gerçekleşmiş deneme verisi değişmez.

## AUD-06 · P2 · 30 dakikalık güne 95 görev sığdırılabiliyor

**Doğrulandı.** Hedef bugün, tek uygun gün bugün ve kapasite 30 dakika verilince tek plan kaydında 95 görev kimliği çıktı. Dakika alanı dağıtımın girdisi gibi görünse de esas olarak etikete dönüşüyor. Ayarlar bu sınırı açıklıyor; açıklama gerçek kapasite planlamasının yerini tutmuyor.

**Kanıt:** `lib/data/daily_schedule_data.dart:908`, `:964`, `:1082`, `:1116`. `docs/daily-task-inventory.csv` süre ve bölünebilirlik alanları hâlâ boş.

**Yapılmalı:** atomik görev, ders/konu kimliği, tahmini dakika, önkoşul, bölünebilirlik ve öncelik modeli. Kapasite yetmezse taşan iş açıkça gösterilip kapsam/hedef seçeneği sunulmalı. Süreler tahmin olarak etiketlenmeli; öğrencinin gerçek çalışma verisiyle zamanla ayarlanmalı. Editoryal süre kararları gerekiyor, ancak veri modeli ve taşma arayüzü kodla hazırlanabilir.

**Kabul:** 30 dakikalık gün kapasitesini sessizce aşmaz; yapılandırılmamış süre için “hesaplanamadı” gösterilir; bir günlük hedefte 95 görev “uygulanabilir plan” diye sunulmaz.

## AUD-07 · P2 · Yeniden planlama kaçırılan günlerin izini siliyor

**Doğrulandı.** Pazartesi üretilen planda cuma öncesi dört planlı gün vardı. Cuma yeniden üretilen planda geçmiş gün sayısı sıfırdı; haftalık rapor `missedScheduledDays=0`, `totalDays=1` verdi. Pazartesiden beri uygulamayı kullanıp dört gün kaçıran öğrenci, cuma yeni başlayan öğrenciyle aynı plan beklentisine düşüyor.

**Neden:** plan bugünden itibaren yeniden oluşturuluyor; geçmişte hangi güne ne planlandığı saklanmıyor. Haftalık rapor güncel planı ve tamamlanan günleri biliyor; tamamlanmamış geçmiş plan beklentisini çıkaramıyor.

**Kanıt:** `lib/data/daily_schedule_data.dart:915`; `lib/services/weekly_report_metrics.dart:112`; `lib/models/exam_profile.dart` profil başlangıç/geçerlilik tarihi içermiyor.

**Yapılmalı:** plan sürümü ve gün bazında planlanan kapasite/görev geçmişi sakla. Güncel dağıtım ile tarihsel beklenti farklı alanlardan gelsin. Uygun gün tercihi değişince eski haftalar yeniden yorumlanmasın.

**Kabul:** pazartesi başlayan ve dört gün kaçıran profilde cuma raporu geçmiş beklentiyi korur; yeni cuma profili geçmiş günler için geride gösterilmez; ayar değişimi eski haftayı değiştirmez.

## AUD-08 · P2 · Aynı tekrar görevi yeniden işaretlenince ikinci tekrar sayılıyor

**Doğrulandı.** Aynı günlük tekrar görevinde tamamla → geri al → tamamla dizisi tekrar aralığını 1 günden 3 güne çıkardı. Yeni öğrenme oturumu olmadan `reviewRepetitions` artıyor.

**Kanıt:** `lib/providers/app_state.dart:1353`, `:1477`; `lib/models/weak_topic.dart:53`. Plan kaynaklı çağrı, normal tekrar ekranındaki vade kontrolünü atlıyor.

**Yapılmalı:** tekrar olayını `profileId + taskId + reviewEventId` ile tekilleştir. Gün tamamlamayı geri alma ile çalışma olayını iptal etmeyi ürün düzeyinde tanımla. Bir işareti geri almak yeni öğrenme olayı üretmemeli.

**Kabul:** aynı görev tekrar işaretlenince aralık büyümez; gerçekten yeni tekrar ayrı kimlikle kaydedilir; yeniden açılış/yedekle aynı sonuç korunur.

## AUD-09 · P2 · Bilgi kartları önceki kaynak envanterinin dışında kalmış

**Kaynak kodla doğrulandı.** Bilgi kartı ekranında 26 kart var; yalnız 5 kart kaynak etiketi/URL içeriyor. Önceki 107/107 konu ve 44/44 formül sayımı bu ayrı kart destesini kapsamıyor. Aynı kavramların birden çok içerik kopyası olması, bir sürüm düzelirken diğerinin eksik kalmasına yol açmış.

Örnekler:

- `mat_4`: logaritma özelliklerinin taban ve pozitif argüman koşulları yok.
- `mat_6`: belirsiz integral formülüyle eğri altı alan anlatımı birleştirilmiş; belirli/belirsiz integral ve işaretli integral/geometrik alan ayrımı eksik.
- `bio_4`: Calvin özeti yalnız CO₂ + ATP → glikoz olarak verilmiş; NADPH gereksinimi bu bölümde eksik.
- Günlük plan metninde “AYT Bio en kolay”, belirli konu için “en çok çıkan” ve “SAY puanını hesapla” gibi kullanıcıya özgü olmayan veya kaynaklandırılmamış yönlendirmeler kalmış.

**Kanıt:** `lib/screens/flashcard_screen.dart:30`, `:52`, `:62`, `:171`; `lib/data/daily_schedule_data.dart:404`, `:414`, `:602`, `:776`.

**Kaynaklar:** [MEB OGM logaritma tanımı](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/12/unite1/files/basic-html/page11.html), [integral ve alan hesabı](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/matematik/12/unite6/files/basic-html/page49.html), [Calvin tepkimelerinde ATP/NADPH](https://ogmmateryal.eba.gov.tr/panel/upload/etkilesimli/kitap/fenlisesibiyoloji/12/unite2/files/basic-html/page12.html).

**Yapılmalı:** konu, bilgi kartı, formül ve plan açıklamalarını ortak içerik kataloğuna bağla; kaynak sürümü, koşullar, örnek ve son gözden geçirme tarihi ekle. Tam kapsam envanteri 107+44 ile sınırlı kalmamalı.

**Kabul:** 26 kart da envantere girer; koşullar ve örnekler denetlenir; aynı kavramın farklı ekranda çelişen kopyası kalmaz. Bu araştırma tüm eğitim içeriğinin uzman onayı değildir.

## AUD-10 · P2 · Puan türü ve seviye seçimi ürün davranışına bağlanmıyor

**Ürün açığı.** Alanlar saklanıyor; dersler, görevler ve süreler bu tercihle değişmiyor. AYT kataloğu yalnız matematik/fizik/kimya/biyoloji içeriyor. EA/SÖZ için edebiyat ve sosyal testleri, DİL için YDT içeriği/net modeli eksik. Arayüzde kapsam sınırının yazması doğru bir adım; desteklenen kullanıcı kitlesini genişletmiyor.

**Kanıt:** `lib/models/exam_profile.dart`, `lib/data/subjects_data.dart:1129` sonrası, `AppState._buildDailySchedule`. ÖSYM 2026 kılavuzu Tablo 1B ve 1E (PDF s. 50 ve 52), bu puan türlerinin farklı test bileşimleri olduğunu gösteriyor.

**Yapılmalı:** ilk beta hedefini açık seç: mevcut SAY ağırlıklı kapsamı tamamla veya EA/SÖZ/DİL kataloglarını ayrı dilimler halinde geliştir. Seviye için ölçülebilir etki tanımla: tanı testi/son deneme/çalışma temposu. Öz değerlendirmeden keyfî başarı veya süre katsayısı türetme.

**Kabul:** seçilen profilin kapsamı, deneme bölümleri ve önerileri tutarlı; desteklenmeyen alan açık; kayıt alanının neden toplandığı kullanıcı için anlaşılır.

## AUD-11 · P2 · Deneme kaydı 13 sabit şablona bağlı

**Ürün açığı.** Deneme takviminden gelen 13 kimlik aynı zamanda gerçek sonuç kayıtları. Kullanıcının istediği yayınevi, tarih ve oturumla sınırsız yeni deneme ekleme akışı yok. Günlük plandaki deneme önerileri bu kimliklere bağlı değil; güncel boş profilde ilk takvim denemesi 112 gün sonra görünürken temel plan daha erken deneme görevleri içeriyor.

**Kanıt:** `lib/data/exam_calendar_data.dart`; `lib/screens/mock_exam_screen.dart`; `lib/data/daily_schedule_data.dart:256`. Mevcut açıklama iki önerinin bağımsız olduğunu belirtiyor ama kullanıcı akışını birleştirmiyor.

**Yapılmalı:** `MockExamTemplate`, `PlannedExam` ve `ExamAttempt` ayrımı. Kullanıcı tarih/yayın/kapsam ile yeni attempt ekleyebilmeli; plan kartından doğrudan aynı attempt'e gidilebilmeli. Düzenleme, silme/geri alma ve eksik bölüm durumu tanımlanmalı.

**Kabul:** 14. ve sonraki deneme eklenebilir; sonuç düzenlemek şablonu değiştirmez; plan/takvim/rapor aynı attempt kimliğini gösterir.

## AUD-12 · P2 · Özel ders adı resmî net kimliğine dönüşebiliyor

**Doğrulandı.** `Turkce` adlı özel TYT dersi eklenebildi. Sadece bu özel anahtar için 20 net girildiğinde resmî TYT toplamı 20 oldu. AUD-01'den ayrı olarak, özel ders ekleme akışıyla da resmî/özel ayrımı delinmiş oluyor.

**Neden:** özel ders benzersizlik kontrolü ham adları karşılaştırıyor; resmî net okuması eski Türkçe yazım takma adını normalize ediyor. Ad bir yerde kimlik, başka yerde gösterim metni olarak kullanılıyor.

**Kanıt:** `lib/providers/app_state.dart:1011`; `lib/models/mock_exam.dart:63`; `MockExam.totalForSubjects`.

**Yapılmalı:** netleri değişmez `subjectId` üzerinden sakla; görünen adları anahtar olarak kullanma. Eski ad anahtarları bir kez migrate edilsin; resmî katalog kimliği özel ders tarafından alınamasın.

**Kabul:** `Turkce`, `Türkçe`, boşluk/harf varyantları ve eski yedekler resmî/özel toplamları karıştırmaz.

## AUD-13 · P2 · Kalıcı veri temeli ve kurtarma yönetimi eksik

**Mimari risk.** Tüm çalışma geçmişi SharedPreferences içinde büyük JSON listeleri olarak yeniden yazılıyor. Paket belgeleri kritik veri için disk kalıcılığı garantisi vermediğini belirtiyor. İşlem günlüğü önemli bir koruma; bu paketi işlem destekli geçmiş veritabanına dönüştürmüyor.

**Kaynak:** [shared_preferences resmî paket belgesi](https://pub.dev/packages/shared_preferences). İncelenen kilitli paket 2.5.4; araştırma sırasında resmî sayfa 2.5.6 gösteriyordu. Sürümün daha yeni olması tek başına güncelleme gerekçesi sayılmadı.

**Yapılmalı:** depolama arayüzü; oturum/soru/deneme için kimlikli kayıtlar ve atomik güncellemeler; mobil ve web için uygun işlem destekli çözüm değerlendirmesi; geçişte önce yedek ve sayım doğrulaması. Karantinada saklanan içerik için incele/dışa aktar/kurtar/sil geri bildirimleri de gerekli.

**Kabul:** süreç öldürme ve yarım yazma halinde tutarlı açılış; büyük geçmişte ölçülen performans; geri alınabilir ve yeniden denenebilir veri geçişi. Tüm veri katmanını tek seferde değiştirmek önerilmiyor.

## AUD-14 · P2 · Otomatik davranış testleri ve CI eksik

**Kaynakla doğrulandı.** `test/widget_test.dart` boş; `.github` iş akışı yok. Analyzer ve başarılı build, AUD-01/02/03/07/08'i yakalamadı. Bu testlerin önemli kısmı fiziksel cihaz gerektirmiyor; bu araştırmadaki bellek deposu senaryoları yerelde çalıştı.

**Kaynak:** [Flutter test türleri](https://docs.flutter.dev/testing/overview). Birim testleri karar/hesabı, widget testleri form ve etkileşimi, entegrasyon testleri bütün akışı doğrulamak için farklı katmanlar sağlar.

**Yapılmalı:** önce bu rapordaki gerçek hataları yakalayan regresyon testleri; export/import anlamsal eşitliği; başarısız yazma ve rollback; aynı anda iki kayıt; gece yarısı ve profil geçişi; takma ad çakışmaları. Ardından CI'da analyze + test + uygun build.

**Kabul:** hatalı mevcut davranışa karşı test kırılır; düzeltme sonrası geçer; kullanıcı deposuna dokunmaz. Uygulamayı taklit eden veya yalnız aynı getter'ı tekrar hesaplayan testlerden kaçınılmalı.

## AUD-15 · P2 · Müfredat kohortu ve içerik sürümü modellenmiyor

**Araştırma bulgusu.** `templateId` sabit 2026 şablonu; profil hedefi 2027'ye kayabiliyor, ama müfredat/program sürümü ayrı tutulmuyor. `Topic` yalnız kaynak etiketi ve URL saklıyor. Güncel bir kaynağın daha yeni sınıf programına ait olması, hedef öğrencinin YKS kapsamına uygun olduğunu tek başına göstermiyor.

MEB'in 2026–2027 açıklamasında 12. sınıfta önceki programın sürdüğü, yeni modelin 9–11. sınıflarda uygulandığı belirtiliyor. MEB ayrıca yeni modele uyumlu YKS soru modelini 2028 için açıklıyor. Buradan çıkarımım: 2027 hedefli profile tüm konuları en yeni kitapla otomatik değiştirmek doğru olmaz; hedef kohort ayrı denetlenmeli.

**Kaynaklar:** [MEB 2026–2027 program geçişi](https://ogm.meb.gov.tr/www/2026-2027-egitim-ogretim-yili-turkiye-yuzyili-maarif-modeli-taslak-cerceve-planlar-yayimlandi/icerik/2633/tr), [MEB 2028 sınav modeli açıklaması](https://egitek.meb.gov.tr/yks-ve-lgsde-yeni-mufredata-uyumlu-soru-modeli-2028de-hayata-gececek/haber/39265/tr).

**Yapılmalı:** `examYear`, `curriculumVersion`, kaynak sürümü, kapsam durumu ve editoryal doğrulama tarihi. Konu gruplarının alt kazanımlarını ayrı envantere bağla.

**Kabul:** hedef yılı değişince içerik kapsamı açık; eski ilerleme kimlikleri yeni içerik sürümüyle sessizce yeniden yorumlanmaz; resmî 2027 kapsamı yayımlandığında kaynak karşılaştırması yapılır.

## AUD-16 · P2 · Erişilebilirlik ve arayüz kabulü tamamlanmış sayılmaz

**Kaynak kanıtı:** deneme net alanları tekrar tekrar yalnız “Net” etiketi taşıyor; ders adı ayrı kardeş metin. Slayderlerde ders adı/değer birimini taşıyan özel semantik açıklama yok. `Güncellendi` işlem sonucu yerine kalıcı düğme metni olarak kullanılıyor. `Zamanlayici`, `Yapilacak`, `gun` gibi Türkçe yazım tutarsızlıkları sürüyor.

**Kanıt:** `lib/screens/mock_exam_screen.dart` `_netSlider`, `:797`; `lib/screens/pomodoro_screen.dart:406`; `lib/screens/weak_topics_screen.dart:213`; `lib/screens/subjects_screen.dart:942`.

**Yapılmalı:** “TYT Matematik neti, izin verilen aralık …” gibi benzersiz erişilebilir adlar; kayıt sırasında bekleme/sonuç metni; klavye odağı ve hata odağı; Türkçe etiket turu. 320/360 px, %200 yazı ölçeği, açık/koyu tema ve ekran okuyucu kabulü ayrı yapılmalı.

**Kaynak:** [W3C form etiketleri](https://www.w3.org/WAI/tutorials/forms/labels/), [W3C %200 metin büyütme](https://www.w3.org/WAI/WCAG22/Understanding/resize-text.html). Bu rapor tam WCAG uygunluk denetimi değildir; 320 px görsel ölçüm aracı çıktısından kesin taşma sonucu çıkarılmadı.

## Davranışı tanımlanması gereken ek ürün kararları

1. **Gerçek odak süresi:** tamamlanmayan 20 dakikalık çalışma, iptal edilen seans olarak saklansa da aktif dakika raporuna katılmıyor (`StudyHistoryMetrics.activeSecondsOn`). “Tamamlanan seans” ile “gerçekte odaklanılan dakika” ayrı sunulabilir. Bunun hata mı tercih mi olduğu ürün kararıyla netleşmeli.
2. **Öğrenme ve tamamlandı ayrımı:** konu işareti çalışma yapıldı anlamında mı, sınavda güvenilir yeterlik anlamında mı? Bir kere işaretlemek kalıcı öğrenme kanıtı değil. Deneme başarısı ve gecikmiş tekrar sonucu ayrı sinyal olabilir.
3. **Gün tahminleri:** derslerdeki ~55/~44 gün gibi toplamlar statik `estimatedDays` toplamı; günlük kapasite/seviye ilişkisi yok. Tahminin temeli gösterilmeli veya kişisel ölçüm oluşana kadar daha ihtiyatlı sunulmalı.
4. **İlk kullanım:** beş tanıtım slaydı ve davranışa henüz etkisi olmayan zorunlu alanlar yerine, ilk oturumda hedef → kısa tanılama → uygulanabilir tek görev sonucu daha anlaşılır olabilir. Bu bir tasarım önerisi; kullanıcı araştırmasıyla doğrulanmadı.
5. **Önizleme/yayın kimliği:** sabit köken ve görünen build/commit kimliği eklemek, 8795 gibi eski önbellekli önizleme ile yeni kaynağı karıştırmayı azaltır. Port değişiminin ayrı kullanıcı deposu yarattığı açık kalmalı. Offline açılış ve sürüm yenilemesi gerçek yayın yapılandırmasında denenmeli.

## Önerilen uygulama sırası

1. AUD-01/02/03/04 ve AUD-12: net ve veri güvenilirliği. Önce bunları yakalayan izole regresyonlar, sonra kaynak düzeltmesi.
2. AUD-05/09: sınav süresi ve tüm eğitim içerik kopyalarının denetimi. Konu/formül sayımlarına bilgi kartları ve günlük metinleri dahil et.
3. AUD-06/07/08: görev kapasitesi, plan geçmişi ve tekrar olay kimliği.
4. AUD-10/11/15: beta kapsamını seç, bağımsız deneme attempt modeli ve kohort sürümlemesi.
5. AUD-13/14/16: aşamalı depo iyileştirmesi, sürekli regresyon ve gerçek cihaz/erişilebilirlik/yayın turu.

Yeni motivasyon widget'ı, ek rozet veya dekoratif animasyon bu sıralamadan önce gelmemeli. KPSS, bulut eşitleme ve yapay zekâ koçluğu ayrı kapsam kararlarıdır; temel YKS akışını bitirmenin ön koşulu olarak önerilmedi.

## Teşhis çıktıları

İzole koşu: `flutter test --no-pub .dart_tool/research-audit/probe_test.dart --reporter expanded`. Script gerçek SharedPreferences yerine bellek deposu kullandı; gerçek 8795 verisi değiştirilmedi. Çıktının özeti `audit-observations-2026-10-16.json` dosyasında. Araştırma koşusu gözlemleri yazdırır; kalıcı regresyon paketi henüz değildir.

| Senaryo | Gözlenen sonuç |
| --- | --- |
| Çelişen Türkçe anahtarları | 100/40 net kabul edildi |
| Kendi yedeğini önizleme | Geçersiz net nedeniyle reddedildi |
| İki eşzamanlı odak kaydı | İki true, tek kalıcı kayıt |
| Tercih yazım hatası | Bellek 30, depo 180; yöntem normal döndü |
| Özel Turkce dersi | Resmî toplam 20 oldu |
| Tamamla/geri al/tamamla | Tekrar aralığı 1 → 3 gün |
| Tek 30 dakikalık gün | 95 görev |
| Pazartesi → cuma yeniden planlama | Önceki 4 gün kaldırıldı; rapor 0 kaçırılan/1 toplam |
| Tek bozuk JSON grubu | Tüm yedek dışa aktarımı başarısız |

Bu bulguların cihaz testi bekleyen yanları vardır; buna rağmen AUD-01/02/03/04/07/08/12 ve regresyon altyapısının kaynak işi şimdi yapılabilir. Bunların tamamını dış doğrulamaya bırakmak doğru değildir.
