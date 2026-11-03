import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/analytics_engine.dart';
import '../../../core/logic/streak_engine.dart';
import '../../../core/models/profile.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_bottom_sheet.dart';
import '../body/log_weight_sheet.dart';
import 'streak_graph_card.dart';
import 'weight_change_card.dart';

class OverviewDashboardView extends StatelessWidget {
  final AppStore store;
  final VoidCallback onStartWorkout;

  const OverviewDashboardView({
    super.key,
    required this.store,
    required this.onStartWorkout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final workouts = store.workouts;
    final profile = store.profile;
    final weeklyGoal = profile?.weeklyGoal ?? 3;
    final unit = profile?.unit ?? WeightUnit.kg;

    final streak = calculateWeeklyStreak(workouts, weeklyGoal);
    final thisWeekCount = countWorkoutsThisWeek(workouts);
    final goalPercent = ((thisWeekCount / weeklyGoal) * 100).clamp(0, 100).toInt();

    final totalVolumeKg = calculateTotalVolumeKg(workouts);
    final volumeDisplay = totalVolumeKg >= 1000
        ? '${(totalVolumeKg / 1000).toStringAsFixed(1)} t'
        : '${totalVolumeKg.toInt()} kg';

    final weekStats = getWeeklyWorkoutCounts(workouts, weeklyGoal, weeksCount: 7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quadrant Feature Cards matching Phone 3 aesthetic
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Card: Goal Ring Card
            Expanded(
              flex: 5,
              child: Container(
                height: 170,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceDark,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 64,
                          height: 64,
                          child: CircularProgressIndicator(
                            value: (thisWeekCount / weeklyGoal).clamp(0.0, 1.0),
                            backgroundColor: const Color(0xFF2C2C2A),
                            color: colors.accent,
                            strokeWidth: 6,
                          ),
                        ),
                        Text(
                          '$goalPercent%',
                          style: typography.body.merge(typography.tabularNums).copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Goal',
                          style: typography.secondary.copyWith(
                            color: const Color(0xFF8E8D88),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$thisWeekCount / $weeklyGoal',
                          style: typography.body.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Right Column: Red Accent Card + Volume Card
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  Container(
                    height: 79,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Streak',
                              style: typography.secondary.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$streak',
                              style: typography.title.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.local_fire_department_rounded,
                            color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 79,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: colors.surfaceDark,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Volume',
                              style: typography.secondary.copyWith(
                                color: const Color(0xFF8E8D88),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              volumeDisplay,
                              style: typography.title
                                  .merge(typography.tabularNums)
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 17,
                                  ),
                            ),
                          ],
                        ),
                        const Icon(Icons.fitness_center_rounded,
                            color: Colors.white, size: 22),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Streak Graph Card
        StreakGraphCard(
          stats: weekStats,
          currentStreak: streak,
          weeklyGoal: weeklyGoal,
        ),
        const SizedBox(height: 20),
        // Weight Change Graph Card
        WeightChangeCard(
          entries: store.bodyEntries,
          unit: unit,
          onLogWeight: () {
            showAppBottomSheet(
              context: context,
              child: LogWeightSheet(
                unit: unit,
                onSave: (entry) => store.saveBodyEntry(entry),
              ),
            );
          },
        ),
      ],
    );
  }
}

