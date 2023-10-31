library zwap.range_slider;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

part 'zwap_range_values.dart';

/// FEATURE: appearing labels on press thumb
/// FEATURE: decorations

enum _ZwapRangeDraggingThumb { start, end }

class ZwapRangeSlider extends StatefulWidget {
  /// The current value of this range slider, if not
  /// provided the inital value will be created using
  /// [minValue] and [maxValue]
  final ZwapRangeValues? value;

  /// The smallest value possible
  final double minValue;

  /// The bigger value possible
  final double maxValue;

  /// The size of the thumbs, default to 16
  final double thumbSize;

  final double lineWidth;

  final double lineBorderRadius;

  final Function(ZwapRangeValues)? onChange;

  const ZwapRangeSlider({
    this.value,
    this.minValue = 0,
    this.maxValue = 5,
    this.thumbSize = 16,
    this.onChange,
    this.lineWidth = 4,
    this.lineBorderRadius = 2,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapRangeSlider> createState() => _ZwapRangeSliderState();
}

class _ZwapRangeSliderState extends State<ZwapRangeSlider> {
  Duration _animationDuration = Duration.zero;

  /// Current widget max width
  double? _maxWidth;

  /// This values is used to show only one of the two thumbs
  /// when their are in the same position.
  ///
  /// Every time user try to move one, without find the
  /// required one this bool is toggled and user should find
  /// the required thumb
  bool _showStartIfEquals = false;

  /// This offset refers to the left side of the stack
  double _startThumbOffset = 0;

  /// This offset refers to the rigth side of the stack
  double _endThumbOffset = 0;

  /// Used to know what thumb has being dragged right now
  _ZwapRangeDraggingThumb? _draggedThumb;

  double get _thumbSize => widget.thumbSize;
  bool get _isDragging => _draggedThumb != null;

  @override
  void didUpdateWidget(covariant ZwapRangeSlider oldWidget) {
    if (!_isDragging && widget.value != null && widget.value != _currentValue) {
      _animationDuration = const Duration(milliseconds: 200);
      _currentValue = widget.value!;

      WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _animationDuration = Duration.zero));
    }
    super.didUpdateWidget(oldWidget);
  }

  ZwapRangeValues get _currentValue {
    if (_maxWidth == null) return ZwapRangeValues(widget.minValue, widget.maxValue);

    final double maxWidth = _maxWidth! - _thumbSize;

    final double _min = (widget.maxValue - widget.minValue) * (_startThumbOffset / maxWidth);
    final double _max = (widget.maxValue - widget.minValue) * (1 - (_endThumbOffset / maxWidth));

    return ZwapRangeValues(_min, _max) + widget.minValue;
  }

  set _currentValue(ZwapRangeValues value) {
    if (_maxWidth == null) {
      _startThumbOffset = 0;
      _endThumbOffset = 0;
      return;
    }

    final double _dValue = widget.maxValue - widget.minValue;

    _startThumbOffset = _maxWidth! * ((value.min - widget.minValue) / _dValue);
    _endThumbOffset = _maxWidth! * (1 - (value.max - widget.minValue) / _dValue);

    //? Correct values here

    _startThumbOffset -= (_startThumbOffset / _maxWidth!) * _thumbSize;
    _endThumbOffset -= (_endThumbOffset / _maxWidth!) * _thumbSize;

    setState(() {});
  }

