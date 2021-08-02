/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Define the switch provider state
class ZwapSwitchState extends ChangeNotifier{

  /// The value of this state
  bool value;

  ZwapSwitchState({required this.value});

  /// Change the state inside this switch
  void changeState(bool value){
   this.value = value;
   notifyListeners();
  }

}

/// Custom widget to display a switch component
class ZwapSwitch extends StatelessWidget{

  /// Handle the change inside the switch state
  void handleChange(BuildContext context){
    bool value = context.read<ZwapSwitchState>().value;
    context.read<ZwapSwitchState>().changeState(value);
  }

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        title: Container(),
        onTap: () => this.handleChange(context),
          trailing: Consumer<ZwapSwitchState>(
            builder: (builder, provider, child){
              return CupertinoSwitch(
                value: provider.value,
                onChanged: (bool value) => provider.changeState(value),
              );
            }
          ),
        )
    );
  }



}