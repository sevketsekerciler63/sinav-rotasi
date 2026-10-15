import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mock_exam.dart';
import '../models/net_score.dart';
import '../providers/app_state.dart';

class ExamCalendarScreen extends StatelessWidget {
  const ExamCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final colors = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        return Scaffold(
          appBar: AppBar(title: const Text('📅 Deneme Takvimi')),
          body: state.mockExams.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.event_note_outlined,
                          size: 44,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Henüz deneme takvimi yok',
                          style: textTheme.titleMedium?.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Planlanan denemeler burada görünür.',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.mockExams.length,
                  itemBuilder: (context, index) {
                    final exam = state.mockExams[index];
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final scheduledDate = DateTime(
                      exam.date.year,
                      exam.date.month,
                      exam.date.day,
                    );
                    final isPast = scheduledDate.isBefore(today);
                    final daysUntil = scheduledDate.difference(today).inDays;
                    final displayedDate = exam.displayDate;
                    final markerColor = exam.isCompleted
                        ? colors.secondary
                        : isPast
                        ? colors.error
                        : colors.primary;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline
                          Column(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: markerColor.withValues(
                                    alpha: isPast && !exam.isCompleted
                                        ? 0.65
                                        : 1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: exam.isCompleted
                                      ? Icon(
                                          Icons.check,
                                          color: colors.onSecondary,
                                          size: 18,
                                        )
                                      : Text(
                                          exam.id.replaceAll('D', ''),
                                          style: TextStyle(
                                            color: exam.isCompleted
                                                ? colors.onSecondary
                                                : isPast
                                                ? colors.onError
                                                : colors.onPrimary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                ),
                              ),
                              if (index < state.mockExams.length - 1)
                                Container(
                                  width: 2,
                                  height: 60,
                                  color: exam.isCompleted
                                      ? colors.secondary.withValues(alpha: 0.3)
                                      : colors.outlineVariant,
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          // Card
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: exam.isCompleted
                                      ? colors.secondary.withValues(alpha: 0.4)
                                      : daysUntil <= 3 && daysUntil >= 0
                                      ? colors.tertiary.withValues(alpha: 0.55)
                                      : colors.outlineVariant,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          exam.type,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colors.onSurface,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      if (!exam.isCompleted && daysUntil >= 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: daysUntil <= 3
                                                ? colors.error.withValues(
                                                    alpha: 0.2,
                                                  )
                                                : colors.primary.withValues(
                                                    alpha: 0.2,
                                                  ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            daysUntil == 0
                                                ? 'Bugün!'
                                                : '$daysUntil gün',
                                            style: TextStyle(
                                              color: daysUntil <= 3
                                                  ? colors.error
                                                  : colors.primary,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${displayedDate.day}.${displayedDate.month.toString().padLeft(2, '0')}.${displayedDate.year} · ${exam.displayDayName} · ${exam.duration}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.onSurfaceVariant,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '🎯 ${exam.targetNet}',
                                    style: TextStyle(
                                      color: colors.tertiary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (exam.isCompleted) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      _netSummary(exam, state),
                                      style: TextStyle(
                                        color: colors.secondary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  String _netSummary(MockExam exam, AppState state) {
    final officialTyt = state.tytSubjects.where((subject) => !subject.isCustom);
    final officialAyt = state.aytSubjects.where((subject) => !subject.isCustom);
    final extraSubjects = state.subjects.where(
      (subject) =>
          subject.isCustom &&
          (subject.type == 'TYT' || exam.type.contains('AYT')),
    );
    final parts = <String>[
      if (exam.hasScoresForSubjects(officialTyt))
        'TYT: ${NetScore.format(exam.totalForSubjects(officialTyt))} net',
      if (exam.type.contains('AYT'))
        'AYT: ${exam.hasScoresForSubjects(officialAyt) ? NetScore.format(exam.totalForSubjects(officialAyt)) : '—'} net',
      if (exam.hasScoresForSubjects(extraSubjects))
        'Ek dersler: ${NetScore.format(exam.totalForSubjects(extraSubjects))} net',
    ];
    return parts.isEmpty ? 'Net girilmedi' : parts.join(' | ');
  }
}
