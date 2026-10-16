import 'package:flutter/foundation.dart';
import 'device_preferences.dart';

class BackupHistoryService {
  BackupHistoryService._();

  // Do not migrate the old timestamp: it could refer only to clipboard text.
  static const _lastFileExportKey = 'last_file_export_at';

  static final ValueNotifier<DateTime?> lastFileExportAt =
      ValueNotifier<DateTime?>(null);

  static Future<void> initialize() async {
    final preferences = await DevicePreferences.open();
    final savedAt = await preferences.getString(_lastFileExportKey);
    lastFileExportAt.value = savedAt == null
        ? null
        : DateTime.tryParse(savedAt)?.toLocal();
  }

  static Future<void> recordFileExport() async {
    final now = DateTime.now();
    final preferences = await DevicePreferences.open();
    final saved = await preferences.setString(
      _lastFileExportKey,
      now.toIso8601String(),
    );
    if (!saved) {
      throw StateError('Dosya dışa aktarım zamanı kaydedilemedi.');
    }
    lastFileExportAt.value = now;
  }
}
