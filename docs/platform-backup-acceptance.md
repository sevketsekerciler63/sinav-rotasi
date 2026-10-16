# Cihaz yedeği ve yayın kabulü · 2026-10-16

## Uygulanan

- Android `allowBackup`, eski `fullBackupContent` ve Android 12+ `dataExtractionRules` açıkça tanımlandı. Yalnız çalışma/profil deposu `FlutterSharedPreferences.xml` dahil; `sinav_rotasi_device.xml`, bildirim plugin zamanlamaları ve diğer dosyalar bu izin listesine dahil değil. Yeni bir depo dosyası eklenirse kurallar da güncellenmeli.
- Hatırlatıcı ve son dosya dışa aktarım bilgisi Android’de ayrı SharedPreferences dosyasında. İlk namespace geçişi saat/dakikayı korur, bildirim etkinliğini ve eski yedek iddiasını taşımaz; eski alanlar ancak yeni kayıt yazıldıktan sonra çıkarılır. Çalışma anahtarları değiştirilmez. Hatırlatıcı bu yükseltmeden sonra yeniden açılır.
- Hatırlatıcı tek JSON snapshot ile yazılır. Başarısız legacy yazımın bellek önbelleği de eski kalıcı değere döndürülür.
- Android bulut yedeği şifreleme yeteneğine bağlı; otomatik sistem yedeği veya çok cihaz eşitlemesi başarısı uygulamada iddia edilmez. Elle JSON dışa/içe aktarım ana kurtarma yoludur.
- `flutter build apk --debug --no-pub` başarılı. APK: `build/app/outputs/flutter-apk/app-debug.apk`. Debug derleme mağaza yayını değildir.
- 2 yeni kabul: geçişte disk hatası → eski çalışma/saat korunur → yeniden dene → etkinlik ve eski export bilgisi taşınmaz; kapalı hatırlatıcı saati yazılamazsa önceki snapshot korunur.
- CI kaynakta eklendi: sabit Flutter 3.38.5 revision, format, analiz, test ve release web derlemesi. GitHub üzerinde henüz çalıştırılmadı.

## Sonra bakılacak / somut dış engeller

1. **Android gerçek geri yükleme:** `adb devices -l` boş; bağlı cihaz/emülatör yok. API 30 ve 31+ cihazlarda backup transport açıkken kontrollü örnek profil oluştur → JSON'u cihaz dışında sakla → sistem yedeğini tetikle/doğrula → kaldır/kur → çalışma gelirken hatırlatıcı ve export zamanı gelmemeli. Bu senaryo kullanıcı verisiyle çalıştırılmaz.
2. **Başka telefon/dosya sağlayıcısı:** Google Drive/iCloud/yerel sağlayıcıdan gerçek dosya seçimi ve temiz kurulumda import, bozuk/eksik dosya, çevrimdışı durum ve sağlayıcı iptali gerçek cihazla kabul edilecek. Dosya kaydetme isteği uzak kopya doğrulaması değildir.
3. **Doğrudan Drive:** uygulama adına OAuth istemcisi, paket/signed SHA yapılandırması ve test hesabı yok. Bunlar olmadan çalışanmış gibi bağlan düğmesi eklenmedi. Sonraki iş: en dar kapsam, dosya sürüm geçmişi, hesap değişimi/erişim iptali, dolu yedeği boş kurulumun ezmemesi, iki cihaz çakışması. Kendi sunucusu gerekmez; provider hesabı/kota/kuralları geçerlidir.
4. **iOS:** bu Windows ortamında Xcode ve bağlı iOS cihazı yok. Cihaza özgü alanın sistem yedeğinden ayrılması ve dosya sağlayıcısı kabulü iOS ortamında yapılmalı. Mevcut JSON yedeği bildirim ayarlarını içermez; iOS sistem yedeği kabulü bununla aynı değildir.
5. **Gerçek tarihsel yedekler:** mevcut testler temsilî schema işaretleri ve legacy biçimi içeriyor; tüm eski sürümlerin gerçek cihaz dosyaları sağlanmadı. Geriye dönük beklenti/tekrar başlangıcı bilinmeyen eski kayıtlara tahmin uygulanmaz.
6. **Mağaza yayını:** gerçek paket kimliği, imzalama anahtarı, mağaza hesabı, gizlilik beyanı ve cihaz kabulü ayrı adımlar. Debug anahtarıyla üretim yayını tamamlanmış sayılmaz.

Kaynak: [Android Auto Backup belgeleri](https://developer.android.com/identity/data/autobackup). Kurallar sistem koşullarına bağlıdır; her silmede/hesapta kurtarma garantisi vermez.
