import '../theme/app_motion.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exam_profile.dart';
import '../models/study_schedule_preferences.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  final AppState appState;
  final Future<void> Function() onComplete;

  const OnboardingScreen({
    super.key,
    required this.appState,
    required this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pageKey = 'yks_onboarding_page';
  static const _targetDateKey = 'yks_onboarding_target_date';
  static const _weekdaysKey = 'yks_onboarding_weekdays';
  static const _minutesKey = 'yks_onboarding_minutes';
  static const _scoreTypeKey = 'yks_onboarding_score_type';
  static const _startingLevelKey = 'yks_onboarding_starting_level';

  final PageController _controller = PageController();
  int _current = 0;
  bool _draftLoaded = false;
  bool _isSaving = false;
  DateTime _targetDate = DateTime.now();
  List<int> _availableWeekdays = const [1, 2, 3, 4, 5, 6, 7];
  int _dailyStudyMinutes = 180;
  String _scoreType = ExamProfile.unspecified;
  String _startingLevel = ExamProfile.unspecified;
  String? _draftError;
  String? _setupError;
  Timer? _draftSaveTimer;
  Future<void> _draftSaveQueue = Future<void>.value();

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      emoji: '🎯',
      title: 'Sınav Rotası',
      subtitle:
          'Hedefe dayalı, günlük programlı,\ntam senin için tasarlanmış çalışma asistanı',
      gradient: AppTheme.primaryGradient,
    ),
    _OnboardingPage(
      emoji: '📅',
      title: 'Hedefine Göre Plan',
      subtitle:
          'Günlük çalışma planını ve denemelerini\nhedef tarihine göre takip et.',
      gradient: AppTheme.cyanGradient,
    ),
    _OnboardingPage(
      emoji: '📊',
      title: 'Deneme Takip',
      subtitle: 'Netlerini gir, grafiklerle\nilerlemeni takip et.',
      gradient: AppTheme.warningGradient,
    ),
    _OnboardingPage(
      emoji: '🏆',
      title: 'Başarımlar & Rozetler',
      subtitle:
          'Hedeflerine ulaştıkça rozetler kazan,\nmotivasyonunu yüksek tut!',
      gradient: AppTheme.successGradient,
    ),
    _OnboardingPage(
      emoji: '🍅',
      title: 'Pomodoro Timer',
      subtitle: '25 dk çalış, 5 dk mola\nKonsantrasyonunu artır!',
      gradient: AppTheme.dangerGradient,
    ),
  ];

  int get _pageCount => _pages.length + 1;

  @override
  void initState() {
    super.initState();
    _targetDate = widget.appState.activeProfile.targetDate;
    _availableWeekdays = List<int>.of(
      widget.appState.schedulePreferences.availableWeekdays,
    );
    _dailyStudyMinutes = widget.appState.schedulePreferences.dailyStudyMinutes;
    _scoreType = widget.appState.activeProfile.scoreType;
    _startingLevel = widget.appState.activeProfile.startingLevel;
    _restoreDraft();
  }

  Future<void> _restoreDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      final savedPage = prefs.getInt(_pageKey);
      final savedTarget = DateTime.tryParse(
        prefs.getString(_targetDateKey) ?? '',
      );
      final savedWeekdays = (prefs.getString(_weekdaysKey) ?? '')
          .split(',')
          .map(int.tryParse)
          .whereType<int>()
          .toList();
      final savedMinutes = prefs.getInt(_minutesKey);
      final savedScoreType = prefs.getString(_scoreTypeKey);
      final savedStartingLevel = prefs.getString(_startingLevelKey);
      setState(() {
        if (savedPage != null) {
          _current = savedPage < 0
              ? 0
              : savedPage >= _pageCount
              ? _pageCount - 1
              : savedPage;
        }
        if (savedTarget != null) {
          _targetDate = DateTime(
            savedTarget.year,
            savedTarget.month,
            savedTarget.day,
          );
        }
        if (savedWeekdays.isNotEmpty &&
            savedWeekdays.every((day) => day >= 1 && day <= 7) &&
            savedWeekdays.toSet().length == savedWeekdays.length) {
          _availableWeekdays = savedWeekdays..sort();
        }
        if (savedMinutes != null &&
            savedMinutes >= 30 &&
            savedMinutes <= 480 &&
            savedMinutes % 15 == 0) {
          _dailyStudyMinutes = savedMinutes;
        }
        if (savedScoreType != null &&
            ExamProfile.scoreTypeLabels.containsKey(savedScoreType)) {
          _scoreType = savedScoreType;
        }
        if (savedStartingLevel != null &&
            ExamProfile.startingLevelLabels.containsKey(savedStartingLevel)) {
          _startingLevel = savedStartingLevel;
        }
        _draftLoaded = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.hasClients) {
          _controller.jumpToPage(_current);
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _draftError = 'Kurulum ilerlemesi yüklenemedi; varsayılanlarla başla.';
        _draftLoaded = true;
      });
    }
  }

  Future<void> _persistDraft() {
    final page = _current;
    final targetDate = _targetDate.toIso8601String();
    final weekdays = _availableWeekdays.join(',');
    final minutes = _dailyStudyMinutes;
    final scoreType = _scoreType;
    final startingLevel = _startingLevel;
    final pending = _draftSaveQueue.then((_) async {
      try {
        final prefs = await SharedPreferences.getInstance();
        final results = <bool>[
          await prefs.setInt(_pageKey, page),
          await prefs.setString(_targetDateKey, targetDate),
          await prefs.setString(_weekdaysKey, weekdays),
          await prefs.setInt(_minutesKey, minutes),
          await prefs.setString(_scoreTypeKey, scoreType),
          await prefs.setString(_startingLevelKey, startingLevel),
        ];
        if (results.any((saved) => !saved)) {
          throw StateError('Taslak ayarlar saklanamadı.');
        }
        if (mounted && _draftError != null) setState(() => _draftError = null);
      } catch (_) {
        if (mounted) {
          setState(() {
            _draftError = 'Kurulum ilerlemesi bu cihazda saklanamadı.';
          });
        }
      }
    });
    _draftSaveQueue = pending;
    return pending;
  }

  void _queueDraftSave() {
    _draftSaveTimer?.cancel();
    _draftSaveTimer = Timer(const Duration(milliseconds: 250), _persistDraft);
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pageKey);
    await prefs.remove(_targetDateKey);
    await prefs.remove(_weekdaysKey);
    await prefs.remove(_minutesKey);
    await prefs.remove(_scoreTypeKey);
    await prefs.remove(_startingLevelKey);
  }

  Future<void> _finishWithoutSetup() async {
    if (_isSaving) return;
    setState(() {
      _isSaving = true;
      _setupError = null;
    });
    try {
      await widget.onComplete();
      await _clearDraft();
    } catch (_) {
      if (mounted) {
        setState(() => _setupError = 'Kurulum tamamlanamadı; tekrar dene.');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _saveSetup() async {
    if (_isSaving) return;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(
      _targetDate.year,
      _targetDate.month,
      _targetDate.day,
    );
    if (target.isBefore(today)) {
      setState(() => _setupError = 'Hedef tarihi bugünden önce olamaz.');
      return;
    }
    if (_availableWeekdays.isEmpty) {
      setState(() => _setupError = 'En az bir uygun gün seç.');
      return;
    }
    if (_scoreType == ExamProfile.unspecified ||
        _startingLevel == ExamProfile.unspecified) {
      setState(() => _setupError = 'Puan türünü ve başlangıç seviyeni seç.');
      return;
    }

    setState(() {
      _isSaving = true;
      _setupError = null;
    });
    try {
      await widget.appState.updateActiveProfile(
        targetDate: target,
        scoreType: _scoreType,
        startingLevel: _startingLevel,
        schedulePreferences: StudySchedulePreferences(
          availableWeekdays: List<int>.of(_availableWeekdays)..sort(),
          dailyStudyMinutes: _dailyStudyMinutes,
        ),
      );
      if (widget.appState.persistenceError != null) {
        throw StateError('Profil ayarları kaydedilemedi.');
      }
      await widget.onComplete();
      await _clearDraft();
    } catch (_) {
      if (mounted) {
        setState(() {
          _setupError =
              'Plan ayarları kaydedilemedi. Bilgilerin duruyor; tekrar dene.';
        });
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _goForward() async {
    if (_isSaving) return;
    if (_current < _pageCount - 1) {
      await _persistDraft();
      if (!mounted) return;
      if (AppMotion.reduced(context)) {
        _controller.jumpToPage(_current + 1);
        return;
      }
      await _controller.nextPage(
        duration: AppMotion.duration(context, AppMotion.standard),
        curve: Curves.easeInOut,
      );
      return;
    }
    await _saveSetup();
  }

  Future<void> _chooseTargetDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initialDate = _targetDate.isBefore(today) ? today : _targetDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: DateTime(today.year + 5, 12, 31),
      helpText: 'Kişisel plan hedef tarihini seç',
      cancelText: 'Vazgeç',
      confirmText: 'Seç',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _targetDate = DateTime(picked.year, picked.month, picked.day);
      _setupError = null;
    });
    _queueDraftSave();
  }

  void _toggleWeekday(int day, bool selected) {
    if (!selected && _availableWeekdays.length == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En az bir uygun gün seçili kalmalı.')),
      );
      return;
    }
    setState(() {
      if (selected) {
        _availableWeekdays = [..._availableWeekdays, day]..sort();
      } else {
        _availableWeekdays = _availableWeekdays
            .where((weekday) => weekday != day)
            .toList();
      }
      _setupError = null;
    });
    _queueDraftSave();
  }

  @override
  Widget build(BuildContext context) {
    if (!_draftLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _isSaving ? null : _finishWithoutSetup,
                child: const Text('Atla'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _current = index);
                  _persistDraft();
                },
                itemCount: _pageCount,
                itemBuilder: (context, index) {
                  if (index == _pages.length) {
                    return _buildPlanSetupPage(context);
                  }
                  final slide = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            gradient: slide.gradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: slide.gradient.colors.first.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              slide.emoji,
                              style: const TextStyle(fontSize: 56),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.subtitle,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: colors.onSurfaceVariant,
                                height: 1.5,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_current < _pages.length &&
                (_draftError != null || _setupError != null))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _setupError ?? _draftError!,
                  style: TextStyle(color: colors.error, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pageCount,
                (index) => AnimatedContainer(
                  duration: AppMotion.duration(context, AppMotion.standard),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: index == _current ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == _current
                        ? colors.primary
                        : colors.outline.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _goForward,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _current < _pageCount - 1
                              ? 'Devam'
                              : 'Planımı kaydet',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanSetupPage(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const weekdayLabels = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Planını ayarla',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Bu tercihler etkin YKS profiline kaydedilir; daha sonra Ayarlar’dan değiştirebilirsin.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.school_outlined, color: colors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Bu sürüm TYT + AYT kataloğunu destekler; YDT içeriği henüz yok. Puan türü ve seviye profile kaydedilir, planı değiştirmez.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _scoreType,
                decoration: const InputDecoration(labelText: 'Puan türü'),
                items: ExamProfile.scoreTypeLabels.entries
                    .map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _scoreType = value;
                    _setupError = null;
                  });
                  _queueDraftSave();
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _startingLevel,
                decoration: const InputDecoration(
                  labelText: 'Başlangıç seviyen (öz değerlendirme)',
                ),
                items: ExamProfile.startingLevelLabels.entries
                    .map(
                      (entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _startingLevel = value;
                    _setupError = null;
                  });
                  _queueDraftSave();
                },
              ),
              const SizedBox(height: 14),
              Text(
                'Kişisel hedef tarihi',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _chooseTargetDate,
                icon: const Icon(Icons.event_outlined),
                label: Text(_formatDate(_targetDate)),
              ),
              const SizedBox(height: 18),
              Text(
                'Çalışabileceğin günler',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (var index = 0; index < weekdayLabels.length; index++)
                    FilterChip(
                      label: Text(weekdayLabels[index]),
                      selected: _availableWeekdays.contains(index + 1),
                      onSelected: (selected) =>
                          _toggleWeekday(index + 1, selected),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Günlük çalışma hedefi',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                min: 30,
                max: 480,
                divisions: 30,
                value: _dailyStudyMinutes.toDouble(),
                label: '$_dailyStudyMinutes dk',
                onChanged: (value) {
                  setState(() {
                    _dailyStudyMinutes = value.round();
                    _setupError = null;
                  });
                  _queueDraftSave();
                },
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: Text(
                  '$_dailyStudyMinutes dakika',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (_draftError != null || _setupError != null) ...[
                const SizedBox(height: 10),
                Text(
                  _setupError ?? _draftError!,
                  style: TextStyle(color: colors.error, fontSize: 12),
                ),
              ],
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  @override
  void dispose() {
    _draftSaveTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}

class _OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final LinearGradient gradient;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}
