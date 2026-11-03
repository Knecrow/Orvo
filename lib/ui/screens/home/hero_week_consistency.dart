import 'package:flutter/material.dart';
import '../../../core/logic/streak_engine.dart';
import '../../../core/logic/today_workout_engine.dart';
import '../../../core/models/workout.dart';
import '../../../core/theme/theme_provider.dart';

class HeroWeekConsistency extends StatelessWidget {
  final List<Workout> workouts;

  const HeroWeekConsistency({super.key, required this.workouts});

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final now = DateTime.now();
    final monday = getIsoMonday(now);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (i) {
          final dayDate = monday.add(Duration(days: i));
          final isToday = isSameCalendarDay(dayDate, now);
          final isPast = dayDate.isBefore(now) && !isToday;

          final hasWorkout = workouts.any((w) {
            final parsed = DateTime.tryParse(w.date);
            return parsed != null && isSameCalendarDay(parsed, dayDate);
          });

          Color dotColor;
          BoxBorder? border;

          if (hasWorkout) {
            dotColor = colors.accent;
          } else if (isToday) {
            dotColor = Colors.transparent;
            border = Border.all(color: Colors.white, width: 1.5);
          } else if (isPast) {
            dotColor = const Color(0xFF383834);
          } else {
            dotColor = const Color(0xFF262624);
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _dayLabels[i],
                style: typography.label.copyWith(
                  fontSize: 10,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                  color: isToday ? Colors.white : const Color(0xFF757470),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: border,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
