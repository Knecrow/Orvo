import 'package:flutter/material.dart';
import '../../../core/theme/spacing.dart';
import '../../components/app_button.dart';

class ProfileSaveBar extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onSave;

  const ProfileSaveBar({
    super.key,
    required this.isVisible,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppLayout.screenHorizontalPadding,
      right: AppLayout.screenHorizontalPadding,
      bottom: 96,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        offset: isVisible ? Offset.zero : const Offset(0, 1.5),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 180),
          opacity: isVisible ? 1.0 : 0.0,
          child: IgnorePointer(
            ignoring: !isVisible,
            child: AppButton(
              label: 'Save Changes',
              onPress: onSave,
            ),
          ),
        ),
      ),
    );
  }
}
