import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('📈 İstatistikler')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall progress
                _buildOverallProgress(context, state),
                const SizedBox(height: 20),

                // Key metrics
                _buildKeyMetrics(state),
                const SizedBox(height: 20),

                // TYT Progress
                Text(
                  '📐 TYT İlerleme',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                _buildSubjectBars(state.tytSubjects),
                const SizedBox(height: 20),

                // AYT Progress
                Text(
                  '🔢 AYT İlerleme',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                _buildSubjectBars(state.aytSubjects),
                const SizedBox(height: 20),

                // Priority distribution
                Text(
                  '🎯 Öncelik Dağılımı',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                _buildPriorityChart(state),
                const SizedBox(height: 20),

                // Daily completion rate
                Text(
                  '📅 Haftalık Tamamlama',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                _buildWeeklyChart(state),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverallProgress(BuildContext context, AppState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircularPercentIndicator(
            radius: 50,
            lineWidth: 8,
            percent: state.overallProgress.clamp(0.0, 1.0),
            center: Text(
              '${(state.overallProgress * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            progressColor: Colors.white,
            backgroundColor: Colors.white24,
            circularStrokeCap: CircularStrokeCap.round,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Genel İlerleme',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                '${state.completedTopics} / ${state.totalTopics} konu',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${state.completedDays} / ${state.totalDays} gün tamamlandı',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                state.daysRemaining < 0
                    ? 'Hedef tarihi ${-state.daysRemaining} gün önce geçti'
                    : '${state.daysRemaining} gün kaldı',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetrics(AppState state) {
    final metrics = [
      _MetricData('🔥', 'Seri', '${state.streak} gün', AppTheme.accentOrange),
      _MetricData(
        '📝',
        'Denemeler',
        '${state.completedExams}/${state.mockExams.length}',
        AppTheme.accentPurple,
      ),
      _MetricData(
        '⚠️',
        'Zayıf Konu',
        '${state.weakTopics.where((t) => !t.isStudied).length}',
        AppTheme.accentRed,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 420 ? 2 : 3;
        final cardWidth = (constraints.maxWidth - (columns - 1) * 10) / columns;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: metrics
              .map(
                (metric) => SizedBox(
                  width: cardWidth,
                  child: _metricCard(
                    metric.emoji,
                    metric.label,
                    metric.value,
                    metric.color,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _metricCard(String emoji, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectBars(List<dynamic> subjects) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        children: subjects.map((s) {
          final color = AppTheme.getSubjectColor(s.name);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${s.emoji} ${s.name}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${(s.progress * 100).toInt()}%',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: s.progress,
                    minHeight: 8,
                    backgroundColor: AppTheme.borderDark,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriorityChart(AppState state) {
    int critical = 0, important = 0, medium = 0, low = 0;
    int criticalDone = 0, importantDone = 0, mediumDone = 0, lowDone = 0;

    for (var s in state.subjects) {
      for (var t in s.topics) {
        if (t.priority.contains('ÇOK KRİTİK')) {
          critical++;
          if (t.isCompleted) criticalDone++;
        } else if (t.priority.contains('ÖNEMLİ')) {
          important++;
          if (t.isCompleted) importantDone++;
        } else if (t.priority.contains('ORTA')) {
          medium++;
          if (t.isCompleted) mediumDone++;
        } else {
          low++;
          if (t.isCompleted) lowDone++;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        children: [
          _priorityRow(
            '🔴 ÇOK KRİTİK',
            criticalDone,
            critical,
            AppTheme.accentRed,
          ),
          const SizedBox(height: 10),
          _priorityRow(
            '🟠 ÖNEMLİ',
            importantDone,
            important,
            AppTheme.accentOrange,
          ),
          const SizedBox(height: 10),
          _priorityRow('🟡 ORTA', mediumDone, medium, const Color(0xFFD29922)),
          const SizedBox(height: 10),
          _priorityRow('🔵 DÜŞÜK', lowDone, low, AppTheme.accentBlue),
        ],
      ),
    );
  }

  Widget _priorityRow(String label, int done, int total, Color color) {
    final progress = total == 0 ? 0.0 : done / total;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              '$done/$total',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: AppTheme.borderDark,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(AppState state) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentWeek = today.subtract(Duration(days: today.weekday - 1));
    final firstWeek = currentWeek.subtract(const Duration(days: 77));
    final weekData = <int, Map<String, bool>>{
      for (var week = 0; week < 12; week++) week: {},
    };
    for (final date in state.completedStudyDates) {
      if (date.isBefore(firstWeek) || date.isAfter(today)) continue;
      final week = date.difference(firstWeek).inDays ~/ 7;
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      weekData[week]![dateKey] = true;
    }
    for (final log in state.dailyLogs) {
      final date = DateTime(log.date.year, log.date.month, log.date.day);
      if (log.isRestDay || date.isBefore(firstWeek) || date.isAfter(today)) {
        continue;
      }
      final week = date.difference(firstWeek).inDays ~/ 7;
      final dateKey = log.dateKey;
      weekData[week]![dateKey] =
          (weekData[week]![dateKey] ?? false) || log.isCompleted;
    }

    final barGroups = <BarChartGroupData>[];
    for (var entry in weekData.entries) {
      final completed = entry.value.values.where((done) => done).length;
      barGroups.add(
        BarChartGroupData(
          x: entry.key,
          barRods: [
            BarChartRodData(
              toY: completed.toDouble(),
              color: entry.value.isNotEmpty && completed == entry.value.length
                  ? AppTheme.accentGreen
                  : AppTheme.accentBlue,
              width: 12,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 20,
                interval: 2,
                getTitlesWidget: (v, m) => Text(
                  v.toInt().toString(),
                  style: const TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, m) => Text(
                  'H${v.toInt() + 1}',
                  style: const TextStyle(color: Colors.white38, fontSize: 9),
                ),
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          barGroups: barGroups,
          maxY: 7,
        ),
      ),
    );
  }
}

class _MetricData {
  final String emoji;
  final String label;
  final String value;
  final Color color;

  const _MetricData(this.emoji, this.label, this.value, this.color);
}
