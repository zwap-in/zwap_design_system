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

  /// Boolean flag to check if this element has the icon on left or right to text inside the open tag component
  final bool isLeft;

  ZwapOpenToTag({
    Key? key,
    required this.openToTagText,
    required this.tagIcon,
    this.callBackClick,
    this.isClickAble = true,
    this.isLeft = true
  }) : super(key: key);

  _ZwapOpenToTagState createState() => _ZwapOpenToTagState();

  @override
  double getSize(){
    Size sizes = getTextSize(this.openToTagText, ZwapTextType.captionSemiBold);
    return sizes.width + 20 + 26;
  }
}

/// Handle the state inside this component
class _ZwapOpenToTagState extends State<ZwapOpenToTag> {

  /// The random color chose for this primary color
  final Color primaryColor = ZwapColors.getRandomColor(is200: true);

  /// BackgroundColor for the default status
  Color get defaultBackgroundColor => primaryColor;

  /// It plots the icon size in base of the current device sizes
  double _getIconSize() {
    return 20;
  }


  /// It gets the child widget for this open status tag
  Widget _getChildWidget(){
    return Container(
        decoration: BoxDecoration(
            color: this.defaultBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.defaultRadius))
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: widget.isLeft ? Padding(
                padding: EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 5),
                child: Icon(
                  widget.tagIcon,
                  size: this._getIconSize(),
                  color: ZwapColors.mappingRandomColor(this.defaultBackgroundColor),
                ),
              ) : Container(),
              flex: 0,
              fit: FlexFit.tight,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 8, top: 5, bottom: 5),
                child: ZwapText(
                  text: widget.openToTagText,
                  zwapTextType: ZwapTextType.captionSemiBold,
                  textColor: ZwapColors.mappingRandomColor(this.defaultBackgroundColor),
                ),
              ),
              flex: 0,
              fit: FlexFit.tight,
            ),
            Flexible(
              child: !widget.isLeft ? Padding(
                padding: EdgeInsets.only(left: 8, right: 5, top: 5, bottom: 5),
                child: Icon(
                  widget.tagIcon,
                  size: this._getIconSize(),
                  color: ZwapColors.mappingRandomColor(this.defaultBackgroundColor),
                ),
              ) : Container(),
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
      onTap: () => widget.callBackClick!(widget.openToTagText),
      child: this._getChildWidget(),
    ) : this._getChildWidget();
  }

  @override
  Widget build(BuildContext context) {
    return widget.callBackClick != null ? this._getClickableParent() : this._getChildWidget();
  }
}
