import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/today_workout_engine.dart';
import '../../../core/models/template.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import 'today_bottom_action.dart';
import 'today_card_header.dart';
import 'today_exercise_row.dart';

class TodayWorkoutCard extends StatefulWidget {
  final AppStore store;
  final ValueChanged<Template> onStartFromTemplate;
  final VoidCallback onNavigateToTemplates;

  const TodayWorkoutCard({
    super.key,
    required this.store,
    required this.onStartFromTemplate,
    required this.onNavigateToTemplates,
  });

  @override
  State<TodayWorkoutCard> createState() => _TodayWorkoutCardState();
}

class _TodayWorkoutCardState extends State<TodayWorkoutCard> {
  String? _selectedTemplateId;
  final Set<String> _checkedExercises = {};
  bool _isLoggedToday = false;

  @override
  void initState() {
    super.initState();
    _initSelectionAndTicks();
  }

  @override
  void didUpdateWidget(covariant TodayWorkoutCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkLoggedTodayStatus();
  }

  Template? _getActiveTemplate() {
    final templates = widget.store.templates;
    if (templates.isEmpty) return null;
    if (_selectedTemplateId != null) {
      final found = templates.where((t) => t.id == _selectedTemplateId).firstOrNull;
      if (found != null) return found;
    }
    final scheduled = findScheduledTemplate(templates);
    return scheduled ?? templates.first;
  }

  String _getTicksPrefKey(String templateId) {
    final now = DateTime.now();
    return 'today_ticks_${now.year}_${now.month}_${now.day}_$templateId';
  }

  Future<void> _initSelectionAndTicks() async {
    final template = _getActiveTemplate();
    if (template == null) return;
    _selectedTemplateId = template.id;

    _checkLoggedTodayStatus();

    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_getTicksPrefKey(template.id));
    if (saved != null && mounted) {
      setState(() {
        _checkedExercises.addAll(saved);
      });
    }
  }

  void _checkLoggedTodayStatus() {
    final todayWorkout = getWorkoutLoggedToday(widget.store.workouts);
    if (todayWorkout != null) {
      _isLoggedToday = true;
      for (final ex in todayWorkout.exercises) {
        _checkedExercises.add(ex.name);
      }
    }
  }

  Future<void> _toggleExercise(String name, String templateId) async {
    setState(() {
      if (_checkedExercises.contains(name)) {
        _checkedExercises.remove(name);
      } else {
        _checkedExercises.add(name);
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_getTicksPrefKey(templateId), _checkedExercises.toList());
  }

  void _finishWorkout(Template template) {
    AppHaptics.success();
    final workout = convertTemplateToWorkout(
      template,
      checkedExerciseNames: _checkedExercises.isNotEmpty ? _checkedExercises : null,
    );
    widget.store.addWorkout(workout);
    setState(() {
      _isLoggedToday = true;
      for (final item in template.items) {
        _checkedExercises.add(item.name);
      }
    });
    widget.store.showSnackbar('Workout logged to history!', () {
      widget.store.deleteWorkout(workout.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final templates = widget.store.templates;

    if (templates.isEmpty) {
      return _buildEmptyCard(colors, typography);
    }

    final activeTemplate = _getActiveTemplate()!;
    final items = activeTemplate.items;
    final totalCount = items.length;
    final doneCount = items.where((i) => _checkedExercises.contains(i.name)).length;
    final weekdayCode = getTodayWeekdayCode();
    final isScheduled = activeTemplate.days.contains(weekdayCode);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.border,
          width: AppLayout.hairlineWidth,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TodayCardHeader(
              activeTemplate: activeTemplate,
              templates: templates,
              weekdayCode: weekdayCode,
              isScheduled: isScheduled,
              isLoggedToday: _isLoggedToday,
              doneCount: doneCount,
              totalCount: totalCount,
              onSelectTemplate: (id) async {
                setState(() {
                  _selectedTemplateId = id;
                  _checkedExercises.clear();
                });
                await _initSelectionAndTicks();
              },
            ),
            const SizedBox(height: 14),
            ...items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return TodayExerciseRow(
                exercise: item,
                isDone: _checkedExercises.contains(item.name),
                onToggle: () => _toggleExercise(item.name, activeTemplate.id),
                isLast: idx == items.length - 1,
              );
            }),
            const SizedBox(height: 14),
            TodayBottomAction(
              isLoggedToday: _isLoggedToday,
              doneCount: doneCount,
              totalCount: totalCount,
              onFinish: () => _finishWorkout(activeTemplate),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(dynamic colors, dynamic typography) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F5F0),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E1DA)),
      ),
      child: Column(
        children: [
          Text(
            'No routines set up yet',
            style: typography.title.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a routine to follow and tick off exercises right here every day.',
            textAlign: TextAlign.center,
            style: typography.secondary.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: widget.onNavigateToTemplates,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Go to Routines'),
          ),
        ],
      ),
    );
  }
}
