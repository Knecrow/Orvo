class Template {
  final String id;
  final String name;
  final List<String> exercises;

  const Template({
    required this.id,
    required this.name,
    required this.exercises,
  });

  Template copyWith({
    String? id,
    String? name,
    List<String>? exercises,
  }) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'exercises': exercises,
    };
  }

  factory Template.fromJson(Map<String, dynamic> json) {
    final rawExercises = json['exercises'] as List<dynamic>? ?? [];
    return Template(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      exercises: rawExercises.map((e) => e.toString()).toList(),
    );
  }
}

