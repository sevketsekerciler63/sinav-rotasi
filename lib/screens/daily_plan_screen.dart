import '../widgets/profile_save_form.dart';
import '../theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weak_topic.dart';
import '../providers/app_state.dart';
import 'settings_screen.dart';
import 'resource_plan_screen.dart';
import 'weak_topics_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/app_primitives.dart';

class DailyPlanScreen extends StatefulWidget {
  final bool showLegacy;
  const DailyPlanScreen({super.key, this.showLegacy = false});

  @override
  State<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends State<DailyPlanScreen> {
  late ScrollController _scrollController;
  int _selectedWeek = -1;
  String? _lastScheduleStartKey;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToToday());
  }

  void _scrollToToday() {
    final state = Provider.of<AppState>(context, listen: false);
    final now = DateTime.now();
    final todayKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final idx = state.dailyLogs.indexWhere((l) => l.dateKey == todayKey);
    if (idx >= 0 && _scrollController.hasClients) {
      if (AppMotion.reduced(context)) {
        _scrollController.jumpTo(idx * 200.0);
        return;
      }
      _scrollController.animateTo(
        idx * 200.0,
        duration: AppMotion.standard,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        if (!widget.showLegacy &&
            state.learningWorkspace.resources.isNotEmpty) {
          return const ResourcePlanScreen();
        }
        final colors = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        final scheduleStartKey = state.dailyLogs.isEmpty
            ? null
            : state.dailyLogs.first.dateKey;
        if (scheduleStartKey != _lastScheduleStartKey) {
          _lastScheduleStartKey = scheduleStartKey;
          _selectedWeek = -1;
        }
        final weeks = <int, List<int>>{};
        final firstDate = state.dailyLogs.isEmpty
            ? DateTime.now()
            : state.dailyLogs.first.date;
        final firstWeek = DateTime(
          firstDate.year,
          firstDate.month,
          firstDate.day,
        ).subtract(Duration(days: firstDate.weekday - 1));
        for (int i = 0; i < state.dailyLogs.length; i++) {
          final logDate = state.dailyLogs[i].date;
          final normalizedDate = DateTime(
            logDate.year,
            logDate.month,
            logDate.day,
          );
          final weekNum = normalizedDate.difference(firstWeek).inDays ~/ 7;
          weeks.putIfAbsent(weekNum, () => []).add(i);
        }

        if (_selectedWeek == -1 || !weeks.containsKey(_selectedWeek)) {
          final now = DateTime.now();
          final todayKey =
              '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
          var foundCurrentWeek = false;
          for (var entry in weeks.entries) {
            if (entry.value.any(
              (i) => state.dailyLogs[i].dateKey == todayKey,
            )) {
              _selectedWeek = entry.key;
              foundCurrentWeek = true;
              break;
            }
          }
          if (!foundCurrentWeek) {
            _selectedWeek = weeks.keys.isEmpty ? -1 : weeks.keys.first;
          }
        }

        final currentWeekDays = weeks[_selectedWeek] ?? [];
        final prioritizedReviews = state.prioritizedWeakTopics;

        return Scaffold(
          appBar: AppBar(title: const Text('Günlük Çalışma Planı')),
          body: Column(
            children: [
              if (state.todayLog == null) _buildPlanStatus(context, state),
              // Week selector
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: weeks.length,
                  itemBuilder: (context, index) {
                    final weekKey = weeks.keys.elementAt(index);
                    final isSelected = weekKey == _selectedWeek;
                    final weekDays = weeks[weekKey]!;
                    final scheduledInWeek = weekDays
                        .where((i) => !state.dailyLogs[i].isRestDay)
                        .length;
                    final completedInWeek = weekDays
                        .where(
                          (i) =>
                              !state.dailyLogs[i].isRestDay &&
                              state.dailyLogs[i].isCompleted,
                        )
                        .length;
                    final allCompleted =
                        scheduledInWeek > 0 &&
                        completedInWeek == scheduledInWeek;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        selected: isSelected,
                        showCheckmark: false,
                        onSelected: (_) =>
                            setState(() => _selectedWeek = weekKey),
                        backgroundColor: colors.surfaceContainerLow,
                        selectedColor: colors.primary.withValues(alpha: 0.2),
                        side: BorderSide(
                          color: isSelected
                              ? colors.primary
                              : allCompleted
                              ? colors.secondary.withValues(alpha: 0.35)
                              : colors.outlineVariant,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        label: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${weekKey + 1}. Hafta',
                              style: TextStyle(
                                color: isSelected
                                    ? colors.primary
                                    : allCompleted
                                    ? colors.secondary
                                    : colors.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '$completedInWeek/$scheduledInWeek',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Daily cards
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: currentWeekDays.length,
                  itemBuilder: (context, index) {
                    final log = state.dailyLogs[currentWeekDays[index]];
                    final hasDenemePlanText = log.tytContent
                        .toLowerCase()
                        .contains('deneme');
                    final now = DateTime.now();
                    final isToday =
                        log.dateKey ==
                        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isToday
                            ? colors.primary.withValues(alpha: 0.08)
                            : colors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isToday
                              ? colors.primary.withValues(alpha: 0.5)
                              : log.isCompleted
                              ? colors.secondary.withValues(alpha: 0.4)
                              : colors.outlineVariant,
                          width: isToday ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  if (isToday)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        gradient: AppTheme.cyanGradient,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'BUGÜN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  Text(
                                    '${log.date.day}.${log.date.month.toString().padLeft(2, '0')} ${log.dayName}',
                                    style: TextStyle(
                                      color: isToday
                                          ? colors.onSurface
                                          : colors.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    log.studyHours,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (log.isRestDay)
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Icon(
                                        Icons.self_improvement_rounded,
                                        color: colors.onSurfaceVariant,
                                        size: 22,
                                      ),
                                    )
                                  else
                                    IconButton(
                                      tooltip: log.isCompleted
                                          ? '${log.dayName} planının tamamlandı durumunu kaldır.'
                                          : '${log.dayName} planını tamamlandı olarak işaretle.',
                                      onPressed:
                                          state.isSavingRecord(
                                            'daily_logs',
                                            log.dateKey,
                                          )
                                          ? null
                                          : () => showRecordResult(
                                              context,
                                              state.toggleDayCompleted(
                                                log.dateKey,
                                              ),
                                            ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 48,
                                        minHeight: 48,
                                      ),
                                      icon: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: log.isCompleted
                                              ? colors.secondary
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: log.isCompleted
                                                ? colors.secondary
                                                : colors.outlineVariant,
                                            width: 2,
                                          ),
                                        ),
                                        child: log.isCompleted
                                            ? Icon(
                                                Icons.check,
                                                color: colors.onSecondary,
                                                size: 16,
                                              )
                                            : null,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          if (log.completedAt != null &&
                              (log.completedAt!.year != log.date.year ||
                                  log.completedAt!.month != log.date.month ||
                                  log.completedAt!.day != log.date.day)) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Tamamlandı: ${log.completedAt!.day}.${log.completedAt!.month.toString().padLeft(2, '0')}.${log.completedAt!.year}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ],
                          if (log.progressIds.length > 1) ...[
                            const SizedBox(height: 2),
                            Text(
                              '${log.completedProgressCount}/${log.progressIds.length} görev tamamlandı',
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ],
                          if (log.completedTaskSummaries.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: colors.secondary.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: colors.secondary.withValues(
                                    alpha: 0.30,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bugün tamamlanan ${log.completedTaskSummaries.length} görev',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.secondary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  for (final summary
                                      in log.completedTaskSummaries)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color: colors.secondary,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              summary,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.8),
                                                fontSize: 12,
                                                height: 1.35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                          if (isToday && prioritizedReviews.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _buildPriorityReviewQueue(
                              context,
                              prioritizedReviews,
                            ),
                          ],
                          const SizedBox(height: 10),

                          // Exam indicator
                          if (log.isExamDay)
                            Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                gradient: AppTheme.warningGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'DENEME SINAVI GÜNÜ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          if (hasDenemePlanText)
                            AppInfoBanner(
                              margin: const EdgeInsets.only(bottom: 8),
                              message:
                                  'Bu günlük plan satırı bir çalışma/analiz önerisidir. '
                                  'Gerçek deneme günü ve netleri Deneme Takip ekranında '
                                  'ayrı kaydedilir; kayıtlar otomatik eşleşmez.',
                            ),

                          // TYT content
                          Text(
                            'TYT:',
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            log.tytContent,
                            style: TextStyle(
                              color: log.isCompleted
                                  ? colors.onSurfaceVariant
                                  : colors.onSurface,
                              fontSize: 13,
                              height: 1.4,
                              decoration: log.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),

                          // AYT content
                          if (log.aytContent != '\u2014' &&
                              log.aytContent.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'AYT:',
                              style: TextStyle(
                                color: colors.secondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              log.aytContent,
                              style: TextStyle(
                                color: log.isCompleted
                                    ? colors.onSurfaceVariant
                                    : colors.onSurface,
                                fontSize: 13,
                                height: 1.4,
                                decoration: log.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ],
                          if (log.reviewTopicId != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Bu tekrar görevini tamamlamak, önerilen konunun sonraki tekrar tarihini günceller.',
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.tertiary,
                                fontSize: 11,
                              ),
                            ),
                          ],

                          // Motivation
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colors.secondary.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    log.motivationNote,
                                    style: TextStyle(
                                      color: colors.secondary,
                                      fontSize: 11,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Question counter
                          if (!log.isRestDay) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: colors.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                runSpacing: 4,
                                children: [
                                  Text(
                                    'Bu günde çözülen soru:',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                  AbsorbPointer(
                                    absorbing: state.isSavingRecord(
                                      'daily_logs',
                                      log.dateKey,
                                    ),
                                    child: Row(
                                      children: [
                                        _counterButton(
                                          context,
                                          Icons.remove,
                                          'Bir soru azalt',
                                          () {
                                            if (log.solvedQuestions > 0) {
                                              showRecordResult(
                                                context,
                                                state.updateDailyLog(
                                                  log.dateKey,
                                                  solvedQuestions:
                                                      log.solvedQuestions - 1,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${log.solvedQuestions}',
                                            style: TextStyle(
                                              color: colors.primary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        _counterButton(
                                          context,
                                          Icons.add,
                                          'Bir soru artır',
                                          () => showRecordResult(
                                            context,
                                            state.updateDailyLog(
                                              log.dateKey,
                                              solvedQuestions:
                                                  log.solvedQuestions + 1,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        TextButton(
                                          onPressed: () {
                                            showRecordResult(
                                              context,
                                              state.updateDailyLog(
                                                log.dateKey,
                                                solvedQuestions:
                                                    log.solvedQuestions + 10,
                                              ),
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            minimumSize: const Size(48, 48),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            tapTargetSize:
                                                MaterialTapTargetSize.padded,
                                            backgroundColor: colors.primary
                                                .withValues(alpha: 0.15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            '+10',
                                            style: TextStyle(
                                              color: colors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _counterButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onTap,
  ) {
    final colors = Theme.of(context).colorScheme;
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      style: IconButton.styleFrom(
        backgroundColor: colors.primary.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(icon, color: colors.primary, size: 16),
    );
  }

  Widget _buildPriorityReviewQueue(
    BuildContext context,
    List<WeakTopic> queue,
  ) {
    final colors = Theme.of(context).colorScheme;
    final visibleTopics = queue.take(3).toList();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colors.tertiary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.tertiary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.replay_rounded, color: colors.tertiary, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Öncelikli tekrar kuyruğu · ${queue.length}',
                  style: TextStyle(
                    color: colors.tertiary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'İsteğe bağlı öneriler; günlük dakika hedefinden ayrı gösterilir.',
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11),
          ),
          const SizedBox(height: 8),
          for (final topic in visibleTopics)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.priority_high, color: colors.tertiary, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${topic.subject} · ${topic.topic}\n${topic.errorType}: ${topic.action}',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                AppPageRoute<void>(builder: (_) => const WeakTopicsScreen()),
              ),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('Zayıf konuları aç'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanStatus(BuildContext context, AppState state) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final targetPassed = state.daysRemaining < 0;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final startsLater =
        state.dailyLogs.isNotEmpty &&
        DateTime(
          state.dailyLogs.first.date.year,
          state.dailyLogs.first.date.month,
          state.dailyLogs.first.date.day,
        ).isAfter(todayDate);
    final firstPlanDate = state.dailyLogs.isEmpty
        ? null
        : state.dailyLogs.first.date;
    final message = targetPassed
        ? 'Bu profilin hedef tarihi geçti. Yeni sınav dönemi için hedef tarihini güncelle.'
        : startsLater && firstPlanDate != null
        ? 'Hazır 95 günlük plan ${firstPlanDate.day}.${firstPlanDate.month.toString().padLeft(2, '0')}.${firstPlanDate.year} tarihinde başlıyor. O zamana kadar Dersler ve Zayıf Konular bölümlerinden ilerleyebilirsin.'
        : 'Bu hazır plan bugün için görev içermiyor. Dersler bölümünden konu çalışmana devam edebilirsin.';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: targetPassed
            ? colors.errorContainer
            : colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: targetPassed
              ? colors.error.withValues(alpha: 0.35)
              : colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Icon(
            targetPassed ? Icons.event_busy_rounded : Icons.info_outline,
            color: targetPassed ? colors.onErrorContainer : colors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurface,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
          if (targetPassed)
            TextButton(
              onPressed: () => Navigator.push(
                context,
                AppPageRoute(builder: (_) => const SettingsScreen()),
              ),
              child: const Text('Tarihi seç'),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
