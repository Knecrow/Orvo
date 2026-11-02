import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';
import '../models/template.dart';
import '../models/workout.dart';
import '../models/body_entry.dart';
import '../models/export_data.dart';

class LocalStorage {
  static const int schemaVersion = 1;

  static const String keyProfile = 'profile';
  static const String keyTemplates = 'templates';
  static const String keyWorkouts = 'workouts';
  static const String keyBodyEntries = 'bodyEntries';
  static const String keySchemaVersion = 'schemaVersion';

  static Future<Map<String, dynamic>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    Profile? profile;
    final profileStr = prefs.getString(keyProfile);
    if (profileStr != null) {
      try {
        profile = Profile.fromJson(jsonDecode(profileStr) as Map<String, dynamic>);
      } catch (_) {}
    }

    final templates = <Template>[];
    final templatesStr = prefs.getString(keyTemplates);
    if (templatesStr != null) {
      try {
        final list = jsonDecode(templatesStr) as List<dynamic>;
        for (final item in list) {
          templates.add(Template.fromJson(item as Map<String, dynamic>));
        }
      } catch (_) {}
    }

    final workouts = <Workout>[];
    final workoutsStr = prefs.getString(keyWorkouts);
    if (workoutsStr != null) {
      try {
        final list = jsonDecode(workoutsStr) as List<dynamic>;
        for (final item in list) {
          workouts.add(Workout.fromJson(item as Map<String, dynamic>));
        }
      } catch (_) {}
    }

    final bodyEntries = <BodyEntry>[];
    final bodyStr = prefs.getString(keyBodyEntries);
    if (bodyStr != null) {
      try {
        final list = jsonDecode(bodyStr) as List<dynamic>;
        for (final item in list) {
          bodyEntries.add(BodyEntry.fromJson(item as Map<String, dynamic>));
        }
      } catch (_) {}
    }

    return {
      'profile': profile,
      'templates': templates,
      'workouts': workouts,
      'bodyEntries': bodyEntries,
    };
  }

  static Future<void> saveProfile(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyProfile, jsonEncode(profile.toJson()));
  }

  static Future<void> saveTemplates(List<Template> templates) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      keyTemplates,
      jsonEncode(templates.map((t) => t.toJson()).toList()),
    );
  }

  static Future<void> saveWorkouts(List<Workout> workouts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      keyWorkouts,
      jsonEncode(workouts.map((w) => w.toJson()).toList()),
    );
  }

  static Future<void> saveBodyEntries(List<BodyEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      keyBodyEntries,
      jsonEncode(entries.map((b) => b.toJson()).toList()),
    );
  }

  static String buildExportJson(
    Profile? profile,
    List<Template> templates,
    List<Workout> workouts,
    List<BodyEntry> bodyEntries,
  ) {
    final data = ExportData(
      schemaVersion: schemaVersion,
      exportedAt: DateTime.now().toIso8601String(),
      profile: profile,
      templates: templates,
      workouts: workouts,
      bodyEntries: bodyEntries,
    );
    return const JsonEncoder.withIndent('  ').convert(data.toJson());
  }
}

