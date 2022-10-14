import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

class ZwapRadioButton extends StatefulWidget {
  final bool active;
  final double size;

  final Color color;
  final Duration animationDuration;

  final Function()? onTap;

  const ZwapRadioButton({
    required this.active,
    this.size = 16,
    this.color = ZwapColors.primary700,
    this.animationDuration = const Duration(milliseconds: 200),
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapRadioButton> createState() => _ZwapRadioButtonState();
}

class _ZwapRadioButtonState extends State<ZwapRadioButton> {
  late bool _active;

  double get _size => widget.size;
  double get _contentSize => _active ? widget.size * 0.5 : 0;

  @override
  void initState() {
    super.initState();

    _active = widget.active;
  }

  @override
  void didUpdateWidget(covariant ZwapRadioButton oldWidget) {
    if (widget.active != _active) setState(() => _active = widget.active);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(widget.size),
      focusColor: ZwapColors.transparent,
      hoverColor: ZwapColors.transparent,
      splashColor: ZwapColors.transparent,
      highlightColor: ZwapColors.transparent,
      onTap: widget.onTap,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size),
          border: Border.all(color: widget.color),
          color: ZwapColors.transparent,
        ),
        child: Center(
          child: AnimatedContainer(
            duration: widget.animationDuration,
            curve: Curves.decelerate,
            width: _contentSize,
            height: _contentSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.size),
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}
