import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/logic/unit_converter.dart';
import '../../core/platform/app_haptics.dart';
import '../../core/theme/theme_provider.dart';
import 'feet_inches_wheels.dart';

class HeightScrollPicker extends StatefulWidget {
  final double initialHeightCm;
  final bool initialUseFeet;
  final void Function(double heightCm, bool useFeet) onSelect;

  const HeightScrollPicker({
    super.key,
    required this.initialHeightCm,
    this.initialUseFeet = false,
    required this.onSelect,
  });

  @override
  State<HeightScrollPicker> createState() => _HeightScrollPickerState();
}

class _HeightScrollPickerState extends State<HeightScrollPicker> {
  static const int minCm = 100;
  static const int maxCm = 240;
  static const int minFeet = 3;
  static const int maxFeet = 7;

  late bool _useFeet;
  late int _selectedCm;
  late int _selectedFeet;
  late int _selectedInches;

  FixedExtentScrollController? _cmController;
  FixedExtentScrollController? _feetController;
  FixedExtentScrollController? _inchesController;

  @override
  void initState() {
    super.initState();
    _useFeet = widget.initialUseFeet;
    final initial = widget.initialHeightCm > 0 ? widget.initialHeightCm : 175.0;
    _selectedCm = initial.round().clamp(minCm, maxCm);

    final (f, i) = cmToFeetInches(_selectedCm.toDouble());
    _selectedFeet = f.clamp(minFeet, maxFeet);
    _selectedInches = i.clamp(0, 11);

    _initControllers();
  }

  void _initControllers() {
    _cmController?.dispose();
    _feetController?.dispose();
    _inchesController?.dispose();

    _cmController = FixedExtentScrollController(initialItem: _selectedCm - minCm);
    _feetController = FixedExtentScrollController(initialItem: _selectedFeet - minFeet);
    _inchesController = FixedExtentScrollController(initialItem: _selectedInches);
  }

  @override
  void dispose() {
    _cmController?.dispose();
    _feetController?.dispose();
    _inchesController?.dispose();
    super.dispose();
  }

  double get _currentCm => _useFeet
      ? feetInchesToCm(_selectedFeet, _selectedInches)
      : _selectedCm.toDouble();

  void _toggleMode(bool useFeet) {
    if (useFeet == _useFeet) return;
    AppHaptics.light();
    setState(() {
      _useFeet = useFeet;
      if (_useFeet) {
        final (f, i) = cmToFeetInches(_selectedCm.toDouble());
        _selectedFeet = f.clamp(minFeet, maxFeet);
        _selectedInches = i.clamp(0, 11);
      } else {
        _selectedCm = feetInchesToCm(_selectedFeet, _selectedInches).round().clamp(minCm, maxCm);
      }
      _initControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    final displayLabel = _useFeet
        ? '$_selectedFeet ft $_selectedInches in'
        : '$_selectedCm cm';

    final cmCount = maxCm - minCm + 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Height',
                  style: typography.title.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  displayLabel,
                  style: typography.secondary.merge(typography.tabularNums).copyWith(
                    color: colors.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                AppHaptics.medium();
                widget.onSelect(_currentCm, _useFeet);
                Navigator.pop(context);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Done',
                  style: typography.label.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          height: 36,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(color: colors.surfaceMuted, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              _buildTab('Centimeters (cm)', !_useFeet, () => _toggleMode(false), typography, colors),
              _buildTab('Feet & Inches (ft/in)', _useFeet, () => _toggleMode(true), typography, colors),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: _useFeet
              ? FeetInchesWheels(
                  selectedFeet: _selectedFeet,
                  selectedInches: _selectedInches,
                  minFeet: minFeet,
                  maxFeet: maxFeet,
                  feetController: _feetController!,
                  inchesController: _inchesController!,
                  onFeetChanged: (f) => setState(() => _selectedFeet = f),
                  onInchesChanged: (i) => setState(() => _selectedInches = i),
                )
              : CupertinoPicker.builder(
                  scrollController: _cmController,
                  itemExtent: 40,
                  childCount: cmCount,
                  onSelectedItemChanged: (idx) {
                    AppHaptics.light();
                    setState(() => _selectedCm = minCm + idx);
                  },
                  itemBuilder: (context, idx) {
                    final cm = minCm + idx;
                    final isSel = cm == _selectedCm;
                    return Center(
                      child: Text(
                        '$cm cm',
                        style: typography.body.merge(typography.tabularNums).copyWith(
                          color: isSel ? colors.textPrimary : colors.textSecondary,
                          fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                          fontSize: isSel ? 20 : 16,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, bool isSelected, VoidCallback onTap, dynamic typography, dynamic colors) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF141414) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: typography.label.copyWith(
              color: isSelected ? Colors.white : colors.textSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
