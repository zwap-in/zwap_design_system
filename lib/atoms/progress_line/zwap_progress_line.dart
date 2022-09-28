import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

class ZwapProgressLine extends StatefulWidget {
  /// Value from 0 to 1.
  ///
  /// Zero means an empty line, one a filled line
  final double value;

  /// Background color of the line
  ///
  /// If both [color] and [gradient] are provided
  /// gradient will be used
  final Color? color;

  /// Background gradient of the line
  ///
  /// If both [color] and [gradient] are provided
  /// gradient will be used
  final LinearGradient? gradient;

  /// Line thickness, default to 6
  final double height;

  /// Must be a finite number
  final double width;

  /// Default to 6
  final double radius;

  /// If provided a background will be showed
  final Color? backgroundColor;

  ZwapProgressLine({
    required this.value,
    required this.width,
    this.color,
    this.gradient,
    this.height = 6,
    this.radius = 6,
    this.backgroundColor,
    Key? key,
  })  : assert(width.isFinite),
        super(key: key);

  @override
  State<ZwapProgressLine> createState() => _ZwapProgressLineState();
}

class _ZwapProgressLineState extends State<ZwapProgressLine> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant ZwapProgressLine oldWidget) {
    if (_value != widget.value) setState(() => _value = widget.value);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final Widget _progressLine = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.decelerate,
      height: widget.height,
      width: widget.width * _value,
      decoration: BoxDecoration(
        color: widget.color,
        gradient: widget.gradient ?? (widget.color != null ? null : ZwapColors.buttonGrad),
        borderRadius: BorderRadius.circular(widget.radius),
      ),
    );

    if (widget.backgroundColor != null)
      return Container(
        color: widget.backgroundColor,
        width: widget.width,
        alignment: Alignment.centerLeft,
        child: _progressLine,
      );

    return _progressLine;
  }
}
