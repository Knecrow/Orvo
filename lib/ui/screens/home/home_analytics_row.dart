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

    final goalPercent = weeklyGoal > 0
        ? ((thisWeekCount / weeklyGoal) * 100).clamp(0, 100).toInt()
        : 0;
    final progress = weeklyGoal > 0
        ? (thisWeekCount / weeklyGoal).clamp(0.0, 1.0)
        : 0.0;

    return Row(
      children: [
        // 1. Goal Ring Card (exact Analytics style, compact 76px)
        Expanded(
          child: Container(
            height: 76,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surfaceDark,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        backgroundColor: const Color(0xFF2C2C2A),
                        color: colors.accent,
                        strokeWidth: 4.5,
                      ),
                      Text(
                        '$goalPercent%',
                        style: typography.label.merge(typography.tabularNums).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Goal',
                        style: typography.label.copyWith(
                          color: const Color(0xFF8E8D88),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$thisWeekCount / $weeklyGoal',
                        style: typography.body.merge(typography.tabularNums).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
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
        // 2. Red Streak Card (exact Analytics style, compact 76px)
        Expanded(
          child: GestureDetector(
            onTap: () {
              AppHaptics.light();
              onStreakTap?.call();
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 76,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: colors.accent,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x28000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
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
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$streak',
                        style: typography.title.merge(typography.tabularNums).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 28,
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

