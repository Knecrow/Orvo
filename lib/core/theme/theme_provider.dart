import 'package:flutter/material.dart';
import '../models/profile.dart';
import 'colors.dart';
import 'typography.dart';

class AppTheme extends InheritedWidget {
  final bool isDark;
  final AccentColor accent;
  final bool highContrast;
  final AppColors colors;
  final AppTypography typography;

  AppTheme({
    super.key,
    required this.isDark,
    required this.accent,
    required this.highContrast,
    required super.child,
  })  : colors = AppColors.resolve(
          isDark: isDark,
          accent: accent,
          highContrast: highContrast,
        ),
        typography = AppTypography.resolve(
          highContrast: highContrast,
        );

  static AppTheme of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    if (theme == null) {
      // Fallback
      return AppTheme(
        isDark: true,
        accent: AccentColor.orange,
        highContrast: false,
        child: const SizedBox.shrink(),
      );
    }
    return theme;
  }

  @override
  bool updateShouldNotify(AppTheme oldWidget) {
    return isDark != oldWidget.isDark ||
        accent != oldWidget.accent ||
        highContrast != oldWidget.highContrast;
  }
}

