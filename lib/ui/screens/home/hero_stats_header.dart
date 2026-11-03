import 'package:flutter/material.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_icons.dart';

class HeroStatsHeader extends StatelessWidget {
  final int streak;
  final String weightStr;
  final String unitLabel;
  final int thisWeekCount;
  final int weeklyGoal;
  final VoidCallback? onStreakTap;
  final VoidCallback? onWeightTap;

  const HeroStatsHeader({
    super.key,
    required this.streak,
    required this.weightStr,
    required this.unitLabel,
    required this.thisWeekCount,
    required this.weeklyGoal,
    this.onStreakTap,
    this.onWeightTap,
  });

  Widget _buildBadge({
    required IconData icon,
    required Color color,
    required String text,
    VoidCallback? onTap,
    required TextStyle style,
    double iconSize = 13,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF262624),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: color),
            const SizedBox(width: 4),
            Text(text, style: style),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final badgeStyle = typography.label.merge(typography.tabularNums).copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 11.5,
    );

    final percent = weeklyGoal > 0
        ? ((thisWeekCount / weeklyGoal) * 100).clamp(0, 100).toInt()
        : 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Goal progress badge
            _buildBadge(
              icon: Icons.track_changes_rounded,
              color: colors.accent,
              text: '$thisWeekCount/$weeklyGoal',
              style: badgeStyle,
            ),
            const SizedBox(width: 6),
            // Streak badge
            if (streak > 0) ...[
              _buildBadge(
                icon: AppIcons.flame,
                color: colors.accent,
                iconSize: 14.5,
                text: '$streak',
                onTap: onStreakTap,
                style: badgeStyle,
              ),
              const SizedBox(width: 6),
            ],
            // Weight badge
            if (weightStr.isNotEmpty)
              _buildBadge(
                icon: AppIcons.activity,
                color: const Color(0xFF8E8D88),
                text: '$weightStr $unitLabel',
                onTap: onWeightTap,
                style: badgeStyle,
              ),
          ],
        ),
        // Goal percent indicator (replacing total volume)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: percent >= 100 ? colors.accent : const Color(0xFF262624),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$percent%',
            style: badgeStyle.copyWith(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

