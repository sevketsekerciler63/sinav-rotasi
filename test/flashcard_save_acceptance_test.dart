import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:yks_study_app/providers/app_state.dart';
import 'package:yks_study_app/screens/flashcard_screen.dart';
import 'package:yks_study_app/services/profile_storage.dart';
import 'package:yks_study_app/theme/app_theme.dart';
import 'storage_recovery_test.dart' show ControlledStore;

void main() {
  testWidgets(
    'failed flashcard rating stays on current card and retries one pending review',
    (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      GoogleFonts.config.allowRuntimeFetching = false;
      SharedPreferences.setMockInitialValues({});
      final store = ControlledStore();
      SharedPreferencesStorePlatform.instance = store;
      final storage = ProfileStorage.forTesting();
      final state = AppState(profileStorage: storage);
      await state.loadData();
      try {
        await tester.pumpWidget(
          ChangeNotifierProvider<AppState>.value(
            value: state,
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(disableAnimations: true),
                child: child!,
              ),
              home: FlashcardScreen(profileStorage: storage),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Pisagor Teoremi nedir?'));
        await tester.pumpAndSettle();
        store.failSuffix = '__flashcard_reviews';
        await tester.tap(find.text('Hatırladım'));
        await tester.pumpAndSettle();
        expect(find.text('Diskriminant nedir?'), findsNothing);
        expect(find.text('Yeniden kaydet'), findsOneWidget);
        expect(await storage.readString('flashcard_reviews'), isNull);
        await tester.tap(find.text('Yeniden kaydet'));
        await tester.pumpAndSettle();
        expect(find.text('Diskriminant nedir?'), findsOneWidget);
        final raw =
            jsonDecode((await storage.readString('flashcard_reviews'))!) as Map;
        expect(raw.toString(), contains('mat_1'));
        final known =
            jsonDecode((await storage.readString('flashcard_known'))!) as List;
        expect(known, ['mat_1']);
        expect(tester.takeException(), isNull);
      } finally {
        await tester.pumpWidget(const SizedBox());
        state.dispose();
        debugDefaultTargetPlatformOverride = null;
      }
    },
  );
}
