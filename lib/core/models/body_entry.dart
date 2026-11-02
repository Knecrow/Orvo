class BodyEntry {
  final String id;
  final String date; // ISO string
  final double weightKg;

  const BodyEntry({
    required this.id,
    required this.date,
    required this.weightKg,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'weightKg': weightKg,
    };
  }

  factory BodyEntry.fromJson(Map<String, dynamic> json) {
    return BodyEntry(
      id: json['id'] as String? ?? '',
      date: json['date'] as String? ?? DateTime.now().toIso8601String(),
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 70.0,
    );
  }
}

