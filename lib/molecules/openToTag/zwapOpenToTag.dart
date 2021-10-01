/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/colStrap/colStrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// Custom component to rendering the openToTag component
class ZwapOpenToTag extends StatefulWidget implements ResponsiveWidget {

  /// Custom text to display inside this text
  final String openToTagText;

  /// The icon to display inside this tag
  final IconData tagIcon;

  /// The callBack function on clicking element
  final Function(String openToTagText)? callBackClick;

  /// Boolean flag to check if this element is clickAble or not
  final bool isClickAble;

  ZwapOpenToTag({
    Key? key,
    required this.openToTagText,
    required this.tagIcon,
    this.callBackClick,
    this.isClickAble = true
  }) : super(key: key);

  _ZwapOpenToTagState createState() => _ZwapOpenToTagState();

  @override
  double getSize(){
    Size sizes = getTextSize(this.openToTagText, ZwapTextType.captionSemiBold);
    return sizes.width + 24 + 26;
  }
}

/// Handle the state inside this component
class _ZwapOpenToTagState extends State<ZwapOpenToTag> {

  /// Flag to check if this container is hovered or not
  bool _isHovered = false;

  /// BackgroundColor for the default status
  final Color defaultBackgroundColor = ZwapColors.primary100;

  /// BackgroundColor for the default status
  final Color hoverBackgroundColor = ZwapColors.primary700;

  /// It plots the icon size in base of the current device sizes
  double _getIconSize() {
    return 24;
  }

  /// Callback function on hovering elements
  void _onHover(bool isHovered){
    setState(() {
      this._isHovered = isHovered;
    });
  }

  /// It gets the child widget for this open status tag
  Widget _getChildWidget(){
    return Container(
        decoration: BoxDecoration(
            color: !this._isHovered ? this.defaultBackgroundColor : this.hoverBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.defaultRadius))
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 5),
                child: Icon(
                  widget.tagIcon,
                  size: this._getIconSize(),
                  color: !this._isHovered ? ZwapColors.primary700 : ZwapColors.shades0,
                ),
              ),
              flex: 0,
              fit: FlexFit.tight,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 8, top: 5, bottom: 5),
                child: ZwapText(
                  text: widget.openToTagText,
                  zwapTextType: ZwapTextType.captionSemiBold,
                  textColor: !this._isHovered ? ZwapColors.primary700 : ZwapColors.shades0,
                ),
              ),
              flex: 0,
              fit: FlexFit.tight,
            ),
          ],
        )
    );
  }

  /// It gets the parent in case of clickable widget
  Widget _getClickableParent(){
    return widget.isClickAble ? InkWell(
      onHover: (bool isHovered) => this._onHover(isHovered),
      onTap: () => widget.callBackClick!(widget.openToTagText),
      child: this._getChildWidget(),
    ) : this._getChildWidget();
  }

  @override
  Widget build(BuildContext context) {
    return widget.callBackClick != null ? this._getClickableParent() : this._getChildWidget();
  }
}
