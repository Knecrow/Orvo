import 'package:flutter/material.dart';
import '../../../core/data/app_store.dart';
import '../../../core/logic/autocomplete_engine.dart';
import '../../../core/models/template.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/app_bottom_sheet.dart';
import '../../components/app_button.dart';
import '../../components/empty_state.dart';
import '../../components/screen_header.dart';
import '../../components/swipeable_row.dart';
import 'new_template_sheet.dart';

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
    final allNames = extractExerciseNames(widget.store.workouts, widget.store.templates);
    showAppBottomSheet(
      context: context,
      initialChildSize: 0.8,
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

  void _showActionSheet(Template template) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    showAppBottomSheet(
      context: context,
      initialChildSize: 0.35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(template.name, style: typography.title.copyWith(color: colors.textPrimary)),
          const SizedBox(height: AppSpacing.md),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              _openNewTemplateSheet(template);
            },
            child: Container(
              height: AppLayout.minTouchTarget,
              alignment: Alignment.centerLeft,
              child: Text('Edit Template', style: typography.body.copyWith(color: colors.textPrimary)),
            ),
          ),
          Container(height: AppLayout.hairlineWidth, color: colors.border),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              widget.store.deleteTemplate(template.id);
            },
            child: Container(
              height: AppLayout.minTouchTarget,
              alignment: Alignment.centerLeft,
              child: Text('Delete Template', style: typography.body.copyWith(color: colors.danger)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final templates = widget.store.templates;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                ScreenHeader(title: 'Templates', scrollOffset: _scrollOffset),
                Expanded(
                  child: templates.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppLayout.screenHorizontalPadding),
                          child: EmptyState(
                            message: 'No templates.',
                            actionLabel: 'New Template',
                            onAction: () => _openNewTemplateSheet(),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(
                            AppLayout.screenHorizontalPadding,
                            0,
                            AppLayout.screenHorizontalPadding,
                            140,
                          ),
                          itemCount: templates.length,
                          itemBuilder: (context, index) {
                            final item = templates[index];
                            final exSummary = item.exercises.join(', ');

                            return SwipeableRow(
                              itemKey: ValueKey(item.id),
                              onDelete: () => widget.store.deleteTemplate(item.id),
                              child: InkWell(
                                onTap: () {
                                  AppHaptics.medium();
                                  widget.onStartWorkoutFromTemplate(item);
                                },
                                onLongPress: () => _showActionSheet(item),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF141414),
                                          borderRadius: BorderRadius.circular(13),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.layers_rounded,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: typography.body.copyWith(
                                                color: colors.textPrimary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              exSummary,
                                              style: typography.secondary.copyWith(
                                                color: colors.textSecondary,
                                                fontSize: 12,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '${item.exercises.length} ex',
                                        style: typography.body.merge(typography.tabularNums).copyWith(
                                          color: colors.textPrimary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                label: 'New Template',
                onPress: () => _openNewTemplateSheet(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
