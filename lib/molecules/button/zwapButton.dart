/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// It defines the types for the button
enum ZwapButtonType { primary, secondary, flat, editButton }

/// It defines the statuses for the button
enum ZwapButtonStatus {
  defaultStatus,
  hoverStatus,
  activeStatus,
  disabledStatus,
  destructiveStatus,
}

/// It defines the types of content for the button
enum ZwapButtonContentType { noIcon, withIcon, noLabel }

/// Standard zwap button with different type and status
class ZwapButton extends StatefulWidget {

  /// The button type
  final ZwapButtonType zwapButtonType;

  /// The current button status
  final ZwapButtonStatus zwapButtonStatus;

  /// The content widget inside this button
  final ZwapButtonContentType zwapButtonContentType;

  /// The optionally callBack function on click
  final Function()? onPressedCallBack;

  /// Optionally text inside this button
  final String? text;

  /// Optionally icon inside this button
  final IconData? icon;

  /// has the full axis this button?. Default = true
  final bool fullAxis;

  /// The optionally forced text color inside this button
  final Color? textColor;

  /// The optionally forced button color inside this button
  final Color? buttonColor;

  /// Optionally height for this button
  final double? height;

  /// Optionally width for this button
  final double? width;

  /// Optionally lateral padding inside this button
  final double? lateralPadding;

  ZwapButton({Key? key,
      required this.zwapButtonType,
      required this.zwapButtonStatus,
      required this.zwapButtonContentType,
      required this.onPressedCallBack,
      this.fullAxis = true,
      this.text,
      this.icon,
      this.textColor,
      this.buttonColor,
      this.height,
      this.width,
      this.lateralPadding
      })
      : super(key: key) {
    if (zwapButtonType == ZwapButtonType.editButton) {
      assert(zwapButtonContentType == ZwapButtonContentType.noIcon,
          "Edit button cannot have an icon inside the button");
    }
    if (zwapButtonContentType == ZwapButtonContentType.noIcon) {
      assert(this.icon == null,
          "Zwap button with no icon could not be contain an icon");
    } else if (zwapButtonContentType == ZwapButtonContentType.noLabel) {
      assert(this.text == null,
          "Zwap button with no label could not be contain a label");
    } else {
      assert(this.text != null && this.icon != null,
          "Zwap button with icon and text must be contain a label and an icon");
    }
    if (this.zwapButtonStatus == ZwapButtonStatus.disabledStatus) {
      assert(this.onPressedCallBack == null,
          "If the button is disabled it cannot have a callBack function");
    } else {
      assert(this.onPressedCallBack != null,
          "If the button is not disabled it must have the callBack function");
    }
  }

  _ZwapButtonState createState() => _ZwapButtonState();
}

/// Handle the state for the standard zwap button
class _ZwapButtonState extends State<ZwapButton> {

  /// Handle the hover on this button
  bool _isHover = false;

  /// It gets the current button status
  ZwapButtonStatus _getButtonStatus() {
    ZwapButtonStatus defaultStatus = widget.zwapButtonStatus;
    if (defaultStatus == ZwapButtonStatus.disabledStatus) {
      return defaultStatus;
    }
    return this._isHover ? ZwapButtonStatus.hoverStatus : defaultStatus;
  }

  /// Change the hover status on this button
  void _hoverButton(bool isHover) {
    setState(() {
      this._isHover = isHover;
    });
  }

