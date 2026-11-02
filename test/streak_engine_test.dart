import 'package:flutter_test/flutter_test.dart';
import 'package:orvo/core/models/workout.dart';
import 'package:orvo/core/logic/streak_engine.dart';

Workout createWorkout(String dateStr) {
  return Workout(
    id: 'w-$dateStr',
    date: dateStr,
    exercises: const [
      WorkoutExercise(
        name: 'Squat',
        sets: [SetEntry(weightKg: 100, reps: 5)],
      ),
    ],
  );
}

void main() {
  group('streak_engine', () {
    test('returns 0 for empty workouts list', () {
      expect(calculateWeeklyStreak([], 3, DateTime(2026, 11, 2)), equals(0));
    });

    test('correctly handles ISO week 53 and year boundary (2020-W53 to 2021-W01)', () {
      final dateWeek53 = DateTime.utc(2020, 12, 31, 12);
      expect(getIsoWeekKey(dateWeek53), equals('2020-W53'));

      final dateWeek1 = DateTime.utc(2021, 1, 4, 12);
      expect(getIsoWeekKey(dateWeek1), equals('2021-W01'));

      final workouts = [
        createWorkout('2020-12-29T10:00:00Z'),
        createWorkout('2020-12-30T10:00:00Z'),
        createWorkout('2020-12-31T10:00:00Z'),
        createWorkout('2021-01-05T10:00:00Z'),
        createWorkout('2021-01-06T10:00:00Z'),
        createWorkout('2021-01-07T10:00:00Z'),
      ];

      final now = DateTime.utc(2021, 1, 8, 12);
      expect(calculateWeeklyStreak(workouts, 3, now), equals(2));
    });

    test('includes in-progress week in streak if it already meets the goal', () {
      final now = DateTime.utc(2026, 11, 4, 12); // Wednesday (2026-W45)
      final workouts = [
        createWorkout('2026-11-02T10:00:00Z'),
        createWorkout('2026-11-03T10:00:00Z'),
        createWorkout('2026-11-04T10:00:00Z'),
        createWorkout('2026-10-27T10:00:00Z'),
        createWorkout('2026-10-28T10:00:00Z'),
        createWorkout('2026-10-29T10:00:00Z'),
      ];

      expect(countWorkoutsThisWeek(workouts, now), equals(3));
      expect(calculateWeeklyStreak(workouts, 3, now), equals(2));
    });

    test('skips in-progress week without breaking streak if not yet met', () {
      final now = DateTime.utc(2026, 11, 3, 12); // Tuesday, only 1 workout
      final workouts = [
        createWorkout('2026-11-02T10:00:00Z'),
        createWorkout('2026-10-27T10:00:00Z'),
        createWorkout('2026-10-28T10:00:00Z'),
        createWorkout('2026-10-29T10:00:00Z'),
        createWorkout('2026-10-20T10:00:00Z'),
        createWorkout('2026-10-21T10:00:00Z'),
        createWorkout('2026-10-22T10:00:00Z'),
      ];

      expect(countWorkoutsThisWeek(workouts, now), equals(1));
      expect(calculateWeeklyStreak(workouts, 3, now), equals(2));
    });

    test('resets streak at a completed past week that fell below goal', () {
      final now = DateTime.utc(2026, 11, 3, 12);
      final workouts = [
        createWorkout('2026-10-27T10:00:00Z'),
        createWorkout('2026-10-28T10:00:00Z'), // only 2 in past week
        createWorkout('2026-10-20T10:00:00Z'),
        createWorkout('2026-10-21T10:00:00Z'),
        createWorkout('2026-10-22T10:00:00Z'),
      ];

      expect(calculateWeeklyStreak(workouts, 3, now), equals(0));
    });
  });
}

