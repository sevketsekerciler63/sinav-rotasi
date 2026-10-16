import '../models/daily_log.dart' show turkishWeekdayName;
import '../theme/app_motion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/subject.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_primitives.dart';
import '../data/achievements_data.dart';
import 'subjects_screen.dart';
import 'daily_plan_screen.dart';
import 'mock_exam_screen.dart';
import 'score_calculator_screen.dart';
import 'exam_calendar_screen.dart';
import 'weak_topics_screen.dart';
import 'study_resources_screen.dart';
import 'resource_plan_screen.dart';
import 'stats_screen.dart';
import 'pomodoro_screen.dart';
import 'achievements_screen.dart';
import 'goals_screen.dart';
import 'weekly_report_screen.dart';
import 'exam_comparison_screen.dart';
import 'settings_screen.dart';
import 'formula_cards_screen.dart';
import 'flashcard_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final quote = getDailyQuote();
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, state),
                  const SizedBox(height: 16),
                  if (state.daysRemaining < 0) ...[
                    _buildExpiredTargetBanner(context),
                    const SizedBox(height: 16),
                  ],

                  const ResourceTodayCard(),
                  const SizedBox(height: 16),

                  // Achievement notification
                  if (state.lastUnlockedAchievement != null) ...[
                    _buildAchievementBanner(context, state),
                    const SizedBox(height: 16),
                  ],

                  if (state.daysRemaining >= 0) ...[
                    _buildCountdownCard(context, state),
                    const SizedBox(height: 16),
                  ],
                  _buildStatsRow(context, state),
                  const SizedBox(height: 16),

                  _buildMotivationCard(context, quote),
                  const SizedBox(height: 16),

                  // Active goals
                  if (state.goals.where((g) => !g.isCompleted).isNotEmpty) ...[
                    _buildActiveGoals(context, state),
                    const SizedBox(height: 16),
                  ],

                  const AppSectionHeader(title: '📚 Ders İlerlemen'),
                  const SizedBox(height: 12),
                  _buildSubjectProgress(context, state),
                  const SizedBox(height: 20),
                  _buildQuickAccess(context),
                  const SizedBox(height: 20),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMotivationCard(BuildContext context, MotivationQuote quote) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colors.secondary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.format_quote_rounded,
              color: colors.secondary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${quote.text}"',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '— ${quote.author}',
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBanner(BuildContext context, AppState state) {
    return GestureDetector(
      onTap: () {
        state.lastUnlockedAchievement = null;
        Navigator.push(
          context,
          AppPageRoute(builder: (_) => const AchievementsScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppTheme.warningGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Text('🏆', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yeni Başarım!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    state.lastUnlockedAchievement!,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveGoals(BuildContext context, AppState state) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final activeGoals = state.goals
        .where((g) => !g.isCompleted)
        .take(2)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: '🎯 Aktif Hedefler',
          trailing: TextButton(
            onPressed: () => Navigator.push(
              context,
              AppPageRoute(builder: (_) => const GoalsScreen()),
            ),
            child: const Text('Tümü →'),
          ),
        ),
        const SizedBox(height: 10),
        ...activeGoals.map(
          (goal) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      goal.title,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${goal.currentCount}/${goal.targetCount}',
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: goal.progress,
                    minHeight: 5,
                    backgroundColor: colors.outlineVariant,
                    valueColor: AlwaysStoppedAnimation(colors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AppState state) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Günaydın! ☀️'
        : hour < 18
        ? 'İyi çalışmalar! 📖'
        : 'İyi akşamlar! 🌙';
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(greeting, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(
              state.daysRemaining < 0
                  ? '${state.streak} günlük seri 🔥'
                  : '${state.daysRemaining} gün kaldı · ${state.streak} günlük seri 🔥',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'Başarımlar: ${state.unlockedAchievements} rozet',
              child: TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  AppPageRoute(builder: (_) => const AchievementsScreen()),
                ),
                icon: const Icon(Icons.emoji_events_outlined),
                label: Text('${state.unlockedAchievements}'),
              ),
            ),
            IconButton.filledTonal(
              tooltip: 'İstatistikleri aç',
              onPressed: () => Navigator.push(
                context,
                AppPageRoute(builder: (_) => const StatsScreen()),
              ),
              icon: const Icon(Icons.bar_chart_rounded),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountdownCard(BuildContext context, AppState state) {
    final remaining = state.daysRemaining;
    final totalTopics = state.subjects.fold<int>(
      0,
      (total, subject) => total + subject.topics.length,
    );
    final completedTopics = state.subjects.fold<int>(
      0,
      (total, subject) => total + subject.completedCount,
    );
    final progress = totalTopics == 0
        ? 0.0
        : (completedTopics / totalTopics).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.accentBlue.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF071411).withValues(alpha: 0.32),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _RouteAtlasPainter(progress: progress),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.route_rounded,
                        color: AppTheme.accentGreen,
                        size: 17,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          'KİŞİSEL HEDEF ROTASI',
                          style: TextStyle(
                            color: AppTheme.accentGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.35,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.explore_outlined,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              remaining < 0
                                  ? 'Hedef tarihi geçti'
                                  : 'Hedefe kalan',
                              style: const TextStyle(
                                color: Color(0xFFD2DFD9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              remaining < 0
                                  ? '${-remaining} gün önce'
                                  : '$remaining gün',
                              style: const TextStyle(
                                color: Color(0xFFF3F4E8),
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: AppMotion.duration(
                          context,
                          AppMotion.progress,
                        ),
                        curve: Curves.easeOutCubic,
                        builder: (context, animatedProgress, _) =>
                            CircularPercentIndicator(
                              radius: 38,
                              lineWidth: 6,
                              percent: animatedProgress,
                              center: Text(
                                '${(animatedProgress * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Color(0xFFF3F4E8),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              progressColor: AppTheme.accentGreen,
                              backgroundColor: Colors.white24,
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Konu ilerlemesi',
                          style: TextStyle(
                            color: Color(0xFFD2DFD9),
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Text(
                        '$completedTopics / $totalTopics',
                        style: const TextStyle(
                          color: Color(0xFFD2DFD9),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: progress),
                    duration: AppMotion.duration(context, AppMotion.progress),
                    curve: Curves.easeOutCubic,
                    builder: (context, animatedProgress, _) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: animatedProgress,
                        minHeight: 5,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(
                          AppTheme.accentBlue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(
                        Icons.flag_outlined,
                        color: Color(0xFFD2DFD9),
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Plan hedefi: ${state.activeProfile.targetDate.day} ${_turkishMonth(state.activeProfile.targetDate.month)} ${state.activeProfile.targetDate.year} · ${turkishWeekdayName(state.activeProfile.targetDate)}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.78),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiredTargetBanner(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.error.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.event_busy_rounded, color: colors.onErrorContainer),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Hedef tarihin geçti. Yeni dönem için hedefini güncelleyebilirsin.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onErrorContainer,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                AppPageRoute(builder: (_) => const SettingsScreen()),
              ),
              icon: const Icon(Icons.edit_calendar_outlined, size: 18),
              label: const Text('Hedef tarihini düzenle'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, AppState state) {
    final today = DateTime.now();
    return Column(
      children: [
        Row(
          children: [
            _statCard(
              context,
              '📚 Konular',
              '${state.completedTopics}/${state.totalTopics}',
              AppTheme.accentPurple,
            ),
            const SizedBox(width: 10),
            _statCard(
              context,
              '📚 Kaynaklar',
              '${state.learningWorkspace.resources.where((resource) => !resource.archived).length}',
              AppTheme.accentGreen,
            ),
            const SizedBox(width: 10),
            _statCard(
              context,
              '📝 Denemeler',
              '${state.completedExams}',
              AppTheme.accentOrange,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _statCard(
              context,
              '🧮 Bugün soru',
              '${state.solvedQuestionsOn(today)}',
              AppTheme.accentBlue,
            ),
            const SizedBox(width: 10),
            _statCard(
              context,
              '⏱️ Odak seansı',
              '${state.completedStudySessionsOn(today)}',
              AppTheme.accentCyan,
            ),
          ],
        ),
      ],
    );
  }

  String _turkishMonth(int month) => const [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ][month - 1];

  Widget _statCard(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final valueColor = Theme.of(context).brightness == Brightness.light
        ? HSLColor.fromColor(color).withLightness(0.36).toColor()
        : color;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectProgress(BuildContext context, AppState state) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        ...state.tytSubjects.map((s) => _subjectProgressTile(context, s)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'AYT',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...state.aytSubjects.map((s) => _subjectProgressTile(context, s)),
      ],
    );
  }

  Widget _subjectProgressTile(BuildContext context, Subject subject) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: colors.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            AppPageRoute(builder: (_) => SubjectDetailScreen(subject: subject)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(subject.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject.name,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: subject.progress,
                          minHeight: 5,
                          backgroundColor: colors.outlineVariant,
                          valueColor: AlwaysStoppedAnimation(
                            AppTheme.getSubjectColor(subject.name),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${subject.completedCount}/${subject.topics.length}',
                  style: TextStyle(
                    color: subject.progress == 1.0
                        ? colors.secondary
                        : colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: colors.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccess(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final items = [
      _QuickItem(
        icon: Icons.timer_outlined,
        label: 'Pomodoro',
        accent: AppTheme.accentRed,
        category: _QuickCategory.calis,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const PomodoroScreen(autoStart: true)),
        ),
      ),
      _QuickItem(
        icon: Icons.route_outlined,
        label: 'Günlük Plan',
        accent: AppTheme.accentGreen,
        category: _QuickCategory.calis,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const DailyPlanScreen()),
        ),
      ),
      _QuickItem(
        icon: Icons.edit_calendar_outlined,
        label: 'Denemeler',
        accent: AppTheme.accentOrange,
        category: _QuickCategory.olc,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const MockExamScreen()),
        ),
      ),
      _QuickItem(
        icon: Icons.calculate_outlined,
        label: 'Net Hesapla',
        accent: AppTheme.accentCyan,
        category: _QuickCategory.olc,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const ScoreCalculatorScreen()),
        ),
      ),
      _QuickItem(
        icon: Icons.flag_outlined,
        label: 'Hedeflerim',
        accent: AppTheme.accentBlue,
        category: _QuickCategory.gelis,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const GoalsScreen()),
        ),
      ),
      _QuickItem(
        icon: Icons.alt_route_outlined,
        label: 'Zayıf Konular',
        accent: AppTheme.accentRed,
        category: _QuickCategory.gelis,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const WeakTopicsScreen()),
        ),
      ),
      _QuickItem(
        icon: Icons.event_note_outlined,
        label: 'Deneme Takvimi',
        accent: AppTheme.accentOrange,
        category: _QuickCategory.olc,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const ExamCalendarScreen()),
        ),
      ),
      _QuickItem(
        icon: Icons.insights_outlined,
        label: 'Haftalık Rapor',
        accent: AppTheme.accentGreen,
        category: _QuickCategory.gelis,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const WeeklyReportScreen()),
        ),
      ),
      _QuickItem(
        icon: Icons.menu_book_outlined,
        label: 'Kaynaklarım',
        accent: AppTheme.accentCyan,
        category: _QuickCategory.calis,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const StudyResourcesScreen()),
        ),
      ),
      _QuickItem(
        icon: Icons.compare_arrows_rounded,
        label: 'Karşılaştır',
        accent: AppTheme.accentBlue,
        category: _QuickCategory.olc,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const ExamComparisonScreen()),
        ),
      ),
      _QuickItem(
        icon: Icons.functions_rounded,
        label: 'Formüller',
        accent: AppTheme.accentPurple,
        category: _QuickCategory.calis,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const FormulaCardsScreen()),
        ),
      ),
      _QuickItem(
        icon: Icons.style_outlined,
        label: 'Bilgi Kartları',
        accent: AppTheme.accentPink,
        category: _QuickCategory.calis,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const FlashcardScreen()),
        ),
      ),
      _QuickItem(
        icon: Icons.tune_rounded,
        label: 'Ayarlar',
        accent: const Color(0xFF9FB3AC),
        category: _QuickCategory.ayarlar,
        onTap: () => Navigator.push(
          context,
          AppPageRoute(builder: (_) => const SettingsScreen()),
        ),
      ),
    ];

    final featured = items.firstWhere((item) => item.label == 'Kaynaklarım');
    final frequentItems = items
        .where((item) => item != featured)
        .take(3)
        .toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ROTA ARAÇLARI',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Hızlı erişim',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showQuickTools(context, items),
                  icon: const Icon(Icons.grid_view_rounded, size: 17),
                  label: const Text('Tüm araçlar'),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            _FeaturedQuickAccessTile(item: featured),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth < 330 ? 2 : 3;
                final ratio = constraints.maxWidth >= 650
                    ? 2.65
                    : constraints.maxWidth < 360
                    ? 1.05
                    : 1.22;
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: columns,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: ratio,
                  children: frequentItems
                      .map((item) => _QuickAccessTile(item: item))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickTools(BuildContext context, List<_QuickItem> items) {
    showModalBottomSheet<_QuickItem>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _QuickToolsSheet(items: items),
    ).then((selectedItem) => selectedItem?.onTap());
  }
}

