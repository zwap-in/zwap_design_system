/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// The possible badges state
enum ZwapStatusBadgeState {
  defaultState,
  hoverState,
}

/// The Zwap status badge
class ZwapStatusBadge extends StatefulWidget implements ResponsiveWidget {

  /// The status text inside this component
  final String statusText;

  /// The icon associated to this status
  final IconData statusIcon;

  /// The icon color
  final Color statusIconColor;

  /// The callBack function on clicking element
  final Function(String status) callBackClick;

  /// Is the current status selected or not
  final bool isSelected;

  ZwapStatusBadge({Key? key,
    required this.statusText,
    required this.statusIcon,
    required this.statusIconColor,
    required this.callBackClick,
    this.isSelected = false
  }) : super(key: key);

  _ZwapStatusBadgeState createState() => _ZwapStatusBadgeState();

  double get statusWidth => 45;

  @override
  double getSize() {
    Size size = getTextSize(this.statusText, ZwapTextType.buttonText);
    return size.width + 6 + 6 + (this.statusWidth * 0.5) + 30 + 2;
  }

}

/// It handles the badge state
class _ZwapStatusBadgeState extends State<ZwapStatusBadge> {

  /// The current state
  ZwapStatusBadgeState _currentState = ZwapStatusBadgeState.defaultState;

  /// It changes the state if the element is hovered or not
  void _onHover(bool isHover) {
    setState(() {
      this._currentState = isHover
          ? ZwapStatusBadgeState.hoverState
          : ZwapStatusBadgeState.defaultState;
    });
  }

  /// It gets the text color in base of the current state
  Color _getTextColor() {
    if(widget.isSelected){
      return ZwapColors.shades0;
    }
    switch (this._currentState) {
      case ZwapStatusBadgeState.defaultState:
        return ZwapColors.neutral700;
      case ZwapStatusBadgeState.hoverState:
        return widget.statusIconColor;
    }
  }

  /// It gets the border colors in base of the current state
  Color _getBorderColor() {
    if(widget.isSelected){
      return ZwapColors.primary700;
    }
    switch (this._currentState) {
      case ZwapStatusBadgeState.defaultState:
        return ZwapColors.neutral200;
      case ZwapStatusBadgeState.hoverState:
        return ZwapColors.neutral100;
    }
  }

  /// It gets the background color in base of the current state
  Color _getBackGroundColor() {
    if(widget.isSelected){
      return ZwapColors.primary700;
    }
    switch (this._currentState) {
      case ZwapStatusBadgeState.defaultState:
        return ZwapColors.shades0;
      case ZwapStatusBadgeState.hoverState:
        return ZwapColors.neutral100;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.statusWidth;
    return InkWell(
      onTap: () => widget.callBackClick(widget.statusText),
      onHover: (bool isHover) => this._onHover(isHover),
      child: Container(
        height: height,
        decoration: BoxDecoration(
            color: this._getBackGroundColor(),
            border: Border.all(
                color: this._getBorderColor(),
                width: 1,
                style: BorderStyle.solid
            ),
            borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.statusRadius))
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: height * 0.10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: Icon(
                    widget.statusIcon,
                    color: widget.statusIconColor,
                    size: height * 0.5,
                  ),
                ),
                flex: 0,
                fit: FlexFit.tight,
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: ZwapText(
                    text: widget.statusText,
                    zwapTextType: ZwapTextType.bodySemiBold,
                    textColor: this._getTextColor(),
                  ),
                ),
                flex: 0,
                fit: FlexFit.tight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
