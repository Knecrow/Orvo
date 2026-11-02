import 'package:flutter/material.dart';
import '../../../core/logic/id_generator.dart';
import '../../../core/models/template.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_bottom_sheet.dart';
import '../../components/app_button.dart';
import '../../components/app_text_input.dart';
import '../workout/add_exercise_sheet.dart';

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
  final List<String> _exercises = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialTemplate != null) {
      _nameCtrl.text = widget.initialTemplate!.name;
      _exercises.addAll(widget.initialTemplate!.exercises);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  bool _isValid() {
    return _nameCtrl.text.trim().isNotEmpty && _exercises.isNotEmpty;
  }

  void _save() {
    if (!_isValid()) return;
    final template = Template(
      id: widget.initialTemplate?.id ?? generateId(),
      name: _nameCtrl.text.trim(),
      exercises: _exercises,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.initialTemplate != null ? 'Edit Template' : 'New Template',
          style: typography.title.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextInput(
          label: 'TEMPLATE NAME',
          controller: _nameCtrl,
          autoFocus: true,
          autoCorrect: false,
          textCapitalization: TextCapitalization.words,
          placeholder: 'Upper Body',
          onChanged: (_) => setState(() {}),
        ),
        Text('EXERCISES', style: typography.label.copyWith(color: colors.textSecondary)),
        const SizedBox(height: AppSpacing.xs),
        ..._exercises.asMap().entries.map((entry) {
          final idx = entry.key;
          final ex = entry.value;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colors.border, width: AppLayout.hairlineWidth),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(ex, style: typography.body.copyWith(color: colors.textPrimary)),
                GestureDetector(
                  onTap: () => setState(() => _exercises.removeAt(idx)),
                  behavior: HitTestBehavior.opaque,
                  child: Text('Remove', style: typography.secondary.copyWith(color: colors.danger)),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Add Exercise',
          variant: ButtonVariant.secondary,
          onPress: () {
            showAppBottomSheet(
              context: context,
              child: AddExerciseSheet(
                allExerciseNames: widget.allExerciseNames,
                onAddExercise: (name) => setState(() => _exercises.add(name)),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: 'Save Template',
          disabled: !_isValid(),
          onPress: _save,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