enum _QuickCategory { calis, olc, gelis, ayarlar }

extension on _QuickCategory {
  String get label => switch (this) {
    _QuickCategory.calis => 'Çalış',
    _QuickCategory.olc => 'Ölç',
    _QuickCategory.gelis => 'Geliş',
    _QuickCategory.ayarlar => 'Ayarlar',
  };

  String get description => switch (this) {
    _QuickCategory.calis => 'Planla ve odaklan',
    _QuickCategory.olc => 'Sonuçlarını değerlendir',
    _QuickCategory.gelis => 'İlerlemeni takip et',
    _QuickCategory.ayarlar => 'Uygulamayı kişiselleştir',
  };

  Color get accent => switch (this) {
    _QuickCategory.calis => AppTheme.accentBlue,
    _QuickCategory.olc => AppTheme.accentOrange,
    _QuickCategory.gelis => AppTheme.accentGreen,
    _QuickCategory.ayarlar => AppTheme.accentPurple,
  };
}

class _QuickItem {
  final IconData icon;
  final String label;
  final Color accent;
  final _QuickCategory category;
  final VoidCallback onTap;

  const _QuickItem({
    required this.icon,
    required this.label,
    required this.accent,
    required this.category,
    required this.onTap,
  });
}

class _FeaturedQuickAccessTile extends StatefulWidget {
  final _QuickItem item;

