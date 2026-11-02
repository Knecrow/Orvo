import 'package:flutter/material.dart';
import '../../../core/data/exercise_library.dart';
import '../../../core/theme/theme_provider.dart';

class PresetChipsRow extends StatelessWidget {
  final String currentName;
  final ValueChanged<RoutinePreset> onSelectPreset;

  const PresetChipsRow({
    super.key,
    required this.currentName,
    required this.onSelectPreset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: routinePresets.map((p) {
          final isCurrent = currentName == p.name;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => onSelectPreset(p),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? const Color(0xFF141414)
                      : colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  p.name,
                  style: typography.label.copyWith(
                    color: isCurrent ? Colors.white : colors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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
