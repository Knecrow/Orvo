import 'package:flutter/material.dart';
import '../../../core/logic/analytics_engine.dart';
import '../../../core/theme/theme_provider.dart';

class StreakGraphCard extends StatelessWidget {
  final List<WeekWorkoutStat> stats;
  final int currentStreak;
  final int weeklyGoal;

  const StreakGraphCard({
    super.key,
    required this.stats,
    required this.currentStreak,
    required this.weeklyGoal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final maxCount = stats.fold<int>(
      weeklyGoal + 1,
      (prev, s) => s.count > prev ? s.count : prev,
    );
    final hitCount = stats.where((s) => s.goalMet).length;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Streaks',
                style: typography.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$currentStreak week streak',
                  style: typography.label.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: stats.map((s) {
                final heightFactor = (s.count / maxCount).clamp(0.08, 1.0);
                final isGoalMet = s.goalMet;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${s.count}',
                      style: typography.label.copyWith(
                        color: isGoalMet ? Colors.white : const Color(0xFF757470),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 22,
                      height: 52 * heightFactor,
                      decoration: BoxDecoration(
                        color: isGoalMet ? colors.accent : const Color(0xFF2C2C2A),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s.label,
                      style: typography.label.copyWith(
                        color: const Color(0xFF757470),
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: const Color(0xFF262624)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Target: $weeklyGoal workouts/wk',
                style: typography.secondary.copyWith(
                  color: const Color(0xFF8E8D88),
                  fontSize: 11,
                ),
              ),
              Text(
                '$hitCount of ${stats.length} wks on target',
                style: typography.secondary.copyWith(
                  color: const Color(0xFF8E8D88),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
