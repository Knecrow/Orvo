import 'package:flutter_test/flutter_test.dart';
import 'package:orvo/core/logic/today_workout_engine.dart';
import 'package:orvo/core/models/template.dart';
import 'package:orvo/core/models/workout.dart';

void main() {
  group('today_workout_engine', () {
    test('getTodayWeekdayCode maps day of week accurately', () {
      // 2026-11-01 was a Sunday
      final sun = DateTime(2026, 11, 1);
      expect(getTodayWeekdayCode(sun), 'SUN');

      // 2026-11-02 was a Monday
      final mon = DateTime(2026, 11, 2);
      expect(getTodayWeekdayCode(mon), 'MON');

      // 2026-11-03 was a Tuesday
      final tue = DateTime(2026, 11, 3);
      expect(getTodayWeekdayCode(tue), 'TUE');

      // 2026-11-04 was a Wednesday
      final wed = DateTime(2026, 11, 4);
      expect(getTodayWeekdayCode(wed), 'WED');

      // 2026-11-05 was a Thursday
      final thu = DateTime(2026, 11, 5);
      expect(getTodayWeekdayCode(thu), 'THU');

      // 2026-11-06 was a Friday
      final fri = DateTime(2026, 11, 6);
      expect(getTodayWeekdayCode(fri), 'FRI');

      // 2026-11-07 was a Saturday
      final sat = DateTime(2026, 11, 7);
      expect(getTodayWeekdayCode(sat), 'SAT');
    });

    test('findScheduledTemplate selects matching routine by day', () {
      const templates = [
        Template(
          id: 'upper',
          name: 'UPPER',
          days: ['SUN', 'WED'],
          exercises: ['Bench Press'],
        ),
        Template(
          id: 'lower',
          name: 'LOWER',
          days: ['MON', 'THU'],
          exercises: ['Squat'],
        ),
      ];

      final sunday = DateTime(2026, 11, 1);
      final monday = DateTime(2026, 11, 2);
      final tuesday = DateTime(2026, 11, 3);

      expect(findScheduledTemplate(templates, sunday)?.id, 'upper');
      expect(findScheduledTemplate(templates, monday)?.id, 'lower');
      expect(findScheduledTemplate(templates, tuesday), isNull);
    });

    test('isSameCalendarDay accurately checks dates across hours', () {
      final a = DateTime(2026, 11, 3, 8, 30);
      final b = DateTime(2026, 11, 3, 21, 45);
      final c = DateTime(2026, 11, 4, 1, 0);

      expect(isSameCalendarDay(a, b), isTrue);
      expect(isSameCalendarDay(a, c), isFalse);
    });

    test('getWorkoutLoggedToday finds workout logged on the target date', () {
      final workouts = [
        const Workout(
          id: 'w1',
          date: '2026-11-02T10:00:00.000Z',
          exercises: [],
        ),
        const Workout(
          id: 'w2',
          date: '2026-11-03T14:30:00.000Z',
          exercises: [],
        ),
      ];

      final target = DateTime(2026, 11, 3, 19, 0);
      final found = getWorkoutLoggedToday(workouts, target);
      expect(found, isNotNull);
      expect(found!.id, 'w2');

      final notFound = getWorkoutLoggedToday(workouts, DateTime(2026, 11, 4));
      expect(notFound, isNull);
    });

    test('convertTemplateToWorkout parses targets and loads into sets', () {
      const template = Template(
        id: 'upper',
        name: 'UPPER',
        routineExercises: [
          TemplateExercise(
            name: 'Lat pulldown',
            target: '2 x 12',
            load: '25-30 kg',
          ),
          TemplateExercise(
            name: 'Treadmill walk',
            target: '5 min',
            load: '-',
          ),
        ],
      );

      final now = DateTime(2026, 11, 3, 12, 0);
      final workout = convertTemplateToWorkout(template, now: now);

      expect(workout.exercises.length, 2);
      expect(workout.exercises[0].name, 'Lat pulldown');
      expect(workout.exercises[0].sets.length, 2);
      expect(workout.exercises[0].sets[0].reps, 12);
      expect(workout.exercises[0].sets[0].weightKg, 25.0);

      expect(workout.exercises[1].name, 'Treadmill walk');
      expect(workout.exercises[1].sets.length, 1);
      expect(workout.exercises[1].sets[0].reps, 5);
      expect(workout.exercises[1].sets[0].weightKg, 0.0);
    });

    test('convertTemplateToWorkout filters to checkedExerciseNames if supplied', () {
      const template = Template(
        id: 'upper',
        name: 'UPPER',
        routineExercises: [
          TemplateExercise(name: 'Lat pulldown', target: '2 x 12', load: '30 kg'),
          TemplateExercise(name: 'Push-up', target: '2 x 10', load: 'Body'),
          TemplateExercise(name: 'Arm curl', target: '2 x 12', load: '6 kg'),
        ],
      );

      final checked = {'Push-up', 'Arm curl'};
      final workout = convertTemplateToWorkout(template, checkedExerciseNames: checked);

      expect(workout.exercises.length, 2);
      expect(workout.exercises.map((e) => e.name).toList(), ['Push-up', 'Arm curl']);
    });
  });
}

