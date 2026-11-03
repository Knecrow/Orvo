import 'package:flutter/material.dart';
import '../../../core/models/template.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/theme_provider.dart';

class TodayExerciseRow extends StatelessWidget {
  final TemplateExercise exercise;
  final bool isDone;
  final VoidCallback onToggle;
  final bool isLast;

  const TodayExerciseRow({
    super.key,
    required this.exercise,
    required this.isDone,
    required this.onToggle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            AppHaptics.light();
            onToggle();
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: Row(
              children: [
                // Circular tick checkbox
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isDone ? colors.accent : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone ? colors.accent : const Color(0xFFC8C7C0),
                      width: 1.5,
                    ),
                  ),
                  child: isDone
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                // Exercise Name
                Expanded(
                  flex: 5,
                  child: Text(
                    exercise.name,
                    style: typography.body.copyWith(
                      color: isDone
                          ? const Color(0xFF9E9D97)
                          : colors.textPrimary,
                      fontWeight: isDone ? FontWeight.w400 : FontWeight.w600,
                      fontSize: 13.5,
                      decoration: isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: const Color(0xFF9E9D97),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // Target (e.g. 2 x 12 or 5 min)
                Expanded(
                  flex: 3,
                  child: Text(
                    exercise.target.isNotEmpty ? exercise.target : '-',
                    textAlign: TextAlign.center,
                    style: typography.secondary
                        .merge(typography.tabularNums)
                        .copyWith(
                          color: isDone
                              ? const Color(0xFFA5A49E)
                              : const Color(0xFF8E8D88),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // Load (e.g. 25-30 kg or Body)
                Expanded(
                  flex: 4,
                  child: Text(
                    exercise.load.isNotEmpty ? exercise.load : '-',
                    textAlign: TextAlign.right,
                    style: typography.label
                        .merge(typography.tabularNums)
                        .copyWith(
                          color: isDone
                              ? const Color(0xFFA5A49E)
                              : colors.textPrimary,
                          fontSize: 12,
                          fontWeight: isDone ? FontWeight.w400 : FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 0.5,
            color: Color(0xFFEAE9E2),
          ),
      ],
    );
  }
}
