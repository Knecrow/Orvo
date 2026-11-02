import 'package:flutter/material.dart';
import '../../../core/data/exercise_library.dart';
import '../../../core/models/template.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_text_input.dart';

class ExercisePickerModal extends StatefulWidget {
  final ValueChanged<TemplateExercise> onSelectExercise;

  const ExercisePickerModal({
    super.key,
    required this.onSelectExercise,
  });

  @override
  State<ExercisePickerModal> createState() => _ExercisePickerModalState();
}

class _ExercisePickerModalState extends State<ExercisePickerModal> {
  final _searchCtrl = TextEditingController();
  String _selectedCategory = 'All';
  final Set<String> _addedNames = {};

  static const _categories = [
    'All',
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Arms',
    'Core',
    'Cardio',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered = defaultExerciseLibrary.where((e) {
      final matchesCat =
          _selectedCategory == 'All' || e.category == _selectedCategory;
      final matchesQuery = query.isEmpty || e.name.toLowerCase().contains(query);
      return matchesCat && matchesQuery;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Exercises',
              style: typography.title.copyWith(color: colors.textPrimary),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'Done',
                style: typography.body.copyWith(
                  color: colors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppTextInput(
          label: '',
          controller: _searchCtrl,
          placeholder: 'Search exercises...',
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.xs),
        // Category Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((cat) {
              final isSel = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    AppHaptics.light();
                    setState(() => _selectedCategory = cat);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSel ? const Color(0xFF141414) : colors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cat,
                      style: typography.label.copyWith(
                        color: isSel ? Colors.white : colors.textPrimary,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          separatorBuilder: (context, index) => Container(
            height: AppLayout.hairlineWidth,
            color: colors.border,
          ),
          itemBuilder: (context, index) {
            final ex = filtered[index];
            final isAdded = _addedNames.contains(ex.name);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ex.name,
                          style: typography.body.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${ex.category} · ${ex.defaultTarget} · ${ex.defaultLoad}',
                          style: typography.secondary.copyWith(
                            color: colors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      AppHaptics.light();
                      setState(() => _addedNames.add(ex.name));
                      widget.onSelectExercise(TemplateExercise(
                        name: ex.name,
                        target: ex.defaultTarget,
                        load: ex.defaultLoad,
                      ));
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isAdded
                            ? colors.surfaceMuted
                            : const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isAdded ? 'Added ✓' : '+ Add',
                        style: typography.label.copyWith(
                          color: isAdded
                              ? colors.textSecondary
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
