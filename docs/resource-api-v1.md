# Kişisel kaynak API'si · v1

Teslim: `ee3f45d`. Profil deposu şeması 9; yeni veri grubu `learning_workspace`.

`AppState.learningWorkspace` kaynak/görev/çalışma grafiğinin salt okunur görünümüdür. Liste öğeleri değişmez modellerdir. Her değişiklik en son kalıcı grafiği işlem kuyruğu içinde okur ve doğrulanmış yeni grafiği yazar. Başarıdan sonra etkin profilin belleği yenilenir. Başarısızlıkta eski görünüm korunur; ekran taslağı açık kalmalıdır.

- `saveStudyResource(StudyResource) → Future<bool>`: ad, isteğe bağlı yayınevi, mevcut dersin `storageId` ve ad anlık görüntüsü, TYT/AYT/YDT oturumu, sayfa/test/soru/video birimi, toplam ve başlangıçta bitirilmiş birim.
- `saveResourceTask(ResourceTask) → Future<bool>`: kaynak kimliği, başlık, 1 tabanlı dahil başlangıç/bitiş aralığı, kullanıcı süre tahmini, isteğe bağlı `YYYY-MM-DD` gün. Aynı aralık iki etkin göreve ayrılmaz.
- `recordResourceProgress(ResourceProgressEvent) → Future<bool>`: olay kimliği, görev, gerçek başlangıç birimi, birim sayısı ve zaman. Aktif aralıklar çakışmaz. Tekrar denemede aynı kimlik ve içerik kullanılır; daha önce geri alınmış olay bir retry ile canlandırılmaz.
- `undoResourceProgress(id) → Future<bool>`: geçmiş olayı saklar, yalnız etkisini geri alır. Sonraki çalışılmış aralıklar korunur; `remainingRanges(taskId)` gerçek boşlukları verir.
- `archiveStudyResource(id, bool)` ve `archiveResourceTask(id, bool)`: geçmişi silmeden arşivleme/geri çıkarma. Arşivli kaynağa ilerleme yazılmaz. Arşivli görev yalnız çalışılmamış aralıkları serbest bırakır; çalışılmış sayfa/test/sorular başka göreve yeniden atanamaz.
- `taskProgress(id)` ve `resourceProgress(id)`: etkin olaylardan türetilir; ekran aynı sayıyı ayrıca hesaplamaz.

Geçmişi olan görevin kaynak/aralığı; geçmişi/görevi olan kaynağın birimi, dersi ve başlangıç ilerlemesi değiştirilemez. Ad, yayınevi, doğrulamaya uygun toplam, görev adı/süre tahmini/gün düzenlenebilir. Değişiklik başarısızsa taslak korunup anlaşılır hata gösterilmelidir.

UI profil kimliğini form açıldığında tutmalı; gönderirken profil değişmişse formu yanlış profile kaydetmemeli. Depo işlemi başladığında ilgili profil kimliği sabitlenir. Başka profildeki grafiğe sonuç uygulanmaz.

Kaynak içeriği/soru metni yüklenmez. Bu API otomatik bulut yüklemesi veya dakika kapasitesine uygun plan ürettiği anlamına gelmez. Sonraki plan dilimi, görev birimleri ve süre tahminini kullanacak.

Kontrol: 7 model testi + 12 depolama testi birlikte geçti. Kısmi ilerleme, eski olayı geri alma, çakışma, arşiv, başarısız yazım, eşzamanlı değişiklik, profil izolasyonu ve yedek turu kapsanıyor. Statik analiz temiz.


## v2 ek sözleşme
Şema 10 ile `plans` eklendi. `rebuildResourcePlan()` bugün/geçmişi koruyup geleceği dakika kapasitesine göre dağıtır. `completeResourcePlanBlock(day, taskId, start, end)` yalnız bugünün gerçek açık aralıklarını tek işlemde kaydeder. Planlanmış görevin kaynak/aralığı sabittir; ad, süre tahmini ve hedef gün gelecek üretime etki edebilir. `reportDailyLogs` ve `reportQuestionEvents` raporların birleşik görünümüdür; bunlar ayrı depolanmaz.
