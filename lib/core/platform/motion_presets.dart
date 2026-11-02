import 'package:flutter/material.dart';

class MotionPresets {
  static const Duration quick = Duration(milliseconds: 150);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration standard = Duration(milliseconds: 250);
  static const Duration chartDrawIn = Duration(milliseconds: 600);

  static const Curve standardCurve = Curves.easeInOutCubic;
  static const Curve easeOutCurve = Curves.easeOutCubic;

  static bool isReducedMotion(BuildContext context) {
    return MediaQuery.maybeDisableAnimationsOf(context) ?? false;
  }
}

