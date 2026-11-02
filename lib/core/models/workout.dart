class SetEntry {
  final double weightKg;
  final int reps;

  const SetEntry({
    required this.weightKg,
    required this.reps,
  });

  Map<String, dynamic> toJson() {
    return {
      'weightKg': weightKg,
      'reps': reps,
    };
  }

  factory SetEntry.fromJson(Map<String, dynamic> json) {
    return SetEntry(
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0.0,
      reps: (json['reps'] as num?)?.toInt() ?? 0,
    );
  }
}

class WorkoutExercise {
  final String name;
  final List<SetEntry> sets;

  const WorkoutExercise({
    required this.name,
    required this.sets,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets.map((s) => s.toJson()).toList(),
    };
  }

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    final rawSets = json['sets'] as List<dynamic>? ?? [];
    return WorkoutExercise(
      name: json['name'] as String? ?? '',
      sets: rawSets
          .map((s) => SetEntry.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Workout {
  final String id;
  final String date; // ISO string
  final List<WorkoutExercise> exercises;
  final String? notes;

  const Workout({
    required this.id,
    required this.date,
    required this.exercises,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      if (notes != null) 'notes': notes,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    final rawExercises = json['exercises'] as List<dynamic>? ?? [];
    return Workout(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? DateTime.now().toIso8601String(),
      exercises: rawExercises
          .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );
  }
}

