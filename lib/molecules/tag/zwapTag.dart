/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// The Tag type inside this custom component
enum ZwapTagType {
  smallTagWhite,
  smallTagPrimary,
  mediumTagWhite,
  mediumTagPrimary,
}

/// The Tag status
enum ZwapTagStatus { defaultStatus, hoverStatus }

class ZwapTag extends StatefulWidget {

  /// The text inside this component
  final String tagText;

  /// The custom callBack function on click on clear icon
  final Function() onClearClick;

  /// The tag type to rendering different style
  final ZwapTagType zwapTagType;

  ZwapTag(
      {Key? key,
      required this.tagText,
      required this.onClearClick,
      required this.zwapTagType})
      : super(key: key);

  _ZwapTagState createState() => _ZwapTagState();
}

/// Custom component to render a custom tag with the standard style
class _ZwapTagState extends State<ZwapTag> {

  /// The current status
  ZwapTagStatus _zwapTagStatus = ZwapTagStatus.defaultStatus;

  /// It retrieves the background color in base of the status and type
  Color _getBackGroundColor() {
    Color backgroundColor;
    if (this._zwapTagStatus == ZwapTagStatus.defaultStatus) {
      if (widget.zwapTagType == ZwapTagType.smallTagWhite ||
          widget.zwapTagType == ZwapTagType.mediumTagWhite) {
        backgroundColor = ZwapColors.shades0;
      } else {
        backgroundColor = ZwapColors.primary700;
      }
    } else {
      if (widget.zwapTagType == ZwapTagType.smallTagWhite ||
          widget.zwapTagType == ZwapTagType.mediumTagWhite) {
        backgroundColor = ZwapColors.neutral50;
      } else {
        backgroundColor = ZwapColors.primary800;
      }
    }
    return backgroundColor;
  }

  /// It retrieves the children color inside this component
  Color _getChildrenColor() {
    Color textColor;
    if (widget.zwapTagType == ZwapTagType.smallTagWhite ||
        widget.zwapTagType == ZwapTagType.mediumTagWhite) {
      textColor = ZwapColors.neutral700;
    } else {
      textColor = ZwapColors.shades0;
    }
    return textColor;
  }

  /// It plots the height for this component
  double _plotHeight() {
    return 25;
  }

  /// It changes the hover status on this container
  void _changeHoverStatus(bool isHover) {
    setState(() {
      this._zwapTagStatus =
          isHover ? ZwapTagStatus.hoverStatus : ZwapTagStatus.defaultStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onClearClick(),
      onHover: (bool isHover) => this._changeHoverStatus(isHover),
      child: Container(
        height: this._plotHeight(),
        decoration: BoxDecoration(
            color: this._getBackGroundColor(),
            borderRadius:
                BorderRadius.all(Radius.circular(ZwapRadius.defaultRadius))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8, right: 2),
                child: ZwapText(
                  text: widget.tagText,
                  textColor: this._getChildrenColor(),
                  zwapTextType: ZwapTextType.body1Regular,
                ),
              ),
              flex: 0,
              fit: FlexFit.tight,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 2, right: 8),
                child: Icon(
                  Icons.clear,
                  color: this._getChildrenColor(),
                  size: 16,
                ),
              ),
              flex: 0,
              fit: FlexFit.tight,
            ),
          ],
        ),
      ),
    );
  }
}
