import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:yks_study_app/models/pomodoro_timer_state.dart';
import 'package:yks_study_app/providers/app_state.dart';
import 'package:yks_study_app/screens/pomodoro_screen.dart';
import 'package:yks_study_app/screens/splash_screen.dart';
import 'package:yks_study_app/services/profile_storage.dart';
import 'package:yks_study_app/theme/app_motion.dart';
import 'package:yks_study_app/theme/app_theme.dart';
import 'storage_recovery_test.dart' show ControlledStore;

Widget app(
  Widget home, {
  GlobalKey<NavigatorState>? navigator,
  AppState? state,
}) {
  final child = MaterialApp(
    navigatorKey: navigator,
    theme: AppTheme.lightTheme,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: child!,
    ),
    home: home,
  );
  return state == null
      ? child
      : ChangeNotifierProvider<AppState>.value(value: state, child: child);
}

void main() {
  setUp(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets(
    'reduced motion opens splash destination without decorative delay',
    (tester) async {
      await tester.pumpWidget(
        app(const SplashScreen(nextScreen: Scaffold(body: Text('Hazır')))),
      );
      await tester.pump();
      await tester.pump();
      expect(find.text('Hazır'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  for (final expired in [false, true]) {
    testWidgets(
      expired
          ? 'pending finished session survives failed write and navigation exactly once'
          : 'navigation preserves running timer identity deadline and task',
      (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.linux;
        SharedPreferences.setMockInitialValues({});
        final store = ControlledStore();
        SharedPreferencesStorePlatform.instance = store;
        final state = AppState(profileStorage: ProfileStorage.forTesting());
        await state.loadData();
        final nav = GlobalKey<NavigatorState>();
        try {
          if (expired) {
            final now = DateTime.now();
            await state.savePomodoroTimerState(
              PomodoroTimerState(
                profileId: state.activeProfile.id,
                isActive: true,
                isRunning: true,
                isBreak: false,
                remainingSeconds: 0,
                phaseDeadline: now.subtract(const Duration(seconds: 1)),
                taskId: 'resource:task',
                taskTitle: 'Kaynak görevi',
                completedPomodoros: 0,
                sessionId: 'finished',
                sessionStartedAt: now.subtract(const Duration(minutes: 25)),
                sessionActiveSeconds: 0,
                activeSegmentStartedAt: now.subtract(
                  const Duration(minutes: 25),
                ),
                activeSegmentBudgetSeconds: 1500,
              ),
            );
            store.failSuffix = '__study_sessions';
          }
          await tester.pumpWidget(
            app(
              const Scaffold(body: Text('Ana sayfa')),
              navigator: nav,
              state: state,
            ),
          );
          nav.currentState!.push(
            AppPageRoute(
              builder: (_) => const PomodoroScreen(
                autoStart: true,
                taskId: 'resource:task',
                taskTitle: 'Kaynak görevi',
              ),
            ),
          );
          await tester.pumpAndSettle();
          final saved = state.pomodoroTimerState!;
          expect(saved.taskId, 'resource:task');
          expect(saved.isActive, isTrue);
          if (expired) {
            expect(state.studySessions, isEmpty);
            expect(saved.pendingSessionEndedAt, isNotNull);
          } else {
            expect(saved.isRunning, isTrue);
            expect(saved.sessionId, isNotNull);
          }
          nav.currentState!.pop();
          await tester.pumpAndSettle();
          expect(state.studySessions, isEmpty);
          expect(state.pomodoroTimerState!.sessionId, saved.sessionId);
          nav.currentState!.push(
            AppPageRoute(builder: (_) => const PomodoroScreen()),
          );
          await tester.pumpAndSettle();
          if (expired) {
            expect(state.studySessions.length, 1);
            expect(state.studySessions.single.id, 'finished');
            expect(
              state.studySessions.single.endedAt,
              saved.pendingSessionEndedAt,
            );
            expect(state.pomodoroTimerState!.isBreak, isTrue);
            nav.currentState!.pop();
            await tester.pumpAndSettle();
            nav.currentState!.push(
              AppPageRoute(builder: (_) => const PomodoroScreen()),
            );
            await tester.pumpAndSettle();
            expect(state.studySessions.length, 1);
          } else {
            expect(state.pomodoroTimerState!.sessionId, saved.sessionId);
            expect(
              state.pomodoroTimerState!.phaseDeadline,
              saved.phaseDeadline,
            );
            expect(state.studySessions, isEmpty);
          }
          expect(tester.takeException(), isNull);
        } finally {
          await tester.pumpWidget(const SizedBox());
          await tester.pumpAndSettle();
          state.dispose();
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );
  }
}
