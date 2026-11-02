import 'package:flutter/material.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/theme_provider.dart';

class HeaderAction {
  final String label;
  final VoidCallback onPress;
  final bool disabled;
  final Color? color;

  const HeaderAction({
    required this.label,
    required this.onPress,
    this.disabled = false,
    this.color,
  });
}

class ScreenHeader extends StatelessWidget {
  final String title;
  final double scrollOffset;
  final HeaderAction? leftAction;
  final HeaderAction? rightAction;
  final Widget? rightWidget;
  final Widget? leftWidget;

  const ScreenHeader({
    super.key,
    required this.title,
    this.scrollOffset = 0.0,
    this.leftAction,
    this.rightAction,
    this.rightWidget,
    this.leftWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final topInset = MediaQuery.of(context).padding.top;

    // Calculate collapse interpolations
    // 0 -> 40: large title fades out and translates up
    final largeProgress = (scrollOffset / 40.0).clamp(0.0, 1.0);
    final largeOpacity = 1.0 - largeProgress;
    final largeTranslateY = -8.0 * largeProgress;

    // 15 -> 45: inline title fades in
    final inlineProgress = ((scrollOffset - 15.0) / 30.0).clamp(0.0, 1.0);
    final inlineOpacity = inlineProgress;

    // 30 -> 50: hairline border fades in
    final borderProgress = ((scrollOffset - 30.0) / 20.0).clamp(0.0, 1.0);
    final borderOpacity = borderProgress;

    return Container(
      color: colors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed Inline Top Bar
          Container(
            padding: EdgeInsets.only(top: topInset),
            height: topInset + 48.0,
            child: Stack(
              children: [
                // Centered inline title
                Center(
                  child: Opacity(
                    opacity: inlineOpacity,
                    child: Text(
                      title,
                      style: typography.body.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                // Left action
                if (leftWidget != null)
                  Positioned(
                    left: AppLayout.screenHorizontalPadding,
                    top: 0,
                    bottom: 0,
                    child: Center(child: leftWidget!),
                  )
                else if (leftAction != null)
                  Positioned(
                    left: AppLayout.screenHorizontalPadding,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: leftAction!.disabled ? null : leftAction!.onPress,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          leftAction!.label,
                          style: typography.body.copyWith(
                            color: colors.accentText,
                          ),
                        ),
                      ),
                    ),
                  ),
                // Right action
                if (rightWidget != null)
                  Positioned(
                    right: AppLayout.screenHorizontalPadding,
                    top: 0,
                    bottom: 0,
                    child: Center(child: rightWidget!),
                  )
                else if (rightAction != null)
                  Positioned(
                    right: AppLayout.screenHorizontalPadding,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: rightAction!.disabled ? null : rightAction!.onPress,
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          rightAction!.label,
                          style: typography.body.copyWith(
                            color: rightAction!.color ?? colors.accentText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                // Hairline bottom border
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Opacity(
                    opacity: borderOpacity,
                    child: Container(
                      height: AppLayout.hairlineWidth,
                      color: colors.border,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Large Collapsing Title
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppLayout.screenHorizontalPadding,
            ),
            child: Transform.translate(
              offset: Offset(0, largeTranslateY),
              child: Opacity(
                opacity: largeOpacity,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSpacing.xs,
                    bottom: AppSpacing.md,
                  ),
                  child: Text(
                    title,
                    style: typography.largeTitle.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
