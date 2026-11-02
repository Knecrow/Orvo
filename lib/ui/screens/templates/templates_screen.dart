import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/autocomplete_engine.dart';
import '../../../core/models/template.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_bottom_sheet.dart';
import '../../components/app_button.dart';
import '../../components/empty_state.dart';
import '../../components/screen_header.dart';
import 'new_template_sheet.dart';
import 'routine_card.dart';
import 'week_split_bar.dart';

class TemplatesScreen extends StatefulWidget {
  final AppStore store;
  final ValueChanged<Template> onStartWorkoutFromTemplate;

  const TemplatesScreen({
    super.key,
    required this.store,
    required this.onStartWorkoutFromTemplate,
  });

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  final _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  String? _selectedDay;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openNewTemplateSheet([Template? template]) {
    final allNames = extractExerciseNames(
      widget.store.workouts,
      widget.store.templates,
    );
    showAppBottomSheet(
      context: context,
      initialChildSize: 0.85,
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

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final allTemplates = widget.store.templates;

    final templates = _selectedDay == null
        ? allTemplates
        : allTemplates.where((t) => t.days.contains(_selectedDay)).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                ScreenHeader(title: 'Routines', scrollOffset: _scrollOffset),
                // 7-day circular split bar matching reference
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppLayout.screenHorizontalPadding,
                  ),
                  child: WeekSplitBar(
                    templates: allTemplates,
                    selectedDay: _selectedDay,
                    onSelectDay: (day) => setState(() => _selectedDay = day),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: templates.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppLayout.screenHorizontalPadding,
                          ),
                          child: EmptyState(
                            message: _selectedDay != null
                                ? 'No routine on $_selectedDay.'
                                : 'No routines yet.',
                            actionLabel: 'New Routine',
                            onAction: () => _openNewTemplateSheet(),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(
                            AppLayout.screenHorizontalPadding,
                            4,
                            AppLayout.screenHorizontalPadding,
                            140,
                          ),
                          itemCount: templates.length,
                          itemBuilder: (context, index) {
                            final item = templates[index];
                            return RoutineCard(
                              template: item,
                              onStart: () =>
                                  widget.onStartWorkoutFromTemplate(item),
                              onEdit: () => _openNewTemplateSheet(item),
                              onDelete: () =>
                                  widget.store.deleteTemplate(item.id),
                            );
                          },
                        ),
                ),
              ],
            ),
            Positioned(
              left: AppLayout.screenHorizontalPadding,
              right: AppLayout.screenHorizontalPadding,
              bottom: MediaQuery.of(context).padding.bottom + 85,
              child: AppButton(
                label: 'New Routine',
                onPress: () => _openNewTemplateSheet(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
