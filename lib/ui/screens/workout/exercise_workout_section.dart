import 'package:flutter/material.dart';
import '../../../core/logic/last_time_lookup.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/profile.dart';
import '../../../core/models/workout.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_bottom_sheet.dart';
import '../../components/reps_scroll_picker.dart';
import '../../components/swipeable_row.dart';
import '../../components/weight_scroll_picker.dart';

class DraftSet {
  final TextEditingController weightCtrl;
  final TextEditingController repsCtrl;
  DraftSet({String weight = '', String reps = ''})
      : weightCtrl = TextEditingController(text: weight),
        repsCtrl = TextEditingController(text: reps);
  void dispose() {
    weightCtrl.dispose();
    repsCtrl.dispose();
  }
}

class DraftEx {
  String name;
  List<DraftSet> sets;
  DraftEx({required this.name, required this.sets});
  void dispose() {
    for (final s in sets) {
      s.dispose();
    }
  }
}

class ExerciseWorkoutSection extends StatelessWidget {
  final DraftEx exercise;
  final int exerciseIndex;
  final List<Workout> allWorkouts;
  final WeightUnit unit;
  final VoidCallback onRemoveExercise;
  final ValueChanged<int> onRemoveSet;
  final VoidCallback onAddSet;
  final VoidCallback onDataChanged;

  const ExerciseWorkoutSection({
    super.key,
    required this.exercise,
    required this.exerciseIndex,
    required this.allWorkouts,
    required this.unit,
    required this.onRemoveExercise,
    required this.onRemoveSet,
    required this.onAddSet,
    required this.onDataChanged,
  });

  void _openWeightPicker(BuildContext context, DraftSet s) {
    final curVal = double.tryParse(s.weightCtrl.text) ?? (unit == WeightUnit.kg ? 20.0 : 45.0);
    showAppBottomSheet(
      context: context,
      initialChildSize: 0.42,
      child: WeightScrollPicker(
        initialWeight: curVal,
        unit: unit,
        onSelect: (val) {
          s.weightCtrl.text = formatWeightValue(val, unit);
          onDataChanged();
        },
      ),
    );
  }

  void _openRepsPicker(BuildContext context, DraftSet s) {
    final curReps = int.tryParse(s.repsCtrl.text) ?? 10;
    showAppBottomSheet(
      context: context,
      initialChildSize: 0.40,
      child: RepsScrollPicker(
        initialReps: curReps,
        onSelect: (val) {
          s.repsCtrl.text = '$val';
          onDataChanged();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final unitLabel = unit == WeightUnit.kg ? 'kg' : 'lb';
    final hint = getLastTimeTopSet(exercise.name, allWorkouts, unit);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: typography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    if (hint != null)
                      Text(
                        hint.formattedHint,
                        style: typography.secondary.copyWith(
                          color: colors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onRemoveExercise,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Remove',
                  style: typography.secondary.copyWith(color: colors.danger),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...exercise.sets.asMap().entries.map((sEntry) {
            final sIdx = sEntry.key;
            final s = sEntry.value;

            return SwipeableRow(
              itemKey: ValueKey('${exercise.name}-$sIdx-${s.hashCode}'),
              showSeparator: false,
              onDelete: () => onRemoveSet(sIdx),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${sIdx + 1}',
                        style: typography.body.merge(typography.tabularNums).copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: s.weightCtrl,
                        readOnly: true,
                        onTap: () => _openWeightPicker(context, s),
                        textAlign: TextAlign.right,
                        style: typography.body.merge(typography.tabularNums).copyWith(
                          color: colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          suffixText: ' $unitLabel',
                          suffixStyle: typography.secondary.copyWith(color: colors.textSecondary),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: colors.border)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colors.accent, width: 2)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('×', style: typography.secondary.copyWith(color: colors.textSecondary)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: s.repsCtrl,
                        readOnly: true,
                        onTap: () => _openRepsPicker(context, s),
                        textAlign: TextAlign.right,
                        style: typography.body.merge(typography.tabularNums).copyWith(
                          color: colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          suffixText: ' reps',
                          suffixStyle: typography.secondary.copyWith(color: colors.textSecondary),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: colors.border)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: colors.accent, width: 2)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          GestureDetector(
            onTap: onAddSet,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                '+ Add Set',
                style: typography.body.copyWith(
                  color: colors.accentText,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