  /// It retrieves the text color in base of the type and the status
  Color _getTextColor() {
    Color defaultColor = ZwapColors.shades0;
    Color hoverColor = ZwapColors.shades0;
    Color activeColor = ZwapColors.shades0;
    Color disabledColor = ZwapColors.shades0;
    Color destructiveColor = ZwapColors.shades0;
    switch (widget.zwapButtonType) {
      case ZwapButtonType.primary:
        destructiveColor = ZwapColors.error400;
        break;
      case ZwapButtonType.secondary:
        defaultColor = ZwapColors.primary700;
        hoverColor = ZwapColors.primary700;
        disabledColor = ZwapColors.primary200;
        destructiveColor = ZwapColors.error400;
        break;
      case ZwapButtonType.flat:
        defaultColor = ZwapColors.primary700;
        hoverColor = ZwapColors.primary700;
        disabledColor = ZwapColors.primary300;
        destructiveColor = ZwapColors.warning700;
        break;
      case ZwapButtonType.editButton:
        defaultColor = ZwapColors.neutral500;
        hoverColor = ZwapColors.neutral500;
        break;
    }
    switch (this._getButtonStatus()) {
      case ZwapButtonStatus.defaultStatus:
        return defaultColor;
      case ZwapButtonStatus.hoverStatus:
        return hoverColor;
      case ZwapButtonStatus.activeStatus:
        return activeColor;
      case ZwapButtonStatus.disabledStatus:
        return disabledColor;
      case ZwapButtonStatus.destructiveStatus:
        return destructiveColor;
    }
  }

  /// It retrieves the children color
  Color _getChildrenColor() {
    Color iconColor;
    if (widget.zwapButtonType == ZwapButtonType.primary) {
      iconColor = ZwapColors.shades0;
    } else if (widget.zwapButtonType == ZwapButtonType.secondary) {
      if (this._getButtonStatus() == ZwapButtonStatus.defaultStatus ||
          this._getButtonStatus() == ZwapButtonStatus.hoverStatus) {
        iconColor = ZwapColors.primary700;
      } else if (this._getButtonStatus() == ZwapButtonStatus.activeStatus) {
        iconColor = ZwapColors.shades0;
      } else if (this._getButtonStatus() == ZwapButtonStatus.disabledStatus) {
        iconColor = ZwapColors.primary200;
      } else {
        iconColor = ZwapColors.warning700;
      }
    } else {
      if (this._getButtonStatus() == ZwapButtonStatus.destructiveStatus) {
        iconColor = ZwapColors.error400;
      } else if (this._getButtonStatus() == ZwapButtonStatus.disabledStatus) {
        iconColor = ZwapColors.primary300;
      } else {
        iconColor = ZwapColors.primary700;
      }
    }
    return iconColor;
  }

