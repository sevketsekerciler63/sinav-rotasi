import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:yks_study_app/providers/app_state.dart';
import 'package:yks_study_app/providers/theme_state.dart';
import 'package:yks_study_app/services/profile_storage.dart';
import 'package:yks_study_app/screens/settings_screen.dart';
import 'package:yks_study_app/theme/app_theme.dart';
import 'storage_recovery_test.dart' show ControlledStore;

void main() {
  testWidgets(
    'profile edit preserves failed draft and closes only after retry',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      GoogleFonts.config.allowRuntimeFetching = false;
      SharedPreferences.setMockInitialValues({});
      final store = ControlledStore();
      SharedPreferencesStorePlatform.instance = store;
      final state = AppState(profileStorage: ProfileStorage.forTesting());
      final theme = ThemeState();
      await state.loadData();
      try {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AppState>.value(value: state),
              ChangeNotifierProvider<ThemeState>.value(value: theme),
            ],
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: const SettingsScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final oldName = state.activeProfile.name;
        await tester.tap(find.text(oldName));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byType(TextField).first,
          'Korunacak profil taslağım',
        );
        tester.testTextInput.hide();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        store.failSuffix = 'exam_profiles';
        await tester.tap(find.text('Kaydet'));
        await tester.pumpAndSettle();
        expect(state.activeProfile.name, oldName);
        expect(find.text('Korunacak profil taslağım'), findsOneWidget);
        expect(
          find.textContaining('Bilgilerin burada duruyor'),
          findsOneWidget,
        );
        expect(find.byType(AlertDialog), findsOneWidget);
        await tester.tap(find.text('Kaydet'));
        await tester.pumpAndSettle();
        expect(state.activeProfile.name, 'Korunacak profil taslağım');
        expect(find.byType(AlertDialog), findsNothing);
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox());
        await tester.pumpAndSettle();
        state.dispose();
        theme.dispose();
        debugDefaultTargetPlatformOverride = null;
      }
    },
  );
}
