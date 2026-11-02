import 'package:flutter/material.dart';
import '../../../core/models/template.dart';
import '../../../core/theme/theme_provider.dart';

class ExerciseEditorRow extends StatelessWidget {
  final TemplateExercise exercise;
  final ValueChanged<TemplateExercise> onChanged;
  final VoidCallback onRemove;

  const ExerciseEditorRow({
    super.key,
    required this.exercise,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Exercise Name
          Expanded(
            flex: 5,
            child: TextFormField(
              initialValue: exercise.name,
              style: typography.body.copyWith(
                color: colors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Exercise name',
                hintStyle: typography.secondary.copyWith(
                  color: colors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                filled: true,
                fillColor: colors.surfaceMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => onChanged(exercise.copyWith(name: val)),
            ),
          ),
          const SizedBox(width: 6),
          // Target (e.g. 2 x 12, 5 min)
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: exercise.target,
              style: typography.body.copyWith(
                color: colors.textPrimary,
                fontSize: 12,
              ),
              decoration: InputDecoration(
                hintText: '2 x 12',
                hintStyle: typography.secondary.copyWith(
                  color: colors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                filled: true,
                fillColor: colors.surfaceMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => onChanged(exercise.copyWith(target: val)),
            ),
          ),
          const SizedBox(width: 6),
          // Load (e.g. 25-30 kg, Body)
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: exercise.load,
              style: typography.body.copyWith(
                color: colors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Body / kg',
                hintStyle: typography.secondary.copyWith(
                  color: colors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                filled: true,
                fillColor: colors.surfaceMuted,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => onChanged(exercise.copyWith(load: val)),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              size: 16,
              color: colors.textSecondary,
            ),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

