import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/platform/app_haptics.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/theme_provider.dart';

enum ButtonVariant { primary, secondary, destructive }

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPress;
  final ButtonVariant variant;
  final bool disabled;

  const AppButton({
    super.key,
    required this.label,
    required this.onPress,
    this.variant = ButtonVariant.primary,
    this.disabled = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool get _isIos => !kIsWeb && Platform.isIOS;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(_pressController);
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(_pressController);
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    if (!widget.disabled && _isIos) {
      _pressController.forward();
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (!widget.disabled && _isIos) {
      _pressController.reverse();
    }
  }

  void _handleTapCancel() {
    if (!widget.disabled && _isIos) {
      _pressController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final highContrast = theme.highContrast;

    Color backgroundColor = Colors.transparent;
    Color borderColor = Colors.transparent;
    double borderWidth = 0.0;
    Color textColor = colors.textPrimary;

    if (widget.variant == ButtonVariant.primary) {
      backgroundColor = const Color(0xFF141414);
      textColor = Colors.white;
    } else if (widget.variant == ButtonVariant.secondary) {
      borderWidth = 1.0;
      borderColor = colors.border;
      backgroundColor = colors.surfaceMuted;
      textColor = colors.textPrimary;
    } else if (widget.variant == ButtonVariant.destructive) {
      textColor = colors.danger;
    }

    double containerOpacity = 1.0;
    if (widget.disabled) {
      if (highContrast) {
        borderWidth = 1.0;
        borderColor = colors.disabledBorder ?? const Color(0xFF555555);
        textColor = colors.disabledText ?? const Color(0xFF8E8E93);
        backgroundColor = Colors.transparent;
      } else {
        containerOpacity = 0.4;
      }
    }

    final childContent = Container(
      width: double.infinity,
      height: AppLayout.buttonHeight,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: borderWidth > 0 ? Border.all(color: borderColor, width: borderWidth) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        widget.label,
        style: typography.body.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    return Opacity(
      opacity: containerOpacity,
      child: Semantics(
        button: true,
        enabled: !widget.disabled,
        label: widget.label,
        child: _isIos
            ? GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                onTap: widget.disabled
                    ? null
                    : () {
                        AppHaptics.light();
                        widget.onPress?.call();
                      },
                child: AnimatedBuilder(
                  animation: _pressController,
                  builder: (context, child) => Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: childContent,
                    ),
                  ),
                ),
              )
            : Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.button),
                child: InkWell(
                  onTap: widget.disabled
                      ? null
                      : () {
                          AppHaptics.light();
                          widget.onPress?.call();
                        },
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  splashColor: colors.accent.withValues(alpha: 0.12),
                  highlightColor: colors.accent.withValues(alpha: 0.08),
                  child: childContent,
                ),
              ),
      ),
    );
  }
}

