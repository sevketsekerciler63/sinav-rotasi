import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/topic.dart';
import '../models/daily_log.dart';
import '../models/question_event.dart';
import '../models/study_session.dart';
import '../models/pomodoro_timer_state.dart';
import '../models/legacy_daily_activity.dart';
import '../models/learning_workspace.dart';
import '../models/mock_exam.dart';
import '../models/exam_attempt.dart';
import '../models/weak_topic.dart';
import '../models/goal.dart';
import '../models/exam_profile.dart';
import '../models/study_schedule_preferences.dart';
import '../data/subjects_data.dart';
import '../data/daily_schedule_data.dart';
import '../data/exam_calendar_data.dart';
import '../data/achievements_data.dart';
import '../services/profile_storage.dart';
import '../services/daily_reminder_service.dart';
import '../services/study_history_metrics.dart';
import '../services/daily_plan_metrics.dart';
import '../services/daily_plan_migration.dart';
import '../services/achievement_progress_metrics.dart';
import '../services/mock_exam_metrics.dart';

enum AppBootStatus { loading, ready, error }

class AppState extends ChangeNotifier with WidgetsBindingObserver {
  late List<Subject> subjects;
  late List<DailyLog> dailyLogs;
  late List<MockExam> mockExams;
  List<WeakTopic> weakTopics = [];
  List<Goal> goals = [];
  final List<Object?> _quarantinedGoalRecords = [];
  List<QuestionEvent> questionEvents = [];
  List<StudySession> studySessions = [];
  PomodoroTimerState? pomodoroTimerState;
  late List<Achievement> achievements;
  final ProfileStorage _profileStorage;
  ExamProfile _activeProfile = ExamProfile.defaultYks;
  Map<String, dynamic> _dailyPlanEntries = {};
  Map<String, dynamic> _dailyLogHistory = {};
  final List<String> _quarantinedDailyPlanPayloads = [];
  bool _dailyPlanQuarantineNeedsRewrite = false;
  StudySchedulePreferences _schedulePreferences =
      StudySchedulePreferences.defaults;
  int _dataLoadRequest = 0;
  int _profileTransitionRequest = 0;
  int _questionEventSequence = 0;
  bool _isProfileTransitioning = false;
  DateTime? _planDateBuiltFor;
  Timer? _midnightPlanRefreshTimer;
  AppBootStatus _bootStatus = AppBootStatus.loading;
  Object? _loadError;
  String? _persistenceError;
  final Map<String, String> _failedWriteErrors = {};
  final Set<String> _savingMockExams = {};
  List<String> _recoveryDataKeys = [];
  late ExamAttemptBook _examAttemptBook;
  final Set<String> _pendingRecordWrites = {};
  String? recordSaveError;
  bool isSavingRecord(String group, String id) =>
      _pendingRecordWrites.contains('${activeProfile.id}:$group:$id');
  String? _examAttemptError;
  ExamAttemptBook get examAttemptBook => _examAttemptBook;
  String? get examAttemptError => _examAttemptError;
  late LearningWorkspace _learningWorkspace;
  String? _learningWorkspaceError;

  LearningWorkspace get learningWorkspace => _learningWorkspace;
  String? get learningWorkspaceError => _learningWorkspaceError;

  ExamProfile get activeProfile => _activeProfile;
  bool get isProfileTransitioning => _isProfileTransitioning;
  AppBootStatus get bootStatus => _bootStatus;
  String? get loadErrorMessage => _loadError?.toString();
  String? get persistenceError => _persistenceError;
  List<String> get recoveryDataKeys => List.unmodifiable(_recoveryDataKeys);
  List<ExamProfile> get profiles => _profileStorage.profiles;
  List<Object?> get quarantinedGoalRecords =>
      List.unmodifiable(_quarantinedGoalRecords);
  int get quarantinedDailyPlanRecordCount =>
      _quarantinedDailyPlanPayloads.length;
  StudySchedulePreferences get schedulePreferences => _schedulePreferences;
  List<WeakTopic> get prioritizedWeakTopics =>
      DailyPlanMetrics.prioritizedWeakTopicsFor(weakTopics, DateTime.now());

  // Celebration callback
  VoidCallback? onCelebrate;
  String? lastUnlockedAchievement;

  // Kept under the old getter name because existing screens use it.
  DateTime get yksDate => activeProfile.targetDate;

  Future<void> updateActiveProfile({
    String? name,
    String? scoreType,
    String? startingLevel,
    DateTime? targetDate,
    StudySchedulePreferences? schedulePreferences,
  }) async {
    if (_isProfileTransitioning) return;
    final transitionRequest = ++_profileTransitionRequest;
    _dataLoadRequest++;
    final profileId = _activeProfile.id;
    final previousExams = {for (final exam in mockExams) exam.id: exam};
    final updatedProfile = _activeProfile.copyWith(
      name: name,
      scoreType: scoreType,
      startingLevel: startingLevel,
      targetDate: targetDate,
    );
    final validatedSchedulePreferences = schedulePreferences == null
        ? null
        : StudySchedulePreferences.fromJson(schedulePreferences.toJson());
    _isProfileTransitioning = true;
    notifyListeners();
    try {
      await _profileStorage.updateProfile(
        updatedProfile,
        additionalData: validatedSchedulePreferences == null
            ? const {}
            : {
                'schedule_preferences': jsonEncode(
                  validatedSchedulePreferences.toJson(),
                ),
              },
      );
      if (transitionRequest != _profileTransitionRequest ||
          _profileStorage.activeProfile.id != profileId) {
        return;
      }
      _activeProfile = _profileStorage.activeProfile;
      _syncDailyReminder();
      if (validatedSchedulePreferences != null) {
        _schedulePreferences = validatedSchedulePreferences;
      }
      dailyLogs = _buildDailySchedule(_activeProfile.targetDate);
      _applyDailyPlanProgress();
      _applyWeakTopicReviews();
      mockExams = getExamCalendar(targetDate: _activeProfile.targetDate);
      for (final exam in mockExams) {
        final previous = previousExams[exam.id];
        if (previous == null || !previous.isCompleted) continue;
        exam.isCompleted = previous.isCompleted;
        exam.nets = Map<String, double>.of(previous.nets);
        exam.completedAt = previous.completedAt;
        exam.updatedAt = previous.updatedAt;
        if (previous.completedAt == null) {
          // Legacy backups stored completion state and net scores, but no
          // attempt date. Keep the original template date for those records.
          exam.date = previous.date;
          exam.dayName = previous.dayName;
        }
      }
    } finally {
      if (transitionRequest == _profileTransitionRequest) {
        _isProfileTransitioning = false;
        notifyListeners();
      }
    }
  }

  Future<void> createYksProfile({
    required String name,
    required String scoreType,
    required String startingLevel,
    required DateTime targetDate,
    required StudySchedulePreferences schedulePreferences,
  }) async {
    if (_isProfileTransitioning) return;
    final now = DateTime.now();
    final normalizedTarget = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    final today = DateTime(now.year, now.month, now.day);
    if (normalizedTarget.isBefore(today)) {
      throw ArgumentError.value(
        targetDate,
        'targetDate',
        'Sınav tarihi bugünden önce olamaz.',
      );
    }
    final validatedSchedulePreferences = StudySchedulePreferences.fromJson(
      schedulePreferences.toJson(),
    );

    final profile = ExamProfile(
      id: 'yks_${DateTime.now().microsecondsSinceEpoch}',
      name: name.trim(),
      examSystem: 'YKS',
      examType: 'TYT_AYT',
      scoreType: scoreType,
      startingLevel: startingLevel,
      targetDate: normalizedTarget,
      templateId: 'yks_tyt_ayt_2026',
    );
    final transitionRequest = ++_profileTransitionRequest;
    _isProfileTransitioning = true;
    notifyListeners();
    try {
      await _profileStorage.addProfile(
        profile,
        initialData: {
          'schedule_preferences': jsonEncode(
            validatedSchedulePreferences.toJson(),
          ),
        },
      );
      if (transitionRequest != _profileTransitionRequest) return;
      await _profileStorage.setActiveProfile(profile.id);
      if (transitionRequest != _profileTransitionRequest) return;
      await loadData();
    } finally {
      if (transitionRequest == _profileTransitionRequest) {
        _isProfileTransitioning = false;
        notifyListeners();
      }
    }
  }

  Future<void> switchActiveProfile(String profileId) async {
    // Invalidate any profile load already in flight before the stored active
    // profile changes. Its result must not overwrite the next profile's state.
    final transitionRequest = ++_profileTransitionRequest;
    _dataLoadRequest++;
    _isProfileTransitioning = true;
    notifyListeners();
    try {
      await _profileStorage.setActiveProfile(profileId);
      if (transitionRequest != _profileTransitionRequest) return;
      await loadData();
    } finally {
      if (transitionRequest == _profileTransitionRequest) {
        _isProfileTransitioning = false;
        notifyListeners();
      }
    }
  }

  AppState({ProfileStorage? profileStorage})
    : _profileStorage = profileStorage ?? ProfileStorage.instance {
    _learningWorkspace = LearningWorkspace.empty(_activeProfile.id);
    _examAttemptBook = ExamAttemptBook(_activeProfile.id, []);
    WidgetsBinding.instance.addObserver(this);
    subjects = getAllSubjects();
    dailyLogs = _buildDailySchedule(_activeProfile.targetDate);
    mockExams = getExamCalendar(targetDate: _activeProfile.targetDate);
    achievements = getDefaultAchievements();

    _scheduleMidnightPlanRefresh();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    _refreshDailyScheduleForCurrentDate();
    _syncDailyReminder();
    // Recalculate from the current local clock in case the device timezone or
    // clock changed while the app was suspended.
    _scheduleMidnightPlanRefresh();
  }

  void _refreshDailyScheduleForCurrentDate() {
    if (_isProfileTransitioning) return;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (_planDateBuiltFor == today) return;
    dailyLogs = _buildDailySchedule(_activeProfile.targetDate);
    _applyDailyPlanProgress();
    _applyWeakTopicReviews();
    notifyListeners();
  }

  void _scheduleMidnightPlanRefresh() {
    _midnightPlanRefreshTimer?.cancel();
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    _midnightPlanRefreshTimer = Timer(
      nextMidnight.difference(now),
      _handleMidnightPlanRefresh,
    );
  }

