library zwap.range_slider;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

/// FEATURE: appearing label on press thumb
/// FEATURE: decorationsw

class ZwapSlider extends StatefulWidget {
  /// Value between [minValue] and [maxValue]
  final double? value;

  /// The smallest value possible
  ///
  /// Default to 0
  final double minValue;

  /// The bigger value possible
  ///
  /// Default to 1
  final double maxValue;

  /// The size of the thumbs, default to 16
  final double thumbSize;

  final Function(double)? onChange;

  const ZwapSlider({
    this.value,
    this.minValue = 0,
    this.maxValue = 1,
    this.thumbSize = 16,
    this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapSlider> createState() => _ZwapSliderState();
}

class _ZwapSliderState extends State<ZwapSlider> {
  Duration _animationDuration = Duration.zero;

  bool _isDragging = false;

  /// Current widget max width
  double? _maxWidth;

  /// This offset refers to the left side of the stack
  double _thumbOffset = 0;

  double get _thumbSize => widget.thumbSize;

  @override
  void didUpdateWidget(covariant ZwapSlider oldWidget) {
    if (!_isDragging && widget.value != null && widget.value != _currentValue) {
      _animationDuration = const Duration(milliseconds: 200);
      _currentValue = widget.value!;

      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _animationDuration = Duration.zero));
    }
    super.didUpdateWidget(oldWidget);
  }

  double get _currentValue {
    if (_maxWidth == null) return widget.minValue;

    final double maxWidth = _maxWidth! - _thumbSize;
    return (widget.maxValue - widget.minValue) * (_thumbOffset / maxWidth);
  }

  set _currentValue(double value) {
    if (_maxWidth == null) {
      _thumbOffset = 0;
      return;
    }

    final double _dValue = widget.maxValue - widget.minValue;

    _thumbOffset = _maxWidth! * ((value - widget.minValue) / _dValue);

    //? Correct values here
    _thumbOffset -= (_thumbOffset / _maxWidth!) * _thumbSize;

    setState(() {});
  }

  void _notifyChange(double maxWidth) {
    if (widget.onChange == null) return;
    widget.onChange!(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        _maxWidth = size.maxWidth;

        return MouseRegion(
          cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.basic,
          child: Container(
            height: _thumbSize,
            width: double.infinity,
            child: Stack(
              children: [
                //? Placeholder line
                Positioned(
                  top: (_thumbSize / 2) - 1,
                  left: _thumbSize / 2,
                  right: _thumbSize / 2,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(color: ZwapColors.neutral200, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                //? Range line
                AnimatedPositioned(
                  duration: _animationDuration,
                  curve: Curves.decelerate,
                  top: (_thumbSize / 2) - 1,
                  left: _thumbSize / 2,
                  right: _maxWidth! - _thumbOffset - 2,
                  child: Container(
                    width: double.infinity,
                    height: 4,
                    decoration: BoxDecoration(color: ZwapColors.primary700, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                //? Start thumb widget
                AnimatedPositioned(
                  duration: _animationDuration,
                  curve: Curves.decelerate,
                  left: _thumbOffset,
                  child: MouseRegion(
                    cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
                    child: GestureDetector(
                      onHorizontalDragStart: (_) {
                        setState(() => _isDragging = true);
                      },
                      onHorizontalDragUpdate: (details) {
                        double _newOffset = _thumbOffset + details.delta.dx;
                        _newOffset = max(0, min(_newOffset, size.maxWidth - _thumbSize));

                        setState(() => _thumbOffset = _newOffset);
                        _notifyChange(size.maxWidth);
                      },
                      onHorizontalDragEnd: (_) {
                        setState(() => _isDragging = false);
                      },
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: ZwapColors.shades0,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(color: Color(0xff091E42).withOpacity(0.31), blurRadius: 1),
                            BoxShadow(offset: Offset(0, 3), color: Color(0xff091E42).withOpacity(0.2), blurRadius: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
