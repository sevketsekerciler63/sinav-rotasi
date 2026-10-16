import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/subjects_data.dart';
import '../models/exam_profile.dart';
import '../models/goal.dart';
import '../models/study_schedule_preferences.dart';
import '../models/pomodoro_timer_state.dart';
import '../models/net_score.dart';
import '../models/mock_exam.dart';
import '../models/flashcard_review.dart';

class BackupImportPreview {
  final bool isLegacy;
  final List<String> profileNames;
  final int dataGroupCount;
  final int recoveryRecordCount;

  const BackupImportPreview({
    required this.isLegacy,
    required this.profileNames,
    required this.dataGroupCount,
    this.recoveryRecordCount = 0,
  });
}

class _PreparedBackup {
  final bool isLegacy;
  final List<ExamProfile> profiles;
  final String activeProfileId;
  final Map<String, Map<String, dynamic>> data;
  final Map<String, dynamic> legacyData;

  const _PreparedBackup({
    required this.isLegacy,
    this.profiles = const [],
    this.activeProfileId = '',
    this.data = const {},
    this.legacyData = const {},
  });
}

class ProfileStorage {
  ProfileStorage._();

  @visibleForTesting
  ProfileStorage.forTesting();

  static final ProfileStorage instance = ProfileStorage._();

  static const int schemaVersion = 7;
  static const String backupFormat = 'sinav-rotasi-backup';
  static const String emergencyArchiveFormat = 'sinav-rotasi-emergency-archive';
  static const List<String> dataKeys = [
    'topics_data',
    'daily_logs',
    'daily_logs_quarantine',
    'recovery_records',
    'question_history',
    'study_sessions',
    'mock_exams',
    'weak_topics',
    'goals_data',
    'achievements_data',
    'flashcard_known',
    'flashcard_reviews',
    'custom_curriculum',
    'schedule_preferences',
    'pomodoro_state',
  ];

  static const String _schemaKey = 'profile_schema_version';
  static const String _profilesKey = 'exam_profiles';
  static const String _activeProfileKey = 'active_profile_id';
  static const String _transactionKey = 'profile_data_transaction';

  SharedPreferences? _prefs;
  List<ExamProfile> _profiles = [];
  String? _activeProfileId;
  Future<void>? _initializing;
  Future<void> _mutationQueue = Future<void>.value();

  List<ExamProfile> get profiles => List.unmodifiable(_profiles);

  ExamProfile get activeProfile {
    final id = _activeProfileId;
    return _profiles.firstWhere(
      (profile) => profile.id == id,
      orElse: () => throw StateError('Etkin sınav profili bulunamadı.'),
    );
  }

  Future<void> initialize() async {
    if (_prefs != null && _activeProfileId != null) return;
    final pending = _initializing;
    if (pending != null) return pending;

    final task = _initialize();
    _initializing = task;
    try {
      await task;
    } catch (_) {
      _initializing = null;
      rethrow;
    }
  }

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    await _recoverInterruptedTransaction(prefs);
    final storedVersion = prefs.getInt(_schemaKey) ?? 0;
    if (storedVersion > schemaVersion) {
      throw StateError(
        'Bu yedek/veri şeması uygulamanın desteklediği sürümden daha yeni.',
      );
    }

    final savedProfiles = _decodeProfiles(prefs.getString(_profilesKey));
    final profiles = savedProfiles.isEmpty
        ? <ExamProfile>[ExamProfile.defaultYks]
        : savedProfiles;
    if (storedVersion < 1 &&
        !profiles.any((profile) => profile.id == ExamProfile.defaultYksId)) {
      profiles.add(ExamProfile.defaultYks);
    }
    final profileIds = profiles.map((profile) => profile.id).toSet();
    if (profileIds.length != profiles.length) {
      throw const FormatException(
        'Kayıtlı sınav profillerinde yinelenen kimlik var.',
      );
    }

    final requestedActiveId = prefs.getString(_activeProfileKey);
    final activeId = storedVersion < 1
        ? ExamProfile.defaultYksId
        : requestedActiveId != null && profileIds.contains(requestedActiveId)
        ? requestedActiveId
        : profiles.first.id;

    // Write profile metadata first. The old data keys remain untouched until
    // every value has been copied and verified below.
    await _writeChecked(
      prefs,
      _profilesKey,
      jsonEncode(profiles.map((profile) => profile.toJson()).toList()),
    );

    if (storedVersion < 1) {
      final defaultProfile = profiles.firstWhere(
        (profile) => profile.id == ExamProfile.defaultYksId,
      );
      for (final key in dataKeys) {
        final legacyValue = prefs.getString(key);
        if (legacyValue == null) continue;
        final scopedKey = _scopedKey(defaultProfile.id, key);
        if (prefs.getString(scopedKey) == null) {
          await _writeChecked(prefs, scopedKey, legacyValue);
        }
        if (prefs.getString(scopedKey) != legacyValue) {
          throw StateError(
            'Mevcut $key verisi yeni profile doğrulanarak kopyalanamadı.',
          );
        }
      }
    }

    await _writeChecked(prefs, _activeProfileKey, activeId);
    // This marker is deliberately the final migration write. If a copy fails,
    // the next launch retries while the original legacy values still exist.
    if (storedVersion < schemaVersion) {
      await _writeChecked(prefs, _schemaKey, schemaVersion);
    }

