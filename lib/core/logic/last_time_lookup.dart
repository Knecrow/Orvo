import '../models/profile.dart';
import '../models/workout.dart';
import 'unit_converter.dart';

class TopSetResult {
  final double weightKg;
  final int reps;
  final String formattedHint;

  const TopSetResult({
    required this.weightKg,
    required this.reps,
    required this.formattedHint,
  });
}

TopSetResult? getLastTimeTopSet(
  String exerciseName,
  List<Workout> workouts,
  WeightUnit unit,
) {
  final target = exerciseName.trim().toLowerCase();
  if (target.isEmpty || workouts.isEmpty) return null;

  // Sort descending by date
  final sorted = [...workouts]..sort((a, b) {
      final da = DateTime.tryParse(a.date) ?? DateTime(1970);
      final db = DateTime.tryParse(b.date) ?? DateTime(1970);
      return db.compareTo(da);
    });

  for (final w in sorted) {
    WorkoutExercise? match;
    for (final ex in w.exercises) {
      if (ex.name.trim().toLowerCase() == target) {
        match = ex;
        break;
      }
    }

    if (match != null && match.sets.isNotEmpty) {
      SetEntry? topSet;
      for (final s in match.sets) {
        if (topSet == null) {
          topSet = s;
          continue;
        }
        if (s.weightKg > topSet.weightKg) {
          topSet = s;
        } else if (s.weightKg == topSet.weightKg && s.reps > topSet.reps) {
          topSet = s;
        }
      }

      if (topSet != null) {
        final weightStr = formatWeight(topSet.weightKg, unit);
        return TopSetResult(
          weightKg: topSet.weightKg,
          reps: topSet.reps,
          formattedHint: 'Last time: $weightStr × ${topSet.reps}',
        );
      }
    }
  }

  return null;
}

