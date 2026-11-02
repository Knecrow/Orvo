import 'package:flutter/material.dart';
import '../../core/platform/app_haptics.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/theme_provider.dart';

class SegmentOption<T> {
  final T value;
  final String label;
  const SegmentOption({required this.value, required this.label});
}

class AppSegmentedControl<T> extends StatelessWidget {
  final List<SegmentOption<T>> options;
  final T selectedValue;
  final ValueChanged<T> onSelect;

  const AppSegmentedControl({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.button + 2),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: options.map((opt) {
          final isSelected = opt.value == selectedValue;
          return Expanded(
            child: Semantics(
              selected: isSelected,
              button: true,
              label: opt.label,
              child: GestureDetector(
                onTap: () {
                  if (!isSelected) {
                    AppHaptics.light();
                    onSelect(opt.value);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOutCubic,
                  height: AppLayout.minTouchTarget - 8,
                  decoration: BoxDecoration(
                    color: isSelected ? colors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.button - 1),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    opt.label,
                    style: typography.body.copyWith(
                      color: isSelected ? Colors.white : colors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
