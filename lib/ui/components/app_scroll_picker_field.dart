import 'package:flutter/material.dart';
import '../../core/platform/app_haptics.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/theme_provider.dart';

class AppScrollPickerField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final String? placeholder;
  final String? error;

  const AppScrollPickerField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.placeholder,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final hasValue = value.isNotEmpty && value != '0' && value != '0.0';
    final displayText = hasValue ? value : (placeholder ?? 'Tap to select');

    final underlineColor = error != null ? colors.danger : colors.border;
    final underlineHeight = error != null ? 2.0 : AppLayout.hairlineWidth;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: GestureDetector(
        onTap: () {
          AppHaptics.light();
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: typography.label.copyWith(color: colors.textSecondary),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    displayText,
                    style: typography.body
                        .merge(typography.tabularNums)
                        .copyWith(
                          color: hasValue ? colors.textPrimary : colors.textSecondary,
                          fontSize: 16,
                          fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                        ),
                  ),
                  Icon(
                    Icons.unfold_more_rounded,
                    size: 20,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
            Container(
              height: underlineHeight,
              color: underlineColor,
              width: double.infinity,
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  error!,
                  style: typography.secondary.copyWith(
                    color: colors.danger,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
