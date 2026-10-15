import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/daily_log.dart';
import '../models/mock_exam.dart';
import '../models/net_score.dart';
import '../models/study_session.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        // Calculate this week's stats
        final now = DateTime.now();
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final today = DateTime(now.year, now.month, now.day);
        final normalizedWeekStart = DateTime(
          weekStart.year,
          weekStart.month,
          weekStart.day,
        );
        final thisWeekLogs = state.dailyLogs.where((log) {
          final date = DateTime(log.date.year, log.date.month, log.date.day);
          return !date.isBefore(normalizedWeekStart) && !date.isAfter(today);
        }).toList();
        final completedDaysThisWeek = state.completedStudyDates
            .where(
              (date) =>
                  !date.isBefore(normalizedWeekStart) && !date.isAfter(today),
            )
            .toList();
        final scheduledDateKeys = thisWeekLogs
            .where((log) => !log.isRestDay)
            .map((log) => log.dateKey)
            .toSet();
        scheduledDateKeys.addAll(
          completedDaysThisWeek.map(
            (date) =>
                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
          ),
        );
        final daysCompleted = completedDaysThisWeek.length;
        final totalDaysThisWeek = scheduledDateKeys.length;
        var questionsThisWeek = 0;
        for (
          var date = normalizedWeekStart;
          !date.isAfter(today);
          date = DateTime(date.year, date.month, date.day + 1)
        ) {
          questionsThisWeek += state.solvedQuestionsOn(date);
        }
        final completedSessionsThisWeek = state.studySessions.where((session) {
          final date = session.sessionDate;
          return session.status == StudySessionStatus.completed &&
              !date.isBefore(normalizedWeekStart) &&
              !date.isAfter(today);
        });
        final focusSessionCount = completedSessionsThisWeek.length;
        final focusMinutes =
            completedSessionsThisWeek.fold<int>(
              0,
              (sum, session) => sum + session.activeSeconds,
            ) ~/
            60;
        final legacyActivities = state.legacyDailyActivities;
        final dailyBreakdown =
            <
              ({
                DateTime date,
                DailyLog? log,
                bool completed,
                int questions,
                int sessions,
                int minutes,
              })
            >[];
        for (
          var date = normalizedWeekStart;
          !date.isAfter(today);
          date = DateTime(date.year, date.month, date.day + 1)
        ) {
          DailyLog? log;
          for (final candidate in thisWeekLogs) {
            if (candidate.date.year == date.year &&
                candidate.date.month == date.month &&
                candidate.date.day == date.day) {
              log = candidate;
              break;
            }
          }
          final questions = state.solvedQuestionsOn(date);
          final sessions = state.completedStudySessionsOn(date);
          final minutes = state.studyMinutesOn(date);
          final completed = completedDaysThisWeek.any(
            (completedDate) =>
                completedDate.year == date.year &&
                completedDate.month == date.month &&
                completedDate.day == date.day,
          );
          if (log != null || completed || questions > 0 || sessions > 0) {
            dailyBreakdown.add((
              date: date,
              log: log,
              completed: completed,
              questions: questions,
              sessions: sessions,
              minutes: minutes,
            ));
          }
        }

        // Topics completed this week (approximate)
        final topicsCompleted = state.completedTopics;

        // This week's exams
        final examsThisWeek = state.mockExams.where((e) {
          final d = e.displayDate;
          final weekEnd = DateTime(
            weekStart.year,
            weekStart.month,
            weekStart.day,
          ).add(const Duration(days: 7));
          return !d.isBefore(
                DateTime(weekStart.year, weekStart.month, weekStart.day),
              ) &&
              !d.isAfter(weekEnd);
        }).toList();

        return Scaffold(
          appBar: AppBar(title: const Text('📈 Haftalık Rapor')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Bu Haftanın Özeti',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${weekStart.day}.${weekStart.month.toString().padLeft(2, '0')} — ${now.day}.${now.month.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Stats grid
                Row(
                  children: [
                    _statCard(
                      '📅',
                      'Çalışılan Gün',
                      totalDaysThisWeek == 0
                          ? '—'
                          : '$daysCompleted/$totalDaysThisWeek',
                      AppTheme.accentBlue,
                    ),
                    const SizedBox(width: 10),
                    _statCard(
                      '📝',
                      'Çözülen Soru',
                      '$questionsThisWeek',
                      AppTheme.accentPurple,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _statCard(
                      '🔥',
                      'Aktif Seri',
                      '${state.streak} gün',
                      AppTheme.accentOrange,
                    ),
                    const SizedBox(width: 10),
                    _statCard(
                      '📚',
                      'Toplam Konu',
                      '$topicsCompleted/${state.totalTopics}',
                      AppTheme.accentGreen,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _statCard(
                      '⏱️',
                      'Tamamlanan Odak Seansı',
                      '$focusSessionCount',
                      AppTheme.accentCyan,
                    ),
                    const SizedBox(width: 10),
                    _statCard(
                      '⌛',
                      'Odak Süresi',
                      '$focusMinutes dk',
                      AppTheme.accentOrange,
                    ),
                  ],
                ),
                if (state.legacyUnattributedQuestionCount > 0) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${state.legacyUnattributedQuestionCount} eski soru kaydının günü belli olmadığından günlük/haftalık toplama katılmıyor.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 20),

                // Daily breakdown
                Text(
                  '📊 Günlük Detay',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                if (dailyBreakdown.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Bu hafta için planlanmış çalışma veya kayıt yok.',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ...dailyBreakdown.map(
                  (day) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: day.completed
                            ? AppTheme.accentGreen.withValues(alpha: 0.3)
                            : AppTheme.borderDark,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: day.completed
                                ? AppTheme.accentGreen
                                : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            day.completed ? Icons.check : Icons.circle_outlined,
                            color: day.completed
                                ? Colors.white
                                : Colors.white24,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${day.date.day}.${day.date.month.toString().padLeft(2, '0')} ${turkishWeekdayName(day.date)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              if (day.log != null)
                                Text(
                                  day.log!.studyHours,
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              if (day.completed && day.log == null)
                                const Text(
                                  'Önceki plan görevinden çalışma kaydı',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              if (day.sessions > 0)
                                Text(
                                  '${day.sessions} tamamlanan seans · ${day.minutes} dk',
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (day.questions > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentBlue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${day.questions} soru',
                              style: TextStyle(
                                color: AppTheme.accentBlue,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                if (legacyActivities.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    '🗂️ Eski Plan Geçmişi',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Şablon dışındaki korunmuş gün kayıtları burada ayrı gösterilir; haftalık toplamlara eklenmez. Tarih, eski plan kaydının anahtarıdır.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...legacyActivities.map((activity) {
                    final date = activity.date;
                    final dateLabel = date == null
                        ? activity.sourceDateKey
                        : '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
                    final details = <String>[
                      if (activity.isCompleted) 'Tamamlandı',
                      if (activity.solvedQuestions > 0)
                        '${activity.solvedQuestions} soru',
                      if (activity.weakTopicNotes.isNotEmpty)
                        activity.weakTopicNotes,
                    ];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.borderDark),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.history, color: AppTheme.accentCyan),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dateLabel,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                if (details.isNotEmpty)
                                  Text(
                                    details.join(' · '),
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],

                // Upcoming exams
                if (examsThisWeek.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    '📅 Bu Hafta Denemeler',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  ...examsThisWeek.map(
                    (exam) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.accentOrange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            exam.isCompleted ? '✅' : '📝',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exam.type,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Hedef: ${exam.targetNet}',
                                  style: TextStyle(
                                    color: AppTheme.accentOrange,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (exam.isCompleted)
                            Text(
                              _netSummary(exam, state),
                              style: TextStyle(
                                color: AppTheme.accentGreen,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 30),

                // Motivation
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppTheme.successGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Text('💪', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          totalDaysThisWeek == 0
                              ? 'Hedef tarihine göre yeni bir plan dönemi bekleniyor.'
                              : daysCompleted >= totalDaysThisWeek
                              ? 'Harika! Bu haftaki planlanan günleri tamamladın! 🎉'
                              : daysCompleted >= totalDaysThisWeek / 2
                              ? 'İyi gidiyorsun! Kalan günleri de tamamla!'
                              : 'Bu hafta biraz geride kaldın, hızlanmalısın!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
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

  Widget _statCard(String emoji, String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.borderDark),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
      ),
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
        'TYT ${NetScore.format(exam.totalForSubjects(officialTyt))}',
      if (exam.type.contains('AYT') && exam.hasScoresForSubjects(officialAyt))
        'AYT ${NetScore.format(exam.totalForSubjects(officialAyt))}',
      if (exam.hasScoresForSubjects(extraSubjects))
        'Ek ders ${NetScore.format(exam.totalForSubjects(extraSubjects))}',
    ];
    return parts.isEmpty ? 'Net girilmedi' : '${parts.join(' · ')} net';
  }
}
