import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:yks_study_app/providers/app_state.dart';
import 'package:yks_study_app/services/profile_storage.dart';
import 'package:yks_study_app/screens/goals_screen.dart';
import 'package:yks_study_app/theme/app_theme.dart';
import 'package:yks_study_app/widgets/profile_save_form.dart';
import 'storage_recovery_test.dart' show ControlledStore;

void main() {
  testWidgets(
    'goal form at 200 percent text retains failed draft and closes after retry',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      GoogleFonts.config.allowRuntimeFetching = false;
      SharedPreferences.setMockInitialValues({});
      final store = ControlledStore();
      SharedPreferencesStorePlatform.instance = store;
      final state = AppState(profileStorage: ProfileStorage.forTesting());
      await state.loadData();
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 700);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      try {
        await tester.pumpWidget(
          ChangeNotifierProvider<AppState>.value(
            value: state,
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: const TextScaler.linear(2),
                  disableAnimations: true,
                ),
                child: child!,
              ),
              home: const GoalsScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Hedef Ekle'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byType(TextFormField).first,
          'Bu haftaki sorularım',
        );
        tester.testTextInput.hide();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        final scroll = find
            .descendant(
              of: find.byType(ProfileSaveForm),
              matching: find.byType(Scrollable),
            )
            .first;
        await tester.scrollUntilVisible(
          find.text('Hedefi Kaydet'),
          250,
          scrollable: scroll,
        );
        await tester.pumpAndSettle();
        store.failSuffix = '__goals_data';
        await tester.tap(find.text('Hedefi Kaydet'));
        await tester.pumpAndSettle();
        expect(state.goals, isEmpty);
        expect(find.byType(ProfileSaveForm), findsOneWidget);
        await tester.ensureVisible(find.text('Hedefi Kaydet'));
        await tester.tap(find.text('Hedefi Kaydet'));
        await tester.pumpAndSettle();
        expect(state.goals.single.title, 'Bu haftaki sorularım');
        expect(find.byType(ProfileSaveForm), findsNothing);
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
