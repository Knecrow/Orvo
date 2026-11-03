import 'package:flutter/material.dart';
import '../../../core/models/profile.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/segmented_control.dart';
import 'profile_metric_tile.dart';

class ProfileMetricsCard extends StatelessWidget {
  final String heightDisplay;
  final String weightDisplay;
  final String daysDisplay;
  final WeightUnit unit;
  final VoidCallback onHeightTap;
  final VoidCallback onWeightTap;
  final VoidCallback onDaysTap;
  final ValueChanged<WeightUnit> onUnitChange;

  const ProfileMetricsCard({
    super.key,
    required this.heightDisplay,
    required this.weightDisplay,
    required this.daysDisplay,
    required this.unit,
    required this.onHeightTap,
    required this.onWeightTap,
    required this.onDaysTap,
    required this.onUnitChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border, width: 1.0),
      ),
      child: Column(
        children: [
          ProfileMetricTile(
            label: 'Height',
            value: heightDisplay,
            onTap: onHeightTap,
          ),
          ProfileMetricTile(
            label: 'Weight',
            value: weightDisplay,
            onTap: onWeightTap,
          ),
          // Unit row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Units',
                  style: typography.secondary.copyWith(
                    color: colors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: AppSegmentedControl<WeightUnit>(
                    options: const [
                      SegmentOption(value: WeightUnit.kg, label: 'kg'),
                      SegmentOption(value: WeightUnit.lb, label: 'lb'),
                    ],
                    selectedValue: unit,
                    onSelect: onUnitChange,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: colors.border.withValues(alpha: 0.6), height: 1),
          ),
          ProfileMetricTile(
            label: 'Workout Days',
            value: daysDisplay,
            onTap: onDaysTap,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

