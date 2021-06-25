/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Define custom switch
class CustomSwitchState extends ChangeNotifier{

  /// The value of this state
  bool value;

  CustomSwitchState({required this.value});

  /// Change the state inside this switch
  void changeState(bool value){
   this.value = value;
   notifyListeners();
  }

}

/// Custom widget to display a switch component
class CustomSwitch extends StatelessWidget{

  /// The provider to handle change and the current state
  final CustomSwitchState provider;

  CustomSwitch({Key? key,
    required this.provider
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        title: Container(),
        trailing: CupertinoSwitch(
          value: this.provider.value,
          onChanged: (bool value) => this.provider.changeState(value),
        ),
        onTap: () => this.provider.changeState(!this.provider.value),
      ),
    );
  }



}