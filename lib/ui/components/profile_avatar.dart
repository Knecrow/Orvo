import 'package:flutter/material.dart';
import '../../../core/platform/app_haptics.dart';
import '../../../core/theme/theme_provider.dart';

class ProfileAvatar extends StatefulWidget {
  final String name;
  final double size;
  final VoidCallback? onTap;
  final bool showAccentRing;
  final bool showEditBadge;

  const ProfileAvatar({
    super.key,
    required this.name,
    this.size = 40,
    this.onTap,
    this.showAccentRing = false,
    this.showEditBadge = false,
  });

  static String computeInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '';
    final parts = trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      final first = parts.first[0].toUpperCase();
      final last = parts.last[0].toUpperCase();
      return '$first$last';
    }
    return parts.first[0].toUpperCase();
  }

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final initials = ProfileAvatar.computeInitials(widget.name);
    final size = widget.size;

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.surfaceDark,
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.showAccentRing ? colors.accent : colors.border,
          width: widget.showAccentRing ? 2.0 : 1.2,
        ),
      ),
      alignment: Alignment.center,
      child: initials.isNotEmpty
          ? Text(
              initials,
              style: typography.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: size * 0.38,
                letterSpacing: -0.5,
              ),
            )
          : Icon(
              Icons.person_rounded,
              size: size * 0.52,
              color: Colors.white,
            ),
    );

    if (widget.showEditBadge) {
      avatar = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.32,
              height: size * 0.32,
              decoration: BoxDecoration(
                color: colors.accent,
                shape: BoxShape.circle,
                border: Border.all(color: colors.background, width: 2),
              ),
              child: Icon(
                Icons.edit_rounded,
                size: size * 0.18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    if (widget.onTap == null) return avatar;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        AppHaptics.light();
      },
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: avatar,
      ),
    );
  }
}

