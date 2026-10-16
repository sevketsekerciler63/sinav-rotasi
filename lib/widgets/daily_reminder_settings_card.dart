import 'package:flutter/material.dart';

import '../models/exam_profile.dart';
import '../services/daily_reminder_service.dart';

class DailyReminderSettingsCard extends StatefulWidget {
  const DailyReminderSettingsCard({required this.profile, super.key});

  final ExamProfile profile;

  @override
  State<DailyReminderSettingsCard> createState() =>
      _DailyReminderSettingsCardState();
}

class _DailyReminderSettingsCardState extends State<DailyReminderSettingsCard> {
  DailyReminderSettings _settings = const DailyReminderSettings(
    enabled: false,
    hour: 20,
    minute: 0,
  );
  bool _loaded = false;
  bool _busy = false;
  bool? _permissionAllowed;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant DailyReminderSettingsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.id != widget.profile.id ||
        oldWidget.profile.name != widget.profile.name ||
        oldWidget.profile.targetDate != widget.profile.targetDate) {
      _refreshSchedule();
    }
  }

  Future<void> _load() async {
    try {
      final settings = await DailyReminderService.readSettings();
      final permission = await DailyReminderService.notificationsAllowed();
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _permissionAllowed = permission;
        _loaded = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loaded = true);
      _showMessage('Hatırlatıcı ayarı okunamadı: $error');
    }
  }

  Future<void> _refreshSchedule() async {
    try {
      await DailyReminderService.syncForProfile(
        profileName: widget.profile.name,
        targetDate: widget.profile.targetDate,
      );
    } catch (error) {
      _showMessage('Hatırlatıcı yeniden planlanamadı: $error');
    } finally {
      await _load();
    }
  }

  Future<void> _toggle(bool enabled) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      if (enabled) {
        final granted = await DailyReminderService.enable(
          hour: _settings.hour,
          minute: _settings.minute,
          profileName: widget.profile.name,
          targetDate: widget.profile.targetDate,
        );
        if (!granted) {
          _showMessage(
            'Bildirim izni verilmedi. Hatırlatıcı kapalı kaldı; izni cihaz ayarlarından açabilirsin.',
          );
        }
      } else {
        await DailyReminderService.disable();
      }
      await _load();
    } catch (error) {
      _showMessage('Hatırlatıcı güncellenemedi: $error');
      await _load();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _chooseTime() async {
    if (_busy || !DailyReminderService.isSupportedPlatform) return;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _settings.hour, minute: _settings.minute),
      helpText: 'Günlük hatırlatma saati',
    );
    if (picked == null || !mounted) return;

    setState(() => _busy = true);
    try {
      await DailyReminderService.updateTime(
        hour: picked.hour,
        minute: picked.minute,
        profileName: widget.profile.name,
        targetDate: widget.profile.targetDate,
      );
      await _load();
    } catch (error) {
      _showMessage('Saat değiştirilemedi: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final supported = DailyReminderService.isSupportedPlatform;
    final status = !supported
        ? 'Yerel hatırlatıcı Android ve iOS uygulamalarında kullanılabilir.'
        : !_loaded
        ? 'Hatırlatıcı tercihi yükleniyor…'
        : _settings.enabled && _permissionAllowed != true
        ? 'Bildirim izni kapalı. İzin verilene kadar bildirim gönderilmez.'
        : _settings.enabled
        ? 'Her gün ${_settings.formattedTime} · cihaz saat dilimi'
        : 'Kapalı · izin, sen etkinleştirince istenir.';

    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 12, 14),
        child: Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.notifications_active_outlined),
              title: const Text(
                'Günlük çalışma hatırlatıcısı',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(status),
              value: _settings.enabled,
              onChanged: !supported || !_loaded || _busy ? null : _toggle,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: !supported || !_loaded || _busy ? null : _chooseTime,
                icon: const Icon(Icons.schedule_rounded),
                label: Text('Saat: ${_settings.formattedTime}'),
              ),
            ),
            const SizedBox(height: 4),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hatırlatıcı yalnız bu cihazda saklanır; yedeğe eklenmez. Saat işletim sistemi tarafından yaklaşık uygulanabilir.',
                style: TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
