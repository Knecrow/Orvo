import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/streak_engine.dart';
import '../../../core/logic/unit_converter.dart';
import '../../../core/models/profile.dart';
import '../../../core/models/template.dart';
import '../../../core/models/workout.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_icons.dart';
import '../../components/profile_avatar.dart';
import 'hero_chart_card.dart';
import 'stats_double_card.dart';
import 'today_workout_card.dart';

class HomeScreen extends StatelessWidget {
  final AppStore store;
  final VoidCallback onStartWorkout;
  final ValueChanged<Template> onStartFromTemplate;
  final ValueChanged<Workout>? onOpenWorkoutDetail;
  final VoidCallback onSeeAllWorkouts;
  final VoidCallback onNavigateToTemplates;
  final VoidCallback? onOpenBodyProgress;
  final VoidCallback? onOpenProfile;
  final VoidCallback? onOpenSettings;

  const HomeScreen({
    super.key,
    required this.store,
    required this.onStartWorkout,
    required this.onStartFromTemplate,
    this.onOpenWorkoutDetail,
    required this.onSeeAllWorkouts,
    required this.onNavigateToTemplates,
    this.onOpenBodyProgress,
    this.onOpenProfile,
    this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final workouts = store.workouts;
    final profile = store.profile;
    final unit = profile?.unit ?? WeightUnit.kg;
    final streak = calculateWeeklyStreak(workouts, profile?.weeklyGoal ?? 3);

    final latestWeightKg = store.bodyEntries.isNotEmpty
        ? store.bodyEntries.first.weightKg
        : profile?.weightKg ?? 70.0;
    final weightStr = formatWeightValue(latestWeightKg, unit);
    final unitLabel = unit == WeightUnit.kg ? 'kg' : 'lb';

    final firstName = profile?.name.isNotEmpty == true
        ? profile!.name.split(' ').first
        : 'Athlete';

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
            // Top row: profile avatar + name (tap to open profile) & settings button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onOpenProfile,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileAvatar(
                        name: profile?.name ?? '',
                        size: 40,
                        showAccentRing: true,
                        onTap: onOpenProfile,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        firstName,
                        style: typography.title.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onOpenSettings,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: AppLayout.minTouchTarget,
                    height: AppLayout.minTouchTarget,
                    alignment: Alignment.centerRight,
                    child: Icon(
                      AppIcons.settings,
                      size: 22,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Two muted grey stat cards (Streak & Weight)
            StatsDoubleCard(
              streak: streak,
              weightStr: weightStr,
              unitLabel: unitLabel,
              onStreakTap: onSeeAllWorkouts,
              onWeightTap: onOpenBodyProgress ?? () {},
            ),
            const SizedBox(height: 16),
            // Today's Routine checklist card
            TodayWorkoutCard(
              store: store,
              onStartFromTemplate: onStartFromTemplate,
              onNavigateToTemplates: onNavigateToTemplates,
            ),
            // Hero black chart card
            HeroChartCard(
              workouts: workouts,
              onStartWorkout: onStartWorkout,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
