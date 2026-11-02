import 'package:flutter_test/flutter_test.dart';
import 'package:orvo/core/models/profile.dart';
import 'package:orvo/core/logic/unit_converter.dart';

void main() {
  group('unit_converter', () {
    test('converts lb to kg using factor 0.45359237', () {
      expect(inputToKg(150, WeightUnit.lb), closeTo(150 * lbToKgFactor, 0.0001));
    });

    test('preserves precision in lb -> kg -> lb round-trip', () {
      const originalLb = 135.0;
      final kg = inputToKg(originalLb, WeightUnit.lb);
      final returnedLb = kgToUnit(kg, WeightUnit.lb);
      expect(returnedLb, closeTo(originalLb, 0.0001));
    });

    test('strips trailing .0 on whole number display values', () {
      expect(formatWeightValue(60, WeightUnit.kg), equals('60'));
      expect(formatWeight(60, WeightUnit.kg), equals('60 kg'));
    });

    test('formats decimals to 1 decimal place without stripping', () {
      expect(formatWeightValue(62.5, WeightUnit.kg), equals('62.5'));
      expect(formatWeight(62.5, WeightUnit.kg), equals('62.5 kg'));
      expect(formatWeightValue(62.54, WeightUnit.kg), equals('62.5'));
      expect(formatWeightValue(62.56, WeightUnit.kg), equals('62.6'));
    });
  });
}

