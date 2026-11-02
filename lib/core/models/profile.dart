enum WeightUnit { kg, lb }

enum AccentColor { orange, blue, green, purple }

class Profile {
  final String name;
  final double heightCm;
  final double weightKg;
  final WeightUnit unit;
  final int weeklyGoal; // 3, 4, 5, or 6
  final AccentColor accent;
  final bool highContrast;

  const Profile({
    required this.name,
    required this.heightCm,
    required this.weightKg,
    this.unit = WeightUnit.kg,
    this.weeklyGoal = 3,
    this.accent = AccentColor.orange,
    this.highContrast = false,
  });

  Profile copyWith({
    String? name,
    double? heightCm,
    double? weightKg,
    WeightUnit? unit,
    int? weeklyGoal,
    AccentColor? accent,
    bool? highContrast,
  }) {
    return Profile(
      name: name ?? this.name,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      unit: unit ?? this.unit,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      accent: accent ?? this.accent,
      highContrast: highContrast ?? this.highContrast,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'unit': unit.name,
      'weeklyGoal': weeklyGoal,
      'accent': accent.name,
      'highContrast': highContrast,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] as String? ?? '',
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 175.0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 70.0,
      unit: (json['unit'] == 'lb') ? WeightUnit.lb : WeightUnit.kg,
      weeklyGoal: (json['weeklyGoal'] as num?)?.toInt() ?? 3,
      accent: AccentColor.values.firstWhere(
        (a) => a.name == json['accent'],
        orElse: () => AccentColor.orange,
      ),
      highContrast: json['highContrast'] as bool? ?? false,
    );
  }
}

