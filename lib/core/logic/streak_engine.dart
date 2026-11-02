import '../models/workout.dart';

DateTime getIsoMonday(DateTime date) {
  final d = DateTime(date.year, date.month, date.day);
  final diffFromMonday = date.weekday - 1; // Mon = 1 -> 0
  return d.subtract(Duration(days: diffFromMonday));
}

String getIsoWeekKey(DateTime date) {
  final monday = getIsoMonday(date);
  final thursday = monday.add(const Duration(days: 3));
  final year = thursday.year;

  final jan4 = DateTime(year, 1, 4);
  final firstThursday = jan4.add(Duration(days: 4 - jan4.weekday));

  final weekNumber = 1 + ((thursday.difference(firstThursday).inDays) / 7).round();
  final weekStr = weekNumber.toString().padLeft(2, '0');
  return '$year-W$weekStr';
}

int countWorkoutsThisWeek(List<Workout> workouts, [DateTime? referenceNow]) {
  final now = referenceNow ?? DateTime.now();
  final currentWeekKey = getIsoWeekKey(now);
  var count = 0;
  for (final w in workouts) {
    final parsed = DateTime.tryParse(w.date);
    if (parsed != null && getIsoWeekKey(parsed) == currentWeekKey) {
      count++;
    }
  }
  return count;
}

int calculateWeeklyStreak(
  List<Workout> workouts,
  int weeklyGoal, [
  DateTime? referenceNow,
]) {
  if (workouts.isEmpty) return 0;

  final now = referenceNow ?? DateTime.now();

  // Count workouts per ISO week key
  final weekCounts = <String, int>{};
  for (final w in workouts) {
    final parsed = DateTime.tryParse(w.date);
    if (parsed != null) {
      final key = getIsoWeekKey(parsed);
      weekCounts[key] = (weekCounts[key] ?? 0) + 1;
    }
  }

  final currentMonday = getIsoMonday(now);
  final currentWeekKey = getIsoWeekKey(currentMonday);
  final currentCount = weekCounts[currentWeekKey] ?? 0;

  var streak = 0;
  DateTime checkMonday;

  if (currentCount >= weeklyGoal) {
    streak = 1;
    checkMonday = currentMonday.subtract(const Duration(days: 7));
  } else {
    // Current in-progress week does not break streak
    checkMonday = currentMonday.subtract(const Duration(days: 7));
  }

  while (true) {
    final weekKey = getIsoWeekKey(checkMonday);
    final count = weekCounts[weekKey] ?? 0;
    if (count >= weeklyGoal) {
      streak++;
      checkMonday = checkMonday.subtract(const Duration(days: 7));
    } else {
      break;
    }
  }

  return streak;
}

