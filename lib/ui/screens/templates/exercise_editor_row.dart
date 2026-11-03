import 'package:flutter/material.dart';
import '../../../core/models/template.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_bottom_sheet.dart';
import 'load_scroll_picker.dart';
import 'target_scroll_picker.dart';

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

  void _openTargetPicker(BuildContext context) {
    AppHaptics.light();
    showAppBottomSheet(
      context: context,
      initialChildSize: 0.45,
      child: TargetScrollPicker(
        initialTarget: exercise.target.isNotEmpty ? exercise.target : '3 x 10',
        onSelect: (val) => onChanged(exercise.copyWith(target: val)),
      ),
    );
  }

  void _openLoadPicker(BuildContext context) {
    AppHaptics.light();
    showAppBottomSheet(
      context: context,
      initialChildSize: 0.45,
      child: LoadScrollPicker(
        initialLoad: exercise.load.isNotEmpty ? exercise.load : 'Body',
        onSelect: (val) => onChanged(exercise.copyWith(load: val)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final targetText = exercise.target.isNotEmpty ? exercise.target : '3 x 10';
    final loadText = exercise.load.isNotEmpty ? exercise.load : 'Body';

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
                  vertical: 9,
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
          // Scrollable Target Button
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => _openTargetPicker(context),
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  targetText,
                  style: typography.body.copyWith(
                    color: colors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Scrollable Load Button
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => _openLoadPicker(context),
              child: Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  loadText,
                  style: typography.body.copyWith(
                    color: colors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
