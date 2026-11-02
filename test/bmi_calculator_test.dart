import 'package:flutter_test/flutter_test.dart';
import 'package:orvo/core/logic/bmi_calculator.dart';

void main() {
  group('bmi_calculator', () {
    test('returns null for non-positive values', () {
      expect(calculateBmi(0, 180), isNull);
      expect(calculateBmi(70, 0), isNull);
    });

    test('calculates underweight category (< 18.5) with orange status', () {
      final res = calculateBmi(50, 175);
      expect(res, isNotNull);
      expect(res!.value, equals(16.3));
      expect(res.category, equals(BmiCategory.underweight));
      expect(res.statusKey, equals(BmiStatusColorKey.orange));
    });

    test('calculates normal category (18.5 - 24.9) with green status', () {
      final res = calculateBmi(70, 175);
      expect(res!.value, equals(22.9));
      expect(res.category, equals(BmiCategory.normal));
      expect(res.statusKey, equals(BmiStatusColorKey.green));
    });

    test('calculates overweight category (25.0 - 29.9) with orange status', () {
      final res = calculateBmi(85, 175);
      expect(res!.value, equals(27.8));
      expect(res.category, equals(BmiCategory.overweight));
      expect(res.statusKey, equals(BmiStatusColorKey.orange));
    });

    test('calculates obese category (30.0+) with danger status', () {
      final res = calculateBmi(105, 175);
      expect(res!.value, equals(34.3));
      expect(res.category, equals(BmiCategory.obese));
      expect(res.statusKey, equals(BmiStatusColorKey.danger));
    });
  });
}

