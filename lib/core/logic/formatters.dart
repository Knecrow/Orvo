import 'package:intl/intl.dart';

String formatDate(DateTime target, [DateTime? referenceNow]) {
  final now = referenceNow ?? DateTime.now();

  final targetMidnight = DateTime(target.year, target.month, target.day);
  final nowMidnight = DateTime(now.year, now.month, now.day);

  final diffDays = nowMidnight.difference(targetMidnight).inDays;

  if (diffDays == 0) {
    return 'Today';
  }
  if (diffDays == 1) {
    return 'Yesterday';
  }
  if (diffDays >= 2 && diffDays <= 6) {
    return DateFormat.E().format(target);
  }

  if (target.year == now.year) {
    return DateFormat('d MMM').format(target);
  }

  return DateFormat('d MMM y').format(target);
}

String formatMonthYear(DateTime target) {
  return DateFormat('MMMM y').format(target);
}

String formatWorkouts(int count) {
  return '$count ${count == 1 ? 'workout' : 'workouts'}';
}

String formatSets(int count) {
  return '$count ${count == 1 ? 'set' : 'sets'}';
}

String formatExercises(int count) {
  return '$count ${count == 1 ? 'exercise' : 'exercises'}';
}

