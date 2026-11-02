import '../models/body_entry.dart';
import '../models/workout.dart';
import 'streak_engine.dart';

class WeekWorkoutStat {
  final String label;
  final int count;
  final bool goalMet;

  const WeekWorkoutStat({
    required this.label,
    required this.count,
    required this.goalMet,
  });
}

class WeightChangeStat {
  final double startKg;
  final double currentKg;
  final double diffKg;
  final double percentChange;

  const WeightChangeStat({
    required this.startKg,
    required this.currentKg,
    required this.diffKg,
    required this.percentChange,
  });
}

List<WeekWorkoutStat> getWeeklyWorkoutCounts(
  List<Workout> workouts,
  int weeklyGoal, {
  int weeksCount = 8,
  DateTime? referenceNow,
}) {
  final now = referenceNow ?? DateTime.now();
  final currentMonday = getIsoMonday(now);

  final weekCounts = <String, int>{};
  for (final w in workouts) {
    final parsed = DateTime.tryParse(w.date);
    if (parsed != null) {
      final key = getIsoWeekKey(parsed);
      weekCounts[key] = (weekCounts[key] ?? 0) + 1;
    }
  }

  final stats = <WeekWorkoutStat>[];
  for (int i = weeksCount - 1; i >= 0; i--) {
    final monday = currentMonday.subtract(Duration(days: i * 7));
    final key = getIsoWeekKey(monday);
    final count = weekCounts[key] ?? 0;
    final isCurrent = i == 0;
    final label = isCurrent ? 'Now' : 'W-$i';

    stats.add(WeekWorkoutStat(
      label: label,
      count: count,
      goalMet: count >= weeklyGoal,
    ));
  }
  return stats;
}

double calculateTotalVolumeKg(List<Workout> workouts) {
  var total = 0.0;
  for (final w in workouts) {
    for (final ex in w.exercises) {
      for (final s in ex.sets) {
        if (s.weightKg > 0 && s.reps > 0) {
          total += s.weightKg * s.reps;
        }
      }
    }
  }
  return total;
}

WeightChangeStat? calculateWeightChange(List<BodyEntry> entries) {
  if (entries.isEmpty) return null;

  final sorted = [...entries]..sort((a, b) {
      final da = DateTime.tryParse(a.date) ?? DateTime(1970);
      final db = DateTime.tryParse(b.date) ?? DateTime(1970);
      return da.compareTo(db);
    });

  final start = sorted.first.weightKg;
  final current = sorted.last.weightKg;
  final diff = current - start;
  final percent = start > 0 ? (diff / start) * 100 : 0.0;

  return WeightChangeStat(
    startKg: start,
    currentKg: current,
    diffKg: diff,
    percentChange: percent,
  );
}
