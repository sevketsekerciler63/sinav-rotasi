# Günlük plan görev ve süre envanteri

`daily-task-inventory.csv`, mevcut statik planın 95 `day_001`–`day_095` bloğunu içerik kaybetmeden dışa aktarır. Her satırdaki TYT/AYT metinleri bugünkü şablondan gelir; `legacyStudyHoursLabel` yalnız tarihsel etikettir.

## Editoryal kararlar

- Boş `subjectIds`, `topicIds`, `estimatedMinutes`, `prerequisiteTaskIds` ve `splittable` alanları veri eksikliğini gösterir. Tahminle doldurulmamalı.
- Bir gün bloğu birkaç farklı öğrenme işini bir arada içerebilir. Her satır önce atomik görevlere ayrılmalı; sonra görev başına ders/konu, gerçekçi dakika aralığı veya tahmini dakika, ön koşul ve bölünebilirlik incelenmeli.
- Eski “6 saat”, “7 saat” ve benzeri etiketler görevlere bölüştürülmemeli. Yeni süre tahmininin dayanağı (soru adedi, okuma/video/çözüm işi ve editoryal tahmin) ayrıca kaydedilmeli.
- Plan `day_001`–`day_095` kimliklerini geçmiş tamamlanma kayıtlarında kullanıyor. Bir bloğu birden çok göreve ayırma kararı, eski kimliklerin tamamlanmış ilerlemesini koruyan açık bir geçiş eşlemesi içermeli.
- Kapasite dağıtımı, bu envanter ve geçiş eşlemesi gözden geçirildikten sonra devreye alınmalı. Sığmayan görevler ve taşma, öğrenciye hangi görevin neden kaldığını ve hangi seçenekleri bulunduğunu göstermeli.

## CSV alanları

| Alan | Anlamı |
|---|---|
| `taskId` | Mevcut kararlı günlük blok kimliği |
| `templateDate`, `weekday` | Statik şablonun kaynak tarihi ve günü |
| `tytContent`, `aytContent` | Şablondaki özgün çalışma metni |
| `legacyStudyHoursLabel` | Yalnız denetim için eski süre etiketi |
| `subjectIds`, `topicIds` | İnceleme sonrası konu kataloğu bağlantıları |
| `estimatedMinutes` | Atomik görev için editoryal süre tahmini |
| `prerequisiteTaskIds` | Gerçek ön koşullar; gerekçesiz sıra bağı kurulmaz |
| `splittable` | Görevin kapasiteye göre güvenle bölünüp bölünemeyeceği |
| `editorialStatus` | Görev ayrıştırma ve onay durumu |

Mevcut durum: 95/95 blok envantere aktarıldı; görev ayrıştırma, süre tahmini, konu bağları ve kabul henüz yapılmadı. Bu nedenle günlük dakika tercihi halen bir hedef bilgisidir; plan yükü sınırı değildir.
