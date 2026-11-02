import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/profile.dart';
import '../models/template.dart';
import '../models/workout.dart';
import '../models/body_entry.dart';
import '../platform/app_haptics.dart';
import 'default_templates.dart';
import 'local_storage.dart';

class SnackbarInfo {
  final String message;
  final VoidCallback onUndo;
  SnackbarInfo({required this.message, required this.onUndo});
}

class AppStore extends ChangeNotifier {
  bool _isHydrated = false;
  bool _hydrationSlow = false;
  Profile? _profile;
  List<Template> _templates = [];
  List<Workout> _workouts = [];
  List<BodyEntry> _bodyEntries = [];
  SnackbarInfo? _snackbar;

  bool get isHydrated => _isHydrated;
  bool get hydrationSlow => _hydrationSlow;
  Profile? get profile => _profile;
  List<Template> get templates => _templates;
  List<Workout> get workouts => _workouts;
  List<BodyEntry> get bodyEntries => _bodyEntries;
  SnackbarInfo? get snackbar => _snackbar;

  AppStore() {
    _hydrate();
  }

  Future<void> _hydrate() async {
    Timer? slowTimer = Timer(const Duration(milliseconds: 100), () {
      _hydrationSlow = true;
      notifyListeners();
    });

    final data = await LocalStorage.loadAll();
    slowTimer.cancel();

    _profile = data['profile'] as Profile?;
    final loadedTemplates = (data['templates'] as List<Template>?) ?? [];
    _templates = loadedTemplates.isNotEmpty ? loadedTemplates : List.of(defaultTemplates);
    _workouts = (data['workouts'] as List<Workout>?) ?? [];
    _bodyEntries = (data['bodyEntries'] as List<BodyEntry>?) ?? [];
    _isHydrated = true;
    _hydrationSlow = false;
    notifyListeners();
  }

  void dismissSnackbar() {
    _snackbar = null;
    notifyListeners();
  }

  void showSnackbar(String message, VoidCallback onUndo) {
    _snackbar = SnackbarInfo(message: message, onUndo: onUndo);
    notifyListeners();
  }

  void updateProfile(Profile newProfile) {
    _profile = newProfile;
    notifyListeners();
    LocalStorage.saveProfile(newProfile);
  }

  void addWorkout(Workout workout) {
    _workouts = [workout, ..._workouts];
    notifyListeners();
    LocalStorage.saveWorkouts(_workouts);
  }

  void updateWorkout(Workout workout) {
    _workouts = _workouts.map((w) => w.id == workout.id ? workout : w).toList();
    notifyListeners();
    LocalStorage.saveWorkouts(_workouts);
  }

  void deleteWorkout(String id) {
    final index = _workouts.indexWhere((w) => w.id == id);
    if (index == -1) return;
    final removed = _workouts[index];
    _workouts = _workouts.where((w) => w.id != id).toList();
    notifyListeners();
    LocalStorage.saveWorkouts(_workouts);

    AppHaptics.warning();
    showSnackbar('Workout deleted', () {
      final restored = [..._workouts]..insert(index, removed);
      _workouts = restored;
      notifyListeners();
      LocalStorage.saveWorkouts(_workouts);
      dismissSnackbar();
    });
  }

  void addTemplate(Template template) {
    _templates = [..._templates, template];
    notifyListeners();
    LocalStorage.saveTemplates(_templates);
  }

  void updateTemplate(Template template) {
    _templates = _templates.map((t) => t.id == template.id ? template : t).toList();
    notifyListeners();
    LocalStorage.saveTemplates(_templates);
  }

  void deleteTemplate(String id) {
    final index = _templates.indexWhere((t) => t.id == id);
    if (index == -1) return;
    final removed = _templates[index];
    _templates = _templates.where((t) => t.id != id).toList();
    notifyListeners();
    LocalStorage.saveTemplates(_templates);

    AppHaptics.warning();
    showSnackbar('Template deleted', () {
      final restored = [..._templates]..insert(index, removed);
      _templates = restored;
      notifyListeners();
      LocalStorage.saveTemplates(_templates);
      dismissSnackbar();
    });
  }

  void saveBodyEntry(BodyEntry entry) {
    // Max one entry per calendar date
    final targetDate = entry.date.split('T')[0];
    final filtered = _bodyEntries.where((e) => e.date.split('T')[0] != targetDate).toList();
    final next = [entry, ...filtered]..sort((a, b) {
        final da = DateTime.tryParse(a.date) ?? DateTime(1970);
        final db = DateTime.tryParse(b.date) ?? DateTime(1970);
        return db.compareTo(da);
      });

    _bodyEntries = next;
    notifyListeners();
    LocalStorage.saveBodyEntries(_bodyEntries);
  }

  void deleteBodyEntry(String id) {
    final index = _bodyEntries.indexWhere((e) => e.id == id);
    if (index == -1) return;
    final removed = _bodyEntries[index];
    _bodyEntries = _bodyEntries.where((e) => e.id != id).toList();
    notifyListeners();
    LocalStorage.saveBodyEntries(_bodyEntries);

    AppHaptics.warning();
    showSnackbar('Body entry deleted', () {
      final restored = [..._bodyEntries]..insert(index, removed);
      _bodyEntries = restored;
      notifyListeners();
      LocalStorage.saveBodyEntries(_bodyEntries);
      dismissSnackbar();
    });
  }
}

