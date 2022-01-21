/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// Custom scroll arrow
class ZwapScrollArrow extends StatefulWidget {
  /// Is a right arrow or left?
  final bool isRight;

  /// Is this arrow disabled or not?
  final bool isDisabled;

  /// Custom callBack function to handle the click on this icon
  final Function() onClickCallBack;

  ZwapScrollArrow({Key? key, required this.onClickCallBack, this.isRight = true, this.isDisabled = false}) : super(key: key);

  _ZwapScrollArrowState createState() => _ZwapScrollArrowState();
}

class _ZwapScrollArrowState extends State<ZwapScrollArrow> {
  bool _isHovered = false;

  void _handleHover(bool isHovered) {
    setState(() {
      this._isHovered = isHovered;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget tmp = Container(
      decoration: BoxDecoration(
        color: this._isHovered && !widget.isDisabled ? ZwapColors.neutral100 : ZwapColors.neutral50,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: widget.isRight
            ? ZwapIcons.icons('arrow_right', iconColor: widget.isDisabled ? ZwapColors.neutral200 : ZwapColors.shades100, iconSize: 15)
            : ZwapIcons.icons('arrow_left', iconColor: widget.isDisabled ? ZwapColors.neutral200 : ZwapColors.shades100, iconSize: 15),
      ),
    );
    return InkWell(
      onTap: widget.isDisabled ? () => {} : () => widget.onClickCallBack(),
      hoverColor: ZwapColors.shades0,
      onHover: (bool isHovered) => this._handleHover(isHovered),
      borderRadius: BorderRadius.circular(50),
      child: tmp,
    );
  }
}
