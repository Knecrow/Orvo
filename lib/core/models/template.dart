class TemplateExercise {
  final String name;
  final String target;
  final String load;

  const TemplateExercise({
    required this.name,
    this.target = '',
    this.load = '',
  });

  TemplateExercise copyWith({
    String? name,
    String? target,
    String? load,
  }) {
    return TemplateExercise(
      name: name ?? this.name,
      target: target ?? this.target,
      load: load ?? this.load,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'target': target,
      'load': load,
    };
  }

  factory TemplateExercise.fromJson(dynamic json) {
    if (json is String) {
      return TemplateExercise(name: json);
    }
    if (json is Map<String, dynamic>) {
      return TemplateExercise(
        name: json['name'] as String? ?? '',
        target: json['target'] as String? ?? '',
        load: json['load'] as String? ?? '',
      );
    }
    return TemplateExercise(name: json.toString());
  }
}

class Template {
  final String id;
  final String name;
  final List<String> days;
  final List<TemplateExercise> routineExercises;
  final List<String> exercises;

  const Template({
    required this.id,
    required this.name,
    this.days = const [],
    this.routineExercises = const [],
    this.exercises = const [],
  });

  List<TemplateExercise> get items {
    if (routineExercises.isNotEmpty) return routineExercises;
    return exercises.map((e) => TemplateExercise(name: e)).toList();
  }

  List<String> get allExerciseNames {
    if (exercises.isNotEmpty) return exercises;
    return routineExercises.map((e) => e.name).toList();
  }

  Template copyWith({
    String? id,
    String? name,
    List<String>? days,
    List<TemplateExercise>? routineExercises,
    List<String>? exercises,
  }) {
    final newRoutine = routineExercises ?? this.routineExercises;
    final newExercises = exercises ??
        (routineExercises != null
            ? routineExercises.map((e) => e.name).toList()
            : this.exercises);

    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      days: days ?? this.days,
      routineExercises: newRoutine,
      exercises: newExercises,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'days': days,
      'routineExercises': items.map((e) => e.toJson()).toList(),
      'exercises': allExerciseNames,
    };
  }

  factory Template.fromJson(Map<String, dynamic> json) {
    final rawDays = json['days'] as List<dynamic>? ?? [];
    final days = rawDays.map((d) => d.toString()).toList();

    List<TemplateExercise> routineExercises = [];
    if (json['routineExercises'] is List) {
      final list = json['routineExercises'] as List<dynamic>;
      routineExercises =
          list.map((e) => TemplateExercise.fromJson(e)).toList();
    } else if (json['exercises'] is List) {
      final list = json['exercises'] as List<dynamic>;
      routineExercises =
          list.map((e) => TemplateExercise.fromJson(e)).toList();
    }

    final rawExercises = json['exercises'] as List<dynamic>? ?? [];
    final exercises = rawExercises.isNotEmpty
        ? rawExercises.map((e) => e.toString()).toList()
        : routineExercises.map((e) => e.name).toList();

    return Template(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      days: days,
      routineExercises: routineExercises,
      exercises: exercises,
    );
  }
}
