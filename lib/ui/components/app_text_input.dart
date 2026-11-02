import 'package:flutter/material.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/theme_provider.dart';

class AppTextInput extends StatefulWidget {
  final String label;
  final String? value;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final String? error;
  final String? placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autoFocus;
  final bool autoCorrect;
  final TextCapitalization textCapitalization;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const AppTextInput({
    super.key,
    required this.label,
    this.value,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.error,
    this.placeholder,
    this.keyboardType,
    this.textInputAction,
    this.autoFocus = false,
    this.autoCorrect = true,
    this.textCapitalization = TextCapitalization.none,
    this.controller,
    this.focusNode,
  });

  @override
  State<AppTextInput> createState() => _AppTextInputState();
}

class _AppTextInputState extends State<AppTextInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.value);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(AppTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && widget.value != null && widget.value != _controller.text) {
      _controller.text = widget.value!;
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    Color underlineColor = colors.border;
    double underlineHeight = AppLayout.hairlineWidth;

    if (widget.error != null) {
      underlineColor = colors.danger;
      underlineHeight = 2.0;
    } else if (_isFocused) {
      underlineColor = colors.accent;
      underlineHeight = 2.0;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label.toUpperCase(),
            style: typography.label.copyWith(color: colors.textSecondary),
          ),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: widget.autoFocus,
            autocorrect: widget.autoCorrect,
            textCapitalization: widget.textCapitalization,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            cursorColor: colors.accent,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            style: typography.body.copyWith(color: colors.textPrimary),
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.placeholder,
              hintStyle: typography.body.copyWith(color: colors.textSecondary),
              contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              border: InputBorder.none,
            ),
          ),
          Container(
            height: underlineHeight,
            color: underlineColor,
            width: double.infinity,
          ),
          if (widget.error != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                widget.error!,
                style: typography.secondary.copyWith(
                  color: colors.danger,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