  void _handleMidnightPlanRefresh() {
    if (_isProfileTransitioning) {
      // Keep the date rollover pending until the active profile is stable.
      _midnightPlanRefreshTimer = Timer(
        const Duration(seconds: 1),
        _handleMidnightPlanRefresh,
      );
      return;
    }
    _refreshDailyScheduleForCurrentDate();
    _scheduleMidnightPlanRefresh();
  }

  @override
  void dispose() {
    _midnightPlanRefreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ─── Persistence ───────────────────────────────
  Future<void> loadData() async {
    final requestId = ++_dataLoadRequest;
    _bootStatus = AppBootStatus.loading;
    _loadError = null;
    notifyListeners();
    try {
      await _loadDataForRequest(requestId);
    } catch (error) {
      if (requestId == _dataLoadRequest) {
        _bootStatus = AppBootStatus.error;
        _loadError = error;
        notifyListeners();
      }
    }
  }

  Future<void> _loadDataForRequest(int requestId) async {
    await _profileStorage.initialize();
    if (requestId != _dataLoadRequest) return;
    _activeProfile = _profileStorage.activeProfile;
    final profileId = _activeProfile.id;

    bool isCurrentRequest() =>
        requestId == _dataLoadRequest &&
        _profileStorage.activeProfile.id == profileId;

    // Rebuild defaults before applying persisted values so reset and restore
    // do not retain objects left over from the previous in-memory state.
    subjects = getAllSubjects();
    _learningWorkspace = LearningWorkspace.empty(profileId);
    _examAttemptBook = ExamAttemptBook(profileId, []);
    _examAttemptError = null;
    _learningWorkspaceError = null;
    _schedulePreferences = StudySchedulePreferences.defaults;
    dailyLogs = _buildDailySchedule(_activeProfile.targetDate);
    mockExams = getExamCalendar(targetDate: _activeProfile.targetDate);
    _dailyPlanEntries = {};
    _dailyLogHistory = {};
    _quarantinedDailyPlanPayloads.clear();
    _dailyPlanQuarantineNeedsRewrite = false;
    weakTopics = [];
    goals = [];
    _quarantinedGoalRecords.clear();
    questionEvents = [];
    studySessions = [];
    pomodoroTimerState = null;
    _questionEventSequence = 0;
    achievements = getDefaultAchievements();

    _recoveryDataKeys = [];
    final recoveryJson = await _profileStorage.readStringForProfile(
      profileId,
      'recovery_records',
    );
    if (!isCurrentRequest()) return;
    if (recoveryJson != null) {
      try {
        final archive = jsonDecode(recoveryJson);
        if (archive is Map && archive['records'] is List) {
          _recoveryDataKeys = [
            for (final record in archive['records'] as List)
              if (record is Map && record['dataKey'] is String)
                record['dataKey'] as String,
          ];
        }
      } catch (_) {
        // Inert bytes remain in storage; export can wrap a damaged archive.
      }
    }

    final curriculumJson = await _profileStorage.readStringForProfile(
      profileId,
      'custom_curriculum',
    );
    if (!isCurrentRequest()) return;
    if (curriculumJson != null) _restoreCustomCurriculum(curriculumJson);

    final workspaceJson = await _profileStorage.readStringForProfile(
      profileId,
      'learning_workspace',
    );
    if (!isCurrentRequest()) return;
    if (workspaceJson != null) {
      _learningWorkspace = LearningWorkspace.fromJson(
        Map<String, dynamic>.from(jsonDecode(workspaceJson) as Map),
      );
      if (_learningWorkspace.profileId != profileId) {
        throw const FormatException(
          'Kaynak çalışma alanı başka bir profile bağlı.',
        );
      }
    }

    final attemptJson = await _profileStorage.readStringForProfile(
      profileId,
      'exam_attempts',
    );
    if (!isCurrentRequest()) return;
    if (attemptJson != null) {
      _examAttemptBook = ExamAttemptBook.fromJson(
        Map<String, dynamic>.from(jsonDecode(attemptJson) as Map),
      );
      if (_examAttemptBook.profileId != profileId) {
        throw const FormatException('Deneme defteri başka profile bağlı.');
      }
    }

    final schedulePreferencesJson = await _profileStorage.readStringForProfile(
      profileId,
      'schedule_preferences',
    );
    if (!isCurrentRequest()) return;
    _schedulePreferences = schedulePreferencesJson == null
        ? StudySchedulePreferences.defaults
        : StudySchedulePreferences.fromJson(
            jsonDecode(schedulePreferencesJson) as Map<String, dynamic>,
          );
    dailyLogs = _buildDailySchedule(_activeProfile.targetDate);

    // Load topic completion
    final topicsJson = await _profileStorage.readStringForProfile(
      profileId,
      'topics_data',
    );
    if (!isCurrentRequest()) return;
    if (topicsJson != null) {
      final Map<String, dynamic> data = jsonDecode(topicsJson);
      for (var subject in subjects) {
        for (var topic in subject.topics) {
          if (data.containsKey(topic.id)) {
            topic.fromJson(data[topic.id]);
          }
        }
      }
    }

    // Load daily logs
    final dailyPlanQuarantineJson = await _profileStorage.readStringForProfile(
      profileId,
      'daily_logs_quarantine',
    );
    if (!isCurrentRequest()) return;
    _restoreDailyPlanQuarantine(dailyPlanQuarantineJson);

    final logsJson = await _profileStorage.readStringForProfile(
      profileId,
      'daily_logs',
    );
    if (!isCurrentRequest()) return;
    var dailyLogsNeedQuarantine = false;
    if (logsJson != null) {
      try {
        _restoreDailyPlanProgress(logsJson);
      } catch (_) {
        _dailyPlanEntries = {};
        _dailyLogHistory = {};
        if (!_quarantinedDailyPlanPayloads.contains(logsJson)) {
          _quarantinedDailyPlanPayloads.add(logsJson);
        }
        dailyLogsNeedQuarantine = true;
      }
    }
    final questionHistoryJson = await _profileStorage.readStringForProfile(
      profileId,
      'question_history',
    );
    if (!isCurrentRequest()) return;
    if (questionHistoryJson == null) {
      _migrateLegacyQuestionCounts(profileId);
      await _writeProfileData(profileId, {
        'question_history': jsonEncode(_questionHistoryJson()),
      });
      if (!isCurrentRequest()) return;
    } else {
      _restoreQuestionHistory(questionHistoryJson, profileId);
    }
    dailyLogs = _buildDailySchedule(_activeProfile.targetDate);
    _applyDailyPlanProgress();

    final studySessionsJson = await _profileStorage.readStringForProfile(
      profileId,
      'study_sessions',
    );
    if (!isCurrentRequest()) return;
    if (studySessionsJson != null) {
      final decoded = jsonDecode(studySessionsJson);
      if (decoded is! List) {
        throw const FormatException('Odak oturumu kayıtları geçersiz.');
      }
      studySessions = decoded
          .map(
            (value) =>
                StudySession.fromJson(Map<String, dynamic>.from(value as Map)),
          )
          .toList();
      if (studySessions.any((session) => session.profileId != profileId)) {
        throw const FormatException('Odak oturumu başka bir profile bağlı.');
      }
    }

    final pomodoroStateJson = await _profileStorage.readStringForProfile(
      profileId,
      'pomodoro_state',
    );
    if (!isCurrentRequest()) return;
    if (pomodoroStateJson != null) {
      final decoded = jsonDecode(pomodoroStateJson);
      if (decoded is! Map) {
        throw const FormatException('Pomodoro zamanlayıcı durumu geçersiz.');
      }
      final timerState = PomodoroTimerState.fromJson(
        Map<String, dynamic>.from(decoded),
      );
      if (timerState.profileId != profileId) {
        throw const FormatException('Pomodoro durumu başka bir profile bağlı.');
      }
      pomodoroTimerState = timerState;
    }

    // Load mock exams
    final examsJson = await _profileStorage.readStringForProfile(
      profileId,
      'mock_exams',
    );
    if (!isCurrentRequest()) return;
    if (examsJson != null) {
      final Map<String, dynamic> data = jsonDecode(examsJson);
      final originalDates = {
        for (final exam in getExamCalendar()) exam.id: exam,
      };
      for (var exam in mockExams) {
        if (data.containsKey(exam.id)) {
          exam.fromJson(data[exam.id]);
          if (exam.isCompleted && exam.completedAt == null) {
            final original = originalDates[exam.id];
            if (original != null) {
              // Preserve the known legacy schedule date. Older records did
              // not store the day the user actually took the exam.
              exam.date = original.date;
              exam.dayName = original.dayName;
            }
          }
        }
      }
    }

    // Load weak topics
    final weakJson = await _profileStorage.readStringForProfile(
      profileId,
      'weak_topics',
    );
    if (!isCurrentRequest()) return;
    if (weakJson != null) {
      final List<dynamic> data = jsonDecode(weakJson);
      weakTopics = data.map((e) => WeakTopic.fromJson(e)).toList();
      final migratedReviewDates = weakTopics.fold<bool>(
        false,
        (changed, topic) =>
            topic.migrateLegacyReviewToDue(DateTime.now()) || changed,
      );
      final removedOrphans = _removeOrphanedWeakTopicReferences();
      final attachedIds = _attachWeakTopicCatalogIds();
      var registeredLegacyReviews = false;
      for (final entry in _dailyPlanEntries.entries) {
        final value = entry.value;
        if (!entry.key.startsWith('review_') ||
            value is! Map ||
            value['isCompleted'] != true ||
            value['reviewTopicId'] is! String) {
          continue;
        }
        final topic = weakTopics
            .where((topic) => topic.id == value['reviewTopicId'])
            .firstOrNull;
        if (topic == null) continue;
        final at =
            DateTime.tryParse(value['completedAt'] as String? ?? '') ??
            DateTime.now();
        registeredLegacyReviews =
            topic.registerLegacyReview(
              _planReviewEventId(entry.key, topic.id),
              at,
            ) ||
            registeredLegacyReviews;
      }
      if (removedOrphans ||
          attachedIds ||
          migratedReviewDates ||
          registeredLegacyReviews) {
        await _saveWeakTopicsForProfile(profileId, _weakTopicsJson());
        if (!isCurrentRequest()) return;
      }
    }
    _applyWeakTopicReviews();

    // Load goals
    final goalsJson = await _profileStorage.readStringForProfile(
      profileId,
      'goals_data',
    );
    if (!isCurrentRequest()) return;
    if (goalsJson != null) {
      try {
        final decoded = jsonDecode(goalsJson);
        if (decoded is! List) {
          _quarantinedGoalRecords.add(decoded);
        } else {
          for (final value in decoded) {
            if (Goal.isQuarantinedRecord(value)) {
              _quarantinedGoalRecords.add(Goal.quarantinedRawValue(value));
              continue;
            }
            try {
              if (value is! Map) {
                throw const FormatException('Hedef kaydı nesne değil.');
              }
              final goal = Goal.fromJson(Map<String, dynamic>.from(value));
              goal.validateForPersistence();
              goals.add(goal);
            } catch (_) {
              _quarantinedGoalRecords.add(value);
            }
          }
        }
      } catch (_) {
        // Keep the original bytes as an inert recovery value. A later save or
        // export wraps it in a versioned record instead of discarding it.
        _quarantinedGoalRecords.add(goalsJson);
      }
    }

    // Load achievements
    final achieveJson = await _profileStorage.readStringForProfile(
      profileId,
      'achievements_data',
    );
    if (!isCurrentRequest()) return;
    if (achieveJson != null) {
      final Map<String, dynamic> data = jsonDecode(achieveJson);
      for (var a in achievements) {
        if (data.containsKey(a.id)) {
          a.fromJson(data[a.id]);
        }
      }
    }

    if (isCurrentRequest()) {
      _bootStatus = AppBootStatus.ready;
      _loadError = null;
      _persistenceError = _failedWriteErrors.values.firstOrNull;
      _syncDailyReminder();
      notifyListeners();
    }
    if (isCurrentRequest() &&
        (dailyLogsNeedQuarantine || _dailyPlanQuarantineNeedsRewrite)) {
      final recoveryData = <String, String>{
        'daily_logs_quarantine': _dailyPlanQuarantineJson(),
        if (dailyLogsNeedQuarantine)
          'daily_logs': jsonEncode({
            'schemaVersion': 2,
            'entries': <String, dynamic>{},
            'history': <String, dynamic>{},
          }),
      };
      final saved = await _writeProfileData(profileId, recoveryData);
      if (saved) _dailyPlanQuarantineNeedsRewrite = false;
    }
  }

  void _restoreDailyPlanQuarantine(String? quarantineJson) {
    if (quarantineJson == null) return;
    try {
      final decoded = jsonDecode(quarantineJson);
      if (decoded is Map &&
          decoded['schemaVersion'] == 1 &&
          decoded['payloads'] is List &&
          (decoded['payloads'] as List).every((payload) => payload is String)) {
        _quarantinedDailyPlanPayloads.addAll(
          (decoded['payloads'] as List).cast<String>(),
        );
        return;
      }
    } catch (_) {
      // Preserve an unrecognized recovery record below as opaque text.
    }
    _quarantinedDailyPlanPayloads.add(quarantineJson);
    _dailyPlanQuarantineNeedsRewrite = true;
  }

  String _dailyPlanQuarantineJson() => jsonEncode({
    'schemaVersion': 1,
    'payloads': _quarantinedDailyPlanPayloads,
  });

  void _syncDailyReminder() {
    unawaited(
      DailyReminderService.syncForProfile(
        profileName: _activeProfile.name,
        targetDate: _activeProfile.targetDate,
      ).catchError((Object _) {}),
    );
  }

  void _migrateLegacyQuestionCounts(String profileId) {
    questionEvents = DailyPlanMigration.migrateLegacyQuestionEvents(
      entries: _dailyPlanEntries,
      profileId: profileId,
    );
  }

  void _restoreQuestionHistory(String historyJson, String profileId) {
    final decoded = jsonDecode(historyJson);
    if (decoded is! Map || decoded['schemaVersion'] != 1) {
      throw const FormatException('Soru geçmişi biçimi geçersiz.');
    }
    final events = decoded['events'];
    if (events is! List) {
      throw const FormatException('Soru geçmişi kayıtları geçersiz.');
    }
    questionEvents = events
        .map(
          (value) =>
              QuestionEvent.fromJson(Map<String, dynamic>.from(value as Map)),
        )
        .toList();
    final ids = questionEvents.map((event) => event.id).toSet();
    if (ids.length != questionEvents.length) {
      throw const FormatException(
        'Soru geçmişinde yinelenen kayıt kimliği var.',
      );
    }
    if (questionEvents.any((event) => event.profileId != profileId)) {
      throw const FormatException('Soru kaydı başka bir profile bağlı.');
    }
  }

  Map<String, dynamic> _questionHistoryJson() => {
    'schemaVersion': 1,
    'events': questionEvents.map((event) => event.toJson()).toList(),
  };

  Future<bool> recordStudySession(StudySession session) async {
    final profileId = session.profileId;
    try {
      final validated = StudySession.fromJson(session.toJson());
      final saved = await _profileStorage.mutateStringsForProfile(
        profileId,
        {'study_sessions'},
        (current) {
          final raw = current['study_sessions'];
          final decoded = raw == null ? <dynamic>[] : jsonDecode(raw);
          if (decoded is! List) {
            throw const FormatException('Odak oturumu kayıtları geçersiz.');
          }
          final records = decoded
              .map(
                (value) => StudySession.fromJson(
                  Map<String, dynamic>.from(value as Map),
                ),
              )
              .toList();
          if (records.any((item) => item.profileId != profileId)) {
            throw const FormatException('Odak oturumu başka profile bağlı.');
          }
          final existing = records.where((item) => item.id == validated.id);
          if (existing.isNotEmpty) {
            if (jsonEncode(existing.single.toJson()) !=
                jsonEncode(validated.toJson())) {
              throw const FormatException(
                'Oturum kimliği farklı bir kayıtta kullanılıyor.',
              );
            }
          } else {
            records.add(validated);
          }
          return {
            'study_sessions': jsonEncode(
              records.map((item) => item.toJson()).toList(),
            ),
          };
        },
      );
      if (profileId == _activeProfile.id && !_isProfileTransitioning) {
        studySessions = (jsonDecode(saved['study_sessions']!) as List)
            .map(
              (value) => StudySession.fromJson(
                Map<String, dynamic>.from(value as Map),
              ),
            )
            .toList();
      }
      _clearWriteErrors(profileId, {'study_sessions:${session.id}'});
      notifyListeners();
      return true;
    } catch (error) {
      _recordWriteError(profileId, {'study_sessions:${session.id}'}, error);
      return false;
    }
  }

  Future<bool> savePomodoroTimerState(PomodoroTimerState timerState) async {
    if (_isProfileTransitioning) return false;
    final saved = await _writeProfileData(timerState.profileId, {
      'pomodoro_state': jsonEncode(timerState.toJson()),
    });
    if (!saved) return false;
    if (timerState.profileId == _activeProfile.id && !_isProfileTransitioning) {
      pomodoroTimerState = timerState;
      notifyListeners();
    }
    return true;
  }

  void _restoreDailyPlanProgress(String logsJson) {
    final snapshot = DailyPlanMigration.restore(
      logsJson,
      templateLogs: getDailySchedule(),
    );
    _dailyPlanEntries = snapshot.entries;
    _dailyLogHistory = snapshot.history;
    _applyDailyPlanProgress();
  }

  void _applyDailyPlanProgress() {
    DailyPlanMetrics.applyPersistedProgress(
      logs: dailyLogs,
      planEntries: _dailyPlanEntries,
      questionEvents: questionEvents,
    );
  }

  List<DailyLog> _buildDailySchedule(DateTime targetDate) {
    final now = DateTime.now();
    _planDateBuiltFor = DateTime(now.year, now.month, now.day);
    return getPersonalizedDailySchedule(
      targetDate: targetDate,
      preferences: _schedulePreferences,
      completedTaskIds: DailyPlanMetrics.completedCoreTaskIds(
        _dailyPlanEntries,
      ),
      completedTaskIdsForToday: DailyPlanMetrics.completedCoreTaskIdsOnDate(
        _dailyPlanEntries,
        now,
      ),
    );
  }

  Future<void> updateSchedulePreferences({
    required List<int> availableWeekdays,
    required int dailyStudyMinutes,
  }) async {
    if (_isProfileTransitioning) {
      throw StateError('Profil geçişi sürüyor; tercihlerini yeniden kaydet.');
    }
    final updated = StudySchedulePreferences.fromJson({
      'version': 1,
      'availableWeekdays': availableWeekdays,
      'dailyStudyMinutes': dailyStudyMinutes,
    });
    final profileId = _activeProfile.id;
    final saved = await _writeProfileData(profileId, {
      'schedule_preferences': jsonEncode(updated.toJson()),
    });
    if (!saved) throw StateError('Çalışma tercihleri cihaza kaydedilemedi.');
    if (profileId != _activeProfile.id) return;
    _schedulePreferences = updated;
    dailyLogs = _buildDailySchedule(_activeProfile.targetDate);
    _applyDailyPlanProgress();
    _applyWeakTopicReviews();
    notifyListeners();
  }

  void _applyWeakTopicReviews() {
    DailyPlanMetrics.applyWeakTopicReviews(
      logs: dailyLogs,
      weakTopics: weakTopics,
      subjects: subjects,
    );
  }

  void _restoreCustomCurriculum(String curriculumJson) {
    final decoded = jsonDecode(curriculumJson);
    if (decoded is! Map) {
      throw const FormatException('Özel ders ve konu kataloğu geçersiz.');
    }

    final customSubjects = decoded['customSubjects'];
    if (customSubjects is List) {
      for (final value in customSubjects) {
        if (value is! Map) continue;
        final item = Map<String, dynamic>.from(value);
        final id = item['id'];
        final name = item['name'];
        final type = item['type'];
        if (id is! String ||
            !RegExp(r'^custom_subject_\d+$').hasMatch(id) ||
            name is! String ||
            name.trim().isEmpty ||
            (type != 'TYT' && type != 'AYT') ||
            subjects.any(
              (subject) =>
                  subject.storageId == id ||
                  (subject.type == type &&
                      subject.name.toLowerCase() == name.toLowerCase()),
            )) {
          continue;
        }
        final topics = <Topic>[];
        final savedTopics = item['topics'];
        if (savedTopics is List) {
          for (final topicValue in savedTopics) {
            final topic = _topicFromDefinition(topicValue);
            if (topic != null) topics.add(topic);
          }
        }
        subjects.add(
          Subject(
            id: id,
            isCustom: true,
            name: name,
            emoji: item['emoji'] is String ? item['emoji'] as String : '📘',
            type: type,
            totalQuestions: item['totalQuestions'] is int
                ? item['totalQuestions'] as int
                : 40,
            tip: item['tip'] is String ? item['tip'] as String : '',
            topics: topics,
          ),
        );
      }
    }

    final extraTopics = decoded['customTopics'];
    if (extraTopics is List) {
      for (final value in extraTopics) {
        if (value is! Map) continue;
        final item = Map<String, dynamic>.from(value);
        final subjectId = item['subjectId'];
        if (subjectId is! String) continue;
        final topic = _topicFromDefinition(item['topic']);
        if (topic == null) continue;
        for (final subject in subjects) {
          if (subject.storageId == subjectId) {
            subject.topics.add(topic);
            break;
          }
        }
      }
    }
  }

  Topic? _topicFromDefinition(dynamic value) {
    if (value is! Map) return null;
    final item = Map<String, dynamic>.from(value);
    final id = item['id'];
    final name = item['name'];
    if (id is! String ||
        !RegExp(r'^custom_topic_\d+$').hasMatch(id) ||
        name is! String ||
        name.trim().isEmpty) {
      return null;
    }
    final questionCount = item['questionCount'] is int
        ? item['questionCount'] as int
        : 0;
    final estimatedDays = item['estimatedDays'] is int
        ? item['estimatedDays'] as int
        : 1;
    if (questionCount < 0 ||
        questionCount > 200 ||
        estimatedDays < 1 ||
        estimatedDays > 365) {
      return null;
    }
    return Topic(
      id: id,
      name: name,
      description: item['description'] is String
          ? item['description'] as String
          : '',
      questionCount: questionCount,
      difficulty: item['difficulty'] is String
          ? item['difficulty'] as String
          : '🟡 Orta',
      priority: item['priority'] is String
          ? item['priority'] as String
          : '🟡 ORTA',
      estimatedDays: estimatedDays,
      isCustom: true,
    );
  }

  Map<String, dynamic> _topicDefinition(Topic topic) => {
    'id': topic.id,
    'name': topic.name,
    'description': topic.description,
    'questionCount': topic.questionCount,
    'difficulty': topic.difficulty,
    'priority': topic.priority,
    'estimatedDays': topic.estimatedDays,
  };

  String _customCurriculumJson() {
    final customSubjects = subjects
        .where((subject) => subject.isCustom)
        .map(
          (subject) => {
            'id': subject.storageId,
            'name': subject.name,
            'emoji': subject.emoji,
            'type': subject.type,
            'totalQuestions': subject.totalQuestions,
            'tip': subject.tip,
            'topics': subject.topics
                .where((topic) => topic.isCustom)
                .map(_topicDefinition)
                .toList(),
          },
        )
        .toList();
    final customTopics = <Map<String, dynamic>>[];
    for (final subject in subjects.where((item) => !item.isCustom)) {
      for (final topic in subject.topics.where((item) => item.isCustom)) {
        customTopics.add({
          'subjectId': subject.storageId,
          'topic': _topicDefinition(topic),
        });
      }
    }
    return jsonEncode({
      'version': 1,
      'customSubjects': customSubjects,
      'customTopics': customTopics,
    });
  }

  void _validateCustomTopicFields({
    required int questionCount,
    required String difficulty,
    required String priority,
    required int estimatedDays,
  }) {
    if (questionCount < 0 ||
        questionCount > 200 ||
        estimatedDays < 1 ||
        estimatedDays > 365 ||
        !const {'🟢 Kolay', '🟡 Orta', '🔴 Zor'}.contains(difficulty) ||
        !const {
          '🔴 ÇOK KRİTİK',
          '🟠 ÖNEMLİ',
          '🟡 ORTA',
          '🔵 DÜŞÜK',
        }.contains(priority)) {
      throw ArgumentError('Soru, gün, zorluk veya öncelik değeri geçersiz.');
    }
  }

  Future<void> _editCurriculum(void Function() change) async {
    if (isProfileTransitioning) {
      throw StateError('Profil değişimi bitince yeniden dene.');
    }
    final profile = activeProfile.id;
    final pending = '$profile:custom_curriculum:catalog';
    if (!_pendingRecordWrites.add(pending)) {
      throw StateError('Müfredat kaydı sürüyor.');
    }
    final original = subjects;
    final originalWeak = weakTopics;
    late List<Subject> staged;
    late String curriculum;
    late Set<String> removedTopics;
    try {
      try {
        subjects = [
          for (final subject in original)
            Subject(
              id: subject.id,
              isCustom: subject.isCustom,
              name: subject.name,
              emoji: subject.emoji,
              type: subject.type,
              totalQuestions: subject.totalQuestions,
              tip: subject.tip,
              topics: [
                for (final topic in subject.topics)
                  Topic(
                    id: topic.id,
                    name: topic.name,
                    description: topic.description,
                    questionCount: topic.questionCount,
                    difficulty: topic.difficulty,
                    priority: topic.priority,
                    estimatedDays: topic.estimatedDays,
                    sourceLabel: topic.sourceLabel,
                    sourceUrl: topic.sourceUrl,
                    isCompleted: topic.isCompleted,
                    notes: topic.notes,
                    isCustom: topic.isCustom,
                  ),
              ],
            ),
        ];
        weakTopics = originalWeak
            .map((topic) => WeakTopic.fromJson(topic.toJson()))
            .toList();
        change();
        if (weakTopics.length != originalWeak.length) {
          throw const FormatException(
            'Hata/tekrar kaydı bağlı olan ders veya konu silinemez. Önce ilgili kayıtları gözden geçir.',
          );
        }
        final remainingSubjects = subjects
            .map((subject) => subject.storageId)
            .toSet();
        if (learningWorkspace.resources.any(
          (resource) =>
              !remainingSubjects.contains(resource.subjectId) &&
              original.any(
                (subject) => subject.storageId == resource.subjectId,
              ),
        )) {
          throw const FormatException(
            'Kaynak geçmişi bağlı olan ders silinemez.',
          );
        }
        final remainingTopics = subjects
            .expand((subject) => subject.topics)
            .map((topic) => topic.id)
            .toSet();
        removedTopics = original
            .expand((subject) => subject.topics)
            .map((topic) => topic.id)
            .where((id) => !remainingTopics.contains(id))
            .toSet();
        if (removedTopics.any((id) => isSavingRecord('topics_data', id))) {
          throw const FormatException(
            'Konu kaydı sürüyor; bitince yeniden dene.',
          );
        }
        staged = subjects;
        curriculum = _customCurriculumJson();
      } finally {
        subjects = original;
        weakTopics = originalWeak;
      }
      notifyListeners();
      await _profileStorage.mutateStringsForProfile(
        profile,
        {'custom_curriculum', if (removedTopics.isNotEmpty) 'topics_data'},
        (values) {
          final updates = {'custom_curriculum': curriculum};
          if (removedTopics.isNotEmpty) {
            final raw = values['topics_data'];
            final progress = raw == null
                ? <String, dynamic>{}
                : Map<String, dynamic>.from(jsonDecode(raw) as Map);
            for (final id in removedTopics) {
              progress.remove(id);
            }
            updates['topics_data'] = jsonEncode(progress);
          }
          return updates;
        },
      );
      _clearWriteErrors(profile, {'custom_curriculum'});
      if (profile == activeProfile.id && !isProfileTransitioning) {
        final progress = {
          for (final topic in subjects.expand((subject) => subject.topics))
            topic.id: topic.toJson(),
        };
        for (final topic in staged.expand((subject) => subject.topics)) {
          if (progress.containsKey(topic.id)) {
            topic.fromJson(progress[topic.id]!);
          }
        }
        subjects = staged;
        recordSaveError = null;
        notifyListeners();
      }
    } catch (error) {
      _recordWriteError(profile, {'custom_curriculum'}, error);
      if (profile == activeProfile.id) {
        recordSaveError = error is FormatException
            ? error.message.toString()
            : 'Müfredat kaydedilemedi. Yeniden dene.';
      }
      throw StateError(recordSaveError ?? 'Müfredat kaydedilemedi.');
    } finally {
      _pendingRecordWrites.remove(pending);
      notifyListeners();
    }
  }

  Future<void> addCustomSubject({
    required String name,
    required String type,
    required int totalQuestions,
  }) async {
    await _editCurriculum(() {
      final normalizedName = name.trim();
      if (normalizedName.isEmpty || (type != 'TYT' && type != 'AYT')) {
        throw ArgumentError('Ders adı veya sınav türü geçersiz.');
      }
      if (totalQuestions < 1 || totalQuestions > 200) {
        throw ArgumentError.value(totalQuestions, 'totalQuestions');
      }
      final netLabel = normalizedName.startsWith('$type ')
          ? normalizedName
          : '$type $normalizedName';
      if (subjects.any((subject) {
        if (subject.type != type) return false;
        final existingNetLabel = subject.name.startsWith('$type ')
            ? subject.name
            : '$type ${subject.name}';
        return existingNetLabel.toLowerCase() == netLabel.toLowerCase();
      })) {
        throw ArgumentError('Bu ders zaten listede var.');
      }
      subjects.add(
        Subject(
          id: 'custom_subject_${DateTime.now().microsecondsSinceEpoch}',
          isCustom: true,
          name: normalizedName,
          emoji: type == 'TYT' ? '📘' : '📙',
          type: type,
          totalQuestions: totalQuestions,
          topics: [],
        ),
      );
    });
  }

  Future<void> addCustomTopic({
    required String subjectId,
    required String name,
    required String description,
    required int questionCount,
    required String difficulty,
    required String priority,
    required int estimatedDays,
  }) async {
    await _editCurriculum(() {
      _validateCustomTopicFields(
        questionCount: questionCount,
        difficulty: difficulty,
        priority: priority,
        estimatedDays: estimatedDays,
      );
      final subject = subjects.firstWhere(
        (item) => item.storageId == subjectId,
        orElse: () => throw ArgumentError.value(subjectId, 'subjectId'),
      );
      final normalizedName = name.trim();
      if (normalizedName.isEmpty ||
          subject.topics.any(
            (topic) => topic.name.toLowerCase() == normalizedName.toLowerCase(),
          )) {
        throw ArgumentError('Konu adı boş veya bu derste zaten kullanılıyor.');
      }
      final topic = Topic(
        id: 'custom_topic_${DateTime.now().microsecondsSinceEpoch}',
        name: normalizedName,
        description: description.trim(),
        questionCount: questionCount,
        difficulty: difficulty,
        priority: priority,
        estimatedDays: estimatedDays,
        isCustom: true,
      );
      subject.topics.add(topic);
    });
  }

  Future<void> updateCustomTopic({
    required String subjectId,
    required String topicId,
    required String name,
    required String description,
    required int questionCount,
    required String difficulty,
    required String priority,
    required int estimatedDays,
  }) async {
    await _editCurriculum(() {
      _validateCustomTopicFields(
        questionCount: questionCount,
        difficulty: difficulty,
        priority: priority,
        estimatedDays: estimatedDays,
      );
      final subject = subjects.firstWhere(
        (item) => item.storageId == subjectId,
        orElse: () => throw ArgumentError.value(subjectId, 'subjectId'),
      );
      final index = subject.topics.indexWhere((topic) => topic.id == topicId);
      if (index == -1 || !subject.topics[index].isCustom) {
        throw ArgumentError.value(topicId, 'topicId', 'Özel konu bulunamadı.');
      }
      final normalizedName = name.trim();
      if (normalizedName.isEmpty ||
          subject.topics.asMap().entries.any(
            (entry) =>
                entry.key != index &&
                entry.value.name.toLowerCase() == normalizedName.toLowerCase(),
          )) {
        throw ArgumentError('Konu adı boş veya bu derste zaten kullanılıyor.');
      }
      final previous = subject.topics[index];
      subject.topics[index] = Topic(
        id: previous.id,
        name: normalizedName,
        description: description.trim(),
        questionCount: questionCount,
        difficulty: difficulty,
        priority: priority,
        estimatedDays: estimatedDays,
        isCompleted: previous.isCompleted,
        notes: previous.notes,
        isCustom: true,
      );
    });
  }

  Future<void> removeCustomTopic({
    required String subjectId,
    required String topicId,
  }) async {
    await _editCurriculum(() {
      final subject = subjects.firstWhere(
        (item) => item.storageId == subjectId,
        orElse: () => throw ArgumentError.value(subjectId, 'subjectId'),
      );
      final removedTopic = subject.topics.where((topic) => topic.id == topicId);
      if (removedTopic.isEmpty || !removedTopic.first.isCustom) return;
      final removedTopicName = removedTopic.first.name;
      subject.topics.removeWhere(
        (topic) => topic.id == topicId && topic.isCustom,
      );
      _removeWeakTopicReferences(
        subject: subject,
        topicId: topicId,
        topicName: removedTopicName,
      );
    });
  }

  Future<void> removeCustomSubject(String subjectId) async {
    await _editCurriculum(() {
      final subject = subjects.where((item) => item.storageId == subjectId);
      if (subject.isEmpty || !subject.first.isCustom) return;
      final removedSubject = subject.first;
      final topicIds = removedSubject.topics.map((topic) => topic.id).toSet();
      subjects.removeWhere((item) => item.storageId == subjectId);
      for (final item in subjects) {
        item.topics.removeWhere(
          (topic) => topic.isCustom && topicIds.contains(topic.id),
        );
      }
      weakTopics.removeWhere(
        (weakTopic) =>
            weakTopic.subjectId == subjectId ||
            (weakTopic.subjectId == null &&
                weakTopic.subject == removedSubject.name),
      );
    });
  }

  String _weakTopicsJson() =>
      jsonEncode(weakTopics.map((topic) => topic.toJson()).toList());

  Future<void> _saveWeakTopicsForProfile(String profileId, String json) async {
    await _writeProfileData(profileId, {'weak_topics': json});
  }

  bool _removeOrphanedWeakTopicReferences() {
    final subjectIds = subjects.map((subject) => subject.storageId).toSet();
    final topicIds = {
      for (final subject in subjects)
        for (final topic in subject.topics) topic.id,
    };
    final initialCount = weakTopics.length;
    weakTopics.removeWhere(
      (weakTopic) =>
          (weakTopic.subjectId != null &&
              !subjectIds.contains(weakTopic.subjectId)) ||
          (weakTopic.topicId != null && !topicIds.contains(weakTopic.topicId)),
    );
    return weakTopics.length != initialCount;
  }

  bool _attachWeakTopicCatalogIds() {
    var changed = false;
    for (final weakTopic in weakTopics) {
      var matchingSubjects = subjects
          .where((subject) => subject.name == weakTopic.subject)
          .toList();
      if (weakTopic.subjectId != null) {
        matchingSubjects = matchingSubjects
            .where((subject) => subject.storageId == weakTopic.subjectId)
            .toList();
      } else if (matchingSubjects.length == 1) {
        weakTopic.subjectId = matchingSubjects.single.storageId;
        changed = true;
      }
      if (weakTopic.topicId != null || matchingSubjects.length != 1) continue;
      final matchingTopics = matchingSubjects.single.topics
          .where((topic) => topic.name == weakTopic.topic)
          .toList();
      if (matchingTopics.length == 1) {
        weakTopic.topicId = matchingTopics.single.id;
        changed = true;
      }
    }
    return changed;
  }

  void _removeWeakTopicReferences({
    required Subject subject,
    required String topicId,
    required String topicName,
  }) {
    weakTopics.removeWhere(
      (weakTopic) =>
          weakTopic.topicId == topicId ||
          (weakTopic.topic == topicName &&
              weakTopic.subject == subject.name &&
              (weakTopic.subjectId == null ||
                  weakTopic.subjectId == subject.storageId)),
    );
  }

  Future<bool> _writeProfileData(
    String profileId,
    Map<String, String> values,
  ) async {
    try {
      await _profileStorage.writeStringsForProfile(profileId, values);
      _clearWriteErrors(profileId, values.keys);
      return true;
    } catch (error) {
      _recordWriteError(profileId, values.keys, error);
      return false;
    }
  }

  void _recordWriteError(
    String profileId,
    Iterable<String> keys,
    Object error,
  ) {
    for (final key in keys) {
      _failedWriteErrors['$profileId::$key'] = error.toString();
    }
    _persistenceError = _failedWriteErrors.values.firstOrNull;
    notifyListeners();
  }

  void _clearWriteErrors(String profileId, Iterable<String> keys) {
    for (final key in keys) {
      _failedWriteErrors.remove('$profileId::$key');
    }
    final previous = _persistenceError;
    _persistenceError = _failedWriteErrors.values.firstOrNull;
    if (previous != _persistenceError) notifyListeners();
  }

  void dismissPersistenceError() {
    // Acknowledging an error must not turn an unsaved change into a saved one.
    if (_failedWriteErrors.isNotEmpty || _persistenceError == null) return;
    _persistenceError = null;
    notifyListeners();
  }

  Future<void> discardUnsavedChangesAndReload() async {
    _failedWriteErrors.clear();
    _persistenceError = null;
    // Only old drafts were discarded. A new load/migration failure must remain.
    await loadData();
  }

  Future<bool> _changeRecordGroup(
    String group,
    String id,
    Object initial,
    Object Function(dynamic) change,
    void Function(dynamic) apply,
  ) async {
    if (_isProfileTransitioning) return false;
    final profileId = activeProfile.id;
    final pendingKey = '$profileId:$group:$id';
    if (!_pendingRecordWrites.add(pendingKey)) return false;
    final fallback = jsonEncode(initial);
    final errorKey = '$group:$id';
    notifyListeners();
    try {
      final saved = await _profileStorage.mutateStringsForProfile(
        profileId,
        {group},
        (values) {
          final raw = values[group];
          dynamic decoded;
          try {
            decoded = jsonDecode(raw ?? fallback);
          } catch (_) {
            if (group != 'goals_data') rethrow;
            decoded = jsonDecode(fallback);
          }
          return {group: jsonEncode(change(decoded))};
        },
      );
      _clearWriteErrors(profileId, {errorKey});
      if (profileId == activeProfile.id && !_isProfileTransitioning) {
        apply(jsonDecode(saved[group]!));
        recordSaveError = null;
      }
      return true;
    } catch (error) {
      if (profileId == activeProfile.id) {
        recordSaveError = error is FormatException
            ? error.message.toString()
            : 'Kayıt yapılamadı. Yeniden dene.';
      }
      _recordWriteError(profileId, {errorKey}, error);
      return false;
    } finally {
      _pendingRecordWrites.remove(pendingKey);
      notifyListeners();
    }
  }

  Future<bool> _changeTopic(
    String id,
    Map<String, dynamic> Function(Map<String, dynamic>) change,
  ) async {
    if (isSavingRecord('custom_curriculum', 'catalog')) return false;
    final topic = subjects
        .expand((subject) => subject.topics)
        .where((topic) => topic.id == id)
        .firstOrNull;
    if (topic == null) return false;
    final initial = topic.toJson();
    return _changeRecordGroup(
      'topics_data',
      id,
      {},
      (raw) {
        final data = Map<String, dynamic>.from(raw as Map);
        final current = Map<String, dynamic>.from((data[id] ?? initial) as Map);
        data[id] = change(current);
        return data;
      },
      (raw) {
        final current = subjects
            .expand((subject) => subject.topics)
            .where((topic) => topic.id == id)
            .firstOrNull;
        if (current != null) {
          current.fromJson(Map<String, dynamic>.from(raw[id] as Map));
        }
      },
    );
  }

  Future<bool> toggleTopic(String topicId) async {
    final profile = activeProfile.id;
    final saved = await _changeTopic(
      topicId,
      (value) => {...value, 'isCompleted': !(value['isCompleted'] == true)},
    );
    if (saved && profile == activeProfile.id && !isProfileTransitioning) {
      if (subjects
          .expand((subject) => subject.topics)
          .any((topic) => topic.id == topicId && topic.isCompleted)) {
        onCelebrate?.call();
      }
      await checkAchievements();
      notifyListeners();
    }
    return saved;
  }

  Future<bool> updateTopicNotes(String topicId, String notes) =>
      _changeTopic(topicId, (value) => {...value, 'notes': notes});

  // ─── Daily Log Actions ─────────────────────────
  String _planReviewEventId(String progressId, String topicId) =>
      'plan:$progressId:$topicId';

  Future<bool> _changeLegacyDay(
    String dateKey, {
    bool toggle = false,
    int? solvedQuestions,
    String? weakTopicNotes,
  }) async {
    if (isProfileTransitioning) return false;
    final source = dailyLogs
        .where(
          (log) =>
              log.dateKey == dateKey &&
              !log.isRestDay &&
              log.progressIds.isNotEmpty,
        )
        .firstOrNull;
    if (source == null) return false;
    final profile = activeProfile.id;
    final key = '$profile:daily_logs:$dateKey';
    if (!_pendingRecordWrites.add(key)) return false;
    final initialLogs = jsonEncode({
      'schemaVersion': 2,
      'entries': _dailyPlanEntries,
      'history': _dailyLogHistory,
    });
    final initialQuestions = jsonEncode(_questionHistoryJson());
    final initialWeak = _weakTopicsJson();
    final now = DateTime.now();
    final review =
        source.progressIds.length == 1 &&
        source.progressIds.single.startsWith('review_') &&
        source.reviewTopicId != null;
    final log = DailyLog(
      date: source.date,
      dayName: source.dayName,
      tytContent: source.tytContent,
      aytContent: source.aytContent,
      studyHours: source.studyHours,
      motivationNote: source.motivationNote,
      progressIds: List.of(source.progressIds),
      reviewTopicId: source.reviewTopicId,
    );
    notifyListeners();
    try {
      final saved = await _profileStorage.mutateStringsForProfile(
        profile,
        {'daily_logs', 'question_history', if (review && toggle) 'weak_topics'},
        (values) {
          final snapshot = DailyPlanMigration.restore(
            values['daily_logs'] ?? initialLogs,
            templateLogs: getDailySchedule(),
          );
          final questionsRaw =
              jsonDecode(values['question_history'] ?? initialQuestions) as Map;
          final events = (questionsRaw['events'] as List)
              .map(
                (raw) => QuestionEvent.fromJson(
                  Map<String, dynamic>.from(raw as Map),
                ),
              )
              .toList();
          DailyPlanMetrics.applyPersistedProgress(
            logs: [log],
            planEntries: snapshot.entries,
            questionEvents: events,
          );
          if (toggle) {
            log.isCompleted = !log.isCompleted;
            log.completedAt = log.isCompleted ? now : null;
          }
          if (weakTopicNotes != null) log.weakTopicNotes = weakTopicNotes;
          log.activityAt = now;
          if (solvedQuestions != null) {
            if (solvedQuestions < 0 || solvedQuestions > 1000000) {
              throw const FormatException(
                'Soru sayısı 0–1000000 arasında olmalı.',
              );
            }
            DailyPlanMetrics.setSolvedQuestionsForLog(
              log: log,
              questionEvents: events,
              profileId: profile,
              targetCount: solvedQuestions,
              nextEventId: () =>
                  '${profile}_q_${now.microsecondsSinceEpoch}_${++_questionEventSequence}',
            );
          }
          DailyPlanMetrics.saveLogProgress(
            planEntries: snapshot.entries,
            changedLog: log,
            completedOverride: toggle ? log.isCompleted : null,
          );
          final updates = {
            'daily_logs': jsonEncode({
              'schemaVersion': 2,
              'entries': snapshot.entries,
              'history': snapshot.history,
            }),
            'question_history': jsonEncode({
              'schemaVersion': 1,
              'events': events.map((event) => event.toJson()).toList(),
            }),
          };
          if (review && toggle) {
            final topics =
                (jsonDecode(values['weak_topics'] ?? initialWeak) as List)
                    .map(
                      (raw) => WeakTopic.fromJson(
                        Map<String, dynamic>.from(raw as Map),
                      ),
                    )
                    .toList();
            final topic = topics
                .where((topic) => topic.id == log.reviewTopicId)
                .firstOrNull;
            if (topic != null) {
              final id = _planReviewEventId(log.progressIds.single, topic.id);
              if (log.isCompleted) {
                topic.scheduleNextReview(now, eventId: id);
              } else {
                topic.undoReview(id);
              }
            }
            updates['weak_topics'] = jsonEncode(
              topics.map((topic) => topic.toJson()).toList(),
            );
          }
          return updates;
        },
      );
      _clearWriteErrors(profile, {'daily_logs:$dateKey'});
      if (profile == activeProfile.id && !isProfileTransitioning) {
        _restoreQuestionHistory(saved['question_history']!, profile);
        _restoreDailyPlanProgress(saved['daily_logs']!);
        if (saved['weak_topics'] != null) {
          weakTopics = (jsonDecode(saved['weak_topics']!) as List)
              .map(
                (raw) =>
                    WeakTopic.fromJson(Map<String, dynamic>.from(raw as Map)),
              )
              .toList();
        }
        _applyWeakTopicReviews();
        recordSaveError = null;
        await checkAchievements();
      }
      return true;
    } catch (error) {
      if (profile == activeProfile.id) {
        recordSaveError = error is FormatException
            ? error.message.toString()
            : 'Günlük kayıt yapılamadı. Yeniden dene.';
      }
      _recordWriteError(profile, {'daily_logs:$dateKey'}, error);
      return false;
    } finally {
      _pendingRecordWrites.remove(key);
      notifyListeners();
    }
  }

  Future<bool> toggleDayCompleted(String dateKey) =>
      _changeLegacyDay(dateKey, toggle: true);
  Future<bool> updateDailyLog(
    String dateKey, {
    int? solvedQuestions,
    String? weakTopicNotes,
  }) => _changeLegacyDay(
    dateKey,
    solvedQuestions: solvedQuestions,
    weakTopicNotes: weakTopicNotes,
  );

  // ─── Mock Exam Actions ─────────────────────────
  Future<bool> updateMockExam(
    String examId, {
    Map<String, double>? nets,
    bool? isCompleted,
    DateTime? completedAt,
  }) async {
    if (_isProfileTransitioning) return false;
    final profileId = _activeProfile.id;
    final saveKey = '$profileId::$examId';
    if (!_savingMockExams.add(saveKey)) return false;
    try {
      final current = mockExams.where((exam) => exam.id == examId).firstOrNull;
      if (current == null) return false;
      if (nets != null &&
          !MockExamMetrics.areNetUpdatesValid(nets: nets, subjects: subjects)) {
        return false;
      }
      final candidate = MockExam(
        id: current.id,
        date: current.date,
        dayName: current.dayName,
        type: current.type,
        scope: current.scope,
        duration: current.duration,
        targetNet: current.targetNet,
        analysisMethod: current.analysisMethod,
      )..fromJson(current.toJson());
      if (nets != null) candidate.nets = MockExam.canonicalizeNets(nets);
      if (isCompleted != null) {
        candidate.isCompleted = isCompleted;
        if (!isCompleted) {
          candidate.completedAt = null;
        } else if (completedAt != null) {
          candidate.completedAt = DateTime(
            completedAt.year,
            completedAt.month,
            completedAt.day,
          );
        } else if (!current.isCompleted && current.completedAt == null) {
          final now = DateTime.now();
          candidate.completedAt = DateTime(now.year, now.month, now.day);
        }
      }
      candidate.updatedAt = DateTime.now();
      final saved = await _profileStorage.mutateStringsForProfile(
        profileId,
        {'mock_exams'},
        (values) {
          final raw = values['mock_exams'];
          final decoded = raw == null ? <String, dynamic>{} : jsonDecode(raw);
          if (decoded is! Map) {
            throw const FormatException('Deneme kayıtları geçersiz.');
          }
          final data = Map<String, dynamic>.from(decoded);
          data[examId] = candidate.toJson();
          return {'mock_exams': jsonEncode(data)};
        },
      );
      _clearWriteErrors(profileId, {'mock_exams:$examId'});
      if (profileId == _activeProfile.id && !_isProfileTransitioning) {
        final data = jsonDecode(saved['mock_exams']!) as Map;
        for (final exam in mockExams) {
          if (data[exam.id] is Map) {
            exam.fromJson(Map<String, dynamic>.from(data[exam.id] as Map));
          }
        }
        await checkAchievements();
        notifyListeners();
      }
      return true;
    } catch (error) {
      _recordWriteError(profileId, {'mock_exams:$examId'}, error);
      return false;
    } finally {
      _savingMockExams.remove(saveKey);
    }
  }

  Future<bool> _changeLearningWorkspace(
    String identity,
    LearningWorkspace Function(LearningWorkspace) change,
  ) async {
    if (_isProfileTransitioning) return false;
    final profileId = _activeProfile.id;
    final errorKey = 'learning_workspace:$identity';
    try {
      final saved = await _profileStorage.mutateStringsForProfile(
        profileId,
        {'learning_workspace'},
        (values) {
          final raw = values['learning_workspace'];
          final current = raw == null
              ? LearningWorkspace.empty(profileId)
              : LearningWorkspace.fromJson(
                  Map<String, dynamic>.from(jsonDecode(raw) as Map),
                );
          if (current.profileId != profileId) {
            throw const FormatException(
              'Kaynak çalışma alanı başka bir profile bağlı.',
            );
          }
          return {'learning_workspace': jsonEncode(change(current).toJson())};
        },
      );
      _clearWriteErrors(profileId, {errorKey});
      if (profileId == _activeProfile.id && !_isProfileTransitioning) {
        _learningWorkspaceError = null;
        _learningWorkspace = LearningWorkspace.fromJson(
          Map<String, dynamic>.from(
            jsonDecode(saved['learning_workspace']!) as Map,
          ),
        );
        notifyListeners();
        await checkAchievements();
      }
      return true;
    } catch (error) {
      if (profileId == _activeProfile.id) {
        _learningWorkspaceError = error is FormatException
            ? error.message.toString()
            : 'Kaynak verisi kaydedilemedi. Yeniden dene.';
      }
      _recordWriteError(profileId, {errorKey}, error);
      return false;
    }
  }

  Future<bool> _changeExamAttempts(
    String identity,
    ExamAttemptBook Function(ExamAttemptBook) change,
  ) async {
    if (_isProfileTransitioning) return false;
    final profileId = activeProfile.id;
    final errorKey = 'exam_attempts:$identity';
    try {
      final saved = await _profileStorage.mutateStringsForProfile(
        profileId,
        {'exam_attempts'},
        (values) {
          final raw = values['exam_attempts'];
          final book = raw == null
              ? ExamAttemptBook(profileId, [])
              : ExamAttemptBook.fromJson(
                  Map<String, dynamic>.from(jsonDecode(raw) as Map),
                );
          if (book.profileId != profileId) {
            throw const FormatException('Deneme defteri başka profile bağlı.');
          }
          return {'exam_attempts': jsonEncode(change(book).toJson())};
        },
      );
      _clearWriteErrors(profileId, {errorKey});
      if (activeProfile.id == profileId && !_isProfileTransitioning) {
        _examAttemptBook = ExamAttemptBook.fromJson(
          Map<String, dynamic>.from(jsonDecode(saved['exam_attempts']!) as Map),
        );
        _examAttemptError = null;
        notifyListeners();
        await checkAchievements();
      }
      return true;
    } catch (error) {
      if (activeProfile.id == profileId) {
        _examAttemptError = error is FormatException
            ? error.message.toString()
            : 'Deneme kaydedilemedi. Yeniden dene.';
      }
      _recordWriteError(profileId, {errorKey}, error);
      return false;
    }
  }

  Future<bool> saveExamAttempt(ExamAttempt attempt) =>
      _changeExamAttempts(attempt.id, (book) {
        final today = DateTime.now().toIso8601String().substring(0, 10);
        if (attempt.date.compareTo(today) > 0) {
          throw const FormatException(
            'Çözülmüş deneme için gelecek tarih girilemez.',
          );
        }
        return book.save(attempt);
      });
  Future<bool> archiveExamAttempt(String id, bool archived) =>
      _changeExamAttempts(id, (book) {
        final attempt = book.attempts
            .where((attempt) => attempt.id == id)
            .firstOrNull;
        if (attempt == null) throw const FormatException('Deneme bulunamadı.');
        return book.save(attempt.withArchived(archived));
      });

  Future<bool> rebuildResourcePlan() {
    final target = activeProfile.targetDate;
    final preferences = schedulePreferences;
    final now = DateTime.now();
    return _changeLearningWorkspace(
      'plan',
      (workspace) => workspace.planResources(now, target, preferences),
    );
  }

  Future<bool> completeResourcePlanBlock(
    String dayKey,
    String taskId,
    int start,
    int end,
  ) {
    final now = DateTime.now();
    final today =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return _changeLearningWorkspace('plan:$dayKey:$taskId:$start', (workspace) {
      if (dayKey != today) {
        throw const FormatException(
          'Yalnız bugünün planı buradan tamamlanabilir. Diğer çalışmalar için kaynak ekranını kullan.',
        );
      }
      final day = workspace.plans
          .where((day) => day.date == dayKey)
          .firstOrNull;
      if (day == null ||
          !day.blocks.any(
            (block) =>
                block.taskId == taskId &&
                block.startUnit == start &&
                block.endUnit == end,
          )) {
        throw const FormatException('Plan değişti. Ekranı yeniden aç.');
      }
      var result = workspace;
      for (final range in workspace.remainingRanges(taskId)) {
        final first = range.$1 > start ? range.$1 : start;
        final last = range.$2 < end ? range.$2 : end;
        if (last < first) continue;
        result = result.record(
          ResourceProgressEvent(
            id: 'plan-$dayKey-$taskId-$first-$last-${now.microsecondsSinceEpoch}',
            taskId: taskId,
            startUnit: first,
            units: last - first + 1,
            occurredAt: now.toUtc(),
          ),
        );
      }
      return result;
    });
  }

  Future<bool> saveStudyResource(StudyResource resource) {
    final catalog = {
      for (final subject in subjects) subject.storageId: subject.type,
    };
    return _changeLearningWorkspace('resource:${resource.id}', (workspace) {
      final existing = workspace.resources
          .where((item) => item.id == resource.id)
          .firstOrNull;
      if (existing == null && catalog[resource.subjectId] != resource.session) {
        throw const FormatException('Kaynak için mevcut bir ders seç.');
      }
      return workspace.saveResource(resource);
    });
  }

  Future<bool> saveResourceTask(ResourceTask task) => _changeLearningWorkspace(
    'task:${task.id}',
    (workspace) => workspace.saveTask(task),
  );

  Future<bool> recordResourceProgress(ResourceProgressEvent event) =>
      _changeLearningWorkspace(
        'event:${event.id}',
        (workspace) => workspace.record(event),
      );

  Future<bool> undoResourceProgress(String id) =>
      _changeLearningWorkspace('undo:$id', (workspace) => workspace.undo(id));

  Future<bool> archiveStudyResource(String id, bool archived) =>
      _changeLearningWorkspace('resource:$id', (workspace) {
        final resource = workspace.resources
            .where((resource) => resource.id == id)
            .firstOrNull;
        if (resource == null) throw const FormatException('Kaynak bulunamadı.');
        return workspace.saveResource(resource.withArchived(archived));
      });

  Future<bool> archiveResourceTask(String id, bool archived) =>
      _changeLearningWorkspace('task:$id', (workspace) {
        final task = workspace.tasks.where((task) => task.id == id).firstOrNull;
        if (task == null) throw const FormatException('Görev bulunamadı.');
        return workspace.saveTask(task.withArchived(archived));
      });

  // ─── Weak Topics Actions ───────────────────────
  Future<bool> _changeWeakTopics(
    String id,
    void Function(List<WeakTopic>) change,
  ) async {
    final profile = activeProfile.id;
    final saved = await _changeRecordGroup(
      'weak_topics',
      id,
      weakTopics.map((topic) => topic.toJson()).toList(),
      (raw) {
        final list = (raw as List)
            .map(
              (item) =>
                  WeakTopic.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList();
        change(list);
        if (list.map((topic) => topic.id).toSet().length != list.length) {
          throw const FormatException('Konu kimliği yineleniyor.');
        }
        return list.map((topic) => topic.toJson()).toList();
      },
      (raw) {
        weakTopics = (raw as List)
            .map(
              (item) =>
                  WeakTopic.fromJson(Map<String, dynamic>.from(item as Map)),
            )
            .toList();
        _applyWeakTopicReviews();
      },
    );
    if (saved && profile == activeProfile.id && !isProfileTransitioning)
      await checkAchievements();
    return saved;
  }

  Future<bool> addWeakTopic(WeakTopic topic) {
    final copy = WeakTopic.fromJson(topic.toJson());
    return _changeWeakTopics(topic.id, (list) {
      if (list.any((item) => item.id == copy.id)) {
        throw const FormatException('Konu zaten kayıtlı.');
      }
      list.add(copy);
    });
  }

  Future<bool> toggleWeakTopicStudied(String id) {
    final now = DateTime.now();
    return _changeWeakTopics(id, (list) {
      final topic = list.firstWhere((topic) => topic.id == id);
      if (topic.isStudied) {
        topic.setReviewFlags(now, isStudied: false);
      } else {
        topic.scheduleNextReview(
          now,
          eventId: 'manual:$id:${now.microsecondsSinceEpoch}',
        );
      }
    });
  }

  Future<bool> toggleWeakTopicRepeat(String id) =>
      _changeWeakTopics(id, (list) {
        final topic = list.firstWhere((topic) => topic.id == id);
        topic.setReviewFlags(DateTime.now(), needsRepeat: !topic.needsRepeat);
      });
  Future<bool> completeWeakTopicReview(String id) {
    final now = DateTime.now();
    return _changeWeakTopics(id, (list) {
      final topic = list.firstWhere((topic) => topic.id == id);
      if (topic.isStudied && (topic.needsRepeat || topic.isReviewDueOn(now))) {
        topic.scheduleNextReview(
          now,
          eventId: 'manual:$id:${now.microsecondsSinceEpoch}',
        );
      }
    });
  }

  Future<bool> removeWeakTopic(String id) => _changeWeakTopics(
    id,
    (list) => list.removeWhere((topic) => topic.id == id),
  );
  Future<bool> restoreWeakTopic(
    WeakTopic topic, {
    required int index,
    required String profileId,
  }) async {
    if (profileId != activeProfile.id) return false;
    final copy = WeakTopic.fromJson(topic.toJson());
    return _changeWeakTopics(topic.id, (list) {
      if (!list.any((item) => item.id == topic.id)) {
        list.insert(index.clamp(0, list.length), copy);
      }
    });
  }

  // ─── Goals Actions ─────────────────────────────
  List<dynamic> _goalRecordsSnapshot() => [
    ...goals.map((goal) => goal.toJson()),
    ..._quarantinedGoalRecords.map(Goal.quarantineRecord),
  ];
  void _applyGoalRecords(dynamic raw) {
    goals = [];
    _quarantinedGoalRecords.clear();
    for (final value in raw as List) {
      if (Goal.isQuarantinedRecord(value)) {
        _quarantinedGoalRecords.add(Goal.quarantinedRawValue(value));
        continue;
      }
      try {
        final goal = Goal.fromJson(Map<String, dynamic>.from(value as Map));
        goal.validateForPersistence();
        goals.add(goal);
      } catch (_) {
        _quarantinedGoalRecords.add(value);
      }
    }
  }

  Future<bool> _changeGoals(String id, void Function(List<dynamic>) change) =>
      _changeRecordGroup('goals_data', id, _goalRecordsSnapshot(), (raw) {
        final list = raw is List
            ? List<dynamic>.of(raw)
            : [Goal.quarantineRecord(raw)];
        for (var index = 0; index < list.length; index++) {
          final value = list[index];
          if (Goal.isQuarantinedRecord(value)) continue;
          try {
            Goal.fromJson(
              Map<String, dynamic>.from(value as Map),
            ).validateForPersistence();
          } catch (_) {
            list[index] = Goal.quarantineRecord(value);
          }
        }
        change(list);
        return list;
      }, _applyGoalRecords);
  Future<bool> addGoal(Goal goal) {
    goal.validateForCreation();
    final copy = goal.toJson();
    return _changeGoals(goal.id, (list) {
      if (list.any((value) => value is Map && value['id'] == goal.id)) {
        throw const FormatException('Hedef zaten kayıtlı.');
      }
      list.add(copy);
    });
  }

  Future<bool> updateGoalProgress(String goalId, int newCount) async {
    final profile = activeProfile.id;
    final wasCompleted =
        goals.where((goal) => goal.id == goalId).firstOrNull?.isCompleted ??
        false;
    final saved = await _changeGoals(goalId, (list) {
      final index = list.indexWhere(
        (value) => value is Map && value['id'] == goalId,
      );
      if (index < 0) throw const FormatException('Hedef bulunamadı.');
      final goal = Goal.fromJson(Map<String, dynamic>.from(list[index] as Map));
      if (!goal.hasValidTarget) {
        throw const FormatException('Hedef sayısı geçersiz.');
      }
      goal.currentCount = newCount.clamp(0, goal.targetCount * 2);
      list[index] = goal.toJson();
    });
    if (saved &&
        profile == activeProfile.id &&
        !isProfileTransitioning &&
        !wasCompleted &&
        goals.any((goal) => goal.id == goalId && goal.isCompleted)) {
      onCelebrate?.call();
    }
    return saved;
  }

  Future<bool> removeGoal(String id) => _changeGoals(
    id,
    (list) => list.removeWhere((value) => value is Map && value['id'] == id),
  );
  Future<bool> restoreGoal(
    Goal goal, {
    required int index,
    required String profileId,
  }) async {
    if (profileId != activeProfile.id) return false;
    final copy = goal.toJson();
    return _changeGoals(goal.id, (list) {
      if (!list.any((value) => value is Map && value['id'] == goal.id)) {
        list.insert(index.clamp(0, list.length), copy);
      }
    });
  }

  Future<bool> removeQuarantinedGoalRecord(int index) async {
    if (index < 0 || index >= _quarantinedGoalRecords.length) return false;
    final target = jsonEncode(
      Goal.quarantineRecord(_quarantinedGoalRecords[index]),
    );
    return _changeGoals('quarantine:$index', (list) {
      final found = list.indexWhere((value) => jsonEncode(value) == target);
      if (found >= 0) list.removeAt(found);
    });
  }

  Future<bool> restoreQuarantinedGoalRecord(
    Object? rawValue, {
    required int index,
    required String profileId,
  }) async {
    if (profileId != activeProfile.id) return false;
    final value = Goal.quarantineRecord(rawValue);
    return _changeGoals('quarantine:$index', (list) {
      list.add(value);
    });
  }

  // ─── Achievement Checker ───────────────────────
  Future<void> checkAchievements() async {
    if (isProfileTransitioning) return;
    final profile = activeProfile.id;
    final proposed = getDefaultAchievements();
    for (final achievement in proposed) {
      final existing = achievements
          .where((item) => item.id == achievement.id)
          .firstOrNull;
      if (existing != null) achievement.fromJson(existing.toJson());
    }
    final newly = AchievementProgressMetrics.unlockEligibleAchievements(
      achievements: proposed,
      subjects: subjects,
      mockExams: mockExams,
      weakTopics: weakTopics,
      streak: streak,
      completedTopics: completedTopics,
      totalTopics: totalTopics,
      completedDays: completedDays,
      now: DateTime.now(),
      attempts: examAttemptBook.attempts,
    );
    if (newly == null) return;
    final candidate = {
      for (final achievement in proposed.where((item) => item.isUnlocked))
        achievement.id: achievement.toJson(),
    };
    String? earned;
    final saved = await _changeRecordGroup(
      'achievements_data',
      'unlock',
      {},
      (raw) {
        final data = Map<String, dynamic>.from(raw as Map);
        for (final entry in candidate.entries) {
          final current = data[entry.key];
          if (current is! Map || current['isUnlocked'] != true) {
            data[entry.key] = entry.value;
            earned = proposed.firstWhere((item) => item.id == entry.key).title;
          }
        }
        return data;
      },
      (raw) {
        for (final achievement in achievements) {
          final value = raw[achievement.id];
          if (value is Map) {
            achievement.fromJson(Map<String, dynamic>.from(value));
          }
        }
      },
    );
    if (saved &&
        profile == activeProfile.id &&
        !isProfileTransitioning &&
        earned != null) {
      lastUnlockedAchievement = earned;
      notifyListeners();
    }
  }

  // ─── Computed Properties ───────────────────────
  int get daysRemaining {
    final now = DateTime.now();
    final target = DateTime(yksDate.year, yksDate.month, yksDate.day);
    return target.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  int get totalTopics => AchievementProgressMetrics.totalTopicCount(subjects);
  int get completedTopics =>
      AchievementProgressMetrics.completedTopicCount(subjects);
  double get overallProgress =>
      AchievementProgressMetrics.topicProgress(subjects);

  int get completedDays => completedStudyDates.length;
  int get totalDays => DailyPlanMetrics.totalStudyDays(
    completedDateKeys: completedStudyDateKeys,
    logs: reportDailyLogs,
  );

  /// Resource planning starts a new expectation timeline; earlier history stays.
  List<DailyLog> get reportDailyLogs {
    final plans = learningWorkspace.plans.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    if (plans.isEmpty) return dailyLogs;
    final first = plans.first.date;
    return [
      ...dailyLogs.where((log) => log.dateKey.compareTo(first) < 0),
      for (final day in plans)
        DailyLog(
          date: DateTime.parse(day.date),
          dayName: turkishWeekdayName(DateTime.parse(day.date)),
          tytContent: day.blocks
              .map(
                (block) =>
                    '${block.resourceName} · ${block.title} (${block.startUnit}–${block.endUnit} ${block.unitLabel})',
              )
              .join('\n'),
          aytContent: '',
          studyHours: '${day.plannedMinutes} dakika',
          motivationNote: '',
          isRestDay: day.blocks.isEmpty,
          isCompleted:
              day.blocks.isNotEmpty &&
              day.blocks.every(
                (block) =>
                    learningWorkspace.blockProgress(day, block) == block.units,
              ),
        ),
    ];
  }

  Set<String> get completedStudyDateKeys {
    final legacy = StudyHistoryMetrics.completedStudyDateKeys(
      _dailyPlanEntries,
      getDailySchedule(),
    );
    final plans = learningWorkspace.plans.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    if (plans.isEmpty) return legacy;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return {
      ...legacy.where((date) => date.compareTo(plans.first.date) < 0),
      for (final day in plans.where((day) => day.date.compareTo(today) <= 0))
        if (day.blocks.isNotEmpty &&
            day.blocks.every(
              (block) =>
                  learningWorkspace.blockProgress(day, block) == block.units,
            ))
          day.date,
    };
  }

  /// Derived views avoid duplicating resource progress in another persisted log.
  List<QuestionEvent> get reportQuestionEvents {
    final byTask = {for (final task in learningWorkspace.tasks) task.id: task};
    final byResource = {
      for (final resource in learningWorkspace.resources) resource.id: resource,
    };
    return [
      ...questionEvents,
      for (final event in learningWorkspace.events)
        if (event.active &&
            byResource[byTask[event.taskId]?.resourceId]?.unit ==
                StudyResourceUnit.question)
          QuestionEvent(
            id: 'resource:${event.id}',
            profileId: activeProfile.id,
            progressId: 'resource:${event.taskId}',
            topicId: null,
            occurredAt: event.occurredAt.toLocal(),
            questionCount: event.units,
          ),
    ];
  }

  Set<DateTime> get completedStudyDates => completedStudyDateKeys
      .map(DateTime.parse)
      .map((date) => DateTime(date.year, date.month, date.day))
      .toSet();

  int solvedQuestionsOn(DateTime date) {
    return StudyHistoryMetrics.solvedQuestionsOn(reportQuestionEvents, date);
  }

  int get legacyUnattributedQuestionCount =>
      StudyHistoryMetrics.legacyUnattributedQuestionCount(questionEvents);

  List<LegacyDailyActivity> get legacyDailyActivities =>
      StudyHistoryMetrics.legacyDailyActivities(
        _dailyLogHistory,
        getDailySchedule(),
      );

  int completedStudySessionsOn(DateTime date) {
    return StudyHistoryMetrics.completedSessionsOn(studySessions, date);
  }

  int studyMinutesOn(DateTime date) {
    return StudyHistoryMetrics.activeSecondsOn(studySessions, date) ~/ 60;
  }

  int completedStudySessionsBetween(DateTime start, DateTime end) =>
      StudyHistoryMetrics.completedSessionsBetween(
        studySessions,
        start: start,
        end: end,
      );

  int studySecondsBetween(DateTime start, DateTime end) =>
      StudyHistoryMetrics.activeSecondsBetween(
        studySessions,
        start: start,
        end: end,
      );

  int get streak {
    return StudyHistoryMetrics.streak(
      completedStudyDateKeys,
      schedulePreferences.availableWeekdays,
      DateTime.now(),
    );
  }

  DailyLog? get todayLog {
    return DailyPlanMetrics.logForDate(dailyLogs, DateTime.now());
  }

  /// Returns the next unfinished core task for a combined daily plan, or the
  /// current log for a repeat task whose identity is generated by the planner.
  DailyLog? nextIncompleteTaskFor(DailyLog log) {
    return DailyPlanMetrics.nextIncompleteTask(
      log: log,
      templateTasks: getDailySchedule(),
      planEntries: _dailyPlanEntries,
    );
  }

  List<Subject> get tytSubjects =>
      subjects.where((s) => s.type == 'TYT').toList();
  List<Subject> get aytSubjects =>
      subjects.where((s) => s.type == 'AYT').toList();

  int get totalSolvedQuestions =>
      StudyHistoryMetrics.totalSolvedQuestions(reportQuestionEvents);
  int get completedExams =>
      MockExamMetrics.completedCount(mockExams) +
      examAttemptBook.attempts.where((attempt) => !attempt.archived).length;
  MockExam? get nextUpcomingMockExam =>
      MockExamMetrics.nextUpcoming(mockExams, now: DateTime.now());

  int get unlockedAchievements =>
      AchievementProgressMetrics.unlockedCount(achievements);
  int get activeGoals => goals.where((g) => !g.isCompleted).length;
}