    _prefs = prefs;
    _profiles = profiles;
    _activeProfileId = activeId;
  }

  Future<String?> readString(String key) async {
    _ensureDataKey(key);
    final requestedProfileId = _activeProfileId;
    await initialize();
    return readStringForProfile(requestedProfileId ?? activeProfile.id, key);
  }

  Future<String?> readStringForProfile(String profileId, String key) async {
    _ensureDataKey(key);
    await initialize();
    final profile = _profileForId(profileId);
    final scopedValue = _prefs!.getString(_scopedKey(profile.id, key));
    if (scopedValue != null) return scopedValue;
    if (_isLegacyCompatible(profile)) return _prefs!.getString(key);
    return null;
  }

  Future<void> writeString(String key, String value) async {
    _ensureDataKey(key);
    await initialize();
    await _enqueueMutation(() async {
      final profile = activeProfile;
      final updates = <String, Object?>{_scopedKey(profile.id, key): value};
      if (_isLegacyCompatible(profile)) updates[key] = value;
      await _applyPreferenceUpdates(updates);
    });
  }

  Future<void> writeStringForProfile(
    String profileId,
    String key,
    String value,
  ) async {
    await writeStringsForProfile(profileId, {key: value});
  }

  Future<void> writeStringsForProfile(
    String profileId,
    Map<String, String> values,
  ) async {
    for (final key in values.keys) {
      _ensureDataKey(key);
    }
    if (values.isEmpty) return;
    await initialize();
    await _enqueueMutation(() async {
      final profile = _profileForId(profileId);
      final updates = <String, Object?>{};
      for (final entry in values.entries) {
        updates[_scopedKey(profile.id, entry.key)] = entry.value;
        if (_isLegacyCompatible(profile)) updates[entry.key] = entry.value;
      }
      await _applyPreferenceUpdates(updates);
    });
  }

  Future<void> setActiveProfile(String profileId) async {
    await initialize();
    await _enqueueMutation(() async {
      if (!_profiles.any((profile) => profile.id == profileId)) {
        throw ArgumentError.value(
          profileId,
          'profileId',
          'Kayıtlı profil bulunamadı.',
        );
      }
      await _applyPreferenceUpdates({_activeProfileKey: profileId});
      _activeProfileId = profileId;
    });
  }

  /// Reads and transforms the latest committed values inside the write queue.
  /// The transform is synchronous and must not call another storage mutation.
  Future<Map<String, String>> mutateStringsForProfile(
    String profileId,
    Set<String> keys,
    Map<String, String> Function(Map<String, String?> current) transform,
  ) async {
    for (final key in keys) {
      _ensureDataKey(key);
    }
    await initialize();
    return _enqueueMutation(() async {
      final profile = _profileForId(profileId);
      final current = <String, String?>{
        for (final key in keys)
          key:
              _prefs!.getString(_scopedKey(profile.id, key)) ??
              (_isLegacyCompatible(profile) ? _prefs!.getString(key) : null),
      };
      final values = transform(Map.unmodifiable(current));
      if (values.keys.any((key) => !keys.contains(key))) {
        throw ArgumentError('İşlem kapsamı dışında veri yazılamaz.');
      }
      final updates = <String, Object?>{};
      for (final entry in values.entries) {
        _validateDataPayload(entry.key, jsonDecode(entry.value));
        updates[_scopedKey(profile.id, entry.key)] = entry.value;
        if (_isLegacyCompatible(profile)) updates[entry.key] = entry.value;
      }
      if (updates.isNotEmpty) await _applyPreferenceUpdates(updates);
      return values;
    });
  }

  Future<void> addProfile(
    ExamProfile profile, {
    Map<String, String> initialData = const {},
  }) async {
    await initialize();
    final validatedProfile = ExamProfile.fromJson(profile.toJson());
    for (final entry in initialData.entries) {
      _ensureDataKey(entry.key);
      _validateDataPayload(entry.key, jsonDecode(entry.value));
    }
    await _enqueueMutation(() async {
      if (_profiles.any((saved) => saved.id == validatedProfile.id)) {
        throw ArgumentError.value(
          validatedProfile.id,
          'profile',
          'Bu profil kimliği zaten kullanılıyor.',
        );
      }

      final updatedProfiles = [..._profiles, validatedProfile];
      final updates = <String, Object?>{
        _profilesKey: jsonEncode(
          updatedProfiles.map((item) => item.toJson()).toList(),
        ),
        for (final entry in initialData.entries)
          _scopedKey(validatedProfile.id, entry.key): entry.value,
      };
      await _applyPreferenceUpdates(updates);
      _profiles = updatedProfiles;
    });
  }

  Future<void> updateProfile(
    ExamProfile updatedProfile, {
    Map<String, String> additionalData = const {},
  }) async {
    await initialize();
    final validatedProfile = ExamProfile.fromJson(updatedProfile.toJson());
    for (final entry in additionalData.entries) {
      _ensureDataKey(entry.key);
      _validateDataPayload(entry.key, jsonDecode(entry.value));
    }
    await _enqueueMutation(() async {
      final index = _profiles.indexWhere(
        (profile) => profile.id == validatedProfile.id,
      );
      if (index == -1) {
        throw ArgumentError.value(
          validatedProfile.id,
          'updatedProfile',
          'Kayıtlı profil bulunamadı.',
        );
      }

      final updatedProfiles = List<ExamProfile>.of(_profiles);
      updatedProfiles[index] = validatedProfile;
      final updates = <String, Object?>{
        _profilesKey: jsonEncode(
          updatedProfiles.map((profile) => profile.toJson()).toList(),
        ),
        for (final entry in additionalData.entries)
          _scopedKey(validatedProfile.id, entry.key): entry.value,
        if (_isLegacyCompatible(validatedProfile))
          for (final entry in additionalData.entries) entry.key: entry.value,
      };
      await _applyPreferenceUpdates(updates);
      _profiles = updatedProfiles;
    });
  }

  /// Preserves raw managed preferences even if profile metadata or the journal
  /// cannot be opened. This archive is inert and is not a restorable backup.
  Future<Map<String, dynamic>> exportEmergencyArchive() =>
      _enqueueMutation(() async {
        final prefs = await SharedPreferences.getInstance();
        final keys =
            prefs
                .getKeys()
                .where(
                  (key) =>
                      _isManagedPreferenceKey(key) || key == _transactionKey,
                )
                .toList()
              ..sort();
        return {
          'format': emergencyArchiveFormat,
          'archiveVersion': 1,
          'createdAt': DateTime.now().toUtc().toIso8601String(),
          'rawPreferences': {for (final key in keys) key: prefs.get(key)},
        };
      });

  Future<Map<String, dynamic>> exportBackup() async {
    await initialize();
    return _enqueueMutation(() async {
      final profileData = <String, Map<String, dynamic>>{};
      for (final profile in _profiles) {
        final data = <String, dynamic>{};
        final rawValues = <String, String>{};
        final recovery = <Map<String, dynamic>>[];
        void preserve(String key, Object error) {
          final raw = rawValues[key];
          if (raw == null) return;
          data.remove(key);
          recovery.add({
            'dataKey': key,
            'rawValue': raw,
            'reason': error.toString(),
            'capturedAt': DateTime.now().toUtc().toIso8601String(),
          });
        }

        for (final key in dataKeys) {
          final raw =
              _prefs!.getString(_scopedKey(profile.id, key)) ??
              (_isLegacyCompatible(profile) ? _prefs!.getString(key) : null);
          if (raw == null) continue;
          rawValues[key] = raw;
          try {
            final payload = key == 'goals_data'
                ? _exportableGoalsPayload(raw)
                : jsonDecode(raw);
            _validateDataPayload(key, payload);
            _validateProfileRecordIds(profile.id, key, payload);
            if (key == 'recovery_records') {
              recovery.addAll(
                (payload['records'] as List).map(
                  (item) => Map<String, dynamic>.from(item as Map),
                ),
              );
            } else {
              data[key] = payload;
            }
          } catch (error) {
            preserve(key, error);
          }
        }
        try {
          _validateWeakTopicReferences(data);
        } catch (error) {
          preserve('weak_topics', error);
        }
        try {
          _validateNetScores(data);
        } catch (error) {
          preserve('mock_exams', error);
        }
        if (recovery.isNotEmpty) {
          data['recovery_records'] = {'schemaVersion': 1, 'records': recovery};
        }
        profileData[profile.id] = data;
      }
      final backup = <String, dynamic>{
        'format': backupFormat,
        'schemaVersion': schemaVersion,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
        'activeProfileId': _activeProfileId,
        'profiles': _profiles.map((profile) => profile.toJson()).toList(),
        'data': profileData,
      };
      // Never label an export as usable unless our importer can preview it.
      _prepareBackup(backup);
      return backup;
    });
  }

  int _recoveryRecordCount(Map<String, Map<String, dynamic>> data) =>
      data.values.fold(0, (total, values) {
        final archive = values['recovery_records'];
        return total +
            (archive is Map && archive['records'] is List
                ? (archive['records'] as List).length
                : 0);
      });

  void _validateProfileRecordIds(
    String profileId,
    String key,
    dynamic payload,
  ) {
    final records = key == 'question_history'
        ? payload['events']
        : key == 'study_sessions'
        ? payload
        : null;
    if (records is List &&
        records.any((record) => record['profileId'] != profileId)) {
      _invalid('$key.profileId', 'içinde bulunduğu profil kimliğiyle eşleşen');
    }
    if (key == 'pomodoro_state' && payload['profileId'] != profileId) {
      _invalid('$key.profileId', 'içinde bulunduğu profil kimliğiyle eşleşen');
    }
  }

  Future<BackupImportPreview> previewBackup(Map<String, dynamic> backup) async {
    await initialize();
    await _mutationQueue;
    final prepared = _prepareBackup(backup);
    return BackupImportPreview(
      isLegacy: prepared.isLegacy,
      recoveryRecordCount: prepared.isLegacy
          ? 0
          : _recoveryRecordCount(prepared.data),
      profileNames: prepared.isLegacy
          ? [activeProfile.name]
          : prepared.profiles.map((profile) => profile.name).toList(),
      dataGroupCount: prepared.isLegacy
          ? prepared.legacyData.length
          : prepared.data.values.fold(
              0,
              (total, profileData) => total + profileData.length,
            ),
    );
  }

  /// Previews a full backup without reading possibly damaged local metadata.
  /// Legacy backups need an active profile and therefore cannot be used here.
  Future<BackupImportPreview> previewBackupForStartupRecovery(
    Map<String, dynamic> backup,
  ) async {
    final prepared = _prepareBackup(backup);
    if (prepared.isLegacy) {
      throw const FormatException(
        'Başlangıç kurtarması için profilleri içeren tam yedek gerekli.',
      );
    }
    return BackupImportPreview(
      isLegacy: false,
      recoveryRecordCount: _recoveryRecordCount(prepared.data),
      profileNames: prepared.profiles.map((profile) => profile.name).toList(),
      dataGroupCount: prepared.data.values.fold(
        0,
        (total, profileData) => total + profileData.length,
      ),
    );
  }

  Future<void> importBackup(Map<String, dynamic> backup) async {
    await initialize();
    await _importBackup(backup, requireFullBackup: false);
  }

  /// Restores a complete, validated backup even when local profile metadata or
  /// an interrupted transaction prevents normal initialization.
  Future<void> importBackupForStartupRecovery(
    Map<String, dynamic> backup,
  ) async {
    final previousPrefs = _prefs;
    _prefs = await SharedPreferences.getInstance();
    try {
      await _importBackup(backup, requireFullBackup: true);
    } catch (_) {
      _prefs = previousPrefs;
      rethrow;
    }
  }

  Future<void> _importBackup(
    Map<String, dynamic> backup, {
    required bool requireFullBackup,
  }) async {
    await _enqueueMutation(() async {
      final prepared = _prepareBackup(backup);
      if (requireFullBackup && prepared.isLegacy) {
        throw const FormatException(
          'Başlangıç kurtarması için profilleri içeren tam yedek gerekli.',
        );
      }
      final updates = <String, Object?>{};

      if (prepared.isLegacy) {
        final profile = activeProfile;
        for (final entry in prepared.legacyData.entries) {
          final value = jsonEncode(entry.value);
          updates[_scopedKey(profile.id, entry.key)] = value;
          if (_isLegacyCompatible(profile)) updates[entry.key] = value;
        }
      } else {
        final incomingProfiles = {
          for (final profile in prepared.profiles) profile.id: profile,
        };
        final affectedProfiles = {
          for (final profile in _profiles) profile.id: profile,
          ...incomingProfiles,
        };

        // Replace the profile set as one import. Remove data belonging to local
        // profiles omitted by the backup so it cannot reappear if an ID is reused.
        for (final profile in affectedProfiles.values) {
          final incomingData = prepared.data[profile.id];
          for (final key in dataKeys) {
            final scopedKey = _scopedKey(profile.id, key);
            final value =
                incomingProfiles.containsKey(profile.id) &&
                    incomingData != null &&
                    incomingData.containsKey(key)
                ? jsonEncode(incomingData[key])
                : null;
            updates[scopedKey] = value;
            if (_isLegacyCompatible(profile)) updates[key] = value;
          }
        }
        final incomingIds = incomingProfiles.keys.toSet();
        for (final storedKey in _prefs!.getKeys()) {
          if (!storedKey.startsWith('profile_')) continue;
          for (final key in dataKeys) {
            final suffix = '__$key';
            if (!storedKey.endsWith(suffix)) continue;
            final profileId = storedKey.substring(
              'profile_'.length,
              storedKey.length - suffix.length,
            );
            if (!incomingIds.contains(profileId)) updates[storedKey] = null;
          }
        }
        updates[_profilesKey] = jsonEncode(
          prepared.profiles.map((profile) => profile.toJson()).toList(),
        );
        updates[_activeProfileKey] = prepared.activeProfileId;
        updates[_schemaKey] = schemaVersion;
      }

      await _applyPreferenceUpdates(updates);
      if (!prepared.isLegacy) {
        _profiles = prepared.profiles;
        _activeProfileId = prepared.activeProfileId;
      }
    });
  }

  _PreparedBackup _prepareBackup(Map<String, dynamic> backup) {
    final format = backup['format'];
    if (format == null) {
      final legacyData = <String, dynamic>{};
      for (final entry in backup.entries) {
        if (!dataKeys.contains(entry.key)) continue;
        _validateDataPayload(entry.key, entry.value);
        legacyData[entry.key] = entry.value;
      }
      _validateWeakTopicReferences(legacyData);
      _validateNetScores(legacyData);
      if (legacyData.isEmpty) {
        throw const FormatException(
          'Yedekte içe aktarılabilir veri bulunamadı.',
        );
      }
      return _PreparedBackup(isLegacy: true, legacyData: legacyData);
    }
    if (format != backupFormat) {
      throw const FormatException(
        'Yedek biçimi bu uygulama sürümünde tanınmıyor.',
      );
    }

    final version = backup['schemaVersion'];
    if (version is! int || version > schemaVersion || version < 1) {
      throw const FormatException(
        'Yedek şeması bu uygulama sürümünde desteklenmiyor.',
      );
    }
    final profilesJson = backup['profiles'];
    final dataJson = backup['data'];
    final activeId = backup['activeProfileId'];
    if (profilesJson is! List || dataJson is! Map || activeId is! String) {
      throw const FormatException(
        'Yedek profil bilgileri eksik veya geçersiz.',
      );
    }

    final profiles = profilesJson.map((value) {
      if (value is! Map) throw const FormatException('Profil kaydı geçersiz.');
      return ExamProfile.fromJson(Map<String, dynamic>.from(value));
    }).toList();
    final ids = profiles.map((profile) => profile.id).toSet();
    if (profiles.isEmpty ||
        ids.length != profiles.length ||
        !ids.contains(activeId)) {
      throw const FormatException(
        'Yedekte yinelenen profil veya geçersiz etkin profil var.',
      );
    }

    final validatedData = <String, Map<String, dynamic>>{};
    for (final entry in dataJson.entries) {
      if (entry.key is! String ||
          !ids.contains(entry.key) ||
          entry.value is! Map) {
        throw const FormatException('Yedekte profile bağlanamayan veri var.');
      }
      final profileValues = Map<String, dynamic>.from(entry.value as Map);
      if (profileValues.keys.any((key) => !dataKeys.contains(key))) {
        throw const FormatException(
          'Yedek bilinmeyen kullanıcı verisi içeriyor.',
        );
      }
      for (final value in profileValues.entries) {
        _validateDataPayload(value.key, value.value);
      }
      final questionHistory = profileValues['question_history'];
      if (questionHistory is Map && questionHistory['events'] is List) {
        for (final eventValue in questionHistory['events'] as List) {
          if (eventValue is Map && eventValue['profileId'] != entry.key) {
            _invalid(
              'question_history.profileId',
              'içinde bulunduğu profil kimliğiyle eşleşen',
            );
          }
        }
      }
      final studySessionValues = profileValues['study_sessions'];
      if (studySessionValues is List) {
        for (final sessionValue in studySessionValues) {
          if (sessionValue is Map && sessionValue['profileId'] != entry.key) {
            _invalid(
              'study_sessions.profileId',
              'içinde bulunduğu profil kimliğiyle eşleşen',
            );
          }
        }
      }
      final pomodoroValue = profileValues['pomodoro_state'];
      if (pomodoroValue is Map && pomodoroValue['profileId'] != entry.key) {
        _invalid(
          'pomodoro_state.profileId',
          'içinde bulunduğu profil kimliğiyle eşleşen',
        );
      }
      _validateWeakTopicReferences(profileValues);
      _validateNetScores(profileValues);
      validatedData[entry.key as String] = profileValues;
    }

    return _PreparedBackup(
      isLegacy: false,
      profiles: profiles,
      activeProfileId: activeId,
      data: validatedData,
    );
  }

  void _validateNetScores(Map<String, dynamic> profileValues) {
    final questionCounts = <String, int>{
      for (final subject in getAllSubjects())
        MockExam.netKeyForSubject(subject.type, subject.name):
            subject.totalQuestions,
    };
    final curriculum = profileValues['custom_curriculum'];
    if (curriculum is Map && curriculum['customSubjects'] is List) {
      for (final subjectValue in curriculum['customSubjects'] as List) {
        if (subjectValue is! Map ||
            subjectValue['type'] is! String ||
            subjectValue['name'] is! String ||
            subjectValue['totalQuestions'] is! int) {
          continue; // The curriculum validator reports malformed definitions.
        }
        final type = subjectValue['type'] as String;
        final name = subjectValue['name'] as String;
        questionCounts[MockExam.netKeyForSubject(type, name)] =
            subjectValue['totalQuestions'] as int;
      }
    }

    final exams = profileValues['mock_exams'];
    if (exams is! Map) return;
    for (final examEntry in exams.entries) {
      final exam = examEntry.value;
      if (exam is! Map || exam['nets'] is! Map) continue;
      final canonical = MockExam.canonicalizeNets({
        for (final entry in (exam['nets'] as Map).entries)
          entry.key as String: (entry.value as num).toDouble(),
      });
      exam['nets'] = canonical;
      for (final netEntry in canonical.entries) {
        final key = netEntry.key;
        final questionCount = questionCounts[key];
        if (questionCount != null &&
            !NetScore.isValid(netEntry.value, questionCount)) {
          _invalid(
            'mock_exams.${examEntry.key}.nets.$key',
            'soru sayısıyla uyumlu, çeyrek adımlı net',
          );
        }
      }
    }
  }

  Future<void> _applyPreferenceUpdates(Map<String, Object?> updates) async {
    final prefs = _prefs!;
    final before = {for (final key in updates.keys) key: prefs.get(key)};
    await _writeChecked(
      prefs,
      _transactionKey,
      jsonEncode({'version': 1, 'before': before}),
    );
    try {
      for (final entry in updates.entries) {
        await _writeChecked(prefs, entry.key, entry.value);
      }
      if (!await prefs.remove(_transactionKey)) {
        throw StateError('Yerel işlem günlüğü temizlenemedi.');
      }
    } catch (_) {
      final restored = await _restorePreferenceValues(prefs, before);
      var journalCleared = false;
      if (restored) {
        try {
          journalCleared = await prefs.remove(_transactionKey);
        } catch (_) {
          journalCleared = false;
        }
      }
      if (!restored || !journalCleared) {
        throw StateError(
          'Yazma başarısız oldu ve önceki verilerin geri yüklenmesi doğrulanamadı.',
        );
      }
      rethrow;
    }
  }

  Future<void> _recoverInterruptedTransaction(SharedPreferences prefs) async {
    final encoded = prefs.getString(_transactionKey);
    if (encoded == null) return;
    final decoded = jsonDecode(encoded);
    if (decoded is! Map ||
        decoded['version'] != 1 ||
        decoded['before'] is! Map) {
      throw const FormatException('Bekleyen yerel veri işlemi geçersiz.');
    }
    final before = <String, Object?>{};
    for (final entry in (decoded['before'] as Map).entries) {
      if (entry.key is! String ||
          !_isManagedPreferenceKey(entry.key as String)) {
        throw const FormatException('Bekleyen yerel işlem anahtarı geçersiz.');
      }
      final value = entry.value;
      if (value is List && value.any((item) => item is! String)) {
        throw const FormatException('Bekleyen yerel işlem değeri geçersiz.');
      }
      if (value != null &&
          value is! String &&
          value is! bool &&
          value is! int &&
          value is! double &&
          value is! List) {
        throw const FormatException('Bekleyen yerel işlem değeri geçersiz.');
      }
      before[entry.key as String] = value is List<String>
          ? value
          : value is List
          ? List<String>.from(value)
          : value;
    }
    if (!await _restorePreferenceValues(prefs, before)) {
      throw StateError('Kesilen yerel veri işlemi geri alınamadı.');
    }
    if (!await prefs.remove(_transactionKey)) {
      throw StateError('Kesilen yerel işlem günlüğü temizlenemedi.');
    }
  }

  bool _isManagedPreferenceKey(String key) {
    if (key == _schemaKey || key == _profilesKey || key == _activeProfileKey) {
      return true;
    }
    if (dataKeys.contains(key)) return true;
    return key.startsWith('profile_') &&
        dataKeys.any((dataKey) => key.endsWith('__$dataKey'));
  }

  Future<bool> _restorePreferenceValues(
    SharedPreferences prefs,
    Map<String, Object?> values,
  ) async {
    var restored = true;
    for (final entry in values.entries) {
      try {
        final restoredWrite = await _setPreference(
          prefs,
          entry.key,
          entry.value,
        );
        if (!restoredWrite ||
            !_samePreferenceValue(prefs.get(entry.key), entry.value)) {
          restored = false;
        }
      } catch (_) {
        restored = false;
      }
    }
    return restored;
  }

  Future<T> _enqueueMutation<T>(Future<T> Function() mutation) {
    final result = _mutationQueue.then((_) => mutation());
    _mutationQueue = result.then<void>(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {},
    );
    return result;
  }

  bool _samePreferenceValue(Object? first, Object? second) {
    if (first is List<String> && second is List<String>) {
      if (first.length != second.length) return false;
      for (var index = 0; index < first.length; index++) {
        if (first[index] != second[index]) return false;
      }
      return true;
    }
    return first == second;
  }

  Future<bool> _setPreference(
    SharedPreferences prefs,
    String key,
    Object? value,
  ) {
    if (value == null) return prefs.remove(key);
    if (value is String) return prefs.setString(key, value);
    if (value is bool) return prefs.setBool(key, value);
    if (value is int) return prefs.setInt(key, value);
    if (value is double) return prefs.setDouble(key, value);
    if (value is List<String>) return prefs.setStringList(key, value);
    throw StateError('Desteklenmeyen yerel veri türü: $key');
  }

  Future<void> _writeChecked(
    SharedPreferences prefs,
    String key,
    Object? value,
  ) async {
    if (!await _setPreference(prefs, key, value)) {
      throw StateError('Yerel veri yazılamadı: $key');
    }
  }

  void _validateDataPayload(String key, dynamic value) {
    switch (key) {
      case 'topics_data':
        final topics = _record(value, key);
        for (final entry in topics.entries) {
          final progress = _record(entry.value, '$key.${entry.key}');
          _optionalBool(progress, 'isCompleted', '$key.${entry.key}');
          _optionalString(progress, 'notes', '$key.${entry.key}');
        }
      case 'daily_logs':
        final logs = _record(value, key);
        if (logs.containsKey('schemaVersion')) {
          if (logs['schemaVersion'] != 2) {
            _invalid('$key.schemaVersion', 'desteklenen sürüm');
          }
          final entries = _record(logs['entries'], '$key.entries');
          for (final entry in entries.entries) {
            _validateDailyProgress(entry.value, '$key.entries.${entry.key}');
          }
          final history = logs['history'];
          if (history != null) {
            final historyRecords = _record(history, '$key.history');
            for (final entry in historyRecords.entries) {
              _validateDailyProgress(entry.value, '$key.history.${entry.key}');
            }
          }
        } else {
          for (final entry in logs.entries) {
            _validateDailyProgress(entry.value, '$key.${entry.key}');
          }
        }
      case 'question_history':
        final history = _record(value, key);
        if (history['schemaVersion'] != 1) {
          _invalid('$key.schemaVersion', 'desteklenen sürüm');
        }
        _optionalInt(history, 'legacyUnattributedQuestions', key, min: 0);
        final events = history['events'];
        if (events is! List) _invalid('$key.events', 'liste');
        final ids = <String>{};
        for (var index = 0; index < events.length; index++) {
          final path = '$key.events[$index]';
          final event = _record(events[index], path);
          for (final field in ['id', 'profileId']) {
            if (event[field] is! String ||
                (event[field] as String).trim().isEmpty) {
              _invalid('$path.$field', 'boş olmayan metin');
            }
          }
          if (!ids.add(event['id'] as String)) {
            _invalid('$path.id', 'benzersiz soru kaydı kimliği');
          }
          _optionalNullableString(event, 'progressId', path);
          _optionalNullableString(event, 'topicId', path);
          if (!event.containsKey('occurredAt')) {
            _invalid('$path.occurredAt', 'tarih veya null');
          }
          _optionalDate(event, 'occurredAt', path);
          if (event['questionCount'] is! int ||
              (event['questionCount'] as int) < 0) {
            _invalid('$path.questionCount', 'sıfır veya daha büyük tam sayı');
          }
          if (event['isLegacyUnattributed'] is! bool) {
            _invalid('$path.isLegacyUnattributed', 'doğru/yanlış değeri');
          }
          final isLegacy = event['isLegacyUnattributed'] == true;
          if ((isLegacy && event['occurredAt'] != null) ||
              (!isLegacy &&
                  DateTime.tryParse(event['occurredAt'] as String? ?? '') ==
                      null)) {
            _invalid(path, 'tarihi tutarlı soru kaydı');
          }
        }
      case 'study_sessions':
        final ids = <String>{};
        _validateRecordList(value, key, (session, path) {
          for (final field in ['id', 'profileId', 'status']) {
            if (session[field] is! String ||
                (session[field] as String).trim().isEmpty) {
              _invalid('$path.$field', 'boş olmayan metin');
            }
          }
          if (!ids.add(session['id'] as String)) {
            _invalid('$path.id', 'benzersiz oturum kimliği');
          }
          _optionalNullableString(session, 'taskId', path);
          _optionalNullableString(session, 'topicId', path);
          if (!session.containsKey('startedAt') ||
              !session.containsKey('endedAt')) {
            _invalid(path, 'başlangıç ve bitiş tarihli oturum');
          }
          _optionalDate(session, 'startedAt', path);
          _optionalDate(session, 'endedAt', path);
          if (session['activeSeconds'] is! int ||
              (session['activeSeconds'] as int) < 0) {
            _invalid('$path.activeSeconds', 'sıfır veya daha büyük tam sayı');
          }
          if (!const {
            'completed',
            'skipped',
            'cancelled',
          }.contains(session['status'])) {
            _invalid('$path.status', 'desteklenen oturum durumu');
          }
          final startedAt = DateTime.tryParse(
            session['startedAt'] as String? ?? '',
          );
          final endedAt = DateTime.tryParse(
            session['endedAt'] as String? ?? '',
          );
          if (startedAt == null ||
              endedAt == null ||
              endedAt.isBefore(startedAt)) {
            _invalid(path, 'başlangıç ve bitiş tarihi tutarlı oturum');
          }
        });
      case 'pomodoro_state':
        final timer = _record(value, key);
        PomodoroTimerState.fromJson(timer);
      case 'mock_exams':
        final exams = _record(value, key);
        for (final entry in exams.entries) {
          final exam = _record(entry.value, '$key.${entry.key}');
          _optionalString(exam, 'id', '$key.${entry.key}');
          _optionalBool(exam, 'isCompleted', '$key.${entry.key}');
          _optionalDate(exam, 'plannedDate', '$key.${entry.key}');
          _optionalDate(exam, 'completedAt', '$key.${entry.key}');
          _optionalDate(exam, 'updatedAt', '$key.${entry.key}');
          if (exam.containsKey('nets')) {
            final nets = _record(exam['nets'], '$key.${entry.key}.nets');
            for (final net in nets.entries) {
              if (net.value is! num ||
                  !(net.value as num).isFinite ||
                  !NetScore.isStorable((net.value as num).toDouble())) {
                _invalid('$key.${entry.key}.nets.${net.key}', 'net değeri');
              }
            }
          }
        }
      case 'recovery_records':
        final archive = _record(value, key);
        if (archive['schemaVersion'] != 1 || archive['records'] is! List) {
          _invalid(key, 'desteklenen kurtarma arşivi');
        }
        for (final record in archive['records'] as List) {
          final item = _record(record, '$key.records');
          if (item['dataKey'] is! String ||
              !dataKeys.contains(item['dataKey']) ||
              item['rawValue'] is! String ||
              item['reason'] is! String ||
              item['capturedAt'] is! String ||
              DateTime.tryParse(item['capturedAt'] as String) == null) {
            _invalid(key, 'ham veri ve kaynak bilgisi içeren kurtarma kaydı');
          }
        }
      case 'daily_logs_quarantine':
        final quarantine = _record(value, key);
        if (quarantine['schemaVersion'] != 1) {
          _invalid('$key.schemaVersion', 'desteklenen sürüm');
        }
        final payloads = quarantine['payloads'];
        if (payloads is! List || payloads.any((item) => item is! String)) {
          _invalid('$key.payloads', 'metinlerden oluşan liste');
        }
      case 'weak_topics':
        final ids = <String>{};
        _validateRecordList(value, key, (item, path) {
          final id = item['id'];
          if (id is! String || id.trim().isEmpty || !ids.add(id)) {
            _invalid('$path.id', 'boş olmayan ve benzersiz zayıf konu kimliği');
          }
          for (final field in [
            'id',
            'date',
            'subject',
            'topic',
            'errorType',
            'action',
          ]) {
            _optionalString(item, field, path);
          }
          _optionalNullableString(item, 'subjectId', path);
          _optionalNullableString(item, 'topicId', path);
          _optionalInt(item, 'errorCount', path, min: 0);
          _optionalBool(item, 'isStudied', path);
          _optionalBool(item, 'needsRepeat', path);
          _optionalDate(item, 'lastReviewedAt', path);
          _optionalDate(item, 'nextReviewAt', path);
          _optionalInt(item, 'reviewRepetitions', path, min: 0, max: 10000);
          _optionalInt(item, 'reviewIntervalDays', path, min: 0, max: 30);
        });
      case 'goals_data':
        if (value is! List) _invalid(key, 'hedef listesi');
        for (var index = 0; index < value.length; index++) {
          final path = '$key[$index]';
          final entry = value[index];
          if (Goal.isQuarantinedRecord(entry)) continue;
          final item = _record(entry, path);
          for (final field in ['id', 'title', 'subject', 'unit', 'deadline']) {
            if (item[field] is! String) _invalid('$path.$field', 'metin');
          }
          if ((item['id'] as String).trim().isEmpty ||
              (item['title'] as String).trim().isEmpty ||
              (item['title'] as String).length > 120 ||
              (item['subject'] as String).trim().isEmpty) {
            _invalid(path, 'başlığı ve kimliği olan hedef');
          }
          if (!Goal.supportedUnits.contains(item['unit'])) {
            _invalid('$path.unit', 'desteklenen hedef birimi');
          }
          if (!Goal.supportedDeadlines.contains(item['deadline'])) {
            _invalid('$path.deadline', 'desteklenen hedef süresi');
          }
          _optionalDate(item, 'createdAt', path);
          _optionalDate(item, 'dueDate', path);
          final createdAtValue = item['createdAt'];
          final dueDateValue = item['dueDate'];
          if (dueDateValue is String && createdAtValue is! String) {
            _invalid(
              '$path.createdAt',
              'bitiş tarihi olan hedefte oluşturulma tarihi',
            );
          }
          if (dueDateValue is String && createdAtValue is String) {
            final createdAt = DateTime.parse(createdAtValue);
            final dueDate = DateTime.parse(dueDateValue);
            final createdDay = DateTime(
              createdAt.year,
              createdAt.month,
              createdAt.day,
            );
            final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
            if (dueDay.isBefore(createdDay)) {
              _invalid('$path.dueDate', 'oluşturulma gününde veya sonrasında');
            }
          }
          final target = item['targetCount'];
          if (target is! int || target < 1 || target > Goal.maxTargetCount) {
            _invalid(
              '$path.targetCount',
              '1 ile ${Goal.maxTargetCount} arası tam sayı',
            );
          }
          _optionalInt(item, 'currentCount', path, min: 0);
          final current = item['currentCount'] ?? 0;
          if (current is int && current > target * 2) {
            _invalid(
              '$path.currentCount',
              'hedefin iki katını aşmayan ilerleme',
            );
          }
          _optionalBool(item, 'isCompleted', path);
        }
      case 'achievements_data':
        final achievements = _record(value, key);
        for (final entry in achievements.entries) {
          final achievement = _record(entry.value, '$key.${entry.key}');
          _optionalBool(achievement, 'isUnlocked', '$key.${entry.key}');
          _optionalAchievementDate(
            achievement,
            'unlockedDate',
            '$key.${entry.key}',
          );
        }
      case 'flashcard_known':
        if (value is! List || value.any((item) => item is! String)) {
          _invalid(key, 'metin listesi');
        }
      case 'flashcard_reviews':
        try {
          FlashcardReviewData.fromJson(value);
        } on FormatException catch (error) {
          _invalid(key, error.message);
        }
      case 'custom_curriculum':
        _validateCustomCurriculum(value, key);
      case 'schedule_preferences':
        StudySchedulePreferences.fromJson(_record(value, key));
    }
  }

  List<dynamic> _exportableGoalsPayload(String rawPayload) {
    Object? decoded;
    try {
      decoded = jsonDecode(rawPayload);
    } catch (_) {
      return [Goal.quarantineRecord(rawPayload)];
    }
    if (decoded is! List) return [Goal.quarantineRecord(decoded)];

    return decoded.map((entry) {
      if (Goal.isQuarantinedRecord(entry)) return entry;
      try {
        _validateDataPayload('goals_data', [entry]);
        return entry;
      } catch (_) {
        return Goal.quarantineRecord(entry);
      }
    }).toList();
  }

  void _validateWeakTopicReferences(Map<String, dynamic> profileValues) {
    final weakTopics = profileValues['weak_topics'];
    if (weakTopics is! List) return;

    final topicSubjects = <String, Set<String>>{};
    final subjectIds = <String>{};

    void addTopic(String subjectId, dynamic value, String path) {
      final topic = _record(value, path);
      final topicId = topic['id'];
      if (topicId is! String) return; // The curriculum validator reports it.
      subjectIds.add(subjectId);
      topicSubjects.putIfAbsent(topicId, () => <String>{}).add(subjectId);
    }

    for (final subject in getAllSubjects()) {
      final subjectId = subject.storageId;
      subjectIds.add(subjectId);
      for (final topic in subject.topics) {
        topicSubjects.putIfAbsent(topic.id, () => <String>{}).add(subjectId);
      }
    }

    final curriculum = profileValues['custom_curriculum'];
    if (curriculum is Map) {
      final customSubjects = curriculum['customSubjects'];
      if (customSubjects is List) {
        for (var index = 0; index < customSubjects.length; index++) {
          final subject = _record(
            customSubjects[index],
            'custom_curriculum.customSubjects[$index]',
          );
          final subjectId = subject['id'] as String;
          subjectIds.add(subjectId);
          final topics = subject['topics'];
          if (topics is List) {
            for (var topicIndex = 0; topicIndex < topics.length; topicIndex++) {
              addTopic(
                subjectId,
                topics[topicIndex],
                'custom_curriculum.customSubjects[$index].topics[$topicIndex]',
              );
            }
          }
        }
      }
      final customTopics = curriculum['customTopics'];
      if (customTopics is List) {
        for (var index = 0; index < customTopics.length; index++) {
          final item = _record(
            customTopics[index],
            'custom_curriculum.customTopics[$index]',
          );
          final subjectId = item['subjectId'] as String;
          addTopic(
            subjectId,
            item['topic'],
            'custom_curriculum.customTopics[$index].topic',
          );
        }
      }
    }

    for (var index = 0; index < weakTopics.length; index++) {
      final path = 'weak_topics[$index]';
      final item = _record(weakTopics[index], path);
      final subjectId = item['subjectId'];
      final topicId = item['topicId'];
      if (subjectId is String && !subjectIds.contains(subjectId)) {
        _invalid(
          '$path.subjectId',
          'bu profildeki katalogda bulunan ders kimliği',
        );
      }
      if (topicId is String) {
        final topicParents = topicSubjects[topicId];
        if (topicParents == null || topicParents.isEmpty) {
          _invalid(
            '$path.topicId',
            'bu profildeki katalogda bulunan konu kimliği',
          );
        }
        if (subjectId is String && !topicParents.contains(subjectId)) {
          _invalid('$path.topicId', 'belirtilen derse ait konu kimliği');
        }
        if (subjectId == null && topicParents.length > 1) {
          _invalid(
            '$path.subjectId',
            'konu kimliğini tekil yapan ders kimliği',
          );
        }
      }
    }
  }

  void _validateCustomCurriculum(dynamic value, String path) {
    final curriculum = _record(value, path);
    if (curriculum.containsKey('version') && curriculum['version'] != 1) {
      _invalid('$path.version', 'desteklenmeyen sürüm');
    }
    final knownSubjects = getAllSubjects();
    final subjectIds = knownSubjects
        .map((subject) => subject.storageId)
        .toSet();
    final subjectNames = <String, Set<String>>{
      for (final subject in knownSubjects)
        subject.storageId: {
          for (final topic in subject.topics) topic.name.trim().toLowerCase(),
        },
    };
    final customSubjectNames = <String>{};
    final topicIds = <String>{};

    void registerTopic(
      Map<String, dynamic> topic,
      String topicPath,
      String subjectId,
    ) {
      _validateCustomTopic(topic, topicPath);
      final id = topic['id'] as String;
      final normalizedName = (topic['name'] as String).trim().toLowerCase();
      if (!topicIds.add(id)) {
        _invalid('$topicPath.id', 'yinelenmeyen konu kimliği');
      }
      final names = subjectNames.putIfAbsent(subjectId, () => <String>{});
      if (!names.add(normalizedName)) {
        _invalid('$topicPath.name', 'bu derste yinelenmeyen konu adı');
      }
    }

    final customSubjects = curriculum['customSubjects'];
    if (customSubjects != null) {
      if (customSubjects is! List) _invalid('$path.customSubjects', 'liste');
      for (var index = 0; index < customSubjects.length; index++) {
        final item = _record(
          customSubjects[index],
          '$path.customSubjects[$index]',
        );
        final itemPath = '$path.customSubjects[$index]';
        if (item['id'] is! String ||
            !RegExp(r'^custom_subject_\d+$').hasMatch(item['id'] as String) ||
            item['name'] is! String ||
            (item['name'] as String).trim().isEmpty ||
            (item['type'] != 'TYT' && item['type'] != 'AYT') ||
            item['totalQuestions'] is! int ||
            (item['totalQuestions'] as int) < 1 ||
            (item['totalQuestions'] as int) > 200) {
          _invalid(itemPath, 'özel ders kaydı');
        }
        final id = item['id'] as String;
        final type = item['type'] as String;
        final normalizedSubjectName =
            '${type}_${(item['name'] as String).trim().toLowerCase()}';
        final conflictsWithBuiltIn = knownSubjects.any(
          (subject) =>
              subject.type == type &&
              subject.name.trim().toLowerCase() ==
                  (item['name'] as String).trim().toLowerCase(),
        );
        if (!subjectIds.add(id) ||
            conflictsWithBuiltIn ||
            !customSubjectNames.add(normalizedSubjectName)) {
          _invalid('$itemPath.id/name', 'yinelenmeyen özel ders');
        }
        subjectNames[id] = <String>{};
        _optionalString(item, 'emoji', itemPath);
        _optionalString(item, 'tip', itemPath);
        final topics = item['topics'];
        if (topics != null) {
          if (topics is! List) _invalid('$itemPath.topics', 'liste');
          for (var topicIndex = 0; topicIndex < topics.length; topicIndex++) {
            registerTopic(
              _record(topics[topicIndex], '$itemPath.topics[$topicIndex]'),
              '$itemPath.topics[$topicIndex]',
              id,
            );
          }
        }
      }
    }

    final customTopics = curriculum['customTopics'];
    if (customTopics != null) {
      if (customTopics is! List) _invalid('$path.customTopics', 'liste');
      for (var index = 0; index < customTopics.length; index++) {
        final item = _record(customTopics[index], '$path.customTopics[$index]');
        final itemPath = '$path.customTopics[$index]';
        if (item['subjectId'] is! String) {
          _invalid('$itemPath.subjectId', 'ders kimliği');
        }
        final subjectId = item['subjectId'] as String;
        if (!subjectIds.contains(subjectId)) {
          _invalid('$itemPath.subjectId', 'katalogda bulunan ders kimliği');
        }
        final topic = _record(item['topic'], '$itemPath.topic');
        registerTopic(topic, '$itemPath.topic', subjectId);
      }
    }
  }

  void _validateCustomTopic(dynamic value, String path) {
    final topic = _record(value, path);
    if (topic['id'] is! String ||
        !RegExp(r'^custom_topic_\d+$').hasMatch(topic['id'] as String) ||
        topic['name'] is! String ||
        (topic['name'] as String).trim().isEmpty ||
        topic['questionCount'] is! int ||
        (topic['questionCount'] as int) < 0 ||
        (topic['questionCount'] as int) > 200 ||
        topic['estimatedDays'] is! int ||
        (topic['estimatedDays'] as int) < 1 ||
        (topic['estimatedDays'] as int) > 365) {
      _invalid(path, 'özel konu kaydı');
    }
    for (final field in ['description', 'difficulty', 'priority']) {
      if (topic[field] is! String) _invalid('$path.$field', 'metin');
    }
  }

  void _validateDailyProgress(dynamic value, String path) {
    // DailyLog.fromJson has defensive fallbacks for malformed optional
    // progress fields. Keep those original values intact so a backup can make
    // a lossless round-trip instead of rejecting recoverable legacy data.
    if (value is! Map) return;
    _record(value, path);
  }

  void _validateRecordList(
    dynamic value,
    String key,
    void Function(Map<String, dynamic>, String) validate,
  ) {
    if (value is! List) _invalid(key, 'liste');
    for (var index = 0; index < value.length; index++) {
      validate(_record(value[index], '$key[$index]'), '$key[$index]');
    }
  }

  Map<String, dynamic> _record(dynamic value, String path) {
    if (value is! Map || value.keys.any((key) => key is! String)) {
      _invalid(path, 'nesne');
    }
    return Map<String, dynamic>.from(value);
  }

  void _optionalString(Map<String, dynamic> record, String field, String path) {
    if (record.containsKey(field) && record[field] is! String) {
      _invalid('$path.$field', 'metin');
    }
  }

  void _optionalNullableString(
    Map<String, dynamic> record,
    String field,
    String path,
  ) {
    if (record.containsKey(field) &&
        record[field] != null &&
        record[field] is! String) {
      _invalid('$path.$field', 'metin veya null');
    }
  }

  void _optionalBool(Map<String, dynamic> record, String field, String path) {
    if (record.containsKey(field) && record[field] is! bool) {
      _invalid('$path.$field', 'doğru/yanlış değeri');
    }
  }

  void _optionalInt(
    Map<String, dynamic> record,
    String field,
    String path, {
    required int min,
    int? max,
  }) {
    final value = record[field];
    if (record.containsKey(field) &&
        (value is! int || value < min || (max != null && value > max))) {
      _invalid('$path.$field', 'geçerli tam sayı');
    }
  }

  void _optionalDate(Map<String, dynamic> record, String field, String path) {
    final value = record[field];
    if (record.containsKey(field) &&
        value != null &&
        (value is! String || DateTime.tryParse(value) == null)) {
      _invalid('$path.$field', 'tarih');
    }
  }

  void _optionalAchievementDate(
    Map<String, dynamic> record,
    String field,
    String path,
  ) {
    final value = record[field];
    if (!record.containsKey(field) || value == null) return;
    if (value is String && DateTime.tryParse(value) != null) return;

    // Older app versions stored achievement dates as d.M.yyyy or dd.MM.yyyy.
    // Keep this compatibility rule scoped to this one legacy field.
    if (value is String) {
      final match = RegExp(
        r'^(\d{1,2})\.(\d{1,2})\.(\d{4})$',
      ).firstMatch(value);
      if (match != null) {
        final day = int.parse(match.group(1)!);
        final month = int.parse(match.group(2)!);
        final year = int.parse(match.group(3)!);
        final parsed = DateTime(year, month, day);
        if (parsed.year == year && parsed.month == month && parsed.day == day) {
          return;
        }
      }
    }
    _invalid('$path.$field', 'tarih');
  }

  Never _invalid(String path, String expected) =>
      throw FormatException('Yedekte $path alanı $expected biçiminde değil.');

  Future<void> clearStudyData() async {
    await initialize();
    await _enqueueMutation(() async {
      final updates = <String, Object?>{};
      for (final profile in _profiles) {
        for (final key in dataKeys) {
          updates[_scopedKey(profile.id, key)] = null;
          if (_isLegacyCompatible(profile)) updates[key] = null;
        }
      }
      for (final storedKey in _prefs!.getKeys()) {
        if (!storedKey.startsWith('profile_')) continue;
        if (dataKeys.any((key) => storedKey.endsWith('__$key'))) {
          updates[storedKey] = null;
        }
      }
      await _applyPreferenceUpdates(updates);
    });
  }

  List<ExamProfile> _decodeProfiles(String? value) {
    if (value == null) return [];
    final decoded = jsonDecode(value);
    if (decoded is! List) {
      throw const FormatException('Kayıtlı profil listesi geçersiz.');
    }
    return decoded.map((item) {
      if (item is! Map) {
        throw const FormatException('Kayıtlı profil geçersiz.');
      }
      return ExamProfile.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  String _scopedKey(String profileId, String key) =>
      'profile_${profileId}__$key';

  bool _isLegacyCompatible(ExamProfile profile) =>
      profile.id == ExamProfile.defaultYksId;

  ExamProfile _profileForId(String profileId) => _profiles.firstWhere(
    (profile) => profile.id == profileId,
    orElse: () => throw ArgumentError.value(
      profileId,
      'profileId',
      'Kayıtlı profil bulunamadı.',
    ),
  );

  void _ensureDataKey(String key) {
    if (!dataKeys.contains(key)) {
      throw ArgumentError.value(key, 'key', 'Desteklenmeyen veri anahtarı.');
    }
  }
}
