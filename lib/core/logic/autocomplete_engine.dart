import '../models/template.dart';
import '../models/workout.dart';

List<String> extractExerciseNames(
  List<Workout> workouts,
  List<Template> templates,
) {
  final seen = <String>{};
  final names = <String>[];

  for (final t in templates) {
    for (final ex in t.exercises) {
      final trimmed = ex.trim();
      final lower = trimmed.toLowerCase();
      if (trimmed.isNotEmpty && !seen.contains(lower)) {
        seen.add(lower);
        names.push(trimmed);
      }
    }
  }

  for (final w in workouts) {
    for (final ex in w.exercises) {
      final trimmed = ex.name.trim();
      final lower = trimmed.toLowerCase();
      if (trimmed.isNotEmpty && !seen.contains(lower)) {
        seen.add(lower);
        names.push(trimmed);
      }
    }
  }

  return names;
}

List<String> searchExerciseNames(
  String query,
  List<String> allNames, {
  int maxResults = 5,
}) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) {
    return allNames.take(maxResults).toList();
  }

  final prefixMatches = <String>[];
  final containsMatches = <String>[];

  for (final name in allNames) {
    final lower = name.toLowerCase();
    if (lower.startsWith(q)) {
      prefixMatches.add(name);
    } else if (lower.contains(q)) {
      containsMatches.add(name);
    }
  }

  return [...prefixMatches, ...containsMatches].take(maxResults).toList();
}

extension _ListPush on List<String> {
  void push(String val) => add(val);
}

