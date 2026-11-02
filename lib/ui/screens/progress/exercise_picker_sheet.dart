import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_bottom_sheet.dart';
import '../../components/app_icons.dart';

void showExercisePickerSheet({
  required BuildContext context,
  required List<String> names,
  required String? selectedExercise,
  required ValueChanged<String> onSelect,
}) {
  final theme = AppTheme.of(context);
  final colors = theme.colors;
  final typography = theme.typography;

  showAppBottomSheet(
    context: context,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Exercise',
          style: typography.title.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.md),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: names.length,
          separatorBuilder: (context, index) => Container(
            height: AppLayout.hairlineWidth,
            color: colors.border,
          ),
          itemBuilder: (context, index) {
            final name = names[index];
            final isSel = name == selectedExercise;
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                onSelect(name);
              },
              child: Container(
                height: AppLayout.minTouchTarget,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: typography.body.copyWith(color: colors.textPrimary),
                    ),
                    if (isSel) Icon(AppIcons.check, size: 20, color: colors.accent),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ),
  );
}

