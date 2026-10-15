import 'study_session.dart';

class PomodoroTimerState {
  final String profileId;
  final bool isActive;
  final bool isRunning;
  final bool isBreak;
  final int remainingSeconds;
  final DateTime? phaseDeadline;
  final String? taskId;
  final String? taskTitle;
  final int completedPomodoros;
  final String? sessionId;
  final DateTime? sessionStartedAt;
  final int sessionActiveSeconds;
  final DateTime? activeSegmentStartedAt;
  final int activeSegmentBudgetSeconds;
  final StudySessionStatus? pendingSessionStatus;
  final DateTime? pendingSessionEndedAt;
  final int? pendingSessionActiveSeconds;

  const PomodoroTimerState({
    required this.profileId,
    required this.isActive,
    required this.isRunning,
    required this.isBreak,
    required this.remainingSeconds,
    required this.phaseDeadline,
    required this.taskId,
    required this.taskTitle,
    required this.completedPomodoros,
    required this.sessionId,
    required this.sessionStartedAt,
    required this.sessionActiveSeconds,
    required this.activeSegmentStartedAt,
    required this.activeSegmentBudgetSeconds,
    this.pendingSessionStatus,
    this.pendingSessionEndedAt,
    this.pendingSessionActiveSeconds,
  });

  Map<String, dynamic> toJson() => {
    'profileId': profileId,
    'isActive': isActive,
    'isRunning': isRunning,
    'isBreak': isBreak,
    'remainingSeconds': remainingSeconds,
    'phaseDeadline': phaseDeadline?.toIso8601String(),
    'taskId': taskId,
    'taskTitle': taskTitle,
    'completedPomodoros': completedPomodoros,
    'sessionId': sessionId,
    'sessionStartedAt': sessionStartedAt?.toIso8601String(),
    'sessionActiveSeconds': sessionActiveSeconds,
    'activeSegmentStartedAt': activeSegmentStartedAt?.toIso8601String(),
    'activeSegmentBudgetSeconds': activeSegmentBudgetSeconds,
    'pendingSessionStatus': pendingSessionStatus?.name,
    'pendingSessionEndedAt': pendingSessionEndedAt?.toIso8601String(),
    'pendingSessionActiveSeconds': pendingSessionActiveSeconds,
  };

  factory PomodoroTimerState.fromJson(Map<String, dynamic> json) {
    DateTime? readDate(String key) {
      final value = json[key];
      if (value == null) return null;
      if (value is! String) {
        throw FormatException('Pomodoro durumundaki $key tarihi geçersiz.');
      }
      final parsed = DateTime.tryParse(value);
      if (parsed == null) {
        throw FormatException('Pomodoro durumundaki $key tarihi geçersiz.');
      }
      return parsed;
    }

    StudySessionStatus? readPendingStatus() {
      final value = json['pendingSessionStatus'];
      if (value == null) return null;
      for (final status in StudySessionStatus.values) {
        if (status.name == value) return status;
      }
      throw const FormatException('Pomodoro bekleyen seans durumu geçersiz.');
    }

    final state = PomodoroTimerState(
      profileId: json['profileId'] as String,
      isActive: json['isActive'] as bool,
      isRunning: json['isRunning'] as bool,
      isBreak: json['isBreak'] as bool,
      remainingSeconds: json['remainingSeconds'] as int,
      phaseDeadline: readDate('phaseDeadline'),
      taskId: json['taskId'] as String?,
      taskTitle: json['taskTitle'] as String?,
      completedPomodoros: json['completedPomodoros'] as int,
      sessionId: json['sessionId'] as String?,
      sessionStartedAt: readDate('sessionStartedAt'),
      sessionActiveSeconds: json['sessionActiveSeconds'] as int,
      activeSegmentStartedAt: readDate('activeSegmentStartedAt'),
      activeSegmentBudgetSeconds: json['activeSegmentBudgetSeconds'] as int,
      pendingSessionStatus: readPendingStatus(),
      pendingSessionEndedAt: readDate('pendingSessionEndedAt'),
      pendingSessionActiveSeconds: json['pendingSessionActiveSeconds'] as int?,
    );
    if (state.profileId.trim().isEmpty ||
        state.remainingSeconds < 0 ||
        state.completedPomodoros < 0 ||
        state.sessionActiveSeconds < 0 ||
        state.activeSegmentBudgetSeconds < 0 ||
        (state.pendingSessionActiveSeconds != null &&
            state.pendingSessionActiveSeconds! < 0) ||
        (state.isRunning && state.phaseDeadline == null) ||
        (!state.isRunning && state.phaseDeadline != null) ||
        ((state.sessionId == null) != (state.sessionStartedAt == null)) ||
        (state.isBreak && state.sessionId != null) ||
        (state.isRunning && !state.isBreak && state.sessionId == null) ||
        (state.pendingSessionStatus != null &&
            (state.sessionId == null || state.isBreak || !state.isActive)) ||
        (state.isRunning &&
            !state.isBreak &&
            state.activeSegmentStartedAt == null) ||
        (state.activeSegmentStartedAt != null &&
            (!state.isRunning || state.sessionId == null)) ||
        (!state.isActive &&
            (state.isRunning ||
                state.sessionId != null ||
                state.phaseDeadline != null))) {
      throw const FormatException('Pomodoro durumu geçersiz.');
    }
    return state;
  }

  int remainingAt(DateTime now) {
    if (!isRunning || phaseDeadline == null) return remainingSeconds;
    final remaining = phaseDeadline!.difference(now).inSeconds;
    return remaining <= 0 ? 0 : remaining;
  }
}
