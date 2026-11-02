import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/autocomplete_engine.dart';
import '../../../core/logic/id_generator.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/profile.dart';
import '../../../core/models/template.dart';
import '../../../core/models/workout.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_bottom_sheet.dart';
import '../../components/app_button.dart';
import '../../components/app_text_input.dart';
import '../../components/screen_header.dart';
import 'add_exercise_sheet.dart';
import 'exercise_workout_section.dart';

class LogWorkoutScreen extends StatefulWidget {
  final AppStore store;
  final Workout? workoutToEdit;
  final List<String>? templateExerciseNames;
  final Template? template;

  const LogWorkoutScreen({
    super.key,
    required this.store,
    this.workoutToEdit,
    this.templateExerciseNames,
    this.template,
  });

  @override
  State<LogWorkoutScreen> createState() => _LogWorkoutScreenState();
}

class _LogWorkoutScreenState extends State<LogWorkoutScreen> {
  final List<DraftEx> _exercises = [];
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final unit = widget.store.profile?.unit ?? WeightUnit.kg;
    if (widget.workoutToEdit != null) {
      _notesCtrl.text = widget.workoutToEdit!.notes ?? '';
      for (final ex in widget.workoutToEdit!.exercises) {
        _exercises.add(DraftEx(
          name: ex.name,
          sets: ex.sets.map((s) => DraftSet(
            weight: formatWeightValue(s.weightKg, unit),
            reps: s.reps > 0 ? s.reps.toString() : '',
          )).toList(),
        ));
      }
    } else if (widget.template != null && widget.template!.items.isNotEmpty) {
      for (final item in widget.template!.items) {
        int setCount = 1;
        String reps = '';
        final xMatch = RegExp(r'(\d+)\s*x\s*(\d+)').firstMatch(item.target);
        if (xMatch != null) {
          setCount = int.tryParse(xMatch.group(1) ?? '1') ?? 1;
          reps = xMatch.group(2) ?? '';
        } else {
          final digits = RegExp(r'\d+').firstMatch(item.target);
          if (digits != null) reps = digits.group(0) ?? '';
        }

        String weight = '';
        final wDigits = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(item.load);
        if (wDigits != null) {
          weight = wDigits.group(1) ?? '';
        }

        final sets = List.generate(
          setCount.clamp(1, 10),
          (_) => DraftSet(weight: weight, reps: reps),
        );
        _exercises.add(DraftEx(name: item.name, sets: sets));
      }
    } else if (widget.templateExerciseNames != null && widget.templateExerciseNames!.isNotEmpty) {
      for (final name in widget.templateExerciseNames!) {
        _exercises.add(DraftEx(name: name, sets: [DraftSet()]));
      }
    } else {
      _exercises.add(DraftEx(name: 'Bench Press', sets: [DraftSet()]));
    }
  }

  @override
  void dispose() {
    for (final ex in _exercises) {
      ex.dispose();
    }
    _notesCtrl.dispose();
    super.dispose();
  }

  bool _isSaveEnabled() {
    return _exercises.any((ex) =>
        ex.name.trim().isNotEmpty &&
        ex.sets.any((s) => (int.tryParse(s.repsCtrl.text) ?? 0) > 0));
  }

  void _save() {
    if (!_isSaveEnabled()) return;
    final unit = widget.store.profile?.unit ?? WeightUnit.kg;

    final finalExercises = <WorkoutExercise>[];
    for (final ex in _exercises) {
      if (ex.name.trim().isEmpty) continue;
      final sets = <SetEntry>[];
      for (final s in ex.sets) {
        final reps = int.tryParse(s.repsCtrl.text) ?? 0;
        if (reps > 0) {
          final wVal = double.tryParse(s.weightCtrl.text) ?? 0.0;
          sets.add(SetEntry(weightKg: inputToKg(wVal, unit), reps: reps));
        }
      }
      if (sets.isNotEmpty) {
        finalExercises.add(WorkoutExercise(name: ex.name.trim(), sets: sets));
      }
    }

    final workout = Workout(
      id: widget.workoutToEdit?.id ?? generateId(),
      date: widget.workoutToEdit?.date ?? DateTime.now().toIso8601String(),
      exercises: finalExercises,
      notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
    );

    AppHaptics.savePair();
    if (widget.workoutToEdit != null) {
      widget.store.updateWorkout(workout);
    } else {
      widget.store.addWorkout(workout);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final unit = widget.store.profile?.unit ?? WeightUnit.kg;
    final allNames = extractExerciseNames(widget.store.workouts, widget.store.templates);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: widget.workoutToEdit != null ? 'Edit Workout' : 'Log Workout',
              leftAction: HeaderAction(label: 'Cancel', onPress: () => Navigator.pop(context)),
              rightAction: HeaderAction(
                label: 'Save',
                disabled: !_isSaveEnabled(),
                onPress: _save,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppLayout.screenHorizontalPadding),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  ..._exercises.asMap().entries.map((entry) {
                    final exIdx = entry.key;
                    final ex = entry.value;

                    return ExerciseWorkoutSection(
                      exercise: ex,
                      exerciseIndex: exIdx,
                      allWorkouts: widget.store.workouts,
                      unit: unit,
                      onRemoveExercise: () => setState(() => _exercises.removeAt(exIdx).dispose()),
                      onRemoveSet: (sIdx) => setState(() => ex.sets.removeAt(sIdx).dispose()),
                      onAddSet: () {
                        final prev = ex.sets.isNotEmpty ? ex.sets.last : null;
                        setState(() {
                          ex.sets.add(DraftSet(
                            weight: prev?.weightCtrl.text ?? '',
                            reps: prev?.repsCtrl.text ?? '',
                          ));
                        });
                      },
                      onDataChanged: () => setState(() {}),
                    );
                  }),
                  AppButton(
                    label: 'Add Exercise',
                    variant: ButtonVariant.secondary,
                    onPress: () {
                      showAppBottomSheet(
                        context: context,
                        child: AddExerciseSheet(
                          allExerciseNames: allNames,
                          onAddExercise: (name) {
                            setState(() => _exercises.add(DraftEx(name: name, sets: [DraftSet()])));
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppTextInput(
                    label: 'NOTES',
                    controller: _notesCtrl,
                    placeholder: 'Felt strong on bench',
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
