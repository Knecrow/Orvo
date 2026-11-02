import 'package:flutter_test/flutter_test.dart';
import 'package:orvo/core/logic/analytics_engine.dart';
import 'package:orvo/core/models/body_entry.dart';
import 'package:orvo/core/models/workout.dart';

void main() {
  group('analytics_engine', () {
    test('calculateTotalVolumeKg computes weight * reps correctly', () {
      const workouts = [
        Workout(
          id: 'w1',
          date: '2026-11-01',
          exercises: [
            WorkoutExercise(
              name: 'Bench Press',
              sets: [
                SetEntry(weightKg: 60, reps: 10),
                SetEntry(weightKg: 80, reps: 5),
              ],
            ),
          ],
        ),
      ];

      // 60*10 + 80*5 = 600 + 400 = 1000
      final vol = calculateTotalVolumeKg(workouts);
      expect(vol, equals(1000.0));
    });

    test('calculateWeightChange computes net difference and percent', () {
      final entries = [
        const BodyEntry(id: '1', date: '2026-10-01', weightKg: 80.0),
        const BodyEntry(id: '2', date: '2026-10-15', weightKg: 78.0),
        const BodyEntry(id: '3', date: '2026-11-01', weightKg: 76.0),
      ];

      final stat = calculateWeightChange(entries);
      expect(stat, isNotNull);
      expect(stat!.startKg, equals(80.0));
      expect(stat.currentKg, equals(76.0));
      expect(stat.diffKg, equals(-4.0));
      expect(stat.percentChange, closeTo(-5.0, 0.01));
    });

    test('getWeeklyWorkoutCounts generates accurate past weeks stats', () {
      final refDate = DateTime(2026, 11, 2); // Monday
      const workouts = [
        Workout(id: '1', date: '2026-11-02', exercises: []),
        Workout(id: '2', date: '2026-11-03', exercises: []),
        Workout(id: '3', date: '2026-10-27', exercises: []),
      ];

      final stats = getWeeklyWorkoutCounts(
        workouts,
        2,
        weeksCount: 4,
        referenceNow: refDate,
      );

      expect(stats.length, equals(4));
      // Current week ('Now') has 2 workouts, goal is 2 -> goalMet = true
      expect(stats.last.count, equals(2));
      expect(stats.last.goalMet, isTrue);
    });
  });
}
