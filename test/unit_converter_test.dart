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

    test('converts cm to feet and inches accurately', () {
      // 175 cm ~ 5 ft 9 in
      final (f1, i1) = cmToFeetInches(175);
      expect(f1, 5);
      expect(i1, 9);

      // 183 cm ~ 6 ft 0 in
      final (f2, i2) = cmToFeetInches(183);
      expect(f2, 6);
      expect(i2, 0);

      // 152 cm ~ 5 ft 0 in
      final (f3, i3) = cmToFeetInches(152.4);
      expect(f3, 5);
      expect(i3, 0);
    });

    test('converts feet and inches to cm accurately', () {
      expect(feetInchesToCm(5, 10), closeTo(177.8, 0.01));
      expect(feetInchesToCm(6, 0), closeTo(182.88, 0.01));
    });

    test('formatHeight formats cm and feet properly', () {
      expect(formatHeight(175, useFeet: false), '175 cm');
      expect(formatHeight(175, useFeet: true), '5 ft 9 in');
      expect(formatHeight(183, useFeet: true), '6 ft 0 in');
    });
  });
}
