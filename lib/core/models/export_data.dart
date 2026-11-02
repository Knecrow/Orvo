import 'profile.dart';
import 'template.dart';
import 'workout.dart';
import 'body_entry.dart';

class ExportData {
  final int schemaVersion;
  final String exportedAt;
  final Profile? profile;
  final List<Template> templates;
  final List<Workout> workouts;
  final List<BodyEntry> bodyEntries;

  const ExportData({
    required this.schemaVersion,
    required this.exportedAt,
    required this.profile,
    required this.templates,
    required this.workouts,
    required this.bodyEntries,
  });

  Map<String, dynamic> toJson() {
    return {
      'schemaVersion': schemaVersion,
      'exportedAt': exportedAt,
      'profile': profile?.toJson(),
      'templates': templates.map((t) => t.toJson()).toList(),
      'workouts': workouts.map((w) => w.toJson()).toList(),
      'bodyEntries': bodyEntries.map((b) => b.toJson()).toList(),
    };
  }
}

