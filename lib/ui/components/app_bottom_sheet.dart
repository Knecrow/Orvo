import 'package:flutter/material.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/theme_provider.dart';

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  double initialChildSize = 0.65,
  double? maxChildSize,
  double? minChildSize,
}) {
  final theme = AppTheme.of(context);
  final colors = theme.colors;

  final resolvedInitial = initialChildSize.clamp(0.1, 1.0);
  final resolvedMin = (minChildSize ?? (resolvedInitial * 0.75))
      .clamp(0.1, resolvedInitial);
  final resolvedMax = (maxChildSize ?? (resolvedInitial < 0.85 ? 0.95 : 0.98))
      .clamp(resolvedInitial, 1.0);

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (ctx) {
      return AppTheme(
        isDark: theme.isDark,
        accent: theme.accent,
        highContrast: theme.highContrast,
        child: DraggableScrollableSheet(
          initialChildSize: resolvedInitial,
          maxChildSize: resolvedMax,
          minChildSize: resolvedMin,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.sheet),
                ),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppLayout.screenHorizontalPadding,
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
