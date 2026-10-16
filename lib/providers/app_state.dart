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
import '../models/mock_exam.dart';
import '../models/net_score.dart';
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
  final ProfileStorage _profileStorage = ProfileStorage.instance;
  ExamProfile _activeProfile = ExamProfile.defaultYks;
  Map<String, dynamic> _dailyPlanEntries = {};
  Map<String, dynamic> _dailyLogHistory = {};
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

  ExamProfile get activeProfile => _activeProfile;
  bool get isProfileTransitioning => _isProfileTransitioning;
  AppBootStatus get bootStatus => _bootStatus;
  String? get loadErrorMessage => _loadError?.toString();
  String? get persistenceError => _persistenceError;
  List<ExamProfile> get profiles => _profileStorage.profiles;
  List<Object?> get quarantinedGoalRecords =>
      List.unmodifiable(_quarantinedGoalRecords);
  StudySchedulePreferences get schedulePreferences => _schedulePreferences;
  List<WeakTopic> get prioritizedWeakTopics =>
      _prioritizedWeakTopicsFor(DateTime.now());

  List<WeakTopic> _prioritizedWeakTopicsFor(DateTime date) {
    final targetDay = DateTime(date.year, date.month, date.day);
    final topics = weakTopics.where((topic) {
      final addedOn = _weakTopicDate(topic.date);
      if (addedOn != null &&
          DateTime(
            addedOn.year,
            addedOn.month,
            addedOn.day,
          ).isAfter(targetDay)) {
        return false;
      }
      return !topic.isStudied || topic.needsRepeat || topic.isReviewDueOn(date);
    }).toList();
    topics.sort((a, b) {
      final repeatOrder = (b.needsRepeat ? 1 : 0).compareTo(
        a.needsRepeat ? 1 : 0,
      );
      if (repeatOrder != 0) return repeatOrder;
      final aDue = a.isReviewDueOn(date);
      final bDue = b.isReviewDueOn(date);
      if (aDue != bDue) return bDue ? 1 : -1;
      final errorOrder = b.errorCount.compareTo(a.errorCount);
      if (errorOrder != 0) return errorOrder;
      return (_weakTopicDate(b.date) ?? DateTime(0)).compareTo(
        _weakTopicDate(a.date) ?? DateTime(0),
      );
    });
    return topics;
  }

  // Celebration callback
  VoidCallback? onCelebrate;
  String? lastUnlockedAchievement;

  // Kept under the old getter name because existing screens use it.
  DateTime get yksDate => activeProfile.targetDate;

  Future<void> updateActiveProfile({
    String? name,
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

  AppState() {
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
    _schedulePreferences = StudySchedulePreferences.defaults;
    dailyLogs = _buildDailySchedule(_activeProfile.targetDate);
    mockExams = getExamCalendar(targetDate: _activeProfile.targetDate);
    _dailyPlanEntries = {};
    _dailyLogHistory = {};
    weakTopics = [];
    goals = [];
    _quarantinedGoalRecords.clear();
    questionEvents = [];
    studySessions = [];
    pomodoroTimerState = null;
    _questionEventSequence = 0;
    achievements = getDefaultAchievements();

    final curriculumJson = await _profileStorage.readStringForProfile(
      profileId,
      'custom_curriculum',
    );
    if (!isCurrentRequest()) return;
    if (curriculumJson != null) _restoreCustomCurriculum(curriculumJson);

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
    final logsJson = await _profileStorage.readStringForProfile(
      profileId,
      'daily_logs',
    );
    if (!isCurrentRequest()) return;
    if (logsJson != null) {
      _restoreDailyPlanProgress(logsJson);
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
      if (removedOrphans || attachedIds || migratedReviewDates) {
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
      _persistenceError = null;
      _syncDailyReminder();
      notifyListeners();
    }
  }

  void _syncDailyReminder() {
    unawaited(
      DailyReminderService.syncForProfile(
        profileName: _activeProfile.name,
        targetDate: _activeProfile.targetDate,
      ).catchError((Object _) {}),
    );
  }

  Future<void> _saveTopics() async {
    final profileId = _activeProfile.id;
    final Map<String, dynamic> data = {};
    for (var subject in subjects) {
      for (var topic in subject.topics) {
        data[topic.id] = topic.toJson();
      }
    }
    await _writeProfileData(profileId, {'topics_data': jsonEncode(data)});
  }

  Future<void> _saveDailyLogs(
    DailyLog changedLog, {
    bool? completedOverride,
  }) async {
    final profileId = _activeProfile.id;
    final ids = changedLog.progressIds;
    if (ids.isEmpty || changedLog.isRestDay) return;
    final each = changedLog.solvedQuestions ~/ ids.length;
    final remainder = changedLog.solvedQuestions % ids.length;
    for (var index = 0; index < ids.length; index++) {
      final id = ids[index];
      final previous = _dailyPlanEntries[id] is Map
          ? Map<String, dynamic>.from(_dailyPlanEntries[id] as Map)
          : <String, dynamic>{};
      previous['solvedQuestions'] = each + (index < remainder ? 1 : 0);
      previous['weakTopicNotes'] = index == 0 ? changedLog.weakTopicNotes : '';
      previous['activityAt'] = changedLog.activityAt?.toIso8601String();
      if (changedLog.reviewTopicId == null) {
        previous.remove('reviewTopicId');
      } else {
        previous['reviewTopicId'] = changedLog.reviewTopicId;
      }
      if (completedOverride != null) {
        previous['isCompleted'] = completedOverride;
        previous['completedAt'] = completedOverride
            ? changedLog.completedAt?.toIso8601String()
            : null;
      }
      _dailyPlanEntries[id] = previous;
    }
    await _writeProfileData(profileId, {
      'daily_logs': jsonEncode({
        'schemaVersion': 2,
        'entries': _dailyPlanEntries,
        'history': _dailyLogHistory,
      }),
      'question_history': jsonEncode(_questionHistoryJson()),
    });
  }

  void _migrateLegacyQuestionCounts(String profileId) {
    questionEvents = [];
    for (final entry in _dailyPlanEntries.entries) {
      if (entry.value is! Map) continue;
      final progress = Map<String, dynamic>.from(entry.value as Map);
      final count = (progress['solvedQuestions'] as num?)?.toInt() ?? 0;
      if (count <= 0) continue;
      questionEvents.add(
        QuestionEvent(
          id: 'legacy_${entry.key}',
          profileId: profileId,
          progressId: entry.key,
          topicId: null,
          occurredAt: null,
          questionCount: count,
          isLegacyUnattributed: true,
        ),
      );
    }
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

  int _questionCountForProgressIdOnDate(String progressId, DateTime date) {
    final dateKey = _dailyDateKey(date);
    return questionEvents.fold<int>(0, (sum, event) {
      final occurredAt = event.occurredAt;
      if (event.progressId != progressId ||
          event.isLegacyUnattributed ||
          occurredAt == null ||
          _dailyDateKey(occurredAt) != dateKey) {
        return sum;
      }
      return sum + event.questionCount;
    });
  }

  void _setQuestionCountForProgressId(
    String profileId,
    String progressId,
    int targetCount,
    DateTime studyDate,
  ) {
    final day = DateTime(studyDate.year, studyDate.month, studyDate.day);
    final dateKey = _dailyDateKey(day);
    final currentCount = _questionCountForProgressIdOnDate(progressId, day);
    if (targetCount > currentCount) {
      questionEvents.add(
        QuestionEvent(
          id: '${profileId}_q_${DateTime.now().microsecondsSinceEpoch}_${++_questionEventSequence}',
          profileId: profileId,
          progressId: progressId,
          topicId: null,
          occurredAt: day,
          questionCount: targetCount - currentCount,
        ),
      );
      return;
    }
    if (targetCount == currentCount) return;

    var toRemove = currentCount - targetCount;
    final dated =
        questionEvents
            .where(
              (event) =>
                  event.progressId == progressId &&
                  !event.isLegacyUnattributed &&
                  event.occurredAt != null &&
                  _dailyDateKey(event.occurredAt!) == dateKey,
            )
            .toList()
          ..sort(
            (first, second) => second.occurredAt!.compareTo(first.occurredAt!),
          );
    for (final event in dated) {
      if (toRemove == 0) break;
      final removed = event.questionCount < toRemove
          ? event.questionCount
          : toRemove;
      toRemove -= removed;
      if (removed == event.questionCount) {
        questionEvents.remove(event);
      } else {
        final index = questionEvents.indexOf(event);
        questionEvents[index] = event.withQuestionCount(
          event.questionCount - removed,
        );
      }
    }
  }

  Future<bool> recordStudySession(StudySession session) async {
    try {
      final profileId = session.profileId;
      List<StudySession> records;
      if (profileId == _activeProfile.id) {
        records = List<StudySession>.of(studySessions);
      } else {
        final saved = await _profileStorage.readStringForProfile(
          profileId,
          'study_sessions',
        );
        if (saved == null) {
          records = [];
        } else {
          final decoded = jsonDecode(saved);
          if (decoded is! List) {
            throw const FormatException('Odak oturumu kayıtları geçersiz.');
          }
          records = decoded
              .map(
                (value) => StudySession.fromJson(
                  Map<String, dynamic>.from(value as Map),
                ),
              )
              .toList();
        }
      }
      if (records.any((item) => item.id == session.id)) return true;
      records.add(session);
      await _profileStorage.writeStringsForProfile(profileId, {
        'study_sessions': jsonEncode(
          records.map((item) => item.toJson()).toList(),
        ),
      });
      if (profileId == _activeProfile.id && !_isProfileTransitioning) {
        studySessions = records;
        notifyListeners();
      }
      if (_persistenceError != null) {
        _persistenceError = null;
        notifyListeners();
      }
      return true;
    } catch (error) {
      _persistenceError = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> savePomodoroTimerState(PomodoroTimerState timerState) async {
    if (_isProfileTransitioning) return;
    await _writeProfileData(timerState.profileId, {
      'pomodoro_state': jsonEncode(timerState.toJson()),
    });
    if (timerState.profileId == _activeProfile.id && !_isProfileTransitioning) {
      pomodoroTimerState = timerState;
      notifyListeners();
    }
  }

  void _restoreDailyPlanProgress(String logsJson) {
    final decoded = jsonDecode(logsJson);
    if (decoded is! Map) {
      throw const FormatException('Günlük plan kayıtları geçersiz.');
    }

    if (decoded['schemaVersion'] == 2 && decoded['entries'] is Map) {
      _dailyPlanEntries = Map<String, dynamic>.from(decoded['entries'] as Map);
      final history = decoded['history'];
      _dailyLogHistory = history is Map
          ? Map<String, dynamic>.from(history)
          : {};
    } else {
      // Convert the original date-keyed format into stable day positions.
      // Keep every original key in history so no old value is discarded.
      final legacy = Map<String, dynamic>.from(decoded);
      final templateLogs = getDailySchedule();
      final templateKeys = templateLogs.map((log) => log.dateKey).toSet();
      _dailyPlanEntries = {};
      _dailyLogHistory = Map<String, dynamic>.of(legacy);

      for (final originalLog in templateLogs) {
        final saved = legacy[originalLog.dateKey];
        if (saved is! Map) continue;

        final progress = Map<String, dynamic>.from(saved);
        final hasActivity =
            progress['isCompleted'] == true ||
            (progress['solvedQuestions'] is num &&
                (progress['solvedQuestions'] as num) > 0) ||
            (progress['weakTopicNotes'] is String &&
                (progress['weakTopicNotes'] as String).isNotEmpty);
        if (progress['completedAt'] == null &&
            progress['isCompleted'] == true) {
          progress['completedAt'] = originalLog.date.toIso8601String();
        }
        if (progress['activityAt'] == null && hasActivity) {
          progress['activityAt'] = originalLog.date.toIso8601String();
        }
        final progressId = originalLog.progressIds.first;
        _dailyPlanEntries[progressId] = progress;
      }

      // Retain any non-template records in the preserved legacy map as well.
      _dailyLogHistory.addEntries(
        legacy.entries.where((entry) => !templateKeys.contains(entry.key)),
      );
    }

    _applyDailyPlanProgress();
  }

  void _applyDailyPlanProgress() {
    for (final log in dailyLogs) {
      if (log.progressIds.isEmpty) continue;
      final saved = log.progressIds
          .map((id) => _dailyPlanEntries[id])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      if (saved.isNotEmpty) {
        if (log.progressIds.length == 1) {
          log.fromJson(saved.single);
        } else {
          log.isCompleted =
              saved.length == log.progressIds.length &&
              saved.every((item) => item['isCompleted'] == true);
          log.completedProgressCount = saved
              .where((item) => item['isCompleted'] == true)
              .length;
          log.weakTopicNotes = saved
              .map((item) => item['weakTopicNotes'])
              .whereType<String>()
              .where((text) => text.isNotEmpty)
              .join('\n');
          log.activityAt = _latestProgressDate(saved, 'activityAt');
          log.completedAt = log.isCompleted
              ? _latestProgressDate(saved, 'completedAt')
              : null;
        }
      }
      log.solvedQuestions = log.progressIds.fold<int>(
        0,
        (sum, id) => sum + _questionCountForProgressIdOnDate(id, log.date),
      );
    }
  }

  DateTime? _latestProgressDate(
    List<Map<String, dynamic>> progress,
    String key,
  ) {
    final dates = progress
        .map((item) => item[key])
        .whereType<String>()
        .map(DateTime.tryParse)
        .whereType<DateTime>()
        .toList();
    if (dates.isEmpty) return null;
    dates.sort();
    return dates.last;
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
    if (_isProfileTransitioning) return;
    final updated = StudySchedulePreferences.fromJson({
      'version': 1,
      'availableWeekdays': availableWeekdays,
      'dailyStudyMinutes': dailyStudyMinutes,
    });
    final profileId = _activeProfile.id;
    await _writeProfileData(profileId, {
      'schedule_preferences': jsonEncode(updated.toJson()),
    });
    if (profileId != _activeProfile.id) return;
    _schedulePreferences = updated;
    dailyLogs = _buildDailySchedule(_activeProfile.targetDate);
    _applyDailyPlanProgress();
    _applyWeakTopicReviews();
    notifyListeners();
  }

  void _applyWeakTopicReviews() {
    final reviewDays = dailyLogs
        .where(
          (log) =>
              log.progressIds.length == 1 &&
              log.progressIds.single.startsWith('review_'),
        )
        .toList();
    for (var index = 0; index < reviewDays.length; index++) {
      final log = reviewDays[index];
      final priorityTopics = _prioritizedWeakTopicsFor(log.date);
      WeakTopic? topic;
      final assignedTopicId = log.reviewTopicId;
      if (assignedTopicId != null) {
        for (final candidate in weakTopics) {
          if (candidate.id == assignedTopicId) {
            topic = candidate;
            break;
          }
        }
      }
      if (topic != null &&
          !log.isCompleted &&
          !priorityTopics.any((candidate) => candidate.id == topic!.id)) {
        topic = null;
      }
      topic ??= log.isCompleted || priorityTopics.isEmpty
          ? null
          : priorityTopics[index % priorityTopics.length];
      final selectedTopic = topic;
      if (selectedTopic == null) {
        log.reviewTopicId = null;
        log.tytContent =
            'Önceki konulardan kısa tekrar yap; takıldığın başlıkları not et.';
        log.aytContent =
            'Dersler veya Zayıf Konular bölümünden bir eksik seçip çalış.';
        log.motivationNote =
            'Sınava kadar kalan dönemi tekrar ve eksik kapatmaya ayır.';
        continue;
      }
      log.reviewTopicId = selectedTopic.id;
      final subject = subjects.where(
        (item) =>
            item.storageId == selectedTopic.subjectId ||
            item.name == selectedTopic.subject,
      );
      final isAyt = subject.isNotEmpty
          ? subject.first.type == 'AYT'
          : selectedTopic.subject.toUpperCase().startsWith('AYT');
      final content =
          'Öncelikli tekrar: ${selectedTopic.topic} · ${selectedTopic.errorType}. ${selectedTopic.action}';
      if (isAyt) {
        log.tytContent = 'Kısa paragraf veya temel matematik tekrarı yap.';
        log.aytContent = '${selectedTopic.subject}: $content';
      } else {
        log.tytContent = '${selectedTopic.subject}: $content';
        log.aytContent = 'Son işlediğin konudan kısa tekrar yap.';
      }
      log.motivationNote =
          'Deneme ve hata kayıtlarına göre ${selectedTopic.subject} önceliklendirildi.';
    }
  }

  DateTime? _weakTopicDate(String value) {
    final isoDate = DateTime.tryParse(value);
    if (isoDate != null) return isoDate;
    final parts = value.split('.');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
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

  Future<void> _saveCustomCurriculumForProfile(String profileId) async {
    final curriculumJson = _customCurriculumJson();
    await _writeProfileData(profileId, {'custom_curriculum': curriculumJson});
  }

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

  String _topicsProgressJson() {
    final data = <String, dynamic>{};
    for (final subject in subjects) {
      for (final topic in subject.topics) {
        data[topic.id] = topic.toJson();
      }
    }
    return jsonEncode(data);
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

  Future<void> _saveCurriculumAndTopics(String profileId) async {
    // Serialize both values before either async write so a profile switch
    // cannot cause the second save to capture the next profile's in-memory list.
    final curriculumJson = _customCurriculumJson();
    final topicsJson = _topicsProgressJson();
    await _writeProfileData(profileId, {
      'custom_curriculum': curriculumJson,
      'topics_data': topicsJson,
    });
  }

  Future<void> addCustomSubject({
    required String name,
    required String type,
    required int totalQuestions,
  }) async {
    if (_isProfileTransitioning) return;
    final profileId = _activeProfile.id;
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
    await _saveCustomCurriculumForProfile(profileId);
    notifyListeners();
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
    if (_isProfileTransitioning) return;
    final profileId = _activeProfile.id;
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
    await _saveCurriculumAndTopics(profileId);
    notifyListeners();
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
    if (_isProfileTransitioning) return;
    final profileId = _activeProfile.id;
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
    await _saveCurriculumAndTopics(profileId);
    notifyListeners();
  }

  Future<void> removeCustomTopic({
    required String subjectId,
    required String topicId,
  }) async {
    if (_isProfileTransitioning) return;
    final profileId = _activeProfile.id;
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
    _applyWeakTopicReviews();
    final weakTopicsJson = _weakTopicsJson();
    await _saveCurriculumAndTopics(profileId);
    await _saveWeakTopicsForProfile(profileId, weakTopicsJson);
    notifyListeners();
  }

  Future<void> removeCustomSubject(String subjectId) async {
    if (_isProfileTransitioning) return;
    final profileId = _activeProfile.id;
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
    _applyWeakTopicReviews();
    final weakTopicsJson = _weakTopicsJson();
    await _saveCurriculumAndTopics(profileId);
    await _saveWeakTopicsForProfile(profileId, weakTopicsJson);
    notifyListeners();
  }

  Future<void> _saveMockExams() async {
    final profileId = _activeProfile.id;
    final Map<String, dynamic> data = {};
    for (var exam in mockExams) {
      data[exam.id] = exam.toJson();
    }
    await _writeProfileData(profileId, {'mock_exams': jsonEncode(data)});
  }

  Future<void> _saveWeakTopics() async {
    final profileId = _activeProfile.id;
    await _saveWeakTopicsForProfile(profileId, _weakTopicsJson());
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

  Future<void> _saveGoals() async {
    final profileId = _activeProfile.id;
    final savedGoals = [
      ...goals.map((goal) => goal.toJson()),
      ..._quarantinedGoalRecords.map(Goal.quarantineRecord),
    ];
    await _writeProfileData(profileId, {'goals_data': jsonEncode(savedGoals)});
  }

  Future<void> _saveAchievements() async {
    final profileId = _activeProfile.id;
    final Map<String, dynamic> data = {};
    for (var a in achievements) {
      data[a.id] = a.toJson();
    }
    await _writeProfileData(profileId, {'achievements_data': jsonEncode(data)});
  }

  Future<void> _writeProfileData(
    String profileId,
    Map<String, String> values,
  ) async {
    try {
      await _profileStorage.writeStringsForProfile(profileId, values);
      if (_persistenceError != null) {
        _persistenceError = null;
        notifyListeners();
      }
    } catch (error) {
      _persistenceError = error.toString();
      notifyListeners();
    }
  }

  void dismissPersistenceError() {
    if (_persistenceError == null) return;
    _persistenceError = null;
    notifyListeners();
  }

  // ─── Topic Actions ─────────────────────────────
  void toggleTopic(String topicId) {
    if (_isProfileTransitioning) return;
    for (var subject in subjects) {
      for (var topic in subject.topics) {
        if (topic.id == topicId) {
          topic.isCompleted = !topic.isCompleted;
          if (topic.isCompleted) {
            onCelebrate?.call(); // 🎉 Confetti!
          }
          _saveTopics();
          checkAchievements();
          notifyListeners();
          return;
        }
      }
    }
  }

  void updateTopicNotes(String topicId, String notes) {
    if (_isProfileTransitioning) return;
    for (var subject in subjects) {
      for (var topic in subject.topics) {
        if (topic.id == topicId) {
          topic.notes = notes;
          _saveTopics();
          notifyListeners();
          return;
        }
      }
    }
  }

  // ─── Daily Log Actions ─────────────────────────
  void toggleDayCompleted(String dateKey) {
    if (_isProfileTransitioning) return;
    for (var log in dailyLogs) {
      if (log.dateKey == dateKey && !log.isRestDay) {
        log.isCompleted = !log.isCompleted;
        log.completedProgressCount = log.isCompleted
            ? log.progressIds.length
            : 0;
        final now = DateTime.now();
        log.activityAt = now;
        log.completedAt = log.isCompleted ? now : null;
        if (log.isCompleted &&
            log.progressIds.length == 1 &&
            log.progressIds.single.startsWith('review_') &&
            log.reviewTopicId != null) {
          _recordWeakTopicReview(log.reviewTopicId!, fromPlanTask: true);
        }
        _saveDailyLogs(log, completedOverride: log.isCompleted);
        checkAchievements();
        notifyListeners();
        return;
      }
    }
  }

  void updateDailyLog(
    String dateKey, {
    int? solvedQuestions,
    String? weakTopicNotes,
  }) {
    if (_isProfileTransitioning) return;
    for (var log in dailyLogs) {
      if (log.dateKey == dateKey && !log.isRestDay) {
        if (solvedQuestions != null) {
          final targetCount = solvedQuestions < 0 ? 0 : solvedQuestions;
          final each = log.progressIds.isEmpty
              ? 0
              : targetCount ~/ log.progressIds.length;
          final remainder = log.progressIds.isEmpty
              ? 0
              : targetCount % log.progressIds.length;
          final profileId = _activeProfile.id;
          for (var index = 0; index < log.progressIds.length; index++) {
            _setQuestionCountForProgressId(
              profileId,
              log.progressIds[index],
              each + (index < remainder ? 1 : 0),
              log.date,
            );
          }
          log.solvedQuestions = targetCount;
        }
        if (weakTopicNotes != null) log.weakTopicNotes = weakTopicNotes;
        log.activityAt = DateTime.now();
        _saveDailyLogs(log);
        notifyListeners();
        return;
      }
    }
  }

  // ─── Mock Exam Actions ─────────────────────────
  bool updateMockExam(
    String examId, {
    Map<String, double>? nets,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    if (_isProfileTransitioning) return false;
    if (nets != null) {
      final normalized = <String, double>{};
      for (final entry in nets.entries) {
        if (!NetScore.isStorable(entry.value)) return false;
        normalized[MockExam.normalizeNetKey(entry.key)] = entry.value;
      }
      for (final subject in subjects) {
        final key = MockExam.netKeyForSubject(subject.type, subject.name);
        final value = normalized[key];
        if (value != null && !NetScore.isValid(value, subject.totalQuestions)) {
          return false;
        }
      }
    }
    for (var exam in mockExams) {
      if (exam.id == examId) {
        if (nets != null) exam.nets = nets;
        if (isCompleted != null) {
          final wasCompleted = exam.isCompleted;
          exam.isCompleted = isCompleted;
          if (!isCompleted) {
            exam.completedAt = null;
          } else if (completedAt != null) {
            exam.completedAt = DateTime(
              completedAt.year,
              completedAt.month,
              completedAt.day,
            );
          } else if (!wasCompleted && exam.completedAt == null) {
            final now = DateTime.now();
            exam.completedAt = DateTime(now.year, now.month, now.day);
          }
        }
        exam.updatedAt = DateTime.now();
        _saveMockExams();
        checkAchievements();
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  // ─── Weak Topics Actions ───────────────────────
  void addWeakTopic(WeakTopic topic) {
    if (_isProfileTransitioning) return;
    weakTopics.add(topic);
    _applyWeakTopicReviews();
    _saveWeakTopics();
    notifyListeners();
  }

  void toggleWeakTopicStudied(String id) {
    if (_isProfileTransitioning) return;
    final topic = weakTopics.firstWhere((t) => t.id == id);
    topic.isStudied = !topic.isStudied;
    if (topic.isStudied) {
      topic.needsRepeat = false;
      topic.scheduleNextReview(DateTime.now());
    }
    _applyWeakTopicReviews();
    _saveWeakTopics();
    checkAchievements();
    notifyListeners();
  }

  void toggleWeakTopicRepeat(String id) {
    if (_isProfileTransitioning) return;
    final topic = weakTopics.firstWhere((t) => t.id == id);
    topic.needsRepeat = !topic.needsRepeat;
    _applyWeakTopicReviews();
    _saveWeakTopics();
    notifyListeners();
  }

  void completeWeakTopicReview(String id) {
    _recordWeakTopicReview(id, fromPlanTask: false);
  }

  void _recordWeakTopicReview(String id, {required bool fromPlanTask}) {
    if (_isProfileTransitioning) return;
    final topic = weakTopics.firstWhere((t) => t.id == id);
    final now = DateTime.now();
    if (!fromPlanTask &&
        (!topic.isStudied ||
            (!topic.needsRepeat && !topic.isReviewDueOn(now)))) {
      return;
    }
    topic.isStudied = true;
    topic.needsRepeat = false;
    topic.scheduleNextReview(now);
    _applyWeakTopicReviews();
    _saveWeakTopics();
    notifyListeners();
  }

  void removeWeakTopic(String id) {
    if (_isProfileTransitioning) return;
    weakTopics.removeWhere((t) => t.id == id);
    _applyWeakTopicReviews();
    _saveWeakTopics();
    notifyListeners();
  }

  void restoreWeakTopic(
    WeakTopic topic, {
    required int index,
    required String profileId,
  }) {
    if (_isProfileTransitioning || profileId != _activeProfile.id) return;
    if (weakTopics.any((savedTopic) => savedTopic.id == topic.id)) return;
    final insertionIndex = index < 0
        ? 0
        : index > weakTopics.length
        ? weakTopics.length
        : index;
    weakTopics.insert(insertionIndex, topic);
    _applyWeakTopicReviews();
    _saveWeakTopics();
    notifyListeners();
  }

  // ─── Goals Actions ─────────────────────────────
  void addGoal(Goal goal) {
    if (_isProfileTransitioning) return;
    goal.validateForCreation();
    goals.add(goal);
    _saveGoals();
    notifyListeners();
  }

  void updateGoalProgress(String goalId, int newCount) {
    if (_isProfileTransitioning) return;
    final goal = goals.firstWhere((g) => g.id == goalId);
    if (!goal.hasValidTarget) return;
    final wasCompleted = goal.isCompleted;
    goal.currentCount = newCount.clamp(
      0,
      goal.targetCount * 2,
    ); // allow some overflow
    if (!wasCompleted && goal.isCompleted) {
      onCelebrate?.call(); // 🎉 Confetti!
    }
    _saveGoals();
    notifyListeners();
  }

  void removeGoal(String id) {
    if (_isProfileTransitioning) return;
    goals.removeWhere((g) => g.id == id);
    _saveGoals();
    notifyListeners();
  }

  void removeQuarantinedGoalRecord(int index) {
    if (_isProfileTransitioning ||
        index < 0 ||
        index >= _quarantinedGoalRecords.length) {
      return;
    }
    _quarantinedGoalRecords.removeAt(index);
    _saveGoals();
    notifyListeners();
  }

  void restoreQuarantinedGoalRecord(
    Object? rawValue, {
    required int index,
    required String profileId,
  }) {
    if (_isProfileTransitioning || profileId != _activeProfile.id) return;
    final insertionIndex = index.clamp(0, _quarantinedGoalRecords.length);
    _quarantinedGoalRecords.insert(insertionIndex, rawValue);
    _saveGoals();
    notifyListeners();
  }

  void restoreGoal(Goal goal, {required int index, required String profileId}) {
    if (_isProfileTransitioning || profileId != _activeProfile.id) return;
    if (goals.any((savedGoal) => savedGoal.id == goal.id)) return;
    final insertionIndex = index < 0
        ? 0
        : index > goals.length
        ? goals.length
        : index;
    goals.insert(insertionIndex, goal);
    _saveGoals();
    notifyListeners();
  }

  // ─── Achievement Checker ───────────────────────
  void checkAchievements() {
    final now = DateTime.now();
    final dateStr = DateTime(now.year, now.month, now.day).toIso8601String();
    bool anyNew = false;

    void unlock(String id) {
      final a = achievements.firstWhere((a) => a.id == id);
      if (!a.isUnlocked) {
        a.isUnlocked = true;
        a.unlockedDate = dateStr;
        lastUnlockedAchievement = a.title;
        anyNew = true;
      }
    }

    // Streak
    if (streak >= 3) unlock('streak_3');
    if (streak >= 7) unlock('streak_7');
    if (streak >= 14) unlock('streak_14');
    if (streak >= 30) unlock('streak_30');
    if (streak >= 60) unlock('streak_60');

    // Topics
    if (completedTopics >= 1) unlock('topic_1');
    if (completedTopics >= 10) unlock('topic_10');
    if (completedTopics >= 25) unlock('topic_25');
    if (completedTopics >= 50) unlock('topic_50');
    if (completedTopics >= 75) unlock('topic_75');
    if (completedTopics >= totalTopics && totalTopics > 0) unlock('topic_all');

    // Subject-specific
    final tytMat = subjects.firstWhere((s) => s.name == 'TYT Matematik');
    if (tytMat.progress >= 0.5) unlock('tyt_mat_50');
    if (tytMat.progress >= 1.0) unlock('tyt_mat_100');

    final tytTur = subjects.firstWhere((s) => s.name == 'TYT Türkçe');
    if (tytTur.progress >= 0.5) unlock('tyt_tur_50');
    if (tytTur.progress >= 1.0) unlock('tyt_tur_100');

    final officialTytSubjects = tytSubjects.where((s) => !s.isCustom).toList();
    final officialAytSubjects = aytSubjects.where((s) => !s.isCustom).toList();
    final allTytDone = officialTytSubjects.every((s) => s.progress >= 1.0);
    if (allTytDone && officialTytSubjects.isNotEmpty) unlock('all_tyt');

    final allAytDone = officialAytSubjects.every((s) => s.progress >= 1.0);
    if (allAytDone && officialAytSubjects.isNotEmpty) unlock('all_ayt');

    // Exams
    if (completedExams >= 1) unlock('exam_1');
    if (completedExams >= 5) unlock('exam_5');
    if (completedExams >= 10) unlock('exam_10');
    if (mockExams.isNotEmpty && completedExams >= mockExams.length) {
      unlock('exam_all');
    }

    for (var exam in mockExams.where((e) => e.isCompleted)) {
      final officialTyt = tytSubjects.where((subject) => !subject.isCustom);
      if (exam.hasScoresForSubjects(officialTyt)) {
        final officialTytNet = exam.totalForSubjects(officialTyt);
        if (officialTytNet >= 40) unlock('tyt_40');
        if (officialTytNet >= 50) unlock('tyt_50');
        if (officialTytNet >= 60) unlock('tyt_60');
      }
    }

    // Study days
    if (completedDays >= 1) unlock('day_first');
    if (completedDays >= 7) unlock('day_7');
    if (completedDays >= 30) unlock('day_30');
    if (completedDays >= 60) unlock('day_60');
    if (completedDays >= 90) unlock('day_90');

    // Weak topics
    if (weakTopics.where((t) => t.isStudied).length >= 5) unlock('weak_5');

    if (anyNew) {
      _saveAchievements();
    }
  }

  // ─── Computed Properties ───────────────────────
  int get daysRemaining {
    final now = DateTime.now();
    final target = DateTime(yksDate.year, yksDate.month, yksDate.day);
    return target.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  int get totalTopics => subjects.fold(0, (sum, s) => sum + s.topics.length);
  int get completedTopics =>
      subjects.fold(0, (sum, s) => sum + s.completedCount);
  double get overallProgress =>
      totalTopics == 0 ? 0 : completedTopics / totalTopics;

  int get completedDays => completedStudyDates.length;
  int get totalDays {
    final dates = {
      ...completedStudyDateKeys,
      ...dailyLogs.where((log) => !log.isRestDay).map((log) => log.dateKey),
    };
    return dates.length;
  }

  Set<String> get completedStudyDateKeys =>
      StudyHistoryMetrics.completedStudyDateKeys(
        _dailyPlanEntries,
        getDailySchedule(),
      );

  Set<DateTime> get completedStudyDates => completedStudyDateKeys
      .map(DateTime.parse)
      .map((date) => DateTime(date.year, date.month, date.day))
      .toSet();

  int solvedQuestionsOn(DateTime date) {
    return StudyHistoryMetrics.solvedQuestionsOn(questionEvents, date);
  }

  int get legacyUnattributedQuestionCount =>
      StudyHistoryMetrics.legacyUnattributedQuestionCount(questionEvents);

  List<LegacyDailyActivity> get legacyDailyActivities {
    final templateDateKeys = getDailySchedule()
        .map((log) => log.dateKey)
        .toSet();
    final activities = <LegacyDailyActivity>[];
    for (final entry in _dailyLogHistory.entries) {
      if (templateDateKeys.contains(entry.key) || entry.value is! Map) {
        continue;
      }
      final progress = Map<String, dynamic>.from(entry.value as Map);
      final questions = (progress['solvedQuestions'] as num?)?.toInt() ?? 0;
      final isCompleted = progress['isCompleted'] == true;
      final notes = progress['weakTopicNotes'] is String
          ? progress['weakTopicNotes'] as String
          : '';
      if (!isCompleted && questions <= 0 && notes.isEmpty) continue;
      activities.add(
        LegacyDailyActivity(
          sourceDateKey: entry.key,
          date: DateTime.tryParse(entry.key),
          solvedQuestions: questions < 0 ? 0 : questions,
          isCompleted: isCompleted,
          weakTopicNotes: notes,
        ),
      );
    }
    activities.sort((first, second) {
      final firstDate = first.date;
      final secondDate = second.date;
      if (firstDate != null && secondDate != null) {
        return secondDate.compareTo(firstDate);
      }
      if (firstDate != null) return -1;
      if (secondDate != null) return 1;
      return second.sourceDateKey.compareTo(first.sourceDateKey);
    });
    return List.unmodifiable(activities);
  }

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
    final now = DateTime.now();
    final todayKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    try {
      return dailyLogs.firstWhere((l) => l.dateKey == todayKey);
    } catch (_) {
      return null;
    }
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
      questionEvents.fold(0, (sum, event) => sum + event.questionCount);
  int get completedExams => mockExams.where((e) => e.isCompleted).length;
  MockExam? get nextUpcomingMockExam {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (final exam in mockExams) {
      final examDate = DateTime(exam.date.year, exam.date.month, exam.date.day);
      if (!exam.isCompleted && !examDate.isBefore(today)) return exam;
    }
    return null;
  }

  int get unlockedAchievements =>
      achievements.where((a) => a.isUnlocked).length;
  int get activeGoals => goals.where((g) => !g.isCompleted).length;
}

String _dailyDateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
