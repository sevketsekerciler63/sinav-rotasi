import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:yks_study_app/providers/app_state.dart';
import 'package:yks_study_app/services/profile_storage.dart';
import 'package:yks_study_app/screens/study_resources_screen.dart';
import 'package:yks_study_app/theme/app_theme.dart';
import 'package:yks_study_app/screens/resource_plan_screen.dart';
import 'package:yks_study_app/models/learning_workspace.dart';
import 'package:yks_study_app/models/study_schedule_preferences.dart';
import 'storage_recovery_test.dart' show ControlledStore;

void main() {
  testWidgets(
    'resource draft survives failed storage and real task progress survives reload',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      GoogleFonts.config.allowRuntimeFetching = false;
      SharedPreferences.setMockInitialValues({});
      final store = ControlledStore();
      SharedPreferencesStorePlatform.instance = store;
      final storage = ProfileStorage.forTesting();
      final state = AppState(profileStorage: storage);
      await state.loadData();

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: state,
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const StudyResourcesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kaynak ekle'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'Geometri kitabım');
      store.failSuffix = '__learning_workspace';
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Geometri kitabım'), findsOneWidget);
      expect(state.learningWorkspace.resources, isEmpty);
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(state.learningWorkspace.resources.single.name, 'Geometri kitabım');
      await tester.tap(find.text('Geometri kitabım'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Görev ekle'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), 'Üçgenler');
      await tester.enterText(find.byType(TextField).at(2), '10');
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('İlerleme ekle'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '4');
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();
      expect(state.learningWorkspace.events.single.units, 4);
      final taskId = state.learningWorkspace.tasks.single.id;
      expect(state.learningWorkspace.remainingRanges(taskId), [(5, 10)]);
      await tester.tap(find.text('Son çalışma kayıtları (1)'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Geri al'));
      await tester.tap(find.text('Geri al'));
      await tester.pumpAndSettle();
      expect(state.learningWorkspace.events.single.active, isFalse);
      final reloaded = AppState(profileStorage: storage);
      await reloaded.loadData();
      expect(reloaded.learningWorkspace.remainingRanges(taskId), [(1, 10)]);
      expect(
        reloaded.learningWorkspace.resources.single.name,
        'Geometri kitabım',
      );
      reloaded.dispose();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      state.dispose();
      debugDefaultTargetPlatformOverride = null;
    },
  );
  testWidgets(
    'resource plan and editor fit narrow display at 200 percent text',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      GoogleFonts.config.allowRuntimeFetching = false;
      SharedPreferences.setMockInitialValues({});
      final state = AppState(profileStorage: ProfileStorage.forTesting());
      await state.loadData();
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 700);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      try {
        await state.createYksProfile(
          name: 'Kontrol',
          scoreType: 'say',
          startingLevel: 'basic',
          targetDate: DateTime.now().add(const Duration(days: 10)),
          schedulePreferences: const StudySchedulePreferences(
            dailyStudyMinutes: 30,
          ),
        );
        final subject = state.subjects.first;
        await state.saveStudyResource(
          StudyResource(
            id: 'r',
            name: 'Uzun adlı kaynak kitabım',
            subjectId: subject.storageId,
            subjectName: subject.name,
            session: subject.type,
            unit: StudyResourceUnit.question,
            totalUnits: 100,
          ),
        );
        await state.saveResourceTask(
          const ResourceTask(
            id: 't',
            resourceId: 'r',
            title: 'Birinci konu',
            startUnit: 1,
            endUnit: 20,
            estimatedMinutes: 40,
          ),
        );
        await state.rebuildResourcePlan();
        Widget app(Widget home) => ChangeNotifierProvider<AppState>.value(
          value: state,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: home,
          ),
        );
        await tester.pumpWidget(app(const ResourcePlanScreen()));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text('Aralığı tamamla'),
          400,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Aralığı tamamla').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Aralığı tamamla').first);
        await tester.pumpAndSettle();
        expect(state.learningWorkspace.taskProgress('t'), 15);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(app(const StudyResourcesScreen()));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Kaynak ekle'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Vazgeç'));
        await tester.pumpAndSettle();
      } finally {
        await tester.pumpWidget(const SizedBox());
        state.dispose();
        debugDefaultTargetPlatformOverride = null;
      }
    },
  );
}
