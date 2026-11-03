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
  final bool showQuickAction;

  const AppTabBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onQuickAction,
    this.showQuickAction = false,
  });

  bool get _isIos => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;

    // Grounded edge-to-edge bottom dock with rounded top corners matching the UI cards
    final barContent = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceDark,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        border: Border.all(
          color: const Color(0xFF262624),
          width: 0.8,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              // 1. Home Tab
              _buildTabItem(
                icon: AppIcons.calendar,
                label: 'Home',
                isSelected: currentIndex == 0,
                onTap: () => onTabSelected(0),
                accentColor: colors.accent,
              ),

              // 2. Routines Tab
              _buildTabItem(
                icon: AppIcons.layers,
                label: 'Routines',
                isSelected: currentIndex == 1,
                onTap: () => onTabSelected(1),
                accentColor: colors.accent,
              ),

              // 3. Quick Action Button (+) - only shown in Routine window
              if (showQuickAction)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      AppHaptics.medium();
                      onQuickAction();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Semantics(
                      button: true,
                      label: 'New Routine',
                      child: Center(
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: colors.accent,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33E84132),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // 4. Profile Tab
              _buildTabItem(
                icon: AppIcons.user,
                label: 'Profile',
                isSelected: currentIndex == 2,
                onTap: () => onTabSelected(2),
                accentColor: colors.accent,
              ),
            ],
          ),
        ),
      ),
    );

    if (_isIos) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: barContent,
        ),
      );
    }

    return barContent;
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color accentColor,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isSelected) {
            AppHaptics.light();
            onTap();
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Semantics(
          selected: isSelected,
          button: true,
          label: label,
          child: SizedBox(
            height: 58,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected ? Colors.white : const Color(0xFF757470),
                ),
                const SizedBox(height: 5),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOutCubic,
                  width: isSelected ? 4 : 0,
                  height: 4,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
