import 'theme/app_motion.dart';
import 'dart:convert';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/app_state.dart';
import 'providers/theme_state.dart';
import 'theme/app_theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/subjects_screen.dart';
import 'screens/daily_plan_screen.dart';
import 'screens/mock_exam_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'services/daily_reminder_service.dart';
import 'services/backup_history_service.dart';
import 'services/profile_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks([
      'Inter',
    ], await rootBundle.loadString('assets/google_fonts/Inter-OFL.txt'));
    yield LicenseEntryWithLineBreaks([
      'Space Grotesk',
    ], await rootBundle.loadString('assets/google_fonts/SpaceGrotesk-OFL.txt'));
  });
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.surfaceDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize notifications (safe - won't crash if plugin not configured)
  try {
    await DailyReminderService.initialize();
  } catch (_) {
    // Plugin not available on this platform, skip
  }

  try {
    await BackupHistoryService.initialize();
  } catch (_) {
    // Backup history is optional; the rest of the app can still start.
  }

  runApp(const YKSApp());
}

class YKSApp extends StatefulWidget {
  const YKSApp({super.key});

  @override
  State<YKSApp> createState() => _YKSAppState();
}

class _YKSAppState extends State<YKSApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeState()..load(),
      child: const _ThemeAwareApp(),
    );
  }
}

class _ThemeAwareApp extends StatefulWidget {
  const _ThemeAwareApp();

  @override
  State<_ThemeAwareApp> createState() => _ThemeAwareAppState();
}

class _ThemeAwareAppState extends State<_ThemeAwareApp> {
  bool? _lastAppliedDarkMode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isDark = Provider.of<ThemeState>(context).isDark;
    if (_lastAppliedDarkMode == isDark) return;
    _lastAppliedDarkMode = isDark;
    final brightness = isDark ? Brightness.light : Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark
            ? AppTheme.surfaceDark
            : AppTheme.surfaceLight,
        systemNavigationBarIconBrightness: brightness,
        systemNavigationBarDividerColor: isDark
            ? AppTheme.borderDark
            : AppTheme.borderLight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeState>();
    return ChangeNotifierProvider(
      create: (_) => AppState()..loadData(),
      child: MaterialApp(
        title: 'Sınav Rotası',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeState.themeMode,
        // Takvim, saat seçici ve sistem metinleri Türkçe görünsün.
        locale: const Locale('tr', 'TR'),
        supportedLocales: const [Locale('tr', 'TR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: const SplashScreen(nextScreen: AppGate()),
      ),
    );
  }
}

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  bool _showOnboarding = false;
  bool _loaded = false;
  bool _checkingFirstLaunch = false;
  bool _recoveringFromBackup = false;
  bool _exportingRecovery = false;
  String? _firstLaunchError;
  String? _backupRecoveryError;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    if (_checkingFirstLaunch) return;
    setState(() {
      _checkingFirstLaunch = true;
      _firstLaunchError = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final seen = prefs.getBool('onboarding_seen') ?? false;
      if (!mounted) return;
      setState(() {
        _showOnboarding = !seen;
        _loaded = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _firstLaunchError = error.toString());
    } finally {
      if (mounted) setState(() => _checkingFirstLaunch = false);
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setBool('onboarding_seen', true);
    if (!saved) throw StateError('Kurulum tamamlandı bilgisi saklanamadı.');
    if (!mounted) return;
    setState(() => _showOnboarding = false);
  }

  Future<void> _recoverFromBackupFile() async {
    if (_recoveringFromBackup) return;
    setState(() {
      _recoveringFromBackup = true;
      _backupRecoveryError = null;
    });
    try {
      final result = await FilePicker.pickFiles(
        dialogTitle: 'Kurtarma yedeğini seç',
        type: FileType.custom,
        allowedExtensions: const ['json'],
        allowMultiple: false,
        withData: true,
      );
      if (!mounted || result == null) return;

      final file = result.files.single;
      if (file.size > 10 * 1024 * 1024) {
        throw const FormatException('Yedek dosyası 10 MB sınırını aşıyor.');
      }
      final bytes = file.bytes;
      if (bytes == null) {
        throw const FormatException('Yedek dosyasının içeriği okunamadı.');
      }
      final rawBackup = utf8.decode(bytes).replaceFirst('\uFEFF', '').trim();
      final decoded = jsonDecode(rawBackup);
      if (decoded is! Map) {
        throw const FormatException('Yedek JSON kökünde nesne bulunmalı.');
      }
      final backup = Map<String, dynamic>.from(decoded);
      final preview = await ProfileStorage.instance
          .previewBackupForStartupRecovery(backup);
      if (!mounted) return;

      final details =
          '${preview.profileNames.length} profil ve '
          '${preview.dataGroupCount} veri grubu yüklenecek:\n\n'
          '${preview.profileNames.map((name) => '• $name').join('\n')}\n\n'
          'Cihazdaki profil listesi ve çalışma verileri bu yedekle değişecek.'
          '${preview.recoveryRecordCount == 0 ? '' : '\n\n${preview.recoveryRecordCount} sorunlu veri grubu ham arşiv olarak korunacak; çalışma kayıtlarına uygulanmayacak.'}';
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Kurtarma yedeği doğrulandı'),
          content: Text(details),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Yedeği yükle'),
            ),
          ],
        ),
      );
      if (!mounted || confirmed != true) return;

