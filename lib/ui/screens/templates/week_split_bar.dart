import 'package:flutter/material.dart';
import '../../../core/models/template.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/theme_provider.dart';

class WeekSplitBar extends StatelessWidget {
  final List<Template> templates;
  final String? selectedDay;
  final ValueChanged<String?> onSelectDay;

  const WeekSplitBar({
    super.key,
    required this.templates,
    this.selectedDay,
    required this.onSelectDay,
  });

  static const List<String> days = [
    'SAT',
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) {
          Template? matchingTemplate;
          for (final t in templates) {
            if (t.days.contains(day)) {
              matchingTemplate = t;
              break;
            }
          }

          final hasRoutine = matchingTemplate != null;
          final initial = hasRoutine && matchingTemplate.name.isNotEmpty
              ? matchingTemplate.name[0].toUpperCase()
              : '-';
          final isSelected = selectedDay == day;

          return GestureDetector(
            onTap: () {
              AppHaptics.light();
              onSelectDay(isSelected ? null : day);
            },
            behavior: HitTestBehavior.opaque,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasRoutine ? colors.surfaceDark : colors.surface,
                    border: Border.all(
                      color: isSelected
                          ? colors.accent
                          : (hasRoutine ? colors.surfaceDark : colors.border),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: typography.body.merge(typography.tabularNums).copyWith(
                            color: hasRoutine
                                ? Colors.white
                                : colors.textSecondary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  day,
                  style: typography.label.copyWith(
                    color: isSelected ? colors.accent : colors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
