import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/achievements_data.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        state.checkAchievements();
        final unlocked = state.achievements.where((a) => a.isUnlocked).toList();
        final locked = state.achievements.where((a) => !a.isUnlocked).toList();
        final progress = state.achievements.isEmpty
            ? 0.0
            : unlocked.length / state.achievements.length;

        return Scaffold(
          appBar: AppBar(title: const Text('🏆 Başarımlar')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 6,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation(
                                Colors.white,
                              ),
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                          Text(
                            '${unlocked.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Toplam Başarım',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${unlocked.length} / ${state.achievements.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}% tamamlandı',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Unlocked
                if (unlocked.isNotEmpty) ...[
                  Text(
                    '✅ Kazanılan (${unlocked.length})',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  ...unlocked.map((a) => _achievementCard(context, a, true)),
                  const SizedBox(height: 20),
                ],

                // Locked
                Text(
                  '🔒 Kilitli (${locked.length})',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                ...locked.map((a) => _achievementCard(context, a, false)),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _achievementCard(
    BuildContext context,
    Achievement achievement,
    bool unlocked,
  ) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unlocked
            ? colors.secondaryContainer.withValues(alpha: 0.65)
            : colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: unlocked
              ? colors.secondary.withValues(alpha: 0.4)
              : colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: unlocked
                  ? Colors.transparent
                  : colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                unlocked ? achievement.emoji : '🔒',
                style: TextStyle(fontSize: unlocked ? 28 : 22),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: textTheme.bodyMedium?.copyWith(
                    color: unlocked
                        ? colors.onSurface
                        : colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  achievement.description,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                if (unlocked && achievement.unlockedDate != null)
                  Text(
                    'Kazanıldı: ${achievement.unlockedDateLabel}',
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.secondary,
                    ),
                  ),
              ],
            ),
          ),
          if (unlocked)
            Icon(Icons.check_circle, color: colors.secondary, size: 22),
        ],
      ),
    );
  }
}