      final appState = context.read<AppState>();
      await ProfileStorage.instance.importBackupForStartupRecovery(backup);
      await appState.loadData();
      if (mounted && appState.bootStatus == AppBootStatus.error) {
        setState(() {
          _backupRecoveryError =
              'Yedek yazıldı ancak kayıtlar açılamadı: '
              '${appState.loadErrorMessage ?? 'bilinmeyen yükleme hatası'}';
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _backupRecoveryError = 'Yedek yüklenemedi: $error');
      }
    } finally {
      if (mounted) setState(() => _recoveringFromBackup = false);
    }
  }

  Future<void> _exportRecoveryFile() async {
    if (_exportingRecovery || _recoveringFromBackup) return;
    setState(() {
      _exportingRecovery = true;
      _backupRecoveryError = null;
    });
    try {
      Map<String, dynamic> backup;
      var rawArchive = false;
      try {
        backup = await ProfileStorage.instance.exportBackup();
      } catch (_) {
        backup = await ProfileStorage.instance.exportEmergencyArchive();
        rawArchive = true;
      }
      final bytes = Uint8List.fromList(
        utf8.encode(const JsonEncoder.withIndent('  ').convert(backup)),
      );
      final path = await FilePicker.saveFile(
        dialogTitle: rawArchive
            ? 'Açılamayan verilerin ham arşivini cihaz dışında koru'
            : 'Sağlam kayıtları ve ham kurtarma arşivini kaydet',
        fileName:
            'sinav-rotasi-${rawArchive ? 'ham-arsiv' : 'kurtarma'}-${DateTime.now().millisecondsSinceEpoch}.json',
        type: FileType.custom,
        allowedExtensions: const ['json'],
        bytes: bytes,
      );
      if (!mounted || (path == null && !kIsWeb)) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            rawArchive
                ? 'Ham veri arşivi ${path == null ? 'indirme isteği gönderildi; indirildiğini kontrol et' : 'dışa aktarıldı'}. Bu dosya doğrudan yüklenemez; verileri inceleyip kurtarmak için korunur.'
                : path == null
                ? 'Kurtarma dosyası indirme isteği gönderildi; indirildiğini kontrol et.'
                : 'Kurtarma dosyası dışa aktarıldı. Ham sorunlu kayıtlar etkinleştirilmedi.',
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        setState(
          () =>
              _backupRecoveryError = 'Kurtarma dosyası oluşturulamadı: $error',
        );
      }
    } finally {
      if (mounted) setState(() => _exportingRecovery = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (appState.bootStatus == AppBootStatus.loading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Çalışma kayıtları yükleniyor…'),
            ],
          ),
        ),
      );
    }

    if (appState.bootStatus == AppBootStatus.error) {
      return Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Çalışma kayıtları açılamadı',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Yerel kayıtlar silinmedi. Önce kurtarma dosyası oluşturabilir, yeniden deneyebilir veya tam JSON yedeğini yükleyebilirsin.',
                    textAlign: TextAlign.center,
                  ),
                  if (appState.loadErrorMessage != null) ...[
                    const SizedBox(height: 12),
                    SelectableText(
                      appState.loadErrorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (_backupRecoveryError != null) ...[
                    const SizedBox(height: 10),
                    SelectableText(
                      _backupRecoveryError!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _exportingRecovery || _recoveringFromBackup
                            ? null
                            : _exportRecoveryFile,
                        icon: const Icon(Icons.save_alt_rounded),
                        label: Text(
                          _exportingRecovery
                              ? 'Dosya hazırlanıyor…'
                              : 'Kurtarma dosyası oluştur',
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _recoveringFromBackup || _exportingRecovery
                            ? null
                            : _recoverFromBackupFile,
                        icon: _recoveringFromBackup
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.upload_file_rounded),
                        label: const Text('Yedek dosyasıyla kurtar'),
                      ),
                      FilledButton.icon(
                        onPressed: _recoveringFromBackup || _exportingRecovery
                            ? null
                            : appState.loadData,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Yeniden dene'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_firstLaunchError != null) {
      final colors = Theme.of(context).colorScheme;
      return Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.settings_backup_restore_rounded,
                    size: 44,
                    color: colors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Başlangıç tercihi okunamadı',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Yerel çalışma kayıtlarına dokunulmadı. Tercihi yeniden okumayı deneyebilirsin.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    _firstLaunchError!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _checkingFirstLaunch ? null : _checkFirstLaunch,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Yeniden dene'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_showOnboarding) {
      return OnboardingScreen(
        appState: appState,
        onComplete: _completeOnboarding,
      );
    }

    return const MainScreen();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _showConfetti = false;

  final _screens = const [
    DashboardScreen(),
    SubjectsScreen(),
    DailyPlanScreen(),
    MockExamScreen(),
    StatsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<AppState>(context, listen: false);
      state.onCelebrate = _celebrate;
    });
  }

  void _celebrate() {
    if (!mounted || AppMotion.reduced(context)) return;
    setState(() => _showConfetti = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showConfetti = false);
    });
  }

  Future<void> _confirmReloadSavedData() async {
    final shouldReload = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kaydedilmiş veriyi yükle?'),
        content: const Text(
          'Son değişiklik kaydedilememiş olabilir. Devam edersen ekrandaki '
          'kaydedilmemiş değişiklikler yerine cihazda saklanan son kayıt yüklenir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Kaydedilmiş veriyi yükle'),
          ),
        ],
      ),
    );
    if (!mounted || shouldReload != true) return;
    await context.read<AppState>().discardUnsavedChangesAndReload();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _selectedIndex, children: _screens),
          if (_showConfetti && !AppMotion.reduced(context))
            IgnorePointer(
              child: SizedBox.expand(
                child: CustomPaint(painter: _ConfettiPainter()),
              ),
            ),
          if (_showConfetti && !AppMotion.reduced(context))
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (context, value, child) => Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppTheme.successGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentGreen.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tebrikler! Harika gidiyorsun!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (appState.persistenceError != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Material(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 6, 4, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.save_outlined,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Değişiklik kaydedilemedi: ${appState.persistenceError}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onErrorContainer,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: _confirmReloadSavedData,
                              icon: const Icon(Icons.history_rounded, size: 18),
                              label: const Text('Kaydedilmiş veriyi yükle'),
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                                minimumSize: const Size(48, 44),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) =>
              setState(() => _selectedIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.space_dashboard_outlined),
              selectedIcon: Icon(Icons.space_dashboard_rounded),
              label: 'Ana Sayfa',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book_rounded),
              label: 'Dersler',
            ),
            NavigationDestination(
              icon: Icon(Icons.route_outlined),
              selectedIcon: Icon(Icons.route_rounded),
              label: 'Plan',
            ),
            NavigationDestination(
              icon: Icon(Icons.edit_calendar_outlined),
              selectedIcon: Icon(Icons.edit_calendar_rounded),
              label: 'Deneme',
            ),
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights_rounded),
              label: 'İlerleme',
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final _rand = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      AppTheme.accentBlue,
      AppTheme.accentGreen,
      AppTheme.accentOrange,
      AppTheme.accentRed,
      AppTheme.accentCyan,
    ];

    for (int i = 0; i < 80; i++) {
      final paint = Paint()
        ..color = colors[_rand.nextInt(colors.length)].withValues(
          alpha: 0.7 + _rand.nextDouble() * 0.3,
        );
      final x = _rand.nextDouble() * size.width;
      final y = _rand.nextDouble() * size.height;
      final w = 4.0 + _rand.nextDouble() * 8;
      final h = 4.0 + _rand.nextDouble() * 8;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(_rand.nextDouble() * 3.14);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: w, height: h),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