  const _FeaturedQuickAccessTile({required this.item});

  @override
  State<_FeaturedQuickAccessTile> createState() =>
      _FeaturedQuickAccessTileState();
}

class _FeaturedQuickAccessTileState extends State<_FeaturedQuickAccessTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final radius = BorderRadius.circular(24);

    return Semantics(
      button: true,
      label: 'Pomodoro ile odak seansı başlat',
      child: ExcludeSemantics(
        child: Tooltip(
          message: 'Pomodoro ile odak seansı başlat',
          child: AnimatedScale(
            scale: _isPressed && !reduceMotion ? 0.99 : 1,
            duration: reduceMotion ? Duration.zero : AppMotion.press,
            curve: Curves.easeOutCubic,
            child: Material(
              color: Colors.transparent,
              borderRadius: radius,
              clipBehavior: Clip.antiAlias,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: radius,
                  border: Border.all(
                    color: AppTheme.accentBlue.withValues(alpha: 0.28),
                  ),
                ),
                child: InkWell(
                  onTap: item.onTap,
                  onHighlightChanged: (pressed) {
                    if (mounted) setState(() => _isPressed = pressed);
                  },
                  borderRadius: radius,
                  splashColor: Colors.white.withValues(alpha: 0.08),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -26,
                        top: -38,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.06),
                              width: 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 16, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.accentGreen,
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        'ODAK MODU',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: const Color(0xFFB9E6D8),
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1.2,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Odak seansına başla',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Pomodoro ile hemen başla',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: const Color(0xFFBED1CA),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.11),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.12),
                                ),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 29,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAccessTile extends StatefulWidget {
  final _QuickItem item;

  const _QuickAccessTile({required this.item});

  @override
  State<_QuickAccessTile> createState() => _QuickAccessTileState();
}

class _QuickAccessTileState extends State<_QuickAccessTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final surface = isDark ? AppTheme.cardDark : AppTheme.cardLight;
    final border = isDark ? AppTheme.borderDark : AppTheme.borderLight;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final radius = BorderRadius.circular(20);

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth >= 190;
        final iconBadge = Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: item.accent.withValues(alpha: isDark ? 0.16 : 0.22),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(item.icon, color: item.accent, size: 20),
        );
        final title = Text(
          item.label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        );

        return Semantics(
          button: true,
          label: '${item.label} sayfasını aç',
          child: ExcludeSemantics(
            child: Tooltip(
              message: item.label,
              child: AnimatedScale(
                scale: _isPressed && !reduceMotion ? 0.97 : 1,
                duration: reduceMotion ? Duration.zero : AppMotion.press,
                curve: Curves.easeOutCubic,
                child: Material(
                  color: surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: radius,
                    side: BorderSide(color: border),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: item.onTap,
                    onHighlightChanged: (pressed) {
                      if (mounted) setState(() => _isPressed = pressed);
                    },
                    borderRadius: radius,
                    splashColor: item.accent.withValues(alpha: 0.12),
                    child: Padding(
                      padding: EdgeInsets.all(horizontal ? 14 : 11),
                      child: horizontal
                          ? Row(
                              children: [
                                iconBadge,
                                const SizedBox(width: 11),
                                Expanded(child: title),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.arrow_outward_rounded,
                                  color: item.accent.withValues(alpha: 0.82),
                                  size: 17,
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    iconBadge,
                                    const Spacer(),
                                    Icon(
                                      Icons.arrow_outward_rounded,
                                      color: item.accent.withValues(
                                        alpha: 0.82,
                                      ),
                                      size: 15,
                                    ),
                                  ],
                                ),
                                title,
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _QuickToolsSheet extends StatelessWidget {
  final List<_QuickItem> items;

  const _QuickToolsSheet({required this.items});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.88,
      minChildSize: 0.58,
      maxChildSize: 0.96,
      builder: (context, scrollController) => Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 17, 20, 13),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rota araçları', style: textTheme.headlineSmall),
                      const SizedBox(height: 3),
                      Text(
                        'İhtiyacın olan bölüme doğrudan geç.',
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Kapat',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final contentWidth = constraints.maxWidth - 40;
                final columns = contentWidth >= 560 ? 2 : 1;
                final tileWidth = columns == 2
                    ? (contentWidth - 10) / 2
                    : contentWidth;
                return ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 24),
                  children: [
                    for (final category in _QuickCategory.values) ...[
                      _QuickCategoryHeading(category: category),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final item in items.where(
                            (item) => item.category == category,
                          ))
                            SizedBox(
                              width: tileWidth,
                              child: _QuickToolSheetTile(item: item),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCategoryHeading extends StatelessWidget {
  final _QuickCategory category;

  const _QuickCategoryHeading({required this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: category.accent,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          category.label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: category.accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            category.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _QuickToolSheetTile extends StatelessWidget {
  final _QuickItem item;

  const _QuickToolSheetTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(17);
    return Semantics(
      button: true,
      label: '${item.label} sayfasını aç',
      child: ExcludeSemantics(
        child: Material(
          color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.pop(context, item),
            borderRadius: radius,
            splashColor: item.category.accent.withValues(alpha: 0.12),
            child: SizedBox(
              height: 72,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: item.category.accent.withValues(
                          alpha: isDark ? 0.16 : 0.2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.category.accent,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.label,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 19,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RouteAtlasPainter extends CustomPainter {
  final double progress;

  const _RouteAtlasPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final contourPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var index = 0; index < 4; index++) {
      final inset = index * 13.0;
      final contour = Path()
        ..moveTo(size.width * 0.61 + inset, -8)
        ..cubicTo(
          size.width * 0.48 + inset,
          size.height * 0.2,
          size.width * 0.82,
          size.height * 0.32 + inset,
          size.width + 8,
          size.height * 0.08 + inset,
        );
      canvas.drawPath(contour, contourPaint);
    }

    final route = Path()
      ..moveTo(size.width * 0.72, size.height * 0.33)
      ..cubicTo(
        size.width * 0.84,
        size.height * 0.12,
        size.width * 0.86,
        size.height * 0.78,
        size.width * 1.02,
        size.height * 0.58,
      );
    canvas.drawPath(
      route,
      Paint()
        ..color = AppTheme.accentBlue.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    final metric = route.computeMetrics().first;
    final position = metric
        .getTangentForOffset(metric.length * progress.clamp(0.0, 1.0))
        ?.position;
    if (position == null) return;

    canvas.drawCircle(
      position,
      6,
      Paint()..color = AppTheme.accentGreen.withValues(alpha: 0.18),
    );
    canvas.drawCircle(position, 3.2, Paint()..color = AppTheme.accentGreen);
  }

  @override
  bool shouldRepaint(covariant _RouteAtlasPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
