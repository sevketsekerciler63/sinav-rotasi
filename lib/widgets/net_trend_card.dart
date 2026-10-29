import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/net_score.dart';
import '../services/net_trend_metrics.dart';
import '../utils/turkish_date.dart';

/// İlerleme ekranındaki deneme net gelişimi grafiği.
class NetTrendCard extends StatefulWidget {
  final List<NetTrendSeries> series;
  const NetTrendCard({super.key, required this.series});

  @override
  State<NetTrendCard> createState() => _NetTrendCardState();
}

class _NetTrendCardState extends State<NetTrendCard> {
  String? _selectedKey;

  String _signed(double value) =>
      '${value > 0 ? '+' : ''}${NetScore.format(value)}';

  String _summary(NetTrendSeries series) {
    if (series.points.length == 1) {
      return '${series.label}: 1 deneme, '
          '${NetScore.format(series.last.net)} / ${series.maxNet} net '
          '(${turkishDayKey(series.last.date)}). Grafik için en az 2 deneme gerekir.';
    }
    return '${series.label}: ${series.points.length} deneme. '
        'İlk ${NetScore.format(series.first.net)} → son '
        '${NetScore.format(series.last.net)} net '
        '(${_signed(series.change)}). En yüksek ${NetScore.format(series.best)} / '
        '${series.maxNet}.';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final decoration = BoxDecoration(
      color: colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: colors.outlineVariant),
    );
    if (widget.series.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: decoration,
        child: const Text(
          'Henüz deneme kaydı yok. Denemelerim ekranından çözdüğün denemeleri '
          'ekle; net gelişimin burada çizilir.',
        ),
      );
    }
    final selected =
        widget.series.where((s) => s.key == _selectedKey).firstOrNull ??
        widget.series.first;
    final points = selected.points;
    final spots = [
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].net),
    ];
    final lowest = points
        .map((point) => point.net)
        .reduce((a, b) => a < b ? a : b);
    final minY = lowest < 0 ? (lowest / 5).floorToDouble() * 5 : 0.0;
    final labelEvery = points.length <= 6 ? 1 : (points.length / 6).ceil();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.series.length > 1)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final series in widget.series)
                  ChoiceChip(
                    label: Text('${series.label} (${series.points.length})'),
                    selected: series.key == selected.key,
                    onSelected: (_) =>
                        setState(() => _selectedKey = series.key),
                  ),
              ],
            ),
          if (widget.series.length > 1) const SizedBox(height: 12),
          if (points.length >= 2)
            Semantics(
              label: 'Deneme net grafiği. ${_summary(selected)}',
              child: ExcludeSemantics(
                child: SizedBox(
                  height: 180,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: (points.length - 1).toDouble(),
                      minY: minY,
                      maxY: selected.maxNet.toDouble(),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: selected.maxNet / 4,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: colors.outlineVariant,
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 32,
                            interval: selected.maxNet / 4,
                            getTitlesWidget: (value, meta) => Text(
                              value.round().toString(),
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            reservedSize: 24,
                            getTitlesWidget: (value, meta) {
                              final index = value.round();
                              if (index < 0 ||
                                  index >= points.length ||
                                  (value - index).abs() > 0.001 ||
                                  index % labelEvery != 0) {
                                return const SizedBox.shrink();
                              }
                              final date = parseIsoDay(points[index].date);
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  date == null
                                      ? points[index].date
                                      : '${date.day}.${date.month.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    color: colors.onSurfaceVariant,
                                    fontSize: 10,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (spots) => [
                            for (final spot in spots)
                              LineTooltipItem(
                                '${points[spot.x.round()].title}\n'
                                '${NetScore.format(spot.y)} net',
                                TextStyle(
                                  color: colors.onInverseSurface,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                          getTooltipColor: (_) => colors.inverseSurface,
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: false,
                          color: colors.primary,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: colors.primary.withValues(alpha: 0.12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          Text(_summary(selected), style: textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            'Farklı yayınevlerinin zorluğu farklı olabilir; tek denemeye değil '
            'genel eğilime bak. Puan veya sıralama tahmini değildir.',
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
