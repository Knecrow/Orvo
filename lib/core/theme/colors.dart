import 'package:flutter/material.dart';
import '../models/profile.dart';

class AppColors {
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color surfaceDark;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color success;
  final Color warning;
  final Color danger;
  final Color accent;
  final Color accentText;
  final Color buttonLabelOnAccent;
  final Color? disabledBorder;
  final Color? disabledText;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.success,
    required this.warning,
    required this.danger,
    required this.accent,
    required this.accentText,
    required this.buttonLabelOnAccent,
    this.disabledBorder,
    this.disabledText,
  });

  static const Map<AccentColor, Color> baseAccents = {
    AccentColor.orange: Color(0xFFE84132), // Vibrant coral red/orange matching reference UI
    AccentColor.blue: Color(0xFF0A84FF),
    AccentColor.green: Color(0xFF34C759),
    AccentColor.purple: Color(0xFFBF5AF2),
  };

  static const Map<AccentColor, Color> lightAccentText = {
    AccentColor.orange: Color(0xFFC92A1D),
    AccentColor.blue: Color(0xFF0055B3),
    AccentColor.green: Color(0xFF1C7830),
    AccentColor.purple: Color(0xFF7320B0),
  };

  factory AppColors.resolve({
    required bool isDark,
    required AccentColor accent,
    required bool highContrast,
  }) {
    final base = baseAccents[accent] ?? const Color(0xFFE84132);

    if (isDark) {
      if (highContrast) {
        return AppColors(
          background: const Color(0xFF0A0A0A),
          surface: const Color(0xFF161616),
          surfaceMuted: const Color(0xFF242424),
          surfaceDark: const Color(0xFF000000),
          textPrimary: const Color(0xFFFFFFFF),
          textSecondary: const Color(0xFFB5B5B5),
          border: const Color(0xFF444444),
          success: const Color(0xFF34C759),
          warning: const Color(0xFFFF9500),
          danger: const Color(0xFFFF3B30),
          accent: base,
          accentText: base,
          buttonLabelOnAccent: const Color(0xFF000000),
          disabledBorder: const Color(0xFF555555),
          disabledText: const Color(0xFF8E8E93),
        );
      }
      return AppColors(
        background: const Color(0xFF0E0E0E),
        surface: const Color(0xFF181818),
        surfaceMuted: const Color(0xFF262626),
        surfaceDark: const Color(0xFF121212),
        textPrimary: const Color(0xFFF5F5F5),
        textSecondary: const Color(0xFF8A8A8A),
        border: const Color(0xFF282828),
        success: const Color(0xFF34C759),
        warning: const Color(0xFFFF9500),
        danger: const Color(0xFFFF3B30),
        accent: base,
        accentText: base,
        buttonLabelOnAccent: const Color(0xFFFFFFFF),
      );
    }

    // Light Theme - Warm stone / oatmeal aesthetic matching reference UI
    final darkerAccent = lightAccentText[accent] ?? const Color(0xFFC92A1D);
    if (highContrast) {
      return AppColors(
        background: const Color(0xFFE4E3DE),
        surface: const Color(0xFFFFFFFF),
        surfaceMuted: const Color(0xFFCAC9C3),
        surfaceDark: const Color(0xFF121212),
        textPrimary: const Color(0xFF000000),
        textSecondary: const Color(0xFF454545),
        border: const Color(0xFF666666),
        success: const Color(0xFF1C7830),
        warning: const Color(0xFFB33B00),
        danger: const Color(0xFFC41C16),
        accent: base,
        accentText: darkerAccent,
        buttonLabelOnAccent: const Color(0xFFFFFFFF),
        disabledBorder: const Color(0xFF999999),
        disabledText: const Color(0xFF555555),
      );
    }

    return AppColors(
      background: const Color(0xFFE6E5E0), // Warm Stone / Oatmeal from screenshot
      surface: const Color(0xFFFFFFFF),
      surfaceMuted: const Color(0xFFC8C7C1), // Neutral grey cards (e.g. Positions, Cash)
      surfaceDark: const Color(0xFF151515), // Deep black cards & floating nav
      textPrimary: const Color(0xFF121212),
      textSecondary: const Color(0xFF7E7D78), // Slate stone
      border: const Color(0xFFD6D5CF),
      success: const Color(0xFF34C759),
      warning: const Color(0xFFFF9500),
      danger: const Color(0xFFFF3B30),
      accent: base,
      accentText: darkerAccent,
      buttonLabelOnAccent: const Color(0xFFFFFFFF),
    );
  }
}
