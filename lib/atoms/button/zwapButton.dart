/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/icons/zwapIcons.dart';
import 'package:zwap_design_system/atoms/constants/zwapConstants.dart';
import 'package:zwap_design_system/atoms/typography/zwapTypography.dart';
import 'package:zwap_design_system/atoms/text/text.dart';

import 'buttonTypes/zwapButtonTypes.dart';
export 'buttonTypes/zwapButtonTypes.dart';

/// Standard zwap button with different type and status
class ZwapButton extends StatefulWidget implements ResponsiveWidget {
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

  /// The button alignment type
  final ZwapButtonAlignment? zwapButtonAlignment;

  /// Optionally height for this button
  final double? height;

  /// Optionally width for this button
  final double? width;

  /// Optionally lateral padding inside this button
  final double? lateralPadding;

  /// Optionally vertical padding inside this button
  final double? verticalPadding;

  /// Optionally icon color inside this button
  final Color? iconColor;

  /// The button radius
  final double? buttonRadius;

  ZwapButton(
      {Key? key,
      required this.zwapButtonType,
      required this.zwapButtonStatus,
      required this.zwapButtonContentType,
      required this.onPressedCallBack,
      this.fullAxis = true,
      this.zwapButtonAlignment = ZwapButtonAlignment.center,
      this.text,
      this.icon,
      this.textColor,
      this.buttonColor,
      this.height,
      this.width,
      this.lateralPadding,
      this.verticalPadding,
      this.iconColor,
      this.buttonRadius})
      : super(key: key) {
    if (zwapButtonType == ZwapButtonType.editButton) {
      assert(zwapButtonContentType == ZwapButtonContentType.noIcon, "Edit button cannot have an icon inside the button");
    }
    if (zwapButtonContentType == ZwapButtonContentType.noIcon) {
      assert(this.icon == null, "Zwap button with no icon could not be contain an icon");
    } else if (zwapButtonContentType == ZwapButtonContentType.noLabel) {
      assert(this.text == null, "Zwap button with no label could not be contain a label");
    } else {
      assert(this.text != null && this.icon != null, "Zwap button with icon and text must be contain a label and an icon");
    }
    if (this.zwapButtonStatus == ZwapButtonStatus.disabledStatus) {
      assert(this.onPressedCallBack == null, "If the button is disabled it cannot have a callBack function");
    } else {
      assert(this.onPressedCallBack != null, "If the button is not disabled it must have the callBack function");
    }
  }

  /// It gets the text size for this button
  Size get textSize => getTextSize(this.text != null ? this.text! : "", ZwapTextType.buttonText);

  /// It plots the icon size in base of the current device
  double _plotIconSize() {
    return getMultipleConditions<double>(20.0, 20.0, 20.0, 18.0, 18.0);
  }

  /// It gets the external horizontal padding
  double _externalHorizontalPadding() {
    return this.lateralPadding ?? 10;
  }

  _ZwapButtonState createState() => _ZwapButtonState();

  @override
  double getSize() {
    double iconWidth = this.zwapButtonContentType != ZwapButtonContentType.noIcon ? this._plotIconSize() : 0;
    double textWidth = this.zwapButtonContentType != ZwapButtonContentType.noLabel ? this.textSize.width : 0;
    double internalPadding = this.zwapButtonContentType == ZwapButtonContentType.withIcon ? 6 : 0;
    double externalPadding = this._externalHorizontalPadding();
    double maximumWidth = textWidth + iconWidth + internalPadding + externalPadding;
    return this.width != null ? this.width! + maximumWidth : maximumWidth;
  }
}

/// Handle the state for the standard zwap button
class _ZwapButtonState extends State<ZwapButton> {
  /// Handle the hover on this button
  late bool _isHover;

  @override
  void initState() {
    _isHover = kIsWeb ? false : true;
    super.initState();
  }

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
    if (kIsWeb) return;

    setState(() {
      this._isHover = isHover;
    });
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
          borderColor = ZwapColors.neutral500;
        } else if (widget.zwapButtonType == ZwapButtonType.editButton) {
          boxColor = ZwapColors.shades0;
          borderColor = getMultipleConditions<Color>(ZwapColors.shades0, ZwapColors.shades0, ZwapColors.neutral200, ZwapColors.neutral200, ZwapColors.neutral200);
        } else {
          boxColor = Colors.transparent;
          borderColor = Colors.transparent;
        }
        break;
      case ZwapButtonStatus.hoverStatus:
        if (widget.zwapButtonType == ZwapButtonType.primary) {
          boxColor = ZwapColors.primary800;
          borderColor = ZwapColors.primary800;
        } else if (widget.zwapButtonType == ZwapButtonType.secondary) {
          boxColor = ZwapColors.shades0;
          borderColor = ZwapColors.neutral700;
        } else if (widget.zwapButtonType == ZwapButtonType.editButton) {
          boxColor = ZwapColors.shades0;
          borderColor = ZwapColors.neutral200;
        } else {
          boxColor = ZwapColors.primary50;
          borderColor = Colors.transparent;
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
          boxColor = ZwapColors.neutral300;
          borderColor = ZwapColors.neutral300;
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
        } else if (widget.zwapButtonType == ZwapButtonType.flat) {
          boxColor = ZwapColors.error50;
          borderColor = ZwapColors.error50;
        } else {
          boxColor = ZwapColors.shades0;
          borderColor = ZwapColors.shades0;
        }
        break;
    }
    return BoxDecoration(
        color: widget.buttonColor ?? boxColor,
        border: Border.all(color: widget.buttonColor ?? borderColor, width: 1, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(Radius.circular(widget.buttonRadius ?? ZwapRadius.buttonRadius)));
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
        defaultColor = ZwapColors.neutral500;
        hoverColor = ZwapColors.neutral700;
        disabledColor = ZwapColors.neutral300;
        destructiveColor = ZwapColors.error400;
        break;
      case ZwapButtonType.flat:
        defaultColor = ZwapColors.neutral600;
        hoverColor = ZwapColors.neutral600;
        disabledColor = ZwapColors.neutral400;
        destructiveColor = ZwapColors.error400;
        break;
      case ZwapButtonType.editButton:
        defaultColor = getMultipleConditions<Color>(ZwapColors.shades0, ZwapColors.shades0, ZwapColors.neutral500, ZwapColors.neutral500, ZwapColors.neutral500);
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
      if (this._getButtonStatus() == ZwapButtonStatus.defaultStatus || this._getButtonStatus() == ZwapButtonStatus.hoverStatus) {
        iconColor = ZwapColors.neutral600;
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
        iconColor = ZwapColors.neutral400;
      } else {
        iconColor = ZwapColors.neutral600;
      }
    }
    return iconColor;
  }

  /// It retrieves the child widget for this button
  Widget _getContainerChild() {
    switch (widget.zwapButtonContentType) {
      case ZwapButtonContentType.noIcon:
        return Row(
          mainAxisAlignment: widget.zwapButtonAlignment == ZwapButtonAlignment.center ? MainAxisAlignment.center : MainAxisAlignment.start,
          mainAxisSize: widget.fullAxis ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Flexible(
              child: Center(
                child: ZwapText(text: widget.text!, zwapTextType: ZwapTextType.buttonText, textColor: widget.textColor ?? this._getTextColor()),
              ),
              flex: 0,
              fit: FlexFit.tight,
            ),
          ],
        );
      case ZwapButtonContentType.withIcon:
        return Row(
          mainAxisAlignment: widget.zwapButtonAlignment == ZwapButtonAlignment.center ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(
                    widget.icon,
                    size: widget._plotIconSize(),
                    color: this._getChildrenColor(),
                  )),
              flex: 0,
              fit: FlexFit.tight,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 3),
                child: ZwapText(text: widget.text!, zwapTextType: ZwapTextType.buttonText, textColor: widget.textColor ?? this._getTextColor()),
              ),
              flex: 0,
              fit: FlexFit.tight,
            ),
          ],
        );
      case ZwapButtonContentType.noLabel:
        return Icon(
          widget.icon!,
          color: this._getChildrenColor(),
          size: widget._plotIconSize(),
        );
    }
  }

  /// It gets the button widget
  Widget _getButtonWidget() {
    return Container(
      height: widget.height,
      width: widget.width != null ? widget.getSize() : null,
      decoration: this._getButtonDecoration(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: widget.verticalPadding ?? 5, horizontal: widget._externalHorizontalPadding()),
        child: this._getContainerChild(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonWidget = this._getButtonWidget();
    ZwapButtonStatus currentButtonStatus = this._getButtonStatus();
    return currentButtonStatus == ZwapButtonStatus.disabledStatus
        ? buttonWidget
        : InkWell(
            onHover: (bool isHover) => this._hoverButton(isHover),
            onTap: () => widget.onPressedCallBack!(),
            child: buttonWidget,
          );
  }
}
