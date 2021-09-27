/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// Define the switch provider state
class ZwapSwitch extends StatefulWidget {

  /// The callBack funtion to handle new value inside the switch
  final Function(bool newValue) handleCallBack;

  /// The predefined value
  final bool? predefinedValue;

  ZwapSwitch({Key? key,
    required this.predefinedValue,
    required this.handleCallBack
  }): super(key: key);

  _ZwapSwitchState createState() => _ZwapSwitchState(value: this.predefinedValue ?? false);

}

/// Custom widget to display a switch component
class _ZwapSwitchState extends State<ZwapSwitch> {

  /// The current value
  bool value;

  _ZwapSwitchState({required this.value});

  /// It handles the change inside the switch state
  void handleChange(bool newValue) {
    widget.handleCallBack(newValue);
    setState(() {
      this.value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      activeColor: ZwapColors.primary700,
      trackColor: ZwapColors.neutral200,
      value: this.value,
      onChanged: (bool value) => this.handleChange(value),
    );
  }
}
