import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/formatters.dart';
import '../../../core/logic/streak_engine.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/profile.dart';
import '../../../core/models/template.dart';
import '../../../core/models/workout.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/empty_state.dart';
import '../../components/swipeable_row.dart';
import 'hero_chart_card.dart';
import 'stats_double_card.dart';
import 'workout_list_item.dart';

class HomeScreen extends StatelessWidget {
  final AppStore store;
  final VoidCallback onStartWorkout;
  final ValueChanged<Template> onStartFromTemplate;
  final ValueChanged<Workout> onOpenWorkoutDetail;
  final VoidCallback onSeeAllWorkouts;
  final VoidCallback onNavigateToTemplates;

  const HomeScreen({
    super.key,
    required this.store,
    required this.onStartWorkout,
    required this.onStartFromTemplate,
    required this.onOpenWorkoutDetail,
    required this.onSeeAllWorkouts,
    required this.onNavigateToTemplates,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final workouts = store.workouts;
    final profile = store.profile;
    final unit = profile?.unit ?? WeightUnit.kg;
    final thisWeekCount = countWorkoutsThisWeek(workouts);
    final streak = calculateWeeklyStreak(workouts, profile?.weeklyGoal ?? 3);

    final latestWeightKg = store.bodyEntries.isNotEmpty
        ? store.bodyEntries.first.weightKg
        : profile?.weightKg ?? 70.0;
    final weightStr = formatWeightValue(latestWeightKg, unit);
    final unitLabel = unit == WeightUnit.kg ? 'kg' : 'lb';

    final recent = workouts.take(4).toList();
    final firstName = profile?.name.isNotEmpty == true ? profile!.name.split(' ').first : 'Athlete';

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppLayout.screenHorizontalPadding,
            AppSpacing.md,
            AppLayout.screenHorizontalPadding,
            110,
          ),
          children: [
            // Top Row: "Welcome, John!" + Notification bell with red dot
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'Welcome, ',
                      style: typography.title.copyWith(
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '$firstName!',
                      style: typography.title.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.notifications_none_rounded,
                        size: 24,
                        color: colors.textPrimary,
                      ),
                    ),
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: colors.accent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Hero Large Stat (matches "$ 13,553.00 Balance" in screenshot)
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$thisWeekCount',
                  style: typography.largeTitle.merge(typography.tabularNums).copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formatWorkouts(thisWeekCount),
                  style: typography.title.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'this week',
                  style: typography.secondary.copyWith(
                    color: colors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Two Muted Grey Cards (Positions & Cash style from screenshot)
            StatsDoubleCard(
              streak: streak,
              weightStr: weightStr,
              unitLabel: unitLabel,
              onStreakTap: onSeeAllWorkouts,
              onWeightTap: () {},
            ),
            const SizedBox(height: 16),
            // Hero Black Chart Card (matches Phone 1 chart card)
            HeroChartCard(
              workouts: workouts,
              onStartWorkout: onStartWorkout,
            ),
            const SizedBox(height: 24),
            // Section Header: "Workouts history" + "Recent ▾"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Workouts history',
                  style: typography.title.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: onSeeAllWorkouts,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Text(
                        'Recent',
                        style: typography.secondary.copyWith(
                          color: colors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: colors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Transactions / Workouts History List
            if (workouts.isEmpty)
              EmptyState(
                message: 'No workouts logged yet.',
                actionLabel: 'Log First Workout',
                onAction: onStartWorkout,
              )
            else
              ...recent.map(
                (w) => SwipeableRow(
                  itemKey: ValueKey(w.id),
                  onDelete: () => store.deleteWorkout(w.id),
                  child: WorkoutListItem(
                    workout: w,
                    onTap: () => onOpenWorkoutDetail(w),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
