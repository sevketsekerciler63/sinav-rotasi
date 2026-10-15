import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/theme_state.dart';
import '../models/study_schedule_preferences.dart';
import '../services/profile_storage.dart';
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

              // Theme toggle
              const Text(
                'Gorunum',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _themeToggleCard(context),
              const SizedBox(height: 24),

              // Data section
              const Text(
                'Veri Yonetimi',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: 12),

              _settingsCard(
                icon: Icons.cloud_download,
                title: 'Veriyi Disa Aktar',
                subtitle: 'Tum ilerlemenizi JSON olarak kopyala',
                color: AppTheme.accentBlue,
                onTap: () => _exportData(context),
              ),

              _settingsCard(
                icon: Icons.cloud_upload,
                title: 'Veriyi Ice Aktar',
                subtitle: 'JSON verisini yapistirarak geri yukle',
                color: AppTheme.accentGreen,
                onTap: () => _importData(context, state),
              ),

              _settingsCard(
                icon: Icons.delete_forever,
                title: 'Çalışma Verilerini Sil',
                subtitle: 'İlerleme, plan ve çalışma tercihleri silinir.',
                color: AppTheme.accentRed,
                onTap: () => _confirmReset(context, state),
              ),

              const SizedBox(height: 24),

              // About
              const Text(
                'Hakkinda',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.borderDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sınav Rotası v1.0',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '107 konu - 95 günlük plan - 13 deneme\n29 rozet - Pomodoro - Hedef takibi',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _infoBadge('${state.completedTopics}', 'Konu'),
                        const SizedBox(width: 8),
                        _infoBadge('${state.completedDays}', 'Gun'),
                        const SizedBox(width: 8),
                        _infoBadge('${state.completedExams}', 'Deneme'),
                        const SizedBox(width: 8),
                        _infoBadge('${state.unlockedAchievements}', 'Rozet'),
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

  Widget _settingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderDark),
        ),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _themeToggleCard(BuildContext context) {
    return Consumer<ThemeState>(
      builder: (context, themeState, _) {
        final isDark = themeState.isDark;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.borderDark),
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
                    const Text(
                      'Tema',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      isDark ? 'Karanlik Mod' : 'Aydinlik Mod',
                      style: const TextStyle(fontSize: 11),
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
            backgroundColor: AppTheme.cardDark,
            scrollable: true,
            title: const Text('Çalışma planı'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hangi günler çalışabileceğini ve günlük hedef süreni seç.',
                  style: TextStyle(color: Colors.white60, fontSize: 13),
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
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    height: 1.4,
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

  Widget _infoBadge(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.cardDarkAlt,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportData(BuildContext context) async {
    try {
      final export = await ProfileStorage.instance.exportBackup();
      final jsonStr = const JsonEncoder.withIndent('  ').convert(export);
      await Clipboard.setData(ClipboardData(text: jsonStr));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Yedek panoya kopyalandı.'),
            backgroundColor: AppTheme.accentGreen,
          ),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Yedek panoya kopyalanamadı: $error'),
          backgroundColor: AppTheme.accentRed,
        ),
      );
    }
  }

  Future<void> _chooseProfile(BuildContext context, AppState state) async {
    final selectedProfileId = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
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
                    : Colors.white54,
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
          backgroundColor: AppTheme.cardDark,
          scrollable: true,
          title: const Text('Yeni YKS profili'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Tarih kişisel plan hedefidir; resmî YKS tarihi değildir.',
                style: TextStyle(color: Colors.white60, fontSize: 12),
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Etkin profilindeki gün ve süre başlangıç seçimi olarak gelir. Seçimin yalnızca yeni profile kaydedilir; daha sonra Ayarlar’dan değiştirilebilir.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              if (state.completedExams > 0)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Mevcut profilindeki kayıtlar korunur; yeni profil boş başlar.',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
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
          backgroundColor: AppTheme.cardDark,
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bu tarih planını düzenler; resmî YKS tarihi değildir.',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
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
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Tamamlanan günler ve deneme sonuçları hedef tarihini değiştirsen de bu profilde kalır. Yeni sınav dönemi için yeni profil açabilirsin.',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
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

  Future<void> _importData(BuildContext context, AppState state) async {
    final controller = TextEditingController();
    try {
      final rawBackup = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.cardDark,
          scrollable: true,
          title: const Text(
            'Veri içe aktar',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Yedek JSON verisini yapıştır. Önce biçimi doğrulanıp içeriği gösterilecek.',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () async {
                    try {
                      final clipboard = await Clipboard.getData('text/plain');
                      final text = clipboard?.text?.trim();
                      if (!ctx.mounted) return;
                      if (text == null || text.isEmpty) {
                        ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(
                            content: Text('Panoda yapıştırılacak yedek yok.'),
                          ),
                        );
                        return;
                      }
                      controller.value = TextEditingValue(
                        text: text,
                        selection: TextSelection.collapsed(offset: text.length),
                      );
                    } catch (error) {
                      if (!ctx.mounted) return;
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text('Panoya erişilemedi: $error'),
                          backgroundColor: AppTheme.accentRed,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.content_paste_rounded, size: 18),
                  label: const Text('Panodan yapıştır'),
                ),
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
          backgroundColor: AppTheme.cardDark,
          scrollable: true,
          title: const Text(
            'Yedek doğrulandı',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            preview.isLegacy ? legacyDetails : profileDetails,
            style: const TextStyle(color: Colors.white70),
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

      await ProfileStorage.instance.importBackup(data);
      await state.loadData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veriler başarıyla yüklendi.'),
            backgroundColor: AppTheme.accentGreen,
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

  Future<void> _confirmReset(BuildContext context, AppState state) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text('Emin misin?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Tüm profillerdeki ilerleme, plan kayıtları ve çalışma gün/süre tercihleri, denemeler, zayıf konular, hedefler, rozetler, bilgi kartı durumu ve özel ders/konu kataloğu silinecek. Sınav profilleri ve görünüm tercihleri korunur. Bu işlem geri alınamaz.',
          style: TextStyle(color: Colors.white54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgec'),
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
