import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

/// FEATURE: appearing labels on press thumb
/// FEATURE: decorations

enum _ZwapRangeDraggingThumb { start, end }

class ZwapRangeSlider extends StatefulWidget {
  final int minValue;
  final int maxValue;

  /// The size of the thumbs, default to 16
  final double thumbSize;

  final Function(double min, double max)? onChange;

  const ZwapRangeSlider({
    this.minValue = 0,
    this.maxValue = 5,
    this.thumbSize = 16,
    this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapRangeSlider> createState() => _ZwapRangeSliderState();
}

class _ZwapRangeSliderState extends State<ZwapRangeSlider> {
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

  @override
  void initState() {
    super.initState();
  }

  double get _thumbSize => widget.thumbSize;

  void _notifiyChange(double maxWidth) {
    if (widget.onChange == null) return;

    maxWidth -= _thumbSize;

    final double _min = (widget.maxValue - widget.minValue) * (_startThumbOffset / maxWidth);
    final double _max = (widget.maxValue - widget.minValue) * (1 - (_endThumbOffset / maxWidth));

    widget.onChange!(widget.minValue + _min, widget.minValue + _max);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        final bool _isAtSamePosition = (_startThumbOffset + _thumbSize / 2) == size.maxWidth - _endThumbOffset - _thumbSize / 2;

        return Container(
          height: _thumbSize,
          width: double.infinity,
          child: Stack(
            children: [
              //? Placeholder line
              Positioned(
                top: (_thumbSize / 2) - 1,
                left: 1,
                right: 1,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(color: ZwapColors.neutral200, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              //? Range line
              Positioned(
                top: (_thumbSize / 2) - 1,
                left: _startThumbOffset + 1,
                right: _endThumbOffset + 1,
                child: Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(color: ZwapColors.primary700, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              //? Start thumb widget
              if (!_isAtSamePosition || _showStartIfEquals)
                Positioned(
                  left: _startThumbOffset,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
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
                        _draggedThumb = null;
                        if (!_isAtSamePosition) return;

                        setState(() => _showStartIfEquals = !_showStartIfEquals);
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
              //? End thumb widget
              if (!_isAtSamePosition || !_showStartIfEquals)
                Positioned(
                  right: _endThumbOffset,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
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
                        _draggedThumb = null;
                        if (!_isAtSamePosition) return;

                        setState(() => _showStartIfEquals = !_showStartIfEquals);
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
                )
            ],
          ),
        );
      },
    );
  }
}
