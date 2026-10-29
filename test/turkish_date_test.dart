// Parça 2: Takvimden tarih seçme ve Türkçe tarih gösterimi.
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yks_study_app/utils/turkish_date.dart';
import 'package:yks_study_app/widgets/date_picker_field.dart';

void main() {
  test('kayıt günü Türkçe gösterilir, bozuk kayıt olduğu gibi kalır', () {
    expect(turkishDayKey('2026-10-21'), '21 Ekim 2026');
    expect(
      turkishDayKey('2026-10-21', withWeekday: true),
      '21 Ekim 2026 Çarşamba',
    );
    expect(turkishDayKey('2027-02-01', withYear: false), '1 Şubat');
    expect(turkishDayKey('2026-02-31'), '2026-02-31');
    expect(parseIsoDay('2026-2-1'), isNull);
    expect(isoDay(DateTime(2027, 3, 9)), '2027-03-09');
  });

  testWidgets('takvimden seçilen gün YYYY-AA-GG olarak döner', (tester) async {
    String? picked = '2026-10-21';
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('tr', 'TR'),
        supportedLocales: const [Locale('tr', 'TR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => DatePickerField(
              label: 'Çözdüğün gün',
              value: picked,
              firstDate: DateTime(2026, 1, 1),
              lastDate: DateTime(2026, 12, 31),
              onChanged: (value) => setState(() => picked = value),
            ),
          ),
        ),
      ),
    );
    expect(find.text('21 Ekim 2026 Çarşamba'), findsOneWidget);

    await tester.tap(find.byType(DatePickerField));
    await tester.pumpAndSettle();
    expect(find.text('Ekim 2026'), findsOneWidget, reason: 'Türkçe takvim');
    await tester.tap(find.text('15'));
    await tester.tap(find.text('Seç'));
    await tester.pumpAndSettle();

    expect(picked, '2026-10-15');
    expect(find.text('15 Ekim 2026 Perşembe'), findsOneWidget);
  });

  testWidgets('isteğe bağlı tarih temizlenebilir', (tester) async {
    String? picked = '2026-10-21';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => DatePickerField(
              label: 'Çalışma günü',
              value: picked,
              optional: true,
              firstDate: DateTime(2026, 1, 1),
              lastDate: DateTime(2026, 12, 31),
              onChanged: (value) => setState(() => picked = value),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Tarihi temizle'));
    await tester.pump();
    expect(picked, isNull);
    expect(find.text('Seçilmedi'), findsOneWidget);
  });
}
