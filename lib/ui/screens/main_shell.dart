import 'package:flutter/material.dart';
import '../../core/data/app_store.dart';
import '../../core/logic/autocomplete_engine.dart';
import '../../core/models/profile.dart';
import '../../core/models/template.dart';
import '../../core/models/workout.dart';
import '../../core/theme/theme_provider.dart';
import '../components/app_bottom_sheet.dart';
import '../components/app_snackbar.dart';
import '../components/app_tab_bar.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/templates/new_template_sheet.dart';
import '../screens/templates/templates_screen.dart';
import '../screens/workout/log_workout_screen.dart';
import '../screens/workout/workout_detail_screen.dart';
import '../screens/workout/workout_history_screen.dart';

class MainShell extends StatefulWidget {
  final AppStore store;
  final ValueChanged<AccentColor> onAccentChange;
  final ValueChanged<bool> onHighContrastChange;

  const MainShell({
    super.key,
    required this.store,
    required this.onAccentChange,
    required this.onHighContrastChange,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentTab = 0;

  void _openLogWorkout({
    Workout? workoutToEdit,
    List<String>? templateExerciseNames,
    Template? template,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, anim, _) {
          final theme = AppTheme.of(context);
          return AppTheme(
            isDark: theme.isDark,
            accent: theme.accent,
            highContrast: theme.highContrast,
            child: LogWorkoutScreen(
              store: widget.store,
              workoutToEdit: workoutToEdit,
              templateExerciseNames: templateExerciseNames,
              template: template,
            ),
          );
        },
        transitionsBuilder: (context, anim, _, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(position: anim.drive(tween), child: child);
        },
      ),
    );
  }

  void _openNewTemplate([Template? template]) {
    final allNames = extractExerciseNames(
      widget.store.workouts,
      widget.store.templates,
    );
    showAppBottomSheet(
      context: context,
      initialChildSize: 0.88,
      child: NewTemplateSheet(
        allExerciseNames: allNames,
        initialTemplate: template,
        onSave: (t) {
          if (template != null) {
            widget.store.updateTemplate(t);
          } else {
            widget.store.addTemplate(t);
          }
        },
      ),
    );
  }

  void _openWorkoutDetail(Workout workout) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final theme = AppTheme.of(context);
          return AppTheme(
            isDark: theme.isDark,
            accent: theme.accent,
            highContrast: theme.highContrast,
            child: WorkoutDetailScreen(
              store: widget.store,
              workoutId: workout.id,
              onEditWorkout: (w) => _openLogWorkout(workoutToEdit: w),
            ),
          );
        },
      ),
    );
  }

  void _openWorkoutHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final theme = AppTheme.of(context);
          return AppTheme(
            isDark: theme.isDark,
            accent: theme.accent,
            highContrast: theme.highContrast,
            child: WorkoutHistoryScreen(
              store: widget.store,
              onOpenWorkoutDetail: _openWorkoutDetail,
              onStartWorkout: () => _openLogWorkout(),
            ),
          );
        },
      ),
    );
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          final theme = AppTheme.of(context);
          return AppTheme(
            isDark: theme.isDark,
            accent: theme.accent,
            highContrast: theme.highContrast,
            child: SettingsScreen(
              store: widget.store,
              onAccentChange: widget.onAccentChange,
              onHighContrastChange: widget.onHighContrastChange,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final store = widget.store;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentTab,
            children: [
              HomeScreen(
                store: store,
                onStartWorkout: () => _openLogWorkout(),
                onStartFromTemplate: (t) => _openLogWorkout(template: t),
                onOpenWorkoutDetail: _openWorkoutDetail,
                onSeeAllWorkouts: _openWorkoutHistory,
                onNavigateToTemplates: () => setState(() => _currentTab = 1),
                onOpenBodyProgress: () => setState(() => _currentTab = 2),
                onOpenProfile: () => setState(() => _currentTab = 3),
              ),
              TemplatesScreen(
                store: store,
                onStartWorkoutFromTemplate: (t) => _openLogWorkout(template: t),
              ),
              ProgressScreen(
                store: store,
                onStartWorkout: () => _openLogWorkout(),
              ),
              ProfileScreen(
                store: store,
                onOpenSettings: _openSettings,
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppTabBar(
              currentIndex: _currentTab,
              onTabSelected: (index) => setState(() => _currentTab = index),
              onQuickAction: () {
                if (_currentTab == 1) {
                  _openNewTemplate();
                } else {
                  _openLogWorkout();
                }
              },
            ),
          ),
          if (store.snackbar != null)
            AppSnackbarOverlay(
              message: store.snackbar!.message,
              onUndo: store.snackbar!.onUndo,
              onDismiss: store.dismissSnackbar,
              hasBottomBar: true,
            ),
        ],
      ),
    );
  }
}
