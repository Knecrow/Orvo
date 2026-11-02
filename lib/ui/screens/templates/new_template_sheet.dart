import 'package:flutter/material.dart';
import '../../../core/data/exercise_library.dart';
import '../../../core/logic/id_generator.dart';
import '../../../core/models/template.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_bottom_sheet.dart';
import '../../components/app_button.dart';
import '../../components/app_text_input.dart';
import 'exercise_editor_row.dart';
import 'exercise_picker_modal.dart';
import 'preset_chips_row.dart';
import 'scheduled_days_picker.dart';

class NewTemplateSheet extends StatefulWidget {
  final List<String> allExerciseNames;
  final Template? initialTemplate;
  final ValueChanged<Template> onSave;

  const NewTemplateSheet({
    super.key,
    required this.allExerciseNames,
    this.initialTemplate,
    required this.onSave,
  });

  @override
  State<NewTemplateSheet> createState() => _NewTemplateSheetState();
}

class _NewTemplateSheetState extends State<NewTemplateSheet> {
  final _nameCtrl = TextEditingController();
  final List<String> _days = [];
  final List<TemplateExercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialTemplate != null) {
      _nameCtrl.text = widget.initialTemplate!.name;
      _days.addAll(widget.initialTemplate!.days);
      _exercises.addAll(widget.initialTemplate!.items);
    } else {
      _applyPreset(routinePresets.first);
    }
  }

  void _applyPreset(RoutinePreset preset) {
    AppHaptics.light();
    setState(() {
      _nameCtrl.text = preset.name;
      _days.clear();
      _days.addAll(preset.days);
      _exercises.clear();
      _exercises.addAll(preset.exercises);
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _toggleDay(String day) {
    AppHaptics.light();
    setState(() {
      if (_days.contains(day)) {
        _days.remove(day);
      } else {
        _days.add(day);
      }
    });
  }

  void _openExercisePicker() {
    showAppBottomSheet(
      context: context,
      initialChildSize: 0.85,
      child: ExercisePickerModal(
        onSelectExercise: (ex) {
          setState(() => _exercises.add(ex));
        },
      ),
    );
  }

  bool _isValid() {
    return _nameCtrl.text.trim().isNotEmpty &&
        _exercises.any((e) => e.name.trim().isNotEmpty);
  }

  void _save() {
    if (!_isValid()) return;
    final validExercises =
        _exercises.where((e) => e.name.trim().isNotEmpty).toList();

    final template = Template(
      id: widget.initialTemplate?.id ?? generateId(),
      name: _nameCtrl.text.trim().toUpperCase(),
      days: _days,
      routineExercises: validExercises,
      exercises: validExercises.map((e) => e.name).toList(),
    );

    AppHaptics.success();
    widget.onSave(template);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.initialTemplate != null ? 'Edit Routine' : 'New Routine',
                style: typography.title.copyWith(color: colors.textPrimary),
              ),
              if (widget.initialTemplate == null)
                Text(
                  'Quick Presets:',
                  style: typography.secondary.copyWith(
                    color: colors.textSecondary,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
          if (widget.initialTemplate == null) ...[
            const SizedBox(height: 8),
            PresetChipsRow(
              currentName: _nameCtrl.text,
              onSelectPreset: _applyPreset,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          AppTextInput(
            label: 'ROUTINE NAME',
            controller: _nameCtrl,
            autoCorrect: false,
            textCapitalization: TextCapitalization.characters,
            placeholder: 'UPPER / LOWER / PUSH',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.sm),
          ScheduledDaysPicker(
            selectedDays: _days,
            onToggleDay: _toggleDay,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Text('EXERCISE',
                    style: typography.label.copyWith(color: colors.textSecondary)),
              ),
              Expanded(
                flex: 3,
                child: Text('TARGET',
                    style: typography.label.copyWith(color: colors.textSecondary)),
              ),
              Expanded(
                flex: 3,
                child: Text('LOAD',
                    style: typography.label.copyWith(color: colors.textSecondary)),
              ),
              const SizedBox(width: 32),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ..._exercises.asMap().entries.map((entry) {
            final idx = entry.key;
            final ex = entry.value;
            return ExerciseEditorRow(
              key: ValueKey('ex_${idx}_${ex.name}'),
              exercise: ex,
              onChanged: (updated) => setState(() => _exercises[idx] = updated),
              onRemove: () => setState(() => _exercises.removeAt(idx)),
            );
          }),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: '+ From Library',
                  variant: ButtonVariant.secondary,
                  onPress: _openExercisePicker,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: '+ Custom Row',
                  variant: ButtonVariant.secondary,
                  onPress: () {
                    AppHaptics.light();
                    setState(() {
                      _exercises.add(const TemplateExercise(
                        name: '',
                        target: '3 x 10',
                        load: 'Body',
                      ));
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Save Routine',
            disabled: !_isValid(),
            onPress: _save,
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