  /// It retrieves the child widget for this button
  Widget _getContainerChild() {
    switch (widget.zwapButtonContentType) {
      case ZwapButtonContentType.noIcon:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: widget.fullAxis ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Flexible(
              child: Center(
                child: ZwapText(
                    text: widget.text!,
                    zwapTextType: ZwapTextType.buttonText,
                    textColor: widget.textColor ?? this._getTextColor()),
              ),
              flex: 0,
              fit: FlexFit.tight,
            ),
          ],
        );
      case ZwapButtonContentType.withIcon:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(
                    widget.icon,
                    color: this._getChildrenColor(),
                    size: this._plotIconSize(),
                  ),
                ),
                flex: 0,
                fit: FlexFit.tight),
            Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 3),
                  child: ZwapText(
                      text: widget.text!,
                      zwapTextType: ZwapTextType.buttonText,
                      textColor: widget.textColor ?? this._getTextColor()),
                ),
                flex: 0,
                fit: FlexFit.tight),
          ],
        );
      case ZwapButtonContentType.noLabel:
        return Icon(
          widget.icon!,
          color: this._getChildrenColor(),
          size: this._plotIconSize(),
        );
    }
  }

  /// It retrieves the box decoration for this button in base of type and status
  BoxDecoration _getButtonDecoration() {
    Color borderColor;
    Color boxColor;
    switch (this._getButtonStatus()) {
      case ZwapButtonStatus.defaultStatus:
        if (widget.zwapButtonType == ZwapButtonType.primary) {
          boxColor = ZwapColors.primary700;
          borderColor = ZwapColors.primary700;
        } else if (widget.zwapButtonType == ZwapButtonType.secondary) {
          boxColor = ZwapColors.shades0;
          borderColor = ZwapColors.primary400;
        } else if (widget.zwapButtonType == ZwapButtonType.editButton) {
          boxColor = ZwapColors.shades0;
          borderColor = ZwapColors.shades0;
        } else {
          boxColor = ZwapColors.shades0;
          borderColor = ZwapColors.neutral200;
        }
        break;
      case ZwapButtonStatus.hoverStatus:
        if (widget.zwapButtonType == ZwapButtonType.primary) {
          boxColor = ZwapColors.primary800;
          borderColor = ZwapColors.primary800;
        } else if (widget.zwapButtonType == ZwapButtonType.secondary) {
          boxColor = ZwapColors.primary50;
          borderColor = ZwapColors.primary400;
        } else if (widget.zwapButtonType == ZwapButtonType.editButton) {
          boxColor = ZwapColors.shades0;
          borderColor = ZwapColors.neutral200;
        } else {
          boxColor = ZwapColors.primary50;
          borderColor = ZwapColors.primary50;
        }
        break;
      case ZwapButtonStatus.activeStatus:
        if (widget.zwapButtonType == ZwapButtonType.primary) {
          boxColor = ZwapColors.primary900;
          borderColor = ZwapColors.primary900;
        } else if (widget.zwapButtonType == ZwapButtonType.secondary) {
          boxColor = ZwapColors.primary900;
          borderColor = ZwapColors.primary900;
        } else {
          boxColor = ZwapColors.primary100;
          borderColor = ZwapColors.primary100;
        }
        break;
      case ZwapButtonStatus.disabledStatus:
        if (widget.zwapButtonType == ZwapButtonType.primary) {
          boxColor = ZwapColors.primary200;
          borderColor = ZwapColors.primary200;
        } else if (widget.zwapButtonType == ZwapButtonType.secondary) {
          boxColor = ZwapColors.shades0;
          borderColor = ZwapColors.primary200;
        } else {
          boxColor = ZwapColors.shades0;
          borderColor = ZwapColors.shades0;
        }
        break;
      case ZwapButtonStatus.destructiveStatus:
        if (widget.zwapButtonType == ZwapButtonType.primary) {
          boxColor = ZwapColors.warning700;
          borderColor = ZwapColors.warning700;
        } else if (widget.zwapButtonType == ZwapButtonType.secondary) {
          boxColor = ZwapColors.shades0;
          borderColor = ZwapColors.warning700;
        } else {
          boxColor = ZwapColors.shades0;
          borderColor = ZwapColors.shades0;
        }
        break;
    }
    return BoxDecoration(
        color: widget.buttonColor ?? boxColor,
        border: Border.all(
            color: widget.buttonColor ?? borderColor,
            width: 1,
            style: BorderStyle.solid
        ),
        borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.buttonRadius)));
  }

  /// It plots the icon size in base of the current device
  double _plotIconSize() {
    return getMultipleConditions(24.0, 24.0, 24.0, 21.0, 21.0);
  }

  /// It gets the button widget
  Widget _getButtonWidget() {
    Size textSize = getTextSize(widget.text != null ? widget.text! : "", ZwapTextType.buttonText);
    return Container(
      height: widget.height,
      width: widget.width != null ? widget.width! + textSize.width : null,
      decoration: this._getButtonDecoration(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: widget.lateralPadding ?? 10),
        child: this._getContainerChild(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonWidget = this._getButtonWidget();
    ZwapButtonStatus currentButtonStatus = this._getButtonStatus();
    return currentButtonStatus  == ZwapButtonStatus.disabledStatus ? buttonWidget
    : InkWell(
      onHover: (bool isHover) => this._hoverButton(isHover),
      onTap: () => widget.onPressedCallBack!(),
      child: buttonWidget,
    );
  }
}
