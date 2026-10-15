import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    await NotificationService.initialize();
  } catch (_) {
    // Plugin not available on this platform, skip
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

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_seen') ?? false;
    setState(() {
      _showOnboarding = !seen;
      _loaded = true;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setBool('onboarding_seen', true);
    if (!saved) throw StateError('Kurulum tamamlandı bilgisi saklanamadı.');
    if (!mounted) return;
    setState(() => _showOnboarding = false);
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
                    'Yerel kayıtlar silinmedi. Yeniden deneyebilir veya hata ayrıntılarını inceleyebilirsin.',
                    textAlign: TextAlign.center,
                  ),
                  if (appState.loadErrorMessage != null) ...[
                    const SizedBox(height: 12),
                    SelectableText(
                      appState.loadErrorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: appState.loadData,
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
    setState(() => _showConfetti = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showConfetti = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _selectedIndex, children: _screens),
          if (_showConfetti)
            IgnorePointer(
              child: SizedBox.expand(
                child: CustomPaint(painter: _ConfettiPainter()),
              ),
            ),
          if (_showConfetti)
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
                      padding: const EdgeInsets.only(left: 12, right: 4),
                      child: Row(
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
                          IconButton(
                            tooltip: 'Bildirimi kapat',
                            onPressed: appState.dismissPersistenceError,
                            icon: Icon(
                              Icons.close_rounded,
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
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
