# Hareket sözleşmesi · 2026-10-16

- Basış 120 ms; durum/sayfa 180 ms; ilerleme en fazla 240 ms; easeOutCubic. Mevcut Flutter platform gezinme ve geri davranışı korunur (`AppPageRoute`).
- `MediaQuery.disableAnimations` veya cihaz erişilebilirlik tercihi açıkken özel hareket sıfır süreli/kapalıdır. Açılış dekorasyonu atlanır, konfeti/pulse yok; onboarding sayfa atlar, eski plan otomatik kaydırması anlıktır.
- Listeler provider bildirimiyle yeniden uçuşmaz. Dashboard giriş animasyonları ve artık kullanılmayan staggered paketi kaldırıldı.
- Gerçek kayıt sonucu beklenir. Kaynak/deneme/plan formu beklemede kilitlidir; başarısızlık taslağı korur. Başarı animasyonu kayıt sonucunun yerine geçmez.
- Rota değişimi sayaç kimliği, görev, başlangıç, bitiş hedefi ve aktif süreyi değiştirmez. Pomodoro çıkışı yalnız görsel ticker'ı kapatıp durumu saklar. Süresi dolmuş seans sonraki açılışta tamamlanır; seans yazımı öncesi bekleyen sonuç/tarih/güvenli süre kalıcıdır.
- Açık: fiziksel Android geri jesti/iOS kenar jesti, düşük donanım performansı, tüm eski iyimser konu/hedef eylemlerinin kalıcı başarıya çevrilmesi. Testlerde çalışmayan cihaz akışı kabul edilmiş sayılmaz.
