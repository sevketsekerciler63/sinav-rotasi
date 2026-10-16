import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yks_study_app/models/daily_log.dart';
import 'package:yks_study_app/models/mock_exam.dart';
import 'package:yks_study_app/models/subject.dart';
import 'package:yks_study_app/providers/app_state.dart';
import 'package:yks_study_app/screens/dashboard_screen.dart';
import 'package:yks_study_app/screens/daily_plan_screen.dart';
import 'package:yks_study_app/screens/mock_exam_screen.dart';
import 'package:yks_study_app/screens/weak_topics_screen.dart';
import 'package:yks_study_app/theme/app_theme.dart';

class ReviewState extends AppState {
  int remainingDays = 20;
  DailyLog? nextTask;
  Completer<bool>? pendingSave;
  int saveCalls = 0;

  ReviewState() {
    subjects = [
      Subject(
        name: 'Matematik',
        emoji: '',
        type: 'TYT',
        totalQuestions: 40,
        topics: [],
      ),
    ];
    dailyLogs = [];
    mockExams = [];
  }

  @override
  int get daysRemaining => remainingDays;

  @override
  DailyLog? nextIncompleteTaskFor(DailyLog log) => nextTask;

  @override
  Future<bool> updateMockExam(
    String examId, {
    Map<String, double>? nets,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    saveCalls++;
    return pendingSave!.future;
  }
}

Future<void> pumpScreen(
  WidgetTester tester,
  ReviewState state,
  Widget screen, {
  Size size = const Size(390, 844),
  double scale = 1,
  Brightness brightness = Brightness.dark,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  await tester.pumpWidget(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: MaterialApp(
        theme: brightness == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
        home: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('net input names and pending save preserve retry draft', (
    tester,
  ) async {
    final state = ReviewState();
    final semantics = tester.ensureSemantics();
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    state.mockExams = [
      MockExam(
        id: 'review_exam',
        date: DateTime.now().subtract(const Duration(days: 1)),
        dayName: 'Kontrol',
        type: 'TYT',
        scope: '',
        duration: '',
        targetNet: '',
        analysisMethod: '',
      ),
    ];
    try {
      await pumpScreen(tester, state, const MockExamScreen());
      final field = find.byType(TextField).first;
      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.pumpAndSettle();
      final label = tester
          .getSemantics(find.byType(EditableText).first)
          .getSemanticsData()
          .label;
      expect(label, contains('TYT Matematik neti'));
      await tester.enterText(field, '20,5');
      state.pendingSave = Completer<bool>();
      final save = find.text('Netleri kaydet');
      await tester.ensureVisible(save);
      await tester.tap(save);
      await tester.pump();
      expect(state.saveCalls, 1);
      expect(tester.widget<TextField>(field).readOnly, isTrue);
      expect(
        tester.widget<Slider>(find.byType(Slider).first).onChanged,
        isNull,
      );
      final dateButton = find
          .ancestor(
            of: find.text('Tarihi seç'),
            matching: find.byWidgetPredicate((widget) => widget is TextButton),
          )
          .first;
      expect(tester.widget<TextButton>(dateButton).onPressed, isNull);
      state.pendingSave!.complete(false);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(field).controller!.text, '20,5');
      expect(tester.widget<TextField>(field).readOnly, isFalse);
      expect(find.text('Deneme sonucu kaydedildi.'), findsNothing);
      expect(find.textContaining('Netler kaydedilemedi.'), findsOneWidget);
    } finally {
      if (state.pendingSave != null && !state.pendingSave!.isCompleted) {
        state.pendingSave!.complete(false);
        await tester.pumpAndSettle();
      }
      await tester.pumpWidget(const SizedBox.shrink());
      semantics.dispose();
      state.dispose();
    }
  });

  for (final brightness in Brightness.values) {
    testWidgets('empty state fits short screen with 200% text $brightness', (
      tester,
    ) async {
      final state = ReviewState();
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      try {
        await pumpScreen(
          tester,
          state,
          const WeakTopicsScreen(),
          size: const Size(320, 320),
          scale: 2,
          brightness: brightness,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Henüz zayıf konu eklenmedi'), findsOneWidget);
      } finally {
        await tester.pumpWidget(const SizedBox.shrink());
        state.dispose();
      }
    });
  }

  testWidgets('dashboard exposes missing plan and expired target routes', (
    tester,
  ) async {
    final state = ReviewState()..remainingDays = -1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    try {
      await pumpScreen(tester, state, const DashboardScreen());
      expect(find.text('Bugün için plan görünmüyor'), findsOneWidget);
      expect(find.text('Hedef tarihini düzenle'), findsOneWidget);
      expect(find.text('KİŞİSEL HEDEF ROTASI'), findsNothing);
      expect(tester.getTopLeft(find.text('Günlük planı aç')).dy, lessThan(700));
      await tester.tap(find.text('Günlük planı aç'));
      await tester.pumpAndSettle();
      expect(find.byType(DailyPlanScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      state.dispose();
    }
  });

  testWidgets('dashboard next action fits narrow screen with 200% text', (
    tester,
  ) async {
    final state = ReviewState();
    final task = DailyLog(
      date: DateTime.now(),
      dayName: 'Cuma',
      tytContent: 'Matematik: Uzun Türkçe konu adı ve çalışma adımı',
      aytContent: '',
      studyHours: '30 dk',
      motivationNote: 'Çalışma notu',
      progressIds: ['review_task'],
    );
    state.dailyLogs = [task];
    state.nextTask = task;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    try {
      await pumpScreen(
        tester,
        state,
        const DashboardScreen(),
        size: const Size(320, 844),
        scale: 2,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Göreve başla'), findsOneWidget);
      expect(tester.getTopLeft(find.text('Göreve başla')).dy, lessThan(844));
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      state.dispose();
    }
  });
}
