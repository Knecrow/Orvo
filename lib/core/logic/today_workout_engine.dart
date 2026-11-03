import '../models/template.dart';
import '../models/workout.dart';
import 'id_generator.dart';

const Map<int, String> kWeekdayToCode = {
  DateTime.monday: 'MON',
  DateTime.tuesday: 'TUE',
  DateTime.wednesday: 'WED',
  DateTime.thursday: 'THU',
  DateTime.friday: 'FRI',
  DateTime.saturday: 'SAT',
  DateTime.sunday: 'SUN',
};

String getTodayWeekdayCode([DateTime? now]) {
  final dt = now ?? DateTime.now();
  return kWeekdayToCode[dt.weekday] ?? 'MON';
}

Template? findScheduledTemplate(List<Template> templates, [DateTime? now]) {
  final code = getTodayWeekdayCode(now);
  for (final t in templates) {
    if (t.days.contains(code)) {
      return t;
    }
  }
  return null;
}

bool isSameCalendarDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

Workout? getWorkoutLoggedToday(List<Workout> workouts, [DateTime? now]) {
  final target = now ?? DateTime.now();
  for (final w in workouts) {
    final parsed = DateTime.tryParse(w.date);
    if (parsed != null && isSameCalendarDay(parsed, target)) {
      return w;
    }
  }
  return null;
}

Workout convertTemplateToWorkout(
  Template template, {
  Set<String>? checkedExerciseNames,
  DateTime? now,
}) {
  final items = template.items;
  final effectiveItems = checkedExerciseNames != null && checkedExerciseNames.isNotEmpty
      ? items.where((i) => checkedExerciseNames.contains(i.name)).toList()
      : items;

  final exercises = <WorkoutExercise>[];
  for (final item in effectiveItems) {
    int setCount = 1;
    int reps = 10;
    final xMatch = RegExp(r'(\d+)\s*x\s*(\d+)').firstMatch(item.target);
    if (xMatch != null) {
      setCount = int.tryParse(xMatch.group(1) ?? '1') ?? 1;
      reps = int.tryParse(xMatch.group(2) ?? '10') ?? 10;
    } else {
      final digits = RegExp(r'\d+').firstMatch(item.target);
      if (digits != null) reps = int.tryParse(digits.group(0) ?? '10') ?? 10;
    }

    double weightKg = 0.0;
    final wDigits = RegExp(r'(\d+(?:\.\d+)?)').firstMatch(item.load);
    if (wDigits != null) {
      weightKg = double.tryParse(wDigits.group(1) ?? '0') ?? 0.0;
    }

    final sets = List.generate(
      setCount.clamp(1, 10),
      (_) => SetEntry(weightKg: weightKg, reps: reps),
    );

    exercises.add(WorkoutExercise(name: item.name, sets: sets));
  }

  final dt = now ?? DateTime.now();
  return Workout(
    id: generateId(),
    date: dt.toIso8601String(),
    exercises: exercises,
    notes: 'Completed from ${template.name}',
  );
}
