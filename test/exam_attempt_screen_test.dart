import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:yks_study_app/models/exam_attempt.dart';
import 'package:yks_study_app/providers/app_state.dart';
import 'package:yks_study_app/screens/exam_attempts_screen.dart';
import 'package:yks_study_app/services/profile_storage.dart';
import 'package:yks_study_app/theme/app_theme.dart';
import 'storage_recovery_test.dart' show ControlledStore;

void main() {
  testWidgets(
    'AYT only draft uses comma nets, stays open on failure, and saves once at 200 percent text',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      GoogleFonts.config.allowRuntimeFetching = false;
      SharedPreferences.setMockInitialValues({});
      final store = ControlledStore();
      SharedPreferencesStorePlatform.instance = store;
      final state = AppState(profileStorage: ProfileStorage.forTesting());
      await state.loadData();
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      try {
        final draft = ExamAttempt(
          id: 'draft',
          title: 'EA denemem',
          date: DateTime.now().toIso8601String().substring(0, 10),
          session: 'AYT',
          area: 'ea',
          scores: {
            for (final test in YksAttemptCatalog.tests('AYT', 'ea'))
              test.id: const AttemptScore.net(0),
          },
        );
        await tester.pumpWidget(
          ChangeNotifierProvider<AppState>.value(
            value: state,
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(2)),
                child: child!,
              ),
              home: Builder(
                builder: (context) => Scaffold(
                  body: FilledButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ExamAttemptEditor(attempt: draft),
                      ),
                    ),
                    child: const Text('Aç'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Aç'));
        await tester.pumpAndSettle();
        final net = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.labelText == 'AYT Matematik neti',
        );
        await tester.scrollUntilVisible(
          net,
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(net);
        await tester.enterText(net, '20,5');
        tester.testTextInput.hide();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is TextField &&
                (widget.decoration?.labelText ?? '').startsWith('TYT '),
          ),
          findsNothing,
        );
        await tester.scrollUntilVisible(
          find.text('Kaydet'),
          400,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        store.failSuffix = '__exam_attempts';
        await tester.tap(find.text('Kaydet'));
        await tester.pumpAndSettle();
        expect(find.byType(ExamAttemptEditor), findsOneWidget);
        expect(state.examAttemptBook.attempts, isEmpty);
        await tester.scrollUntilVisible(
          find.text('Kaydet'),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Kaydet'));
        await tester.pumpAndSettle();
        expect(find.byType(ExamAttemptEditor), findsNothing);
        expect(
          state.examAttemptBook.attempts.single.scores['ayt_mat']!.net,
          20.5,
        );
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox());
        state.dispose();
        debugDefaultTargetPlatformOverride = null;
      }
    },
  );
}
