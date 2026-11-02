import 'package:flutter_test/flutter_test.dart';
import 'package:orvo/core/models/template.dart';
import 'package:orvo/core/models/workout.dart';
import 'package:orvo/core/logic/autocomplete_engine.dart';

void main() {
  group('autocomplete_engine', () {
    const templates = [
      Template(id: 't1', name: 'Leg Day', exercises: ['Squat', 'Leg Press']),
      Template(id: 't2', name: 'Push', exercises: ['Bench Press', 'Incline Press']),
    ];

    const workouts = [
      Workout(
        id: 'w1',
        date: '2026-11-01',
        exercises: [
          WorkoutExercise(name: 'bench press', sets: []),
          WorkoutExercise(name: 'Overhead Press', sets: []),
        ],
      ),
    ];

    test('extracts deduplicated names case-insensitively', () {
      final names = extractExerciseNames(workouts, templates);
      expect(names, contains('Bench Press'));
      final benchCount = names.where((n) => n.toLowerCase() == 'bench press').length;
      expect(benchCount, equals(1));
    });

    test('prioritizes prefix matches over contains matches', () {
      final names = ['Incline Press', 'Press', 'Overhead Press', 'Preacher Curl'];
      final results = searchExerciseNames('pre', names);
      expect(results[0], equals('Press'));
      expect(results[1], equals('Preacher Curl'));
      expect(results, contains('Incline Press'));
    });

    test('caps results at 5', () {
      final names = ['A1', 'A2', 'A3', 'A4', 'A5', 'A6', 'A7'];
      final results = searchExerciseNames('a', names, maxResults: 5);
      expect(results.length, equals(5));
    });
  });
}

