import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../models/study_session.dart';
import '../models/pomodoro_timer_state.dart';

class PomodoroScreen extends StatefulWidget {
  final bool autoStart;
  final String? taskTitle;
  final String? taskId;

  const PomodoroScreen({
    super.key,
    this.autoStart = false,
    this.taskTitle,
    this.taskId,
  });

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen>
    with TickerProviderStateMixin {
  static const int workMinutes = 25;
  static const int shortBreakMinutes = 5;
  static const int longBreakMinutes = 15;

  int _totalSeconds = workMinutes * 60;
  int _remainingSeconds = workMinutes * 60;
  bool _isRunning = false;
  bool _isBreak = false;
  int _completedPomodoros = 0;
  int _totalStudyMinutes = 0;
  Timer? _timer;
  late AnimationController _pulseController;
  bool _reduceMotion = false;
  bool _restoreChecked = false;
  bool _isTimerActive = false;
  bool _phaseEndInProgress = false;
  bool _timerSaveFailed = false;
  StudySessionStatus? _pendingSessionStatus;
  DateTime? _pendingSessionEndedAt;
  int? _pendingSessionActiveSeconds;
  AppState? _appState;
  String? _timerProfileId;
  String? _timerTaskId;
  String? _timerTaskTitle;
  String? _sessionId;
  String? _sessionProfileId;
  DateTime? _sessionStartedAt;
  DateTime? _activeSegmentStartedAt;
  DateTime? _phaseDeadline;
  int _sessionActiveSeconds = 0;
  int _activeSegmentBudgetSeconds = 0;

  int get _nextBreakDurationSeconds =>
      _completedPomodoros > 0 && _completedPomodoros % 4 == 0
      ? longBreakMinutes * 60
      : shortBreakMinutes * 60;

  @override
  void initState() {
    super.initState();
    _timerTaskId = widget.taskId;
    _timerTaskTitle = widget.taskTitle;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appState ??= Provider.of<AppState>(context, listen: false);
    if (!_restoreChecked) {
      _restoreChecked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _restoreSavedTimer();
      });
    }
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    _reduceMotion = reduceMotion;
    if (_reduceMotion) {
      _pulseController.stop();
      _pulseController.value = 0;
    } else if (!_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _restoreSavedTimer() {
    final saved = _appState?.pomodoroTimerState;
    if (saved == null || !saved.isActive) {
      if (widget.autoStart) _startTimer();
      return;
    }
    final now = DateTime.now();
    _timerProfileId = saved.profileId;
    _timerTaskId = saved.taskId;
    _timerTaskTitle = saved.taskTitle;
    _isTimerActive = true;
    _isRunning = saved.isRunning;
    _isBreak = saved.isBreak;
    _completedPomodoros = saved.completedPomodoros;
    _totalSeconds = _isBreak ? _nextBreakDurationSeconds : workMinutes * 60;
    _remainingSeconds = saved.remainingAt(now);
    _phaseDeadline = saved.phaseDeadline;
    _sessionId = saved.sessionId;
    _sessionProfileId = saved.sessionId == null ? null : saved.profileId;
    _sessionStartedAt = saved.sessionStartedAt;
    _sessionActiveSeconds = saved.sessionActiveSeconds;
    _activeSegmentStartedAt = saved.activeSegmentStartedAt;
    _activeSegmentBudgetSeconds = saved.activeSegmentBudgetSeconds;
    _pendingSessionStatus = saved.pendingSessionStatus;
    _pendingSessionEndedAt = saved.pendingSessionEndedAt;
    _pendingSessionActiveSeconds = saved.pendingSessionActiveSeconds;
    _totalStudyMinutes = _completedPomodoros * workMinutes;
    if (!_isBreak && _isRunning) {
      _totalStudyMinutes += (workMinutes * 60 - _remainingSeconds) ~/ 60;
    }
    setState(() {});

    if (_pendingSessionStatus == StudySessionStatus.cancelled) {
      unawaited(_resetTimer());
    } else if (_pendingSessionStatus != null) {
      unawaited(
        _handlePhaseEnd(
          skipped: _pendingSessionStatus == StudySessionStatus.skipped,
        ),
      );
    } else if (_isRunning) {
      if (_remainingSeconds == 0) {
        unawaited(_handlePhaseEnd(skipped: false));
      } else {
        _scheduleTimer();
      }
    }
  }

  void _startTimer() {
    final now = DateTime.now();
    _timerProfileId ??= _appState?.activeProfile.id;
    _isTimerActive = true;
    _phaseDeadline = now.add(Duration(seconds: _remainingSeconds));
    if (!_isBreak) {
      if (_sessionStartedAt == null) {
        final profileId = _timerProfileId;
        if (profileId != null) {
          _sessionProfileId = profileId;
          _sessionId = 'session_${profileId}_${now.microsecondsSinceEpoch}';
          _sessionStartedAt = now;
          _sessionActiveSeconds = 0;
        }
      }
      _activeSegmentStartedAt = now;
      _activeSegmentBudgetSeconds = _remainingSeconds;
    }
    setState(() => _isRunning = true);
    _scheduleTimer();
    unawaited(_persistTimerState());
  }

  void _scheduleTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = _remainingAt(DateTime.now());
      if (remaining > 0) {
        setState(() => _remainingSeconds = remaining);
        if (!_isBreak) {
          _totalStudyMinutes =
              (_completedPomodoros * workMinutes) +
              ((workMinutes * 60 - remaining) ~/ 60);
        }
      } else {
        unawaited(_handlePhaseEnd(skipped: false));
      }
    });
  }

  int _remainingAt(DateTime now) {
    final deadline = _phaseDeadline;
    if (deadline == null) return _remainingSeconds;
    final remaining = deadline.difference(now).inSeconds;
    if (remaining <= 0) return 0;
    return remaining > _totalSeconds ? _totalSeconds : remaining;
  }

  Future<void> _handlePhaseEnd({required bool skipped}) async {
    if (_phaseEndInProgress) return;
    _phaseEndInProgress = true;
    _timer?.cancel();
    if (!_isBreak) {
      _pendingSessionStatus ??= skipped
          ? StudySessionStatus.skipped
          : StudySessionStatus.completed;
      final finishStatus = _pendingSessionStatus!;
      final saved = await _finishCurrentSession(finishStatus);
      if (!saved) {
        _phaseEndInProgress = false;
        if (mounted) setState(() => _remainingSeconds = 0);
        await _persistTimerState();
        _schedulePendingSessionRetry();
        return;
      }
      if (finishStatus == StudySessionStatus.completed) _completedPomodoros++;
      _totalStudyMinutes = _completedPomodoros * workMinutes;
      _pendingSessionStatus = null;
    }
    if (!mounted) {
      _phaseEndInProgress = false;
      return;
    }
    setState(() {
      _isRunning = false;
      _isTimerActive = true;
      _phaseDeadline = null;
      _isBreak = !_isBreak;
      _totalSeconds = _isBreak ? _nextBreakDurationSeconds : workMinutes * 60;
      _remainingSeconds = _totalSeconds;
    });
    _phaseEndInProgress = false;
    await _persistTimerState();
  }

  Future<bool> _finishCurrentSession(StudySessionStatus status) async {
    final sessionId = _sessionId;
    final profileId = _sessionProfileId;
    final startedAt = _sessionStartedAt;
    final state = _appState;
    if (sessionId == null || profileId == null || startedAt == null) {
      return true;
    }

    final eventStatus = _pendingSessionStatus ?? status;
    _pendingSessionStatus ??= eventStatus;
    final endedAt = _pendingSessionEndedAt ??= DateTime.now();
    final activeSeconds = _pendingSessionActiveSeconds ??= _activeSecondsAt(
      endedAt,
    );
    final safeEndedAt = endedAt.isBefore(startedAt) ? startedAt : endedAt;
    if (state == null) return false;
    final saved = await state.recordStudySession(
      StudySession(
        id: sessionId,
        profileId: profileId,
        taskId: _timerTaskId,
        topicId: null,
        startedAt: startedAt,
        endedAt: safeEndedAt,
        activeSeconds: activeSeconds,
        status: eventStatus,
      ),
    );
    if (!saved) return false;
    if (_sessionId == sessionId) {
      _sessionId = null;
      _sessionProfileId = null;
      _sessionStartedAt = null;
      _activeSegmentStartedAt = null;
      _sessionActiveSeconds = 0;
      _activeSegmentBudgetSeconds = 0;
      _pendingSessionEndedAt = null;
      _pendingSessionActiveSeconds = null;
    }
    return true;
  }

  int _activeSecondsAt(DateTime endedAt) {
    var activeSeconds = _sessionActiveSeconds;
    final segmentStartedAt = _activeSegmentStartedAt;
    if (segmentStartedAt != null) {
      final elapsed = endedAt.difference(segmentStartedAt).inSeconds;
      final nonNegativeElapsed = elapsed < 0 ? 0 : elapsed;
      activeSeconds += nonNegativeElapsed > _activeSegmentBudgetSeconds
          ? _activeSegmentBudgetSeconds
          : nonNegativeElapsed;
    }
    return activeSeconds < 0 ? 0 : activeSeconds;
  }

  void _schedulePendingSessionRetry() {
    if (!mounted || _pendingSessionStatus == null) return;
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      if (_pendingSessionStatus == StudySessionStatus.cancelled) {
        unawaited(_resetTimer());
      } else {
        unawaited(
          _handlePhaseEnd(
            skipped: _pendingSessionStatus == StudySessionStatus.skipped,
          ),
        );
      }
    });
  }

  void _pauseTimer() {
    if (_phaseEndInProgress) return;
    _timer?.cancel();
    final remaining = _remainingAt(DateTime.now());
    if (remaining == 0) {
      unawaited(
        _handlePhaseEnd(
          skipped: _pendingSessionStatus == StudySessionStatus.skipped,
        ),
      );
      return;
    }
    _remainingSeconds = remaining;
    _phaseDeadline = null;
    final segmentStartedAt = _activeSegmentStartedAt;
    if (!_isBreak && segmentStartedAt != null) {
      final elapsed = DateTime.now().difference(segmentStartedAt).inSeconds;
      final nonNegativeElapsed = elapsed < 0 ? 0 : elapsed;
      _sessionActiveSeconds += nonNegativeElapsed > _activeSegmentBudgetSeconds
          ? _activeSegmentBudgetSeconds
          : nonNegativeElapsed;
      _activeSegmentStartedAt = null;
      _activeSegmentBudgetSeconds = 0;
    }
    setState(() => _isRunning = false);
    unawaited(_persistTimerState());
  }

  Future<void> _resetTimer() async {
    if (_phaseEndInProgress) return;
    _timer?.cancel();
    _pendingSessionStatus ??= StudySessionStatus.cancelled;
    final saved = await _finishCurrentSession(_pendingSessionStatus!);
    if (!saved) {
      await _persistTimerState();
      _schedulePendingSessionRetry();
      return;
    }
    _pendingSessionStatus = null;
    _pendingSessionEndedAt = null;
    _pendingSessionActiveSeconds = null;
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _isTimerActive = false;
      _isBreak = false;
      _phaseDeadline = null;
      _activeSegmentBudgetSeconds = 0;
      _totalSeconds = workMinutes * 60;
      _remainingSeconds = _totalSeconds;
    });
    await _persistTimerState();
    _timerProfileId = null;
  }

  PomodoroTimerState? _timerStateSnapshot({bool? activeOverride}) {
    final profileId = _timerProfileId ?? _appState?.activeProfile.id;
    if (profileId == null) return null;
    return PomodoroTimerState(
      profileId: profileId,
      isActive: activeOverride ?? _isTimerActive,
      isRunning: _isRunning,
      isBreak: _isBreak,
      remainingSeconds: _remainingAt(DateTime.now()),
      phaseDeadline: _phaseDeadline,
      taskId: _timerTaskId,
      taskTitle: _timerTaskTitle,
      completedPomodoros: _completedPomodoros,
      sessionId: _sessionId,
      sessionStartedAt: _sessionStartedAt,
      sessionActiveSeconds: _sessionActiveSeconds,
      activeSegmentStartedAt: _activeSegmentStartedAt,
      activeSegmentBudgetSeconds: _activeSegmentBudgetSeconds,
      pendingSessionStatus: _pendingSessionStatus,
      pendingSessionEndedAt: _pendingSessionEndedAt,
      pendingSessionActiveSeconds: _pendingSessionActiveSeconds,
    );
  }

  Future<void> _persistTimerState({bool? activeOverride}) async {
    final snapshot = _timerStateSnapshot(activeOverride: activeOverride);
    if (snapshot == null) return;
    final saved = await _appState?.savePomodoroTimerState(snapshot) ?? false;
    if (!saved && !_timerSaveFailed && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Zamanlayıcı durumu kaydedilemedi. Uygulama kapanırsa son değişiklik geri gelmeyebilir.',
          ),
          duration: Duration(seconds: 8),
        ),
      );
    }
    _timerSaveFailed = !saved;
  }

  String get _timeDisplay {
    int min = _remainingSeconds ~/ 60;
    int sec = _remainingSeconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  double get _progress =>
      _totalSeconds == 0 ? 0 : 1.0 - (_remainingSeconds / _totalSeconds);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardSurface = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final cardBorder = isDark ? AppTheme.borderDark : AppTheme.borderLight;
    final secondaryText =
        theme.textTheme.bodySmall?.color ?? colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro Zamanlayici')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey(_isBreak),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: _isBreak
                        ? AppTheme.successGradient
                        : AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isBreak ? 'Mola zamanı' : 'Çalışma zamanı',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (_timerTaskTitle case final title?) ...[
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: cardSurface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: cardBorder),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.route_rounded,
                            color: AppTheme.accentGreen,
                            size: 19,
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BUGÜNÜN ROTASI',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppTheme.accentGreen,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.1,
                                    ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: colorScheme.onSurface),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 40),

              // Timer circle
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = _isRunning
                      ? 1.0 + (_pulseController.value * 0.02)
                      : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: SizedBox(
                      width: 260,
                      height: 260,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 260,
                            height: 260,
                            child: CircularProgressIndicator(
                              value: _progress,
                              strokeWidth: 8,
                              backgroundColor: cardBorder,
                              valueColor: AlwaysStoppedAnimation(
                                _isBreak
                                    ? AppTheme.accentGreen
                                    : AppTheme.accentBlue,
                              ),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cardSurface,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (_isBreak
                                              ? AppTheme.accentGreen
                                              : AppTheme.accentBlue)
                                          .withValues(alpha: 0.15),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _timeDisplay,
                                  style: TextStyle(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.onSurface,
                                    letterSpacing: 4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _isBreak ? 'Mola' : 'Çalışma',
                                  style: TextStyle(
                                    color: secondaryText,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _controlButton(
                    context,
                    Icons.refresh,
                    'Sıfırla',
                    _resetTimer,
                    AppTheme.accentPurple,
                  ),
                  const SizedBox(width: 20),
                  Semantics(
                    button: true,
                    label: _isRunning
                        ? 'Zamanlayıcıyı duraklat'
                        : 'Odak seansını başlat',
                    child: ExcludeSemantics(
                      child: Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: _isRunning ? _pauseTimer : _startTimer,
                          customBorder: const CircleBorder(),
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: _isBreak
                                  ? AppTheme.successGradient
                                  : AppTheme.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (_isBreak
                                              ? AppTheme.accentGreen
                                              : AppTheme.accentBlue)
                                          .withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isRunning
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  _controlButton(context, Icons.skip_next, 'Atla', () {
                    final remaining = _remainingAt(DateTime.now());
                    _handlePhaseEnd(skipped: !_isBreak && remaining > 0);
                  }, AppTheme.accentCyan),
                ],
              ),
              const SizedBox(height: 40),

              // Stats
              Row(
                children: [
                  _statCard(
                    'Pomodoro',
                    '$_completedPomodoros',
                    AppTheme.accentRed,
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    'Dakika',
                    '$_totalStudyMinutes dk',
                    AppTheme.accentBlue,
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    'Set',
                    '${_completedPomodoros ~/ 4}',
                    AppTheme.accentOrange,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Integration info
              Consumer<AppState>(
                builder: (context, state, _) {
                  final now = DateTime.now();
                  final sessions = state.completedStudySessionsOn(now);
                  final minutes = state.studyMinutesOn(now);
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.sync, color: colorScheme.primary, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Bugün: $sessions tamamlanan seans · $minutes odak dakikası',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Tips
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pomodoro tekniği',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '25 dk çalış, 5 dk mola\nHer 4 Pomodorodan sonra 15 dk uzun mola\nTamamlanan seanslar otomatik kaydedilir.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondaryText,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
    Color accent,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(16);
    return Semantics(
      button: true,
      label: label,
      child: ExcludeSemantics(
        child: Tooltip(
          message: label,
          child: Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: isDark ? 0.15 : 0.13),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: accent.withValues(alpha: 0.32),
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: theme.colorScheme.onSurface,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_closeTimer());
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _closeTimer() async {
    if (_phaseEndInProgress) return;
    final hadActiveTimer = _isTimerActive || _isRunning;
    if (_sessionStartedAt != null) {
      _pendingSessionStatus ??= StudySessionStatus.cancelled;
      final saved = await _finishCurrentSession(_pendingSessionStatus!);
      if (!saved) {
        _pendingSessionStatus = StudySessionStatus.cancelled;
        await _persistTimerState();
        return;
      }
    }
    _pendingSessionStatus = null;
    _pendingSessionEndedAt = null;
    _pendingSessionActiveSeconds = null;
    if (!hadActiveTimer) return;
    _isRunning = false;
    _isTimerActive = false;
    _phaseDeadline = null;
    _activeSegmentStartedAt = null;
    _activeSegmentBudgetSeconds = 0;
    await _persistTimerState(activeOverride: false);
  }
}
