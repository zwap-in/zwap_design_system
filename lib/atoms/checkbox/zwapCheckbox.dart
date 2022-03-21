/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// It defines the possible status type
enum ZwapCheckBoxStatus { unselected, hover, disabled, error, selected, selectedHover, selectedActive, selectedDisabled, indeterminateDisabled }

/// The state for this component with a provider
class ZwapCheckBox extends StatefulWidget {
  /// It handles the click on checkbox
  final Function(bool isSelected) onCheckBoxClick;

  /// Initial bool value for this checkbox
  final bool initialValue;

  ZwapCheckBox({
    Key? key,
    required this.onCheckBoxClick,
    this.initialValue = false,
  }) : super(key: key);

  _ZwapCheckBoxState createState() => _ZwapCheckBoxState();
}

/// Standard component to render a checkbox with Zwap standard style
class _ZwapCheckBoxState extends State<ZwapCheckBox> {
  /// The status with a default value equal to unselected
  ZwapCheckBoxStatus _status = ZwapCheckBoxStatus.unselected;

  final IconData _checkBoxIcon = Icons.check_rounded;

  @override
  void initState() {
    this._status = widget.initialValue ? ZwapCheckBoxStatus.selected : ZwapCheckBoxStatus.unselected;
    super.initState();
  }

  /// It handles the tap on this component
  void _onTap() {
    this._changeStatus(this._status == ZwapCheckBoxStatus.selected || this._status == ZwapCheckBoxStatus.selectedHover
        ? ZwapCheckBoxStatus.unselected
        : ZwapCheckBoxStatus.selected);
  }

  void _changeStatus(ZwapCheckBoxStatus status) {
    widget.onCheckBoxClick(status == ZwapCheckBoxStatus.selected);
    setState(() {
      this._status = status;
    });
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
    return BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), border: Border.all(color: borderColor), color: boxColor);
  }

  double _getIconSize() {
    return getMultipleConditions<double>(17, 17, 16, 15, 15);
  }

  /// It retrieves the icon inside the component in base of the current status inside the provider
  Widget _getIconChild() {
    switch (this._status) {
      case ZwapCheckBoxStatus.unselected:
        return Container(
          height: this._getIconSize(),
          width: this._getIconSize(),
        );
      case ZwapCheckBoxStatus.hover:
        return Container(
          height: this._getIconSize(),
          width: this._getIconSize(),
        );
      case ZwapCheckBoxStatus.disabled:
        return Container(
          height: this._getIconSize(),
          width: this._getIconSize(),
        );
      case ZwapCheckBoxStatus.error:
        return Container(
          height: this._getIconSize(),
          width: this._getIconSize(),
        );
      case ZwapCheckBoxStatus.selected:
        return Icon(
          _checkBoxIcon,
          size: this._getIconSize(),
          color: ZwapColors.shades0,
        );
      case ZwapCheckBoxStatus.selectedHover:
        return Icon(
          _checkBoxIcon,
          size: this._getIconSize(),
          color: ZwapColors.shades0,
        );
      case ZwapCheckBoxStatus.selectedActive:
        return Icon(
          _checkBoxIcon,
          size: this._getIconSize(),
          color: ZwapColors.shades0,
        );
      case ZwapCheckBoxStatus.selectedDisabled:
        return Icon(
          _checkBoxIcon,
          size: this._getIconSize(),
          color: ZwapColors.shades0,
        );
      case ZwapCheckBoxStatus.indeterminateDisabled:
        return Icon(
          _checkBoxIcon,
          size: this._getIconSize(),
          color: ZwapColors.shades0,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => this._onTap(),
      child: Padding(
        padding: EdgeInsets.only(right: 4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: this._getBoxDecoration(),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: this._getIconChild(),
          ),
        ),
      ),
    );
  }
}
