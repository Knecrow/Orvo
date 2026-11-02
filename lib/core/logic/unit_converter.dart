import '../models/profile.dart';

const double lbToKgFactor = 0.45359237;

double inputToKg(double value, WeightUnit unit) {
  if (unit == WeightUnit.lb) {
    return value * lbToKgFactor;
  }
  return value;
}

double kgToUnit(double weightKg, WeightUnit unit) {
  if (unit == WeightUnit.lb) {
    return weightKg / lbToKgFactor;
  }
  return weightKg;
}

String formatWeightValue(double weightKg, WeightUnit unit) {
  final converted = kgToUnit(weightKg, unit);
  final rounded = (converted * 10).round() / 10;
  final str = rounded.toStringAsFixed(1);
  return str.endsWith('.0') ? str.substring(0, str.length - 2) : str;
}

String formatWeight(double weightKg, WeightUnit unit) {
  final unitStr = unit == WeightUnit.kg ? 'kg' : 'lb';
  return '${formatWeightValue(weightKg, unit)} $unitStr';
}

