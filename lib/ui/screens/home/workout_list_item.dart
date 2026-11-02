import 'package:flutter/material.dart';
import '../../../core/logic/formatters.dart';
import '../../../core/models/workout.dart';
import '../../../core/theme/theme_provider.dart';

class WorkoutListItem extends StatelessWidget {
  final Workout workout;
  final VoidCallback onTap;

  const WorkoutListItem({
    super.key,
    required this.workout,
    required this.onTap,
  });

  IconData _getExerciseIcon(int index) {
    const icons = [
      Icons.fitness_center_rounded,
      Icons.flash_on_rounded,
      Icons.local_fire_department_rounded,
      Icons.timer_outlined,
      Icons.shield_outlined,
    ];
    return icons[index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final parsedDate = DateTime.tryParse(workout.date) ?? DateTime.now();
    final dateLabel = formatDate(parsedDate);
    final exerciseSummary = formatExercises(workout.exercises.length);
    final primaryExerciseName = workout.exercises.isNotEmpty
        ? workout.exercises.first.name
        : 'Workout Session';

    // Calculate total sets
    var totalSets = 0;
    for (final e in workout.exercises) {
      totalSets += e.sets.length;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Black Squircle Icon Box (matches Transactions History in screenshot)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: Icon(
                  _getExerciseIcon(workout.id.hashCode),
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Middle: Name & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primaryExerciseName,
                    style: typography.body.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$dateLabel · $exerciseSummary',
                    style: typography.secondary.copyWith(
                      color: colors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Right: Bold tabular stat (matches amount in screenshot)
            Text(
              '+ $totalSets sets',
              style: typography.body.merge(typography.tabularNums).copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

