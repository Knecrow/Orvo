import 'package:flutter/material.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/theme_provider.dart';

class HomeAnalyticsRow extends StatelessWidget {
  final int thisWeekCount;
  final int weeklyGoal;
  final int streak;
  final VoidCallback? onStreakTap;

  const HomeAnalyticsRow({
    super.key,
    required this.thisWeekCount,
    required this.weeklyGoal,
    required this.streak,
    this.onStreakTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final progress = weeklyGoal > 0
        ? (thisWeekCount / weeklyGoal).clamp(0.0, 1.0)
        : 0.0;

    return Row(
      children: [
        // 1. Goal Ring Card (compact 56px, clean ring without percentage)
        Expanded(
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        backgroundColor: const Color(0xFF2C2C2A),
                        color: colors.accent,
                        strokeWidth: 3.5,
                      ),
                      if (thisWeekCount >= weeklyGoal && weeklyGoal > 0)
                        Icon(
                          Icons.check_rounded,
                          color: colors.accent,
                          size: 16,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Goal',
                        style: typography.label.copyWith(
                          color: const Color(0xFF8E8D88),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '$thisWeekCount / $weeklyGoal',
                        style: typography.body.merge(typography.tabularNums).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // 2. Red Streak Card (compact 56px)
        Expanded(
          child: GestureDetector(
            onTap: () {
              AppHaptics.light();
              onStreakTap?.call();
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.accent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x28000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Streak',
                        style: typography.label.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '$streak',
                        style: typography.title.merge(typography.tabularNums).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

