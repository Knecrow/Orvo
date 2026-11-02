enum BmiCategory {
  underweight('Underweight'),
  normal('Normal'),
  overweight('Overweight'),
  obese('Obese');

  final String label;
  const BmiCategory(this.label);
}

enum BmiStatusColorKey {
  orange,
  green,
  danger,
}

class BmiResult {
  final double value;
  final String formattedValue;
  final BmiCategory category;
  final BmiStatusColorKey statusKey;

  const BmiResult({
    required this.value,
    required this.formattedValue,
    required this.category,
    required this.statusKey,
  });
}

BmiResult? calculateBmi(double weightKg, double heightCm) {
  if (heightCm <= 0 || weightKg <= 0) {
    return null;
  }

  final heightM = heightCm / 100.0;
  final rawBmi = weightKg / (heightM * heightM);
  final rounded = (rawBmi * 10).round() / 10;
  final formatted = rounded.toStringAsFixed(1);

  final BmiCategory category;
  final BmiStatusColorKey statusKey;

  if (rounded < 18.5) {
    category = BmiCategory.underweight;
    statusKey = BmiStatusColorKey.orange;
  } else if (rounded <= 24.9) {
    category = BmiCategory.normal;
    statusKey = BmiStatusColorKey.green;
  } else if (rounded <= 29.9) {
    category = BmiCategory.overweight;
    statusKey = BmiStatusColorKey.orange;
  } else {
    category = BmiCategory.obese;
    statusKey = BmiStatusColorKey.danger;
  }

  return BmiResult(
    value: rounded,
    formattedValue: formatted,
    category: category,
    statusKey: statusKey,
  );
}

