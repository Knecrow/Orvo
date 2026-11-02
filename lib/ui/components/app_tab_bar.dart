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
    (icon: AppIcons.layers, label: 'Templates'),
    (icon: AppIcons.trendingUp, label: 'Progress'),
    (icon: AppIcons.activity, label: 'Body'),
    (icon: AppIcons.user, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final typography = theme.typography;
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
                color: const Color(0xFF141414),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: isSelected ? 12 : 8,
                          vertical: 8,
                        ),
                        decoration: isSelected
                            ? BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                              )
                            : null,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tab.icon,
                              size: 18,
                              color: isSelected ? Colors.black : const Color(0xFF888884),
                            ),
                            if (isSelected) ...[
                              const SizedBox(width: 5),
                              Text(
                                tab.label,
                                style: typography.label.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ],
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
                decoration: const BoxDecoration(
                  color: Color(0xFF141414),
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
