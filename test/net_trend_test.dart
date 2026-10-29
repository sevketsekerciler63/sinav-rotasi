// Parça 3: Deneme net grafiği.
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yks_study_app/models/exam_attempt.dart';
import 'package:yks_study_app/services/net_trend_metrics.dart';
import 'package:yks_study_app/widgets/net_trend_card.dart';

ExamAttempt tyt(String id, String date, double mat, {bool archived = false}) =>
    ExamAttempt(
      id: id,
      title: 'Deneme $id',
      date: date,
      session: 'TYT',
      archived: archived,
      scores: {
        for (final test in YksAttemptCatalog.tests('TYT', ''))
          test.id: AttemptScore.net(test.id == 'tyt_mat' ? mat : 0),
      },
    );

ExamAttempt ayt(String id, String date, String area, double math) =>
    ExamAttempt(
      id: id,
      title: 'AYT $id',
      date: date,
      session: 'AYT',
      area: area,
      scores: {
        for (final test in YksAttemptCatalog.tests('AYT', area))
          test.id: AttemptScore.net(test.id == 'ayt_mat' ? math : 0),
      },
    );

void main() {
  final attempts = [
    tyt('c', '2026-10-21', 30.25),
    ayt('x', '2026-10-19', 'say', 12),
    tyt('a', '2026-10-05', 20.5),
    tyt('old', '2026-09-01', 5, archived: true),
    tyt('b', '2026-10-12', 25),
    ayt('y', '2026-10-20', 'ea', 8),
  ];

  test('oturumlar ayrı seri, tarih sırası, arşiv hariç', () {
    final series = NetTrendMetrics.build(attempts);
    expect(series.map((s) => s.label), ['TYT', 'AYT · EA', 'AYT · SAY']);
    final first = series.first;
    expect(first.points.map((p) => p.date), [
      '2026-10-05',
      '2026-10-12',
      '2026-10-21',
    ]);
    expect(first.maxNet, 120);
    expect(first.change, 9.75);
    expect(first.best, 30.25);
    expect(series[2].maxNet, 80);
  });

  Future<void> pump(WidgetTester tester, List<NetTrendSeries> series) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: NetTrendCard(series: series)),
          ),
        ),
      );

  testWidgets('grafik ve Türkçe özet; seri seçimi değişir', (tester) async {
    await pump(tester, NetTrendMetrics.build(attempts));
    expect(find.byType(LineChart), findsOneWidget);
    expect(
      find.textContaining('İlk 20,5 → son 30,25 net (+9,75)'),
      findsOneWidget,
    );
    await tester.tap(find.text('AYT · SAY (1)'));
    await tester.pump();
    expect(find.byType(LineChart), findsNothing, reason: 'tek ölçüm çizilmez');
    expect(
      find.textContaining('Grafik için en az 2 deneme gerekir'),
      findsOneWidget,
    );
  });

  testWidgets('deneme yokken yönlendirme gösterilir', (tester) async {
    await pump(tester, const []);
    expect(find.textContaining('Henüz deneme kaydı yok'), findsOneWidget);
  });
}
