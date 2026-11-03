import 'package:flutter/material.dart';
import '../../../core/logic/bmi_calculator.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';

class BmiCard extends StatelessWidget {
  final double weightKg;
  final double heightCm;

  const BmiCard({
    super.key,
    required this.weightKg,
    required this.heightCm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final bmi = calculateBmi(weightKg, heightCm);
    if (bmi == null) return const SizedBox.shrink();

    Color dotColor = colors.success;
    if (bmi.statusKey == BmiStatusColorKey.orange) {
      dotColor = colors.warning;
    } else if (bmi.statusKey == BmiStatusColorKey.danger) {
      dotColor = colors.danger;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BMI',
                style: typography.label.copyWith(
                  color: colors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                bmi.formattedValue,
                style: typography.title.merge(typography.tabularNums).copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  bmi.category.label,
                  style: typography.secondary.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
