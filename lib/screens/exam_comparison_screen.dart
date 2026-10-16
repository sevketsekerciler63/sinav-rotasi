import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mock_exam.dart';
import '../models/net_score.dart';
import '../models/subject.dart';
import '../providers/app_state.dart';

class ExamComparisonScreen extends StatefulWidget {
  const ExamComparisonScreen({super.key});

  @override
  State<ExamComparisonScreen> createState() => _ExamComparisonScreenState();
}

class _ExamComparisonScreenState extends State<ExamComparisonScreen> {
  int _exam1Index = 0;
  int _exam2Index = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final colors = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        final completedExams =
            state.mockExams.where((e) => e.isCompleted).toList()..sort((
              first,
              second,
            ) {
              final dateOrder = first.displayDate.compareTo(second.displayDate);
              return dateOrder != 0 ? dateOrder : first.id.compareTo(second.id);
            });

        if (completedExams.length < 2) {
          return Scaffold(
            appBar: AppBar(title: const Text('Deneme Karşılaştırma')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'En az 2 deneme girmelisin',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Denemelere girip netleri kaydet',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (_exam1Index >= completedExams.length) {
          _exam1Index = 0;
        }
        if (_exam2Index >= completedExams.length) {
          _exam2Index = completedExams.length - 1;
        }

        final exam1 = completedExams[_exam1Index];
        final exam2 = completedExams[_exam2Index];

        final subjects = state.subjects;
        final comparisonSubjects = subjects
            .where(
              (subject) =>
                  (subject.type != 'AYT' ||
                      (exam1.type.contains('AYT') &&
                          exam2.type.contains('AYT'))) &&
                  exam1.hasNetForSubject(subject.type, subject.name) &&
                  exam2.hasNetForSubject(subject.type, subject.name),
            )
            .toList();
        double radarValue(MockExam exam, Subject subject) {
          final questionCount = subject.totalQuestions;
          if (questionCount <= 0) return 0;
          final minimum = NetScore.minimumForQuestionCount(questionCount);
          final possibleRange = questionCount - minimum;
          final position = exam.netForSubject(subject.type, subject.name);
          return ((position - minimum) / possibleRange * 100)
              .clamp(0, 100)
              .toDouble();
        }

        final radarAccessibleSummary = comparisonSubjects
            .map((subject) {
              final exam1Net = exam1.netForSubject(subject.type, subject.name);
              final exam2Net = exam2.netForSubject(subject.type, subject.name);
              final difference = exam2Net - exam1Net;
              final differenceLabel =
                  '${difference >= 0 ? '+' : ''}${NetScore.format(difference)} net';
              return '${subject.name}: ${_examLegendLabel(exam1)} ${NetScore.format(exam1Net)} net, '
                  '${_examLegendLabel(exam2)} ${NetScore.format(exam2Net)} net, fark $differenceLabel';
            })
            .join('; ');

        return Scaffold(
          appBar: AppBar(title: const Text('Deneme Karşılaştırma')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Exam selectors
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _exam1Index,
                        dropdownColor: colors.surfaceContainerHighest,
                        decoration: InputDecoration(
                          labelText: 'Deneme 1',
                          labelStyle: TextStyle(color: colors.primary),
                        ),
                        items: List.generate(
                          completedExams.length,
                          (i) => DropdownMenuItem(
                            value: i,
                            child: Text(
                              _examOptionLabel(completedExams[i]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() {
                            _exam1Index = v;
                            if (_exam2Index == v) {
                              _exam2Index = (v + 1) % completedExams.length;
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _exam2Index,
                        dropdownColor: colors.surfaceContainerHighest,
                        decoration: InputDecoration(
                          labelText: 'Deneme 2',
                          labelStyle: TextStyle(color: colors.secondary),
                        ),
                        items: List.generate(
                          completedExams.length,
                          (i) => DropdownMenuItem(
                            value: i,
                            child: Text(
                              _examOptionLabel(completedExams[i]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() {
                            _exam2Index = v;
                            if (_exam1Index == v) {
                              _exam1Index = (v + 1) % completedExams.length;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Radar Chart
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Ortak girilmiş dersler',
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ölçek: mümkün olan en düşük netten en yüksek nete',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (comparisonSubjects.length < 3)
                        SizedBox(
                          height: 120,
                          child: Center(
                            child: Text(
                              'Radar için iki denemede de net girilmiş en az 3 ortak ders gerekli.',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                      else
                        Semantics(
                          label:
                              'Ortak derslerde iki denemenin radar karşılaştırması. '
                              'Özet netler ve farklar: $radarAccessibleSummary.',
                          child: ExcludeSemantics(
                            child: SizedBox(
                              height: 280,
                              child: RadarChart(
                                RadarChartData(
                                  dataSets: [
                                    RadarDataSet(
                                      dataEntries: comparisonSubjects
                                          .map(
                                            (subject) => RadarEntry(
                                              value: radarValue(exam1, subject),
                                            ),
                                          )
                                          .toList(),
                                      fillColor: colors.primary.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderColor: colors.primary,
                                      borderWidth: 2,
                                    ),
                                    RadarDataSet(
                                      dataEntries: comparisonSubjects
                                          .map(
                                            (subject) => RadarEntry(
                                              value: radarValue(exam2, subject),
                                            ),
                                          )
                                          .toList(),
                                      fillColor: colors.secondary.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderColor: colors.secondary,
                                      borderWidth: 2,
                                    ),
                                  ],
                                  radarBackgroundColor: Colors.transparent,
                                  borderData: FlBorderData(show: false),
                                  radarBorderData: BorderSide(
                                    color: colors.outlineVariant,
                                    width: 1,
                                  ),
                                  titlePositionPercentageOffset: 0.2,
                                  titleTextStyle: textTheme.labelSmall
                                      ?.copyWith(
                                        color: colors.onSurfaceVariant,
                                        fontSize: 10,
                                      ),
                                  tickCount: 4,
                                  ticksTextStyle: const TextStyle(
                                    color: Colors.transparent,
                                  ),
                                  tickBorderData: BorderSide(
                                    color: colors.outlineVariant.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                  gridBorderData: BorderSide(
                                    color: colors.outlineVariant.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  getTitle: (index, _) {
                                    final shortName = comparisonSubjects[index]
                                        .name
                                        .replaceFirst(
                                          RegExp(r'^(TYT|AYT) '),
                                          '',
                                        );
                                    final label = shortName.length > 10
                                        ? '${shortName.substring(0, 9)}…'
                                        : shortName;
                                    return RadarChartTitle(text: label);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _legend(context, colors.primary, _examLegendLabel(exam1)),
                    const SizedBox(width: 16),
                    _legend(context, colors.secondary, _examLegendLabel(exam2)),
                  ],
                ),
                const SizedBox(height: 20),

                // Comparison table
                Container(
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Ders',
                                style: textTheme.labelMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'D1',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'D2',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colors.secondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Fark',
                                textAlign: TextAlign.center,
                                style: textTheme.labelMedium?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...subjects.map((subject) {
                        final hasN1 = exam1.hasNetForSubject(
                          subject.type,
                          subject.name,
                        );
                        final hasN2 = exam2.hasNetForSubject(
                          subject.type,
                          subject.name,
                        );
                        final n1 = exam1.netForSubject(
                          subject.type,
                          subject.name,
                        );
                        final n2 = exam2.netForSubject(
                          subject.type,
                          subject.name,
                        );
                        final diff = hasN1 && hasN2 ? n2 - n1 : null;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colors.outlineVariant.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  subject.name.replaceFirst(
                                    RegExp(r'^(TYT|AYT) '),
                                    '',
                                  ),
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  hasN1 ? NetScore.format(n1) : '—',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: hasN1
                                        ? colors.primary
                                        : colors.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  hasN2 ? NetScore.format(n2) : '—',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: hasN2
                                        ? colors.secondary
                                        : colors.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  diff == null
                                      ? '—'
                                      : '${diff >= 0 ? '+' : ''}${NetScore.format(diff)}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: diff == null
                                        ? colors.onSurfaceVariant
                                        : diff > 0
                                        ? colors.secondary
                                        : diff < 0
                                        ? colors.error
                                        : colors.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      _totalComparisonRow(
                        context,
                        'TYT RESMÎ TOPLAM',
                        exam1.hasScoresForSubjects(
                              state.tytSubjects.where(
                                (subject) => !subject.isCustom,
                              ),
                            )
                            ? exam1.totalForSubjects(
                                state.tytSubjects.where(
                                  (subject) => !subject.isCustom,
                                ),
                              )
                            : null,
                        exam2.hasScoresForSubjects(
                              state.tytSubjects.where(
                                (subject) => !subject.isCustom,
                              ),
                            )
                            ? exam2.totalForSubjects(
                                state.tytSubjects.where(
                                  (subject) => !subject.isCustom,
                                ),
                              )
                            : null,
                        isLast: state.aytSubjects.isEmpty,
                      ),
                      if (state.aytSubjects.isNotEmpty)
                        _totalComparisonRow(
                          context,
                          'AYT RESMÎ TOPLAM',
                          exam1.type.contains('AYT') &&
                                  exam1.hasScoresForSubjects(
                                    state.aytSubjects.where(
                                      (subject) => !subject.isCustom,
                                    ),
                                  )
                              ? exam1.totalForSubjects(
                                  state.aytSubjects.where(
                                    (subject) => !subject.isCustom,
                                  ),
                                )
                              : null,
                          exam2.type.contains('AYT') &&
                                  exam2.hasScoresForSubjects(
                                    state.aytSubjects.where(
                                      (subject) => !subject.isCustom,
                                    ),
                                  )
                              ? exam2.totalForSubjects(
                                  state.aytSubjects.where(
                                    (subject) => !subject.isCustom,
                                  ),
                                )
                              : null,
                          isLast: true,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _totalComparisonRow(
    BuildContext context,
    String label,
    double? value1,
    double? value2, {
    required bool isLast,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final difference = value1 != null && value2 != null
        ? value2 - value1
        : null;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(16))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value1 == null ? '—' : NetScore.format(value1),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: value1 == null
                    ? colors.onSurfaceVariant
                    : colors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value2 == null ? '—' : NetScore.format(value2),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: value2 == null
                    ? colors.onSurfaceVariant
                    : colors.secondary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              difference == null
                  ? '—'
                  : '${difference >= 0 ? '+' : ''}${NetScore.format(difference)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: difference == null
                    ? colors.onSurfaceVariant
                    : difference >= 0
                    ? colors.secondary
                    : colors.error,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  String _examOptionLabel(MockExam exam) {
    final date = exam.completedAt == null
        ? 'Tarih yok'
        : _formatDate(exam.completedAt!);
    return '$date · ${exam.type} · ${exam.id}';
  }

  String _examLegendLabel(MockExam exam) {
    final date = exam.completedAt == null
        ? 'Tarih yok'
        : _formatDate(exam.completedAt!);
    return '$date · ${exam.id}';
  }

  Widget _legend(BuildContext context, Color color, String label) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
