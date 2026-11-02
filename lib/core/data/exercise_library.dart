import '../models/template.dart';

class LibraryExercise {
  final String name;
  final String category;
  final String defaultTarget;
  final String defaultLoad;

  const LibraryExercise({
    required this.name,
    required this.category,
    this.defaultTarget = '3 x 10',
    this.defaultLoad = 'Body',
  });
}

const List<LibraryExercise> defaultExerciseLibrary = [
  // Chest
  LibraryExercise(name: 'Bench Press', category: 'Chest', defaultTarget: '3 x 10', defaultLoad: '60 kg'),
  LibraryExercise(name: 'Incline Dumbbell Press', category: 'Chest', defaultTarget: '3 x 10', defaultLoad: '20 kg each'),
  LibraryExercise(name: 'Push-up', category: 'Chest', defaultTarget: '3 x 12', defaultLoad: 'Body'),
  LibraryExercise(name: 'Dumbbell Fly', category: 'Chest', defaultTarget: '3 x 12', defaultLoad: '12 kg each'),
  LibraryExercise(name: 'Chest Dip', category: 'Chest', defaultTarget: '3 x 10', defaultLoad: 'Body'),

  // Back
  LibraryExercise(name: 'Lat Pulldown', category: 'Back', defaultTarget: '3 x 12', defaultLoad: '45 kg'),
  LibraryExercise(name: 'Pull-up', category: 'Back', defaultTarget: '3 x 8', defaultLoad: 'Body'),
  LibraryExercise(name: 'Barbell Row', category: 'Back', defaultTarget: '3 x 10', defaultLoad: '50 kg'),
  LibraryExercise(name: 'Seated Cable Row', category: 'Back', defaultTarget: '3 x 12', defaultLoad: '40 kg'),
  LibraryExercise(name: 'Face Pull', category: 'Back', defaultTarget: '3 x 15', defaultLoad: '15 kg'),

  // Legs
  LibraryExercise(name: 'Barbell Squat', category: 'Legs', defaultTarget: '3 x 8', defaultLoad: '70 kg'),
  LibraryExercise(name: 'Leg Press', category: 'Legs', defaultTarget: '3 x 12', defaultLoad: '100 kg'),
  LibraryExercise(name: 'Romanian Deadlift', category: 'Legs', defaultTarget: '3 x 10', defaultLoad: '60 kg'),
  LibraryExercise(name: 'Leg Extension', category: 'Legs', defaultTarget: '3 x 12', defaultLoad: '35 kg'),
  LibraryExercise(name: 'Calf Raise', category: 'Legs', defaultTarget: '3 x 15', defaultLoad: 'Body'),
  LibraryExercise(name: 'Bodyweight Squat', category: 'Legs', defaultTarget: '3 x 15', defaultLoad: 'Body'),

  // Shoulders
  LibraryExercise(name: 'Overhead Press', category: 'Shoulders', defaultTarget: '3 x 8', defaultLoad: '35 kg'),
  LibraryExercise(name: 'Dumbbell Lateral Raise', category: 'Shoulders', defaultTarget: '3 x 15', defaultLoad: '8 kg each'),
  LibraryExercise(name: 'Front Raise', category: 'Shoulders', defaultTarget: '3 x 12', defaultLoad: '8 kg each'),

  // Arms
  LibraryExercise(name: 'Barbell Bicep Curl', category: 'Arms', defaultTarget: '3 x 10', defaultLoad: '25 kg'),
  LibraryExercise(name: 'Triceps Pushdown', category: 'Arms', defaultTarget: '3 x 12', defaultLoad: '20 kg'),
  LibraryExercise(name: 'Hammer Curl', category: 'Arms', defaultTarget: '3 x 12', defaultLoad: '12 kg each'),
  LibraryExercise(name: 'Dips', category: 'Arms', defaultTarget: '3 x 10', defaultLoad: 'Body'),

  // Core & Cardio
  LibraryExercise(name: 'Plank', category: 'Core', defaultTarget: '3 x 45 sec', defaultLoad: 'Body'),
  LibraryExercise(name: 'Crunches', category: 'Core', defaultTarget: '3 x 20', defaultLoad: 'Body'),
  LibraryExercise(name: 'Treadmill Run', category: 'Cardio', defaultTarget: '15 min', defaultLoad: '-'),
  LibraryExercise(name: 'Cycling', category: 'Cardio', defaultTarget: '10 min', defaultLoad: '-'),
];

class RoutinePreset {
  final String name;
  final List<String> days;
  final List<TemplateExercise> exercises;

  const RoutinePreset({
    required this.name,
    required this.days,
    required this.exercises,
  });
}

const List<RoutinePreset> routinePresets = [
  RoutinePreset(
    name: 'PUSH',
    days: ['MON', 'THU'],
    exercises: [
      TemplateExercise(name: 'Bench Press', target: '3 x 10', load: '60 kg'),
      TemplateExercise(name: 'Incline Dumbbell Press', target: '3 x 10', load: '18 kg each'),
      TemplateExercise(name: 'Overhead Press', target: '3 x 8', load: '35 kg'),
      TemplateExercise(name: 'Dumbbell Lateral Raise', target: '3 x 15', load: '8 kg each'),
      TemplateExercise(name: 'Triceps Pushdown', target: '3 x 12', load: '20 kg'),
    ],
  ),
  RoutinePreset(
    name: 'PULL',
    days: ['TUE', 'FRI'],
    exercises: [
      TemplateExercise(name: 'Lat Pulldown', target: '3 x 12', load: '45 kg'),
      TemplateExercise(name: 'Barbell Row', target: '3 x 10', load: '50 kg'),
      TemplateExercise(name: 'Face Pull', target: '3 x 15', load: '15 kg'),
      TemplateExercise(name: 'Barbell Bicep Curl', target: '3 x 10', load: '25 kg'),
      TemplateExercise(name: 'Hammer Curl', target: '3 x 12', load: '10 kg each'),
    ],
  ),
  RoutinePreset(
    name: 'LEGS',
    days: ['WED', 'SAT'],
    exercises: [
      TemplateExercise(name: 'Barbell Squat', target: '3 x 8', load: '70 kg'),
      TemplateExercise(name: 'Leg Press', target: '3 x 12', load: '90 kg'),
      TemplateExercise(name: 'Romanian Deadlift', target: '3 x 10', load: '50 kg'),
      TemplateExercise(name: 'Leg Extension', target: '3 x 12', load: '30 kg'),
      TemplateExercise(name: 'Calf Raise', target: '3 x 15', load: 'Body'),
    ],
  ),
  RoutinePreset(
    name: 'FULL BODY',
    days: ['MON', 'WED', 'FRI'],
    exercises: [
      TemplateExercise(name: 'Barbell Squat', target: '3 x 8', load: '60 kg'),
      TemplateExercise(name: 'Bench Press', target: '3 x 10', load: '50 kg'),
      TemplateExercise(name: 'Lat Pulldown', target: '3 x 12', load: '40 kg'),
      TemplateExercise(name: 'Overhead Press', target: '3 x 8', load: '30 kg'),
      TemplateExercise(name: 'Plank', target: '3 x 45 sec', load: 'Body'),
    ],
  ),
];
