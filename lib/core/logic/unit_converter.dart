import '../models/profile.dart';

const double lbToKgFactor = 0.45359237;
const double cmPerInch = 2.54;

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

(int feet, int inches) cmToFeetInches(double cm) {
  if (cm <= 0) return (5, 9);
  final totalInches = (cm / cmPerInch).round();
  final feet = totalInches ~/ 12;
  final inches = totalInches % 12;
  return (feet, inches);
}

double feetInchesToCm(int feet, int inches) {
  return ((feet * 12) + inches) * cmPerInch;
}

String formatHeight(double heightCm, {bool useFeet = false}) {
  if (useFeet) {
    final (feet, inches) = cmToFeetInches(heightCm);
    return '$feet ft $inches in';
  }
  return '${heightCm.round()} cm';
}
