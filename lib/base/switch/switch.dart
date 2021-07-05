/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  final Function(bool value) onChange;

  CustomSwitch({Key? key,
    required this.onChange
  }): super(key: key);

  void handleChange(BuildContext context){
    bool value = context.read<CustomSwitchState>().value;
    context.read<CustomSwitchState>().changeState(value);
    this.onChange(value);
  }


  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        title: Container(),
        onTap: () => this.handleChange(context),
          trailing: Consumer<CustomSwitchState>(
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