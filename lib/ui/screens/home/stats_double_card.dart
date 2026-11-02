import 'package:flutter/material.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/theme_provider.dart';

class StatsDoubleCard extends StatelessWidget {
  final int streak;
  final String weightStr;
  final String unitLabel;
  final VoidCallback onStreakTap;
  final VoidCallback onWeightTap;

  const StatsDoubleCard({
    super.key,
    required this.streak,
    required this.weightStr,
    required this.unitLabel,
    required this.onStreakTap,
    required this.onWeightTap,
  });

  Widget _buildCard({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          AppHaptics.light();
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colors.surfaceMuted,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: typography.secondary.copyWith(
                  color: colors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: typography.title.merge(typography.tabularNums).copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildCard(
          context: context,
          label: 'Streak',
          value: '$streak ${streak == 1 ? 'week' : 'weeks'}',
          onTap: onStreakTap,
        ),
        const SizedBox(width: 12),
        _buildCard(
          context: context,
          label: 'Weight',
          value: '$weightStr $unitLabel',
          onTap: onWeightTap,
        ),
      ],
    );
  }
}