  void _notifiyChange(double maxWidth) {
    if (widget.onChange == null) return;
    widget.onChange!(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        _maxWidth = size.maxWidth;
        final bool _isAtSamePosition = (_startThumbOffset + _thumbSize / 2) == size.maxWidth - _endThumbOffset - _thumbSize / 2;

        return MouseRegion(
          cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.basic,
          child: Container(
            height: _thumbSize,
            width: double.infinity,
            child: Stack(
              children: [
                //? Placeholder line
                Positioned(
                  top: (_thumbSize / 2) - (widget.lineWidth / 2),
                  left: 1,
                  right: 1,
                  child: Container(
                    height: widget.lineWidth,
                    decoration: BoxDecoration(
                      color: ZwapColors.neutral200,
                      borderRadius: BorderRadius.circular(widget.lineBorderRadius),
                    ),
                  ),
                ),
                //? Range line
                AnimatedPositioned(
                  duration: _animationDuration,
                  curve: Curves.decelerate,
                  top: (_thumbSize / 2) - (widget.lineWidth / 2),
                  left: _startThumbOffset + 1,
                  right: _endThumbOffset + 1,
                  child: Container(
                    width: double.infinity,
                    height: widget.lineWidth,
                    decoration: BoxDecoration(
                      color: ZwapColors.primary700,
                      borderRadius: BorderRadius.circular(widget.lineBorderRadius),
                    ),
                  ),
                ),
                //? Start thumb widget
                if (!_isAtSamePosition || _showStartIfEquals)
                  AnimatedPositioned(
                    duration: _animationDuration,
                    curve: Curves.decelerate,
                    left: _startThumbOffset,
                    child: MouseRegion(
                      cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
                      child: GestureDetector(
                        onHorizontalDragStart: (_) {
                          if (_draggedThumb == null) _draggedThumb = _ZwapRangeDraggingThumb.start;
                        },
                        onHorizontalDragUpdate: (details) {
                          if (_draggedThumb != _ZwapRangeDraggingThumb.start) return;

                          double _newOffset = _startThumbOffset + details.delta.dx;
                          _newOffset = max(0, min(_newOffset, size.maxWidth - _endThumbOffset - _thumbSize));

                          setState(() => _startThumbOffset = _newOffset);
                          _notifiyChange(size.maxWidth);
                        },
                        onHorizontalDragEnd: (_) {
                          setState(() => _draggedThumb = null);
                          if (!_isAtSamePosition) return;

                          setState(() => _showStartIfEquals = !_showStartIfEquals);
                        },
                        child: Container(
                          height: _thumbSize,
                          width: _thumbSize,
                          decoration: BoxDecoration(
                            color: ZwapColors.shades0,
                            borderRadius: BorderRadius.circular(_thumbSize / 2),
                            boxShadow: [
                              BoxShadow(color: Color(0xff091E42).withOpacity(0.31), blurRadius: 1),
                              BoxShadow(offset: Offset(0, 3), color: Color(0xff091E42).withOpacity(0.2), blurRadius: 5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                //? End thumb widget
                if (!_isAtSamePosition || !_showStartIfEquals)
                  AnimatedPositioned(
                    duration: _animationDuration,
                    curve: Curves.decelerate,
                    right: _endThumbOffset,
                    child: MouseRegion(
                      cursor: _isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
                      child: GestureDetector(
                        onHorizontalDragStart: (_) {
                          if (_draggedThumb == null) _draggedThumb = _ZwapRangeDraggingThumb.end;
                        },
                        onHorizontalDragUpdate: (details) {
                          if (_draggedThumb != _ZwapRangeDraggingThumb.end) return;

                          double _newOffset = _endThumbOffset + -details.delta.dx;
                          _newOffset = max(0, min(_newOffset, size.maxWidth - _startThumbOffset - _thumbSize));

                          setState(() => _endThumbOffset = _newOffset);
                          _notifiyChange(size.maxWidth);
                        },
                        onHorizontalDragEnd: (_) {
                          setState(() => _draggedThumb = null);
                          if (!_isAtSamePosition) return;

                          setState(() => _showStartIfEquals = !_showStartIfEquals);
                        },
                        child: Container(
                          height: _thumbSize,
                          width: _thumbSize,
                          decoration: BoxDecoration(
                            color: ZwapColors.shades0,
                            borderRadius: BorderRadius.circular(_thumbSize / 2),
                            boxShadow: [
                              BoxShadow(color: Color(0xff091E42).withOpacity(0.31), blurRadius: 1),
                              BoxShadow(offset: Offset(0, 3), color: Color(0xff091E42).withOpacity(0.2), blurRadius: 5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
