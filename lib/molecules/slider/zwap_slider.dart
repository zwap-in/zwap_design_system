library zwap.range_slider;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

class ZwapSliderDecoration {
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;

  final Color? fillColor;
  final Color? disabledFillColor;

  final BorderRadius? borderRadius;

  final Color? thumbColor;
  final Color? disabledThumbColor;

  final double backgroundHeight;
  final double fillHeight;

  ZwapSliderDecoration({
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.fillColor,
    this.disabledFillColor,
    this.borderRadius,
    this.thumbColor,
    this.disabledThumbColor,
    this.backgroundHeight = 4,
    this.fillHeight = 4,
  });

  const ZwapSliderDecoration.primary()
      : backgroundColor = null,
        disabledBackgroundColor = null,
        fillColor = null,
        disabledFillColor = null,
        borderRadius = null,
        thumbColor = null,
        disabledThumbColor = null,
        backgroundHeight = 4,
        fillHeight = 4;

  ZwapSliderDecoration copyWith({
    Color? backgroundColor,
    Color? fillColor,
    BorderRadius? borderRadius,
    Color? thumbColor,
  }) {
    return ZwapSliderDecoration(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fillColor: fillColor ?? this.fillColor,
      borderRadius: borderRadius ?? this.borderRadius,
      thumbColor: thumbColor ?? this.thumbColor,
    );
  }
}

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

  /// If true the thumb will be locked
  ///
  /// Default to false
  final bool disabled;

  final ZwapSliderDecoration decoration;
  final Widget? thumbChild;

  const ZwapSlider({
    this.value,
    this.minValue = 0,
    this.maxValue = 1,
    this.thumbSize = 16,
    this.onChange,
    this.disabled = false,
    this.decoration = const ZwapSliderDecoration.primary(),
    this.thumbChild,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapSlider> createState() => _ZwapSliderState();
}

class _ZwapSliderState extends State<ZwapSlider> {
  late bool _disabled;

  Duration _animationDuration = Duration.zero;

  bool _isDragging = false;

  /// Current widget max width
  double? _maxWidth;

  /// This offset refers to the left side of the stack
  double _thumbOffset = 0;

  double get _thumbSize => widget.thumbSize;

  bool _positionHasBeenInitialized = false;

  @override
  void initState() {
    super.initState();
    _disabled = widget.disabled;
  }

  _initializePosition() {
    if (_positionHasBeenInitialized) return;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setState(() => _thumbOffset = ((widget.value ?? 0) / (widget.maxValue - widget.minValue)) * (_maxWidth! - _thumbSize)),
    );
    _positionHasBeenInitialized = true;
  }

  @override
  void didUpdateWidget(covariant ZwapSlider oldWidget) {
    if (widget.disabled != _disabled) setState(() => _disabled = widget.disabled);
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
        _initializePosition();

        return MouseRegion(
          cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.basic,
          child: Container(
            height: _thumbSize,
            width: double.infinity,
            child: Stack(
              children: [
                //? Placeholder line
                Positioned(
                  top: (_thumbSize / 2) - (widget.decoration.backgroundHeight / 2),
                  left: _thumbSize / 2,
                  right: _thumbSize / 2,
                  child: Container(
                    height: widget.decoration.backgroundHeight,
                    decoration: BoxDecoration(
                      color: (_disabled ? widget.decoration.disabledBackgroundColor : widget.decoration.backgroundColor) ?? ZwapColors.neutral200,
                      borderRadius: widget.decoration.borderRadius ?? BorderRadius.circular(2),
                    ),
                  ),
                ),
                //? Range line
                AnimatedPositioned(
                  duration: _animationDuration,
                  curve: Curves.decelerate,
                  top: (_thumbSize / 2) - (widget.decoration.fillHeight / 2),
                  left: _thumbSize / 2,
                  right: _maxWidth! - _thumbOffset - (_thumbSize / 2),
                  child: Container(
                    width: double.infinity,
                    height: widget.decoration.backgroundHeight,
                    decoration: BoxDecoration(
                      color: _disabled
                          ? widget.decoration.disabledFillColor ?? ZwapColors.neutral500
                          : widget.decoration.fillColor ?? ZwapColors.primary700,
                      borderRadius: widget.decoration.borderRadius ?? BorderRadius.circular(2),
                    ),
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
                      onHorizontalDragStart: _disabled
                          ? null
                          : (_) {
                              setState(() => _isDragging = true);
                            },
                      onHorizontalDragUpdate: _disabled
                          ? null
                          : (details) {
                              double _newOffset = _thumbOffset + details.delta.dx;
                              _newOffset = max(0, min(_newOffset, size.maxWidth - _thumbSize));

                              setState(() => _thumbOffset = _newOffset);
                              _notifyChange(size.maxWidth);
                            },
                      onHorizontalDragEnd: _disabled
                          ? null
                          : (_) {
                              setState(() => _isDragging = false);
                            },
                      child: Container(
                        height: widget.thumbSize,
                        width: widget.thumbSize,
                        decoration: BoxDecoration(
                          color: _disabled
                              ? widget.decoration.disabledThumbColor ?? ZwapColors.neutral50
                              : widget.decoration.thumbColor ?? ZwapColors.shades0,
                          borderRadius: BorderRadius.circular(1000),
                          boxShadow: [
                            BoxShadow(color: Color(0xff091E42).withOpacity(0.31), blurRadius: 1),
                            BoxShadow(offset: Offset(0, 3), color: Color(0xff091E42).withOpacity(0.2), blurRadius: 5),
                          ],
                        ),
                        child: widget.thumbChild,
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
