/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

enum ZwapScrollArrowDirection { top, left, right, bottom }

//TODO: same icon style and more directions

class ZwapScrollArrow extends StatefulWidget {
  final ZwapScrollArrowDirection direction;
  final Function()? onTap;

  final bool disabled;

  ZwapScrollArrow({
    required this.direction,
    this.onTap,
    this.disabled = false,
    Key? key,
  }) : super(key: key);

  _ZwapScrollArrowState createState() => _ZwapScrollArrowState();
}

class _ZwapScrollArrowState extends State<ZwapScrollArrow> {
  late bool _disabled;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _disabled = widget.disabled;
  }

  @override
  void didUpdateWidget(covariant ZwapScrollArrow oldWidget) {
    if (_disabled != widget.disabled) setState(() => _disabled = widget.disabled);

    super.didUpdateWidget(oldWidget);
  }

  String get _icon {
    switch (widget.direction) {
      case ZwapScrollArrowDirection.top:
        return 'arrow_up_3';
      case ZwapScrollArrowDirection.left:
        return 'arrow_left';
      case ZwapScrollArrowDirection.right:
        return 'arrow_right';
      case ZwapScrollArrowDirection.bottom:
        return 'arrow_down_3';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.decelerate,
      decoration: BoxDecoration(
        color: _disabled || _isHovered ? ZwapColors.neutral100 : ZwapColors.neutral200,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: _disabled ? null : widget.onTap,
          hoverColor: ZwapColors.shades0,
          onHover: (bool isHovered) => setState(() => _isHovered = isHovered),
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _disabled
                    ? ZwapIcons.icons(_icon, iconColor: ZwapColors.neutral300, iconSize: 15, key: ValueKey(true))
                    : ZwapIcons.icons(_icon, iconColor: ZwapColors.shades100, iconSize: 15, key: ValueKey(false)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
