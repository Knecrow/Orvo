import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/platform/app_haptics.dart';
import '../../core/theme/theme_provider.dart';
import 'app_icons.dart';

class AppTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onQuickAction;

  const AppTabBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onQuickAction,
  });

  bool get _isIos => !kIsWeb && Platform.isIOS;

  static const _tabs = [
    (icon: AppIcons.calendar, label: 'Home'),
    (icon: AppIcons.layers, label: 'Routines'),
    (icon: AppIcons.trendingUp, label: 'Progress'),
    (icon: AppIcons.user, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    // Two-element floating nav bar matching reference design:
    // Left: Pill capsule containing navigation tabs
    // Right: Independent circular button with white '+'
    final floatingBar = Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        0,
        20,
        bottomInset > 0 ? bottomInset + 4 : 20,
      ),
      child: Row(
        children: [
          // Left Pill Capsule
          Expanded(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: colors.surfaceDark,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_tabs.length, (index) {
                  final tab = _tabs[index];
                  final isSelected = currentIndex == index;

                  return GestureDetector(
                    onTap: () {
                      if (currentIndex != index) {
                        AppHaptics.light();
                        onTabSelected(index);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Semantics(
                      selected: isSelected,
                      button: true,
                      label: tab.label,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: isSelected
                            ? const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: Icon(
                          tab.icon,
                          size: 20,
                          color: isSelected ? Colors.black : const Color(0xFF888884),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Right Circular Action Button (+)
          GestureDetector(
            onTap: () {
              AppHaptics.medium();
              onQuickAction();
            },
            behavior: HitTestBehavior.opaque,
            child: Semantics(
              button: true,
              label: 'Start Workout',
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: colors.surfaceDark,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 18,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (_isIos) {
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: floatingBar,
        ),
      );
    }

    return floatingBar;
  }
}
