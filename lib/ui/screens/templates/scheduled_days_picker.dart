import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';

class ScheduledDaysPicker extends StatelessWidget {
  final List<String> selectedDays;
  final ValueChanged<String> onToggleDay;

  const ScheduledDaysPicker({
    super.key,
    required this.selectedDays,
    required this.onToggleDay,
  });

  static const _allDays = ['SAT', 'SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI'];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SCHEDULED DAYS',
          style: typography.label.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _allDays.map((d) {
            final isSel = selectedDays.contains(d);
            return GestureDetector(
              onTap: () => onToggleDay(d),
              child: Container(
                width: 40,
                height: 36,
                decoration: BoxDecoration(
                  color: isSel ? const Color(0xFF141414) : colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  d,
                  style: typography.label.copyWith(
                    color: isSel ? Colors.white : colors.textPrimary,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

