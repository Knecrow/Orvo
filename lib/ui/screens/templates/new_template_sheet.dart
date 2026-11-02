import 'package:flutter/material.dart';
import '../../../core/logic/id_generator.dart';
import '../../../core/models/template.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_button.dart';
import '../../components/app_text_input.dart';
import 'exercise_editor_row.dart';

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

  static const _allDays = [
    'SAT',
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialTemplate != null) {
      _nameCtrl.text = widget.initialTemplate!.name;
      _days.addAll(widget.initialTemplate!.days);
      _exercises.addAll(widget.initialTemplate!.items);
    } else {
      _exercises.add(const TemplateExercise(
        name: 'Bench Press',
        target: '3 x 10',
        load: '60 kg',
      ));
    }
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
          Text(
            widget.initialTemplate != null ? 'Edit Routine' : 'New Routine',
            style: typography.title.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextInput(
            label: 'ROUTINE NAME',
            controller: _nameCtrl,
            autoFocus: widget.initialTemplate == null,
            autoCorrect: false,
            textCapitalization: TextCapitalization.characters,
            placeholder: 'UPPER / LOWER / PUSH',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'SCHEDULED DAYS',
            style: typography.label.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _allDays.map((d) {
              final isSel = _days.contains(d);
              return GestureDetector(
                onTap: () => _toggleDay(d),
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
              exercise: ex,
              onChanged: (updated) => setState(() => _exercises[idx] = updated),
              onRemove: () => setState(() => _exercises.removeAt(idx)),
            );
          }),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: '+ Add Exercise',
            variant: ButtonVariant.secondary,
            onPress: () {
              AppHaptics.light();
              setState(() {
                _exercises.add(const TemplateExercise(name: ''));
              });
            },
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
