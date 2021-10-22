/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// It defines the possible status type
enum ZwapCheckBoxStatus {
  unselected,
  hover,
  disabled,
  error,
  selected,
  selectedHover,
  selectedActive,
  selectedDisabled,
  indeterminateDisabled
}

/// The state for this component with a provider
class ZwapCheckBox extends StatefulWidget {

  /// The text inside this checkbox component
  final String text;

  /// It handles the click on checkbox
  final Function(bool isSelected) onCheckBoxClick;

  /// Initial bool value for this checkbox
  final bool initialValue;

  /// On text click on checkbox
  final Function()? onTextClick;

  ZwapCheckBox({Key? key,
    required this.text,
    required this.onCheckBoxClick,
    this.initialValue = false,
    this.onTextClick
  }) : super(key: key);

  _ZwapCheckBoxState createState() => _ZwapCheckBoxState(this.initialValue);
}

/// Standard component to render a checkbox with Zwap standard style
class _ZwapCheckBoxState extends State<ZwapCheckBox> {
  /// The status with a default value equal to unselected
  ZwapCheckBoxStatus _status = ZwapCheckBoxStatus.unselected;

  _ZwapCheckBoxState(bool initialValue){
    this._status = initialValue ? ZwapCheckBoxStatus.selected : ZwapCheckBoxStatus.unselected;
  }

  /// It handles the hover status on this component
  void _hoverStatus(bool value) {
    if (value) {
      if (this._status == ZwapCheckBoxStatus.selected) {
        this._changeStatus(ZwapCheckBoxStatus.selectedHover);
      } else if (this._status == ZwapCheckBoxStatus.unselected) {
        this._changeStatus(ZwapCheckBoxStatus.hover);
      }
    } else {
      if (this._status == ZwapCheckBoxStatus.selectedHover) {
        this._changeStatus(ZwapCheckBoxStatus.selected);
      } else if (this._status == ZwapCheckBoxStatus.hover) {
        this._changeStatus(ZwapCheckBoxStatus.unselected);
      }
    }
  }

  /// It handles the tap on this component
  void _onTap() {
    this._changeStatus(this._status == ZwapCheckBoxStatus.selected ||
            this._status == ZwapCheckBoxStatus.selectedHover
        ? ZwapCheckBoxStatus.unselected
        : ZwapCheckBoxStatus.selected);
  }

  void _changeStatus(ZwapCheckBoxStatus status) {
    widget.onCheckBoxClick(status == ZwapCheckBoxStatus.selected);
    setState(() {
      this._status = status;
    });
  }

  /// It retrieves the text color in base of the status param inside the provider
  Color _getTextColor() {
    Color textColor = ZwapColors.neutral800;
    switch (this._status) {
      case ZwapCheckBoxStatus.unselected:
        break;
      case ZwapCheckBoxStatus.hover:
        break;
      case ZwapCheckBoxStatus.disabled:
        textColor = ZwapColors.neutral700;
        break;
      case ZwapCheckBoxStatus.error:
        textColor = ZwapColors.error400;
        break;
      case ZwapCheckBoxStatus.selected:
        break;
      case ZwapCheckBoxStatus.selectedHover:
        break;
      case ZwapCheckBoxStatus.selectedActive:
        break;
      case ZwapCheckBoxStatus.selectedDisabled:
        textColor = ZwapColors.neutral400;
        break;
      case ZwapCheckBoxStatus.indeterminateDisabled:
        textColor = ZwapColors.neutral400;
        break;
    }
    return textColor;
  }

  /// It retrieves the box decoration in base of the status inside the provider
  BoxDecoration _getBoxDecoration() {
    Color boxColor = ZwapColors.shades0;
    Color borderColor = ZwapColors.neutral300;
    switch (this._status) {
      case ZwapCheckBoxStatus.unselected:
        break;
      case ZwapCheckBoxStatus.hover:
        boxColor = ZwapColors.neutral50;
        break;
      case ZwapCheckBoxStatus.disabled:
        borderColor = Color(0xFFD4D4D4);
        break;
      case ZwapCheckBoxStatus.error:
        borderColor = ZwapColors.error200;
        boxColor = ZwapColors.error200;
        break;
      case ZwapCheckBoxStatus.selected:
        boxColor = ZwapColors.primary700;
        borderColor = ZwapColors.primary700;
        break;
      case ZwapCheckBoxStatus.selectedHover:
        boxColor = ZwapColors.primary800;
        borderColor = ZwapColors.primary800;
        break;
      case ZwapCheckBoxStatus.selectedActive:
        boxColor = ZwapColors.primary900;
        borderColor = ZwapColors.primary900;
        break;
      case ZwapCheckBoxStatus.selectedDisabled:
        boxColor = ZwapColors.primary200;
        borderColor = ZwapColors.primary200;
        break;
      case ZwapCheckBoxStatus.indeterminateDisabled:
        boxColor = ZwapColors.primary200;
        borderColor = ZwapColors.primary200;
        break;
    }
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: borderColor),
        color: boxColor);
  }

  /// It retrieves the icon inside the component in base of the current status inside the provider
  Widget _getIconChild() {
    switch (this._status) {
      case ZwapCheckBoxStatus.unselected:
        return Container(
          height: 20,
          width: 20,
        );
      case ZwapCheckBoxStatus.hover:
        return Container(
          height: 20,
          width: 20,
        );
      case ZwapCheckBoxStatus.disabled:
        return Container(
          height: 20,
          width: 20,
        );
      case ZwapCheckBoxStatus.error:
        return Container(
          height: 20,
          width: 20,
        );
      case ZwapCheckBoxStatus.selected:
        return Icon(
          Icons.verified_rounded,
          size: 20,
          color: ZwapColors.shades0,
        );
      case ZwapCheckBoxStatus.selectedHover:
        return Icon(
          Icons.verified_rounded,
          size: 20,
          color: ZwapColors.shades0,
        );
      case ZwapCheckBoxStatus.selectedActive:
        return Icon(
          Icons.verified_rounded,
          size: 20,
          color: ZwapColors.shades0,
        );
      case ZwapCheckBoxStatus.selectedDisabled:
        return Icon(
          Icons.verified_rounded,
          size: 20,
          color: ZwapColors.shades0,
        );
      case ZwapCheckBoxStatus.indeterminateDisabled:
        return Icon(
          Icons.verified_rounded,
          size: 20,
          color: ZwapColors.shades0,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget text = ZwapText(
      text: widget.text,
      zwapTextType: ZwapTextType.body1Regular,
      textColor: this._getTextColor(),
    );
    return Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: 0,
          child: Padding(
            padding: EdgeInsets.only(right: 6),
            child: Container(
              decoration: this._getBoxDecoration(),
              child: Padding(
                  padding: EdgeInsets.all(6),
                  child: InkWell(
                    onTap: () => this._onTap(),
                    onHover: (bool value) => this._hoverStatus(value),
                    child: this._getIconChild(),
                  )),
            ),
          ),
        ),
        Flexible(
            fit: FlexFit.tight,
            flex: 0,
            child: Padding(
              padding: EdgeInsets.only(left: 6),
              child: widget.onTextClick != null ? InkWell(
                onTap: () => widget.onTextClick!(),
                child: text,
              ) : text,
            ))
      ],
    );
  }
}
