import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupHistoryService {
  BackupHistoryService._();

  static const _lastSuccessfulBackupKey = 'last_successful_backup_at';

  static final ValueNotifier<DateTime?> lastSuccessfulBackupAt =
      ValueNotifier<DateTime?>(null);

  static Future<void> initialize() async {
    final preferences = await SharedPreferences.getInstance();
    final savedAt = preferences.getString(_lastSuccessfulBackupKey);
    lastSuccessfulBackupAt.value = savedAt == null
        ? null
        : DateTime.tryParse(savedAt)?.toLocal();
  }

  static Future<void> recordSuccessfulBackup() async {
    final now = DateTime.now();
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _lastSuccessfulBackupKey,
      now.toIso8601String(),
    );
    if (!saved) {
      throw StateError('Son yedek zamanı kaydedilemedi.');
    }
    lastSuccessfulBackupAt.value = now;
  }
}
