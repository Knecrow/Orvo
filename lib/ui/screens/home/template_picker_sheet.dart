import 'package:flutter/material.dart';
import '../../../core/models/template.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../components/empty_state.dart';

class TemplatePickerSheet extends StatelessWidget {
  final List<Template> templates;
  final ValueChanged<Template> onSelectTemplate;
  final VoidCallback onNavigateToTemplates;

  const TemplatePickerSheet({
    super.key,
    required this.templates,
    required this.onSelectTemplate,
    required this.onNavigateToTemplates,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Template',
          style: typography.title.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.md),
        if (templates.isEmpty)
          EmptyState(
            message: 'No templates.',
            actionLabel: 'New Template',
            onAction: () {
              Navigator.pop(context);
              onNavigateToTemplates();
            },
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: templates.length,
            separatorBuilder: (context, index) => Container(
              height: AppLayout.hairlineWidth,
              color: colors.border,
            ),
            itemBuilder: (context, index) {
              final template = templates[index];
              return InkWell(
                onTap: () {
                  AppHaptics.medium();
                  Navigator.pop(context);
                  onSelectTemplate(template);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        template.name,
                        style: typography.body.copyWith(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        template.exercises.join(', '),
                        style: typography.secondary.copyWith(
                          color: colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
