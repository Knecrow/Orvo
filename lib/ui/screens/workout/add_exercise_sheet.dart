import 'package:flutter/material.dart';
import '../../../core/logic/autocomplete_engine.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_button.dart';
import '../../components/app_text_input.dart';

class AddExerciseSheet extends StatefulWidget {
  final List<String> allExerciseNames;
  final ValueChanged<String> onAddExercise;

  const AddExerciseSheet({
    super.key,
    required this.allExerciseNames,
    required this.onAddExercise,
  });

  @override
  State<AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends State<AddExerciseSheet> {
  final _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _selectExercise(String name) {
    AppHaptics.light();
    Navigator.pop(context);
    widget.onAddExercise(name.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final query = _queryController.text;
    final suggestions = searchExerciseNames(query, widget.allExerciseNames, maxResults: 5);
    final hasExactMatch = suggestions.any((s) => s.toLowerCase() == query.trim().toLowerCase());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Exercise',
          style: typography.title.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextInput(
          label: 'EXERCISE NAME',
          controller: _queryController,
          autoFocus: true,
          autoCorrect: false,
          textCapitalization: TextCapitalization.words,
          placeholder: 'Bench Press',
          textInputAction: TextInputAction.done,
          onChanged: (_) => setState(() {}),
          onSubmitted: (val) {
            if (val.trim().isNotEmpty) {
              _selectExercise(val.trim());
            }
          },
        ),
        if (suggestions.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: suggestions.length,
            separatorBuilder: (context, index) => Container(
              height: AppLayout.hairlineWidth,
              color: colors.border,
            ),
            itemBuilder: (context, index) {
              final item = suggestions[index];
              return InkWell(
                onTap: () => _selectExercise(item),
                child: Container(
                  height: AppLayout.minTouchTarget,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item,
                    style: typography.body.copyWith(color: colors.textPrimary),
                  ),
                ),
              );
            },
          ),
        if (query.trim().isNotEmpty && !hasExactMatch) ...[
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: 'Add "${query.trim()}"',
            variant: ButtonVariant.secondary,
            onPress: () => _selectExercise(query.trim()),
          ),
        ],
      ],
    );
  }
}
