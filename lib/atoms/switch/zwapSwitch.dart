/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';

/// Define the switch provider state
class ZwapSwitch extends StatefulWidget {

  /// The callBack function to handle new value inside the switch
  final Function(bool newValue) handleCallBack;

  /// The predefined value
  final bool? predefinedValue;

  /// The scale size for this custom switch component
  final double? scaleSize;

  ZwapSwitch({Key? key,
    required this.predefinedValue,
    required this.handleCallBack,
    this.scaleSize
  }): super(key: key);

  ZwapSwitchState createState() => ZwapSwitchState(value: this.predefinedValue ?? false);

}

/// Custom widget to display a switch component
class ZwapSwitchState extends State<ZwapSwitch> {

  /// The current value
  bool value;

  ZwapSwitchState({required this.value});

  /// It handles the change inside the switch state
  void handleChange(bool newValue) {
    widget.handleCallBack(newValue);
    setState(() {
      this.value = newValue;
    });
  }

  /// It reInit the state for this component
  void reInitState(bool newValue){
    setState(() {
      this.value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scaleSize ?? 1.0,
      child: CupertinoSwitch(
        activeColor: ZwapColors.primary700,
        trackColor: ZwapColors.neutral200,
        value: this.value,
        onChanged: (bool value) => this.handleChange(value),
      ),
    );
  }
}
