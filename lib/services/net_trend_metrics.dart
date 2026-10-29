import '../models/exam_attempt.dart';

class NetTrendPoint {
  final String date, title;
  final double net;
  const NetTrendPoint({
    required this.date,
    required this.title,
    required this.net,
  });
}

/// Aynı oturum/alan/dildeki denemelerin zaman içindeki toplam neti.
/// Farklı oturumların netleri toplanmaz ve aynı seride karıştırılmaz.
class NetTrendSeries {
  final String key, label;
  final int maxNet;
  final List<NetTrendPoint> points;
  const NetTrendSeries({
    required this.key,
    required this.label,
    required this.maxNet,
    required this.points,
  });

  NetTrendPoint get first => points.first;
  NetTrendPoint get last => points.last;
  double get change => last.net - first.net;
  double get best =>
      points.map((point) => point.net).reduce((a, b) => a > b ? a : b);
}

class NetTrendMetrics {
  const NetTrendMetrics._();

  static String label(ExamAttempt attempt) => [
    attempt.session,
    if (attempt.area.isNotEmpty) attempt.area.toUpperCase(),
    if (attempt.language.isNotEmpty) attempt.language,
    if (attempt.religionExempt) 'Muaf',
  ].join(' · ');

  /// Arşivdekiler hariç; tarih, eşitlikte kimlik sırasıyla.
  static List<NetTrendSeries> build(Iterable<ExamAttempt> attempts) {
    final groups = <String, List<ExamAttempt>>{};
    for (final attempt in attempts) {
      if (attempt.archived) continue;
      groups.putIfAbsent(attempt.comparisonKey, () => []).add(attempt);
    }
    final series = [
      for (final entry in groups.entries)
        () {
          final items = entry.value
            ..sort((a, b) {
              final date = a.date.compareTo(b.date);
              return date == 0 ? a.id.compareTo(b.id) : date;
            });
          final sample = items.first;
          return NetTrendSeries(
            key: entry.key,
            label: label(sample),
            maxNet: YksAttemptCatalog.tests(
              sample.session,
              sample.area,
              religionExempt: sample.religionExempt,
            ).fold(0, (sum, test) => sum + test.questions),
            points: List.unmodifiable([
              for (final item in items)
                NetTrendPoint(
                  date: item.date,
                  title: item.title,
                  net: item.totalNet,
                ),
            ]),
          );
        }(),
    ];
    const order = {'TYT': 0, 'AYT': 1, 'YDT': 2};
    series.sort((a, b) {
      final session =
          (order[a.label.split(' ').first] ?? 3) -
          (order[b.label.split(' ').first] ?? 3);
      if (session != 0) return session;
      final count = b.points.length - a.points.length;
      return count != 0 ? count : a.label.compareTo(b.label);
    });
    return List.unmodifiable(series);
  }
}
