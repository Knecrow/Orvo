import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/formatters.dart';
import '../../../core/logic/id_generator.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/profile.dart';
import '../../../core/models/template.dart';
import '../../../core/models/workout.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_button.dart';
import '../../components/screen_header.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final AppStore store;
  final String workoutId;
  final ValueChanged<Workout> onEditWorkout;

  const WorkoutDetailScreen({
    super.key,
    required this.store,
    required this.workoutId,
    required this.onEditWorkout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final unit = store.profile?.unit ?? WeightUnit.kg;
    final unitLabel = unit == WeightUnit.kg ? 'kg' : 'lb';

    final workout = store.workouts.firstWhere(
      (w) => w.id == workoutId,
      orElse: () => const Workout(id: '', date: '', exercises: []),
    );

    if (workout.id.isEmpty) {
      return Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Column(
            children: [
              ScreenHeader(
                title: 'Workout',
                leftAction: HeaderAction(label: 'Back', onPress: () => Navigator.pop(context)),
              ),
              const Padding(
                padding: EdgeInsets.all(AppLayout.screenHorizontalPadding),
                child: Text('Workout not found.'),
              ),
            ],
          ),
        ),
      );
    }

    final date = DateTime.tryParse(workout.date) ?? DateTime.now();
    final title = formatDate(date);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: title,
              leftAction: HeaderAction(label: 'Back', onPress: () => Navigator.pop(context)),
              rightAction: HeaderAction(
                label: 'Edit',
                onPress: () {
                  Navigator.pop(context);
                  onEditWorkout(workout);
                },
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppLayout.screenHorizontalPadding),
                children: [
                  ...workout.exercises.map((ex) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ex.name,
                            style: typography.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ...ex.sets.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final s = entry.value;
                            final wStr = formatWeightValue(s.weightKg, unit);

                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: colors.border,
                                    width: AppLayout.hairlineWidth,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Set ${idx + 1}',
                                    style: typography.secondary.copyWith(color: colors.textSecondary),
                                  ),
                                  Text(
                                    '$wStr $unitLabel × ${s.reps} reps',
                                    style: typography.body.merge(typography.tabularNums).copyWith(
                                      color: colors.textPrimary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
                  if (workout.notes != null) ...[
                    Text('NOTES', style: typography.label.copyWith(color: colors.textSecondary)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(workout.notes!, style: typography.body.copyWith(color: colors.textPrimary)),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                  AppButton(
                    label: 'Save as Template',
                    variant: ButtonVariant.secondary,
                    onPress: () {
                      final template = Template(
                        id: generateId(),
                        name: '$title Template',
                        exercises: workout.exercises.map((e) => e.name).toList(),
                      );
                      store.addTemplate(template);
                      AppHaptics.success();
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Delete Workout',
                    variant: ButtonVariant.destructive,
                    onPress: () {
                      store.deleteWorkout(workout.id);
                      Navigator.pop(context);
                    },
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

