import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/formatters.dart';
import '../../../core/models/workout.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/empty_state.dart';
import '../../components/screen_header.dart';
import '../../components/swipeable_row.dart';
import '../home/workout_list_item.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  final AppStore store;
  final ValueChanged<Workout> onOpenWorkoutDetail;
  final VoidCallback onStartWorkout;

  const WorkoutHistoryScreen({
    super.key,
    required this.store,
    required this.onOpenWorkoutDetail,
    required this.onStartWorkout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final workouts = store.workouts;

    final Map<String, List<Workout>> grouped = {};
    for (final w in workouts) {
      final d = DateTime.tryParse(w.date) ?? DateTime.now();
      final key = '${d.year}-${d.month.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(w);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(
              title: 'History',
              leftAction: HeaderAction(
                label: 'Back',
                onPress: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: workouts.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppLayout.screenHorizontalPadding),
                      child: EmptyState(
                        message: 'No workouts logged yet.',
                        actionLabel: 'Start Workout',
                        onAction: onStartWorkout,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        AppLayout.screenHorizontalPadding,
                        AppSpacing.sm,
                        AppLayout.screenHorizontalPadding,
                        100,
                      ),
                      itemCount: sortedKeys.length,
                      itemBuilder: (context, groupIndex) {
                        final key = sortedKeys[groupIndex];
                        final list = grouped[key]!;
                        final parts = key.split('-');
                        final year = int.parse(parts[0]);
                        final month = int.parse(parts[1]);
                        final groupHeaderDate = DateTime(year, month);
                        final headerLabel = formatMonthYear(groupHeaderDate);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                              child: Text(
                                headerLabel,
                                style: typography.label.copyWith(color: colors.textSecondary),
                              ),
                            ),
                            ...list.map((w) {
                              return SwipeableRow(
                                itemKey: ValueKey(w.id),
                                onDelete: () => store.deleteWorkout(w.id),
                                child: WorkoutListItem(
                                  workout: w,
                                  onTap: () => onOpenWorkoutDetail(w),
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
