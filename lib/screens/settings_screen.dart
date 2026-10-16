import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/theme_state.dart';
import '../models/study_schedule_preferences.dart';
import '../services/profile_storage.dart';
import '../services/backup_history_service.dart';
import '../widgets/daily_reminder_settings_card.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Ayarlar')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Sınav Profili',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _settingsCard(
                context,
                icon: Icons.school_rounded,
                title: state.activeProfile.name,
                subtitle:
                    '${state.activeProfile.examSystem} • ${state.activeProfile.examType.replaceAll('_', ' + ')}\nKişisel plan hedefi: ${_formatDate(state.activeProfile.targetDate)}\nResmî sınav tarihi olarak değerlendirilmemelidir.${state.daysRemaining < 0 ? '\nBu tarih geçti. Yeni tarih seçince plan ve denemeler hizalanır.' : ''}',
                color: AppTheme.accentPurple,
                onTap: () => _editProfile(context, state),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _chooseProfile(context, state),
                      icon: const Icon(Icons.swap_horiz_rounded),
                      label: const Text('Profil seç'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _createProfile(context, state),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Yeni YKS profili'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _schedulePreferencesCard(context, state),
              const SizedBox(height: 12),
              DailyReminderSettingsCard(profile: state.activeProfile),
              const SizedBox(height: 12),

              // Theme toggle
              const Text(
                'Görünüm',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _themeToggleCard(context),
              const SizedBox(height: 24),

              // Data section
              const Text(
                'Veri Yönetimi',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 12),

              ValueListenableBuilder<DateTime?>(
                valueListenable: BackupHistoryService.lastSuccessfulBackupAt,
                builder: (context, lastBackupAt, _) => _settingsCard(
                  context,
                  icon: Icons.cloud_download,
                  title: 'Veriyi Dışa Aktar',
                  subtitle: lastBackupAt == null
                      ? 'JSON yedeğini panoya kopyala veya dosya olarak kaydet'
                      : 'JSON yedeğini panoya kopyala veya dosya olarak kaydet\n'
                            'Son başarılı yedek: ${_formatDateTime(lastBackupAt)}',
                  color: AppTheme.accentBlue,
                  onTap: () => _exportData(context),
                ),
              ),

              _settingsCard(
                context,
                icon: Icons.cloud_upload,
                title: 'Veriyi İçe Aktar',
                subtitle: 'JSON dosyası seç veya panodan/yazı alanından yükle',
                color: AppTheme.accentGreen,
                onTap: () => _importData(context, state),
              ),

              _settingsCard(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Veri ve gizlilik',
                subtitle: 'Yerel kayıt, dış bağlantı ve yedek kapsamı',
                color: AppTheme.accentCyan,
                onTap: () => _showDataPrivacy(context),
              ),

              _settingsCard(
                context,
                icon: Icons.delete_forever,
                title: 'Çalışma Verilerini Sil',
                subtitle: 'İlerleme, plan ve çalışma tercihleri silinir.',
                color: AppTheme.accentRed,
                onTap: () => _confirmReset(context, state),
              ),

              const SizedBox(height: 24),

              // About
              const Text(
                'Hakkında',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sınav Rotası v1.0',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '107 konu - 95 günlük plan - 13 deneme\n29 rozet - Pomodoro - Hedef takibi',
                      style: TextStyle(fontSize: 12, height: 1.5),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _infoBadge(context, '${state.completedTopics}', 'Konu'),
                        const SizedBox(width: 8),
                        _infoBadge(context, '${state.completedDays}', 'Gün'),
                        const SizedBox(width: 8),
                        _infoBadge(
                          context,
                          '${state.completedExams}',
                          'Deneme',
                        ),
                        const SizedBox(width: 8),
                        _infoBadge(
                          context,
                          '${state.unlockedAchievements}',
                          'Rozet',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _settingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: colors.outlineVariant),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: colors.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _themeToggleCard(BuildContext context) {
    return Consumer<ThemeState>(
      builder: (context, themeState, _) {
        final isDark = themeState.isDark;
        final theme = Theme.of(context);
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: AppTheme.accentPurple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tema',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      isDark ? 'Karanlık Mod' : 'Aydınlık Mod',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isDark,
                activeThumbColor: AppTheme.accentPurple,
                onChanged: (v) async {
                  try {
                    await themeState.setDark(v);
                  } catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Tema kaydedilemedi: $error')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _schedulePreferencesCard(BuildContext context, AppState state) {
    const dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final preferences = state.schedulePreferences;
    final days = preferences.availableWeekdays
        .map((weekday) => dayNames[weekday - 1])
        .join(' · ');
    return _settingsCard(
      context,
      icon: Icons.tune_rounded,
      title: 'Çalışma planını kişiselleştir',
      subtitle: '$days\nGünlük hedef: ${preferences.dailyStudyMinutes} dakika',
      color: AppTheme.accentCyan,
      onTap: () => _editSchedulePreferences(context, state),
    );
  }

  Future<void> _editSchedulePreferences(
    BuildContext context,
    AppState state,
  ) async {
    const dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    var availableDays = state.schedulePreferences.availableWeekdays.toSet();
    var minutes = state.schedulePreferences.dailyStudyMinutes.toDouble();
    var showDayError = false;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final activeDays = _countAvailableStudyDays(
            DateTime.now(),
            state.activeProfile.targetDate,
            availableDays,
          );
          final scheduleMessage = state.daysRemaining < 0
              ? 'Hedef tarihin geçmiş. Yeni tarih seçince plan o güne kadar oluşturulur.'
              : activeDays == 0
              ? 'Hedef tarihine kadar seçtiğin günlerden hiçbiri gelmiyor. Hedefi ileri al veya bugünün haftanın gününü seç.'
              : activeDays < 95
              ? '$activeDays çalışma gününe 95 görev dağıtılacak; günde yaklaşık ${(95 + activeDays - 1) ~/ activeDays} görev birleşebilir. Kaçırılan görev sonraki uygun güne taşınır. Dakika seçimi günlük hedeftir; görev süresi ayrıca hesaplanmıyor.'
              : '$activeDays çalışma günü var. İlk 95 görev uygun günlere dağıtılır; kalan uygun günlerde tekrar ve deneme analizi gösterilir. Kaçırılan görev sonraki uygun güne taşınır. Dakika seçimi günlük hedeftir; görev süresi ayrıca hesaplanmıyor.';
          return AlertDialog(
            backgroundColor: Theme.of(dialogContext).colorScheme.surface,
            scrollable: true,
            title: const Text('Çalışma planı'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hangi günler çalışabileceğini ve günlük hedef süreni seç.',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: List.generate(7, (index) {
                    final weekday = index + 1;
                    return FilterChip(
                      label: Text(dayNames[index]),
                      selected: availableDays.contains(weekday),
                      onSelected: (selected) {
                        setDialogState(() {
                          if (selected) {
                            availableDays.add(weekday);
                          } else if (availableDays.length > 1) {
                            availableDays.remove(weekday);
                          } else {
                            showDayError = true;
                            return;
                          }
                          showDayError = false;
                        });
                      },
                    );
                  }),
                ),
                if (showDayError)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'En az bir çalışma günü seçili kalmalı.',
                      style: TextStyle(color: AppTheme.accentRed, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 18),
                Text(
                  'Günlük süre hedefi: ${minutes.toInt()} dakika',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Slider(
                  value: minutes,
                  min: 30,
                  max: 480,
                  divisions: 30,
                  label: '${minutes.toInt()} dk',
                  onChanged: (value) => setDialogState(() => minutes = value),
                ),
                const SizedBox(height: 8),
                Text(
                  scheduleMessage,
                  style: Theme.of(
                    dialogContext,
                  ).textTheme.bodySmall?.copyWith(fontSize: 12, height: 1.4),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Vazgeç'),
              ),
              FilledButton(
                onPressed: availableDays.isEmpty
                    ? null
                    : () => Navigator.of(dialogContext).pop(true),
                child: const Text('Planı uygula'),
              ),
            ],
          );
        },
      ),
    );
    if (saved != true) return;
    try {
      await state.updateSchedulePreferences(
        availableWeekdays: availableDays.toList()..sort(),
        dailyStudyMinutes: minutes.toInt(),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Çalışma planı ve tercihlerin güncellendi.'),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Plan kaydedilemedi: $error')));
      }
    }
  }

  int _countAvailableStudyDays(
    DateTime start,
    DateTime target,
    Set<int> weekdays,
  ) {
    final normalizedStart = DateTime(start.year, start.month, start.day);
    final normalizedTarget = DateTime(target.year, target.month, target.day);
    if (normalizedTarget.isBefore(normalizedStart)) return 0;
    var count = 0;
    for (
      var date = normalizedStart;
      !date.isAfter(normalizedTarget);
      date = DateTime(date.year, date.month, date.day + 1)
    ) {
      if (weekdays.contains(date.weekday)) count++;
    }
    return count;
  }

  Widget _infoBadge(BuildContext context, String value, String label) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(BuildContext context) async {
    try {
      final destination = await showDialog<String>(
        context: context,
        builder: (dialogContext) => SimpleDialog(
          title: const Text('Yedek oluştur'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, 'clipboard'),
              child: const ListTile(
                leading: Icon(Icons.content_copy_rounded),
                title: Text('Panoya kopyala'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, 'file'),
              child: const ListTile(
                leading: Icon(Icons.save_alt_rounded),
                title: Text('JSON dosyası kaydet'),
              ),
            ),
          ],
        ),
      );
      if (destination == null || !context.mounted) return;

      final export = await ProfileStorage.instance.exportBackup();
      final jsonStr = const JsonEncoder.withIndent('  ').convert(export);
      if (destination == 'clipboard') {
        await Clipboard.setData(ClipboardData(text: jsonStr));
      } else {
        final now = DateTime.now();
        final bytes = Uint8List.fromList(utf8.encode(jsonStr));
        final savedPath = await FilePicker.saveFile(
          dialogTitle: 'Sınav Rotası yedeğini kaydet',
          fileName:
              'sinav-rotasi-yedek-${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}-${_twoDigits(now.hour)}${_twoDigits(now.minute)}.json',
          type: FileType.custom,
          allowedExtensions: const ['json'],
          bytes: bytes,
        );
        if (savedPath == null && !kIsWeb) return;
      }

      try {
        await BackupHistoryService.recordSuccessfulBackup();
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Yedek oluşturuldu; zamanı kaydedilemedi: $error'),
            backgroundColor: AppTheme.accentRed,
          ),
        );
        return;
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yedek başarıyla oluşturuldu.'),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yedek oluşturulamadı: $error'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
    }
  }

  Future<void> _showDataPrivacy(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        scrollable: true,
        title: const Text('Veri ve gizlilik'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _privacyDetail(
              dialogContext,
              'Nerede saklanır?',
              'Profil, hedef, ders/konu ilerlemesi ve notları, günlük plan, soru ve odak kayıtları, denemeler, zayıf konular, rozetler ve görünüm tercihi uygulamanın yerel profil deposunda tutulur. Uygulamada hesap, bulut eşitleme veya çalışma verilerini gönderen bir servis yoktur.',
            ),
            _privacyDetail(
              dialogContext,
              'Ne zaman dış bağlantı kurulur?',
              '“YouTube’da ara” seçildiğinde arama ifadesi YouTube’a açılır. Konu, bilgi ve formül kartlarındaki “Kaynak” düğmesi seçilen MEB OGM veya TDK sayfasını dış tarayıcıda açar; profil ve plan verisi kaynak bağlantısına eklenmez. Inter ve Space Grotesk yazı tipleri uygulamaya gömülüdür; görünüm için Google font sunucusuna istek gönderilmez. Ders ve plan içeriği uygulamanın içindedir.',
            ),
            _privacyDetail(
              dialogContext,
              'Yedek ne içerir?',
              'JSON yedeği profilleri ve onlar için saklanan çalışma verilerini içerir. Yedeği panoya kopyalayabilir veya seçtiğin konuma dosya olarak kaydedebilirsin. İçe aktarmada JSON dosyası seçebilir ya da metni yapıştırabilirsin; önce profil/veri grubu özeti gösterilir. Güncel biçim yedeği mevcut profil listesini ve çalışma verisini değiştirir. Son başarılı dışa aktarma zamanı yalnız bu cihazda tutulur.',
            ),
            _privacyDetail(
              dialogContext,
              'Hatırlatıcı ne saklar?',
              'Android/iOS günlük hatırlatıcısı varsayılan olarak kapalıdır. Açarsan izin, saat ve tek bir günlük yerel bildirim bu cihazda tutulur; JSON yedeğine eklenmez. Kilit ekranında etkin profil adı ve kişisel plan hedefi görünebilir. Profil veya hedef tarih değiştiğinde bildirim yeniden planlanır.',
            ),
            _privacyDetail(
              dialogContext,
              'Silme ne yapar?',
              '“Çalışma Verilerini Sil” tüm profillerin çalışma ilerlemesini ve tercihlerini siler; profil listesini ve görünüm tercihini korur. İşlem geri alınamaz; önce yedek al.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Widget _privacyDetail(
    BuildContext context,
    String heading,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }

  Future<void> _chooseProfile(BuildContext context, AppState state) async {
    final selectedProfileId = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(dialogContext).colorScheme.surface,
        title: const Text('Sınav profili seç'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: state.profiles.map((profile) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                profile.id == state.activeProfile.id
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: profile.id == state.activeProfile.id
                    ? AppTheme.accentBlue
                    : Theme.of(dialogContext).colorScheme.onSurfaceVariant,
              ),
              title: Text(profile.name),
              subtitle: Text(_formatDate(profile.targetDate)),
              onTap: () => Navigator.of(dialogContext).pop(profile.id),
            );
          }).toList(),
        ),
      ),
    );

    if (selectedProfileId == null ||
        selectedProfileId == state.activeProfile.id) {
      return;
    }
    await state.switchActiveProfile(selectedProfileId);
  }

  Future<void> _createProfile(BuildContext context, AppState state) async {
    final nameController = TextEditingController();
    const dayNames = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final currentPreferences = state.schedulePreferences;
    var availableDays = currentPreferences.availableWeekdays.toSet();
    var minutes = currentPreferences.dailyStudyMinutes.toDouble();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final activeDate = state.activeProfile.targetDate;
    DateTime? targetDate = activeDate.isBefore(today)
        ? today.add(const Duration(days: 180))
        : activeDate;
    var showNameError = false;
    var showDateError = false;
    var showDayError = false;
    final lastDate = DateTime(now.year + 10, 12, 31);
    final fallbackDate = today.add(const Duration(days: 180));

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(dialogContext).colorScheme.surface,
          scrollable: true,
          title: const Text('Yeni YKS profili'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tarih kişisel plan hedefidir; resmî YKS tarihi değildir.',
                style: Theme.of(
                  dialogContext,
                ).textTheme.bodySmall?.copyWith(fontSize: 12),
                textAlign: TextAlign.left,
              ),
              TextField(
                controller: nameController,
                maxLength: 40,
                decoration: InputDecoration(
                  labelText: 'Profil adı',
                  hintText: 'Örn. 2027 YKS hazırlığı',
                  errorText: showNameError ? 'Profil adı boş olamaz.' : null,
                ),
                onChanged: (value) {
                  if (showNameError && value.trim().isNotEmpty) {
                    setDialogState(() => showNameError = false);
                  }
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Kişisel hedef tarihi'),
                subtitle: Text(
                  targetDate == null
                      ? 'Bir tarih seç'
                      : _formatDate(targetDate!),
                ),
                trailing: IconButton(
                  tooltip: 'Kişisel hedef tarihini seç',
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final initialDate =
                        targetDate == null ||
                            targetDate!.isBefore(today) ||
                            targetDate!.isAfter(lastDate)
                        ? fallbackDate
                        : targetDate!;
                    final picked = await showDatePicker(
                      context: dialogContext,
                      initialDate: initialDate,
                      firstDate: today,
                      lastDate: lastDate,
                    );
                    if (picked != null) {
                      setDialogState(() {
                        targetDate = picked;
                        showDateError = false;
                      });
                    }
                  },
                ),
              ),
              if (showDateError)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Devam etmek için bugün veya sonrası için bir tarih seç.',
                    style: TextStyle(color: AppTheme.accentRed, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Çalışabileceğin günler',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 5,
                runSpacing: 0,
                children: List.generate(7, (index) {
                  final weekday = index + 1;
                  return FilterChip(
                    visualDensity: VisualDensity.compact,
                    label: Text(dayNames[index]),
                    selected: availableDays.contains(weekday),
                    onSelected: (selected) {
                      setDialogState(() {
                        if (selected) {
                          availableDays.add(weekday);
                        } else if (availableDays.length > 1) {
                          availableDays.remove(weekday);
                        } else {
                          showDayError = true;
                          return;
                        }
                        showDayError = false;
                      });
                    },
                  );
                }),
              ),
              if (showDayError)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'En az bir çalışma günü seçili kalmalı.',
                    style: TextStyle(color: AppTheme.accentRed, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Günlük süre hedefi: ${minutes.toInt()} dakika',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Slider(
                value: minutes,
                min: 30,
                max: 480,
                divisions: 30,
                label: '${minutes.toInt()} dk',
                onChanged: (value) => setDialogState(() => minutes = value),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Etkin profilindeki gün ve süre başlangıç seçimi olarak gelir. Seçimin yalnızca yeni profile kaydedilir; daha sonra Ayarlar’dan değiştirilebilir.',
                  style: Theme.of(
                    dialogContext,
                  ).textTheme.bodySmall?.copyWith(fontSize: 12),
                ),
              ),
              if (state.completedExams > 0)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Mevcut profilindeki kayıtlar korunur; yeni profil boş başlar.',
                    style: Theme.of(
                      dialogContext,
                    ).textTheme.bodySmall?.copyWith(fontSize: 12),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  setDialogState(() => showNameError = true);
                  return;
                }
                if (targetDate == null || targetDate!.isBefore(today)) {
                  setDialogState(() => showDateError = true);
                  return;
                }
                if (availableDays.isEmpty) {
                  setDialogState(() => showDayError = true);
                  return;
                }
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Oluştur'),
            ),
          ],
        ),
      ),
    );

    try {
      if (saved == true && targetDate != null) {
        await state.createYksProfile(
          name: nameController.text.trim(),
          targetDate: targetDate!,
          schedulePreferences: StudySchedulePreferences(
            availableWeekdays: availableDays.toList()..sort(),
            dailyStudyMinutes: minutes.toInt(),
          ),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Yeni YKS profili oluşturuldu ve etkinleştirildi.'),
              backgroundColor: AppTheme.accentGreen,
            ),
          );
        }
      }
    } finally {
      nameController.dispose();
    }
  }

  Future<void> _editProfile(BuildContext context, AppState state) async {
    final profile = state.activeProfile;
    final nameController = TextEditingController(text: profile.name);
    var targetDate = profile.targetDate;
    var showNameError = false;
    var showDateError = false;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(dialogContext).colorScheme.surface,
          title: const Text('Kişisel plan hedefini düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                maxLength: 40,
                decoration: InputDecoration(
                  labelText: 'Profil adı',
                  errorText: showNameError ? 'Profil adı boş olamaz.' : null,
                ),
                onChanged: (value) {
                  if (showNameError && value.trim().isNotEmpty) {
                    setDialogState(() => showNameError = false);
                  }
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Kişisel hedef tarihi'),
                subtitle: Text(_formatDate(targetDate)),
                trailing: IconButton(
                  tooltip: 'Kişisel hedef tarihini seç',
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final lastDate = DateTime(now.year + 10, 12, 31);
                    final initialDate = targetDate.isBefore(today)
                        ? today
                        : targetDate.isAfter(lastDate)
                        ? lastDate
                        : targetDate;
                    final picked = await showDatePicker(
                      context: dialogContext,
                      initialDate: initialDate,
                      firstDate: today,
                      lastDate: lastDate,
                    );
                    if (picked != null) {
                      setDialogState(() {
                        targetDate = picked;
                        showDateError = false;
                      });
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bu tarih planını düzenler; resmî YKS tarihi değildir.',
                  style: Theme.of(
                    dialogContext,
                  ).textTheme.bodySmall?.copyWith(fontSize: 12),
                ),
              ),
              if (showDateError)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Geçmiş hedef tarihi kullanılamaz. Takvimden yeni bir tarih seç.',
                    style: TextStyle(color: AppTheme.accentRed, fontSize: 12),
                  ),
                ),
              if (state.completedExams > 0)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Tamamlanan günler ve deneme sonuçları hedef tarihini değiştirsen de bu profilde kalır. Yeni sınav dönemi için yeni profil açabilirsin.',
                    style: Theme.of(
                      dialogContext,
                    ).textTheme.bodySmall?.copyWith(fontSize: 12),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  setDialogState(() => showNameError = true);
                  return;
                }
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final selectedDate = DateTime(
                  targetDate.year,
                  targetDate.month,
                  targetDate.day,
                );
                if (selectedDate.isBefore(today)) {
                  setDialogState(() => showDateError = true);
                  return;
                }
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );

    try {
      if (saved == true) {
        await state.updateActiveProfile(
          name: nameController.text.trim(),
          targetDate: targetDate,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sınav profili güncellendi.'),
              backgroundColor: AppTheme.accentGreen,
            ),
          );
        }
      }
    } finally {
      nameController.dispose();
    }
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  String _formatDateTime(DateTime date) =>
      '${_formatDate(date)} ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  Future<void> _importData(BuildContext context, AppState state) async {
    final controller = TextEditingController();
    try {
      final rawBackup = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(ctx).colorScheme.surface,
          scrollable: true,
          title: const Text('Veri içe aktar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'JSON yedeği seç veya yapıştır. Önce biçimi doğrulanıp içeriği gösterilecek.',
                style: Theme.of(
                  ctx,
                ).textTheme.bodySmall?.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 4,
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      await _pasteBackupFromClipboard(ctx, controller);
                    },
                    icon: const Icon(Icons.content_paste_rounded, size: 18),
                    label: const Text('Panodan yapıştır'),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      await _pickBackupFile(ctx, controller);
                    },
                    icon: const Icon(Icons.folder_open_rounded, size: 18),
                    label: const Text('JSON dosyası seç'),
                  ),
                ],
              ),
              TextField(
                controller: controller,
                maxLines: 7,
                decoration: const InputDecoration(hintText: 'JSON buraya...'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Yedeği doğrula'),
            ),
          ],
        ),
      );
      if (rawBackup == null || rawBackup.isEmpty) return;

      final decoded = jsonDecode(rawBackup);
      if (decoded is! Map) {
        throw const FormatException('Yedek JSON kökünde nesne bulunmalı.');
      }
      final data = Map<String, dynamic>.from(decoded);
      final preview = await ProfileStorage.instance.previewBackup(data);
      if (!context.mounted) return;

      final legacyDetails =
          'Eski biçimli yedek, etkin “${preview.profileNames.single}” '
          'profilindeki ${preview.dataGroupCount} veri grubunu güncelleyecek; '
          'yedekte olmayan veriler korunacak.';
      final profileDetails =
          '${preview.profileNames.length} profil ve '
          '${preview.dataGroupCount} veri grubu içe aktarılacak:\n\n'
          '${preview.profileNames.map((name) => '• $name').join('\n')}\n\n'
          'Bu işlem cihazdaki mevcut profil listesini ve çalışma verilerini '
          'yedekle değiştirir. Yedekte bulunmayan profil ve veriler kaldırılır.';
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(ctx).colorScheme.surface,
          scrollable: true,
          title: const Text('Yedek doğrulandı'),
          content: Text(
            preview.isLegacy ? legacyDetails : profileDetails,
            style: Theme.of(ctx).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Yedeği yükle'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;

      final previousBackup = await ProfileStorage.instance.exportBackup();
      await ProfileStorage.instance.importBackup(data);
      await state.loadData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Veriler yüklendi. Kısa süre içinde geri alabilirsin.',
            ),
            backgroundColor: AppTheme.accentGreen,
            duration: const Duration(seconds: 12),
            action: SnackBarAction(
              label: 'Geri al',
              onPressed: () {
                unawaited(_undoBackupImport(context, state, previousBackup));
              },
            ),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Yedek yüklenemedi: $error'),
            backgroundColor: AppTheme.accentRed,
          ),
        );
      }
    } finally {
      controller.dispose();
    }
  }

  Future<void> _pasteBackupFromClipboard(
    BuildContext context,
    TextEditingController controller,
  ) async {
    try {
      final clipboard = await Clipboard.getData('text/plain');
      final text = clipboard?.text?.trim();
      if (!context.mounted) return;
      if (text == null || text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Panoda yapıştırılacak yedek yok.')),
        );
        return;
      }
      controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Panoya erişilemedi: $error'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
    }
  }

  Future<void> _pickBackupFile(
    BuildContext context,
    TextEditingController controller,
  ) async {
    try {
      final result = await FilePicker.pickFiles(
        dialogTitle: 'Sınav Rotası yedeğini seç',
        type: FileType.custom,
        allowedExtensions: const ['json'],
        allowMultiple: false,
        withData: true,
      );
      if (!context.mounted || result == null) return;

      final file = result.files.single;
      if (file.size > 10 * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Yedek dosyası 10 MB sınırını aşıyor.')),
        );
        return;
      }
      final Uint8List? bytes = file.bytes;
      if (bytes == null) {
        throw const FormatException('Dosya içeriği okunamadı.');
      }
      final text = utf8.decode(bytes).replaceFirst('\uFEFF', '').trim();
      if (text.isEmpty) {
        throw const FormatException('Yedek dosyası boş.');
      }
      controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yedek dosyası okunamadı: $error'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
    }
  }

  Future<void> _undoBackupImport(
    BuildContext context,
    AppState state,
    Map<String, dynamic> previousBackup,
  ) async {
    try {
      await ProfileStorage.instance.importBackup(previousBackup);
      await state.loadData();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Önceki veriler geri yüklendi.'),
          backgroundColor: AppTheme.accentGreen,
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Geri alma başarısız: $error'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
    }
  }

  Future<void> _confirmReset(BuildContext context, AppState state) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        title: const Text('Emin misin?'),
        content: Text(
          'Tüm profillerdeki ilerleme, plan kayıtları ve çalışma gün/süre tercihleri, denemeler, zayıf konular, hedefler, rozetler, bilgi kartı durumu ve özel ders/konu kataloğu silinecek. Sınav profilleri ve görünüm tercihleri korunur. Bu işlem geri alınamaz.',
          style: Theme.of(ctx).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () async {
              await ProfileStorage.instance.clearStudyData();
              await state.loadData();
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Çalışma verileri silindi.'),
                    backgroundColor: AppTheme.accentRed,
                  ),
                );
              }
            },
            child: const Text(
              'Hepsini Sil',
              style: TextStyle(color: AppTheme.accentRed),
            ),
          ),
        ],
      ),
    );
  }
}
