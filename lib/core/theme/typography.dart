import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  final TextStyle largeTitle;
  final TextStyle title;
  final TextStyle body;
  final TextStyle secondary;
  final TextStyle label;
  final TextStyle tabularNums;

  const AppTypography({
    required this.largeTitle,
    required this.title,
    required this.body,
    required this.secondary,
    required this.label,
    required this.tabularNums,
  });

  factory AppTypography.resolve({required bool highContrast}) {
    return AppTypography(
      largeTitle: GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 41 / 34,
      ),
      title: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        height: 34 / 28,
      ),
      body: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: highContrast ? FontWeight.w500 : FontWeight.w400,
        letterSpacing: -0.2,
        height: 22 / 17,
      ),
      secondary: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.1,
        height: 20 / 15,
      ),
      label: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: highContrast ? FontWeight.w600 : FontWeight.w500,
        letterSpacing: 0.6,
        height: 16 / 12,
      ),
      tabularNums: GoogleFonts.inter(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}
