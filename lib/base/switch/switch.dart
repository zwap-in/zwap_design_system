/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Define custom switch
class CustomSwitch extends StatefulWidget{

  /// Handle the change of the value inside the switch button
  final Function(bool newValue) changeValue;

  /// The value to show inside this switch
  final bool? isActive;

  CustomSwitch({Key? key,
    required this.changeValue,
    this.isActive,
  }): super(key: key);

  _CustomSwitchState createState() => _CustomSwitchState();

}

class _CustomSwitchState extends State<CustomSwitch>{

  /// Is the switch active or not?
  bool _isOn = false;

  /// Init the state
  _CustomSwitchState(){
   this._isOn = widget.isActive ?? false;
  }

  /// Change the state inside this switch
  void _changeState(bool value){
    setState(() {
      this._isOn = value;
    });
    this._changeState(value);
  }

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        title: Container(),
        trailing: CupertinoSwitch(
          value: this._isOn,
          onChanged: (bool value) => this._changeState(value),
        ),
        onTap: () => this._changeState(!this._isOn),
      ),
    );
  }



}