/// IMPORTING THIRD PARTY PACKAGES

import 'dart:math';

import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';

class ZwapSwitch extends StatefulWidget {
  ///  Is true the switch will be selected
  ///
  /// Default to fales
  final bool value;

  ///  Called each time user try to change the value
  final Function(bool)? onChange;

  final Color? color;
  final Color? activeColor;

  final Gradient? gradient;
  final Gradient? activeGradient;

  final Color? thumbColor;
  final Gradient? thumbGradient;

  final Color? activeThumbColor;
  final Gradient? activeThumbGradient;

  /// Width of switch
  ///
  /// Default to 56
  final double width;

  /// Height of switch
  ///
  /// Default to 32
  final double height;

  /// Final thumb size will be [heigth] - 2 * [thumbPadding]
  final double thumbPadding;

  /// While dragging thumb, its size will be increased
  /// by this value
  ///
  /// Default to 4.5
  final double draggingThumbExtent;

  /// Default to max to make widget circular
  final double? borderRadiuns;

  const ZwapSwitch({
    this.value = false,
    this.onChange,
    this.width = 56,
    this.height = 32,
    this.thumbPadding = 4,
    this.draggingThumbExtent = 4.5,
    this.activeColor,
    this.activeGradient,
    this.activeThumbColor,
    this.activeThumbGradient,
    this.color,
    this.gradient,
    this.thumbColor,
    this.thumbGradient,
    this.borderRadiuns,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapSwitch> createState() => _ZwapSwitchState();
}

class _ZwapSwitchState extends State<ZwapSwitch> {
  final Color _defaultColor = ZwapColors.neutral200;
  final Color _defaultActiveColor = ZwapColors.primary700;
  final Color _defaultThumbColor = ZwapColors.shades0;

  bool _hovered = false;

  ///? Size of the thumb widget
  double get _thumbSize => widget.height - 2 * widget.thumbPadding;

  //? If true thumb is beign pressed
  bool _pressed = false;
  //? If true thumb is beign horizontally dragged
  bool _grabbed = false;

  late bool __value;
  late double _thumbPosition;

  bool get _value => __value;
  set _value(bool value) {
    setState(() => __value = value);
    _updateThumbPosition();
  }

  double get _startThumbPosition => widget.thumbPadding;
  double get _endThumbPosition => widget.width - widget.thumbPadding - _thumbSize - ((_pressed || _grabbed) ? widget.draggingThumbExtent : 0);

  @override
  void initState() {
    super.initState();

    __value = widget.value;
    _updateThumbPosition();
  }

  void _thumbDown() {
    setState(() => _pressed = true);
    if (!_grabbed) _updateThumbPosition();
  }

  void _thumbUp() {
    setState(() => _pressed = false);
    if (!_grabbed) _updateThumbPosition();
  }

  void _updateThumbPosition() => setState(() => _thumbPosition = _value ? _endThumbPosition : _startThumbPosition);

  void _onTap() {
    _value = !_value;
    _notifyListener();
  }

  void _notifyListener() {
    if (widget.onChange != null) widget.onChange!(_value);
  }

  Color? get _switchColor {
    if (widget.gradient != null || widget.activeGradient != null) return null;
    return _value ? widget.activeColor ?? _defaultActiveColor : widget.color ?? _defaultColor;
  }

  Gradient? get _switchGradient {
    if (widget.gradient != null || widget.activeGradient != null) {
      if (_value) {
        return widget.activeGradient ?? ZwapColors.emptyGradient(baseColor: widget.activeColor ?? _defaultActiveColor);
      } else {
        return widget.gradient ?? ZwapColors.emptyGradient(baseColor: widget.color ?? _defaultColor);
      }
    }

    return null;
  }

  Color? get _thumbColor {
    if (widget.thumbGradient != null || widget.activeThumbGradient != null) return null;
    return (_value ? widget.activeThumbColor : widget.thumbColor) ?? _defaultThumbColor;
  }

  Gradient? get _thumbGradient {
    if (widget.thumbGradient != null || widget.activeThumbGradient != null) {
      if (_value) {
        return widget.activeThumbGradient ?? ZwapColors.emptyGradient(baseColor: widget.activeThumbColor ?? _defaultThumbColor);
      } else {
        return widget.thumbGradient ?? ZwapColors.emptyGradient(baseColor: widget.thumbColor ?? _defaultThumbColor);
      }
    }

    return null;
  }

  @override
  void didUpdateWidget(covariant ZwapSwitch oldWidget) {
    if (_value != widget.value) _value = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: _switchColor,
            gradient: _switchGradient,
            borderRadius: BorderRadius.circular(widget.borderRadiuns ?? widget.height),
            boxShadow: [
              if (_hovered)
                BoxShadow(
                  offset: Offset(0, 1.2),
                  color: ZwapColors.shades100.withOpacity(0.1),
                  blurRadius: 1.2,
                  spreadRadius: 0.5,
                ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                top: widget.thumbPadding,
                left: _thumbPosition,
                duration: _grabbed ? Duration.zero : const Duration(milliseconds: 200),
                child: MouseRegion(
                  cursor: (_pressed || _grabbed) ? SystemMouseCursors.grabbing : SystemMouseCursors.click,
                  onExit: (_) => _thumbUp(),
                  child: GestureDetector(
                    onTap: _onTap,
                    onTapDown: (_) => _thumbDown(),
                    onTapUp: (_) => _thumbUp(),
                    onTapCancel: () => _thumbUp(),
                    onHorizontalDragStart: (_) => setState(() => _grabbed = true),
                    onHorizontalDragUpdate: (details) {
                      final double _newPos = max(_startThumbPosition, min(_endThumbPosition, _thumbPosition + details.delta.dx));
                      setState(() => _thumbPosition = _newPos);
                    },
                    onHorizontalDragEnd: (_) {
                      setState(() => _grabbed = false);
                      _value = _thumbPosition > (_endThumbPosition - _startThumbPosition) / 2;
                      _updateThumbPosition();
                      _notifyListener();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _thumbSize + ((_grabbed || _pressed) ? widget.draggingThumbExtent : 0),
                      height: _thumbSize,
                      decoration: BoxDecoration(
                        color: _thumbColor,
                        gradient: _thumbGradient,
                        borderRadius: BorderRadius.circular(widget.height),
                        boxShadow: [
                          BoxShadow(color: ZwapColors.shades100.withOpacity(0.4), blurRadius: 1, spreadRadius: 0),
                          BoxShadow(
                            offset: Offset(0, 6),
                            color: ZwapColors.shades100.withOpacity(0.16),
                            blurRadius: 6,
                            spreadRadius: -6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
