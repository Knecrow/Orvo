import 'package:flutter_test/flutter_test.dart';
import 'package:orvo/core/logic/formatters.dart';

void main() {
  group('formatters', () {
    test('formats plurals strictly without parentheses', () {
      expect(formatWorkouts(1), equals('1 workout'));
      expect(formatWorkouts(2), equals('2 workouts'));
      expect(formatSets(1), equals('1 set'));
      expect(formatSets(4), equals('4 sets'));
      expect(formatExercises(1), equals('1 exercise'));
      expect(formatExercises(3), equals('3 exercises'));
    });

    test('formats Today and Yesterday correctly', () {
      final now = DateTime(2026, 11, 5, 12);
      final today = DateTime(2026, 11, 5, 8);
      final yesterday = DateTime(2026, 11, 4, 18);

      expect(formatDate(today, now), equals('Today'));
      expect(formatDate(yesterday, now), equals('Yesterday'));
    });

    test('formats with year when year differs', () {
      final now = DateTime(2026, 11, 5);
      final pastYearDate = DateTime(2025, 3, 12);
      expect(formatDate(pastYearDate, now), contains('2025'));
    });
  });
}

