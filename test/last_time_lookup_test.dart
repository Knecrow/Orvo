import 'package:flutter_test/flutter_test.dart';
import 'package:orvo/core/models/profile.dart';
import 'package:orvo/core/models/workout.dart';
import 'package:orvo/core/logic/last_time_lookup.dart';

void main() {
  group('last_time_lookup', () {
    test('returns null if no workouts contain the exercise', () {
      final workouts = [
        const Workout(
          id: 'w1',
          date: '2026-11-01T10:00:00Z',
          exercises: [
            WorkoutExercise(
              name: 'Deadlift',
              sets: [SetEntry(weightKg: 140, reps: 5)],
            ),
          ],
        ),
      ];
      expect(getLastTimeTopSet('Bench Press', workouts, WeightUnit.kg), isNull);
    });

    test('selects top set with highest weight, breaking ties with higher reps', () {
      final workouts = [
        const Workout(
          id: 'w1',
          date: '2026-11-01T10:00:00Z',
          exercises: [
            WorkoutExercise(
              name: 'Bench Press',
              sets: [
                SetEntry(weightKg: 80, reps: 8),
                SetEntry(weightKg: 100, reps: 5),
                SetEntry(weightKg: 100, reps: 6), // tie, higher reps!
                SetEntry(weightKg: 90, reps: 10),
              ],
            ),
          ],
        ),
      ];

      final res = getLastTimeTopSet('Bench Press', workouts, WeightUnit.kg);
      expect(res, isNotNull);
      expect(res!.weightKg, equals(100));
      expect(res.reps, equals(6));
      expect(res.formattedHint, equals('Last time: 100 kg × 6'));
    });

    test('selects from the most recent workout containing the exercise', () {
      final workouts = [
        const Workout(
          id: 'w_older',
          date: '2026-10-20T10:00:00Z',
          exercises: [
            WorkoutExercise(name: 'Squat', sets: [SetEntry(weightKg: 120, reps: 5)]),
          ],
        ),
        const Workout(
          id: 'w_newer',
          date: '2026-10-27T10:00:00Z',
          exercises: [
            WorkoutExercise(name: 'Squat', sets: [SetEntry(weightKg: 125, reps: 3)]),
          ],
        ),
      ];

      final res = getLastTimeTopSet('squat', workouts, WeightUnit.kg);
      expect(res?.weightKg, equals(125));
      expect(res?.reps, equals(3));
      expect(res?.formattedHint, equals('Last time: 125 kg × 3'));
    });
  });
}

