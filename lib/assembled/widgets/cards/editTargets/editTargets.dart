import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

class EditTargetState extends ChangeNotifier{

  Map<TargetData, bool> targetsValue;

  EditTargetState(this.targetsValue);

  void changeTargetsMapping(TargetData element, bool newValue){
    this.targetsValue[element] = newValue;
    notifyListeners();
  }

}

class EditTargets extends StatelessWidget{

  final EditTargetState provider;

  EditTargets({Key? key,
    required this.provider,
  }): super(key: key);

  List<Widget> _itemElements(){
    List<Widget> tmp = [];
    this.provider.targetsValue.forEach((TargetData element, bool flagValue) {
      tmp.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: TargetItem(
            buttonTriggered: () => {
              this.provider.changeTargetsMapping(element, !flagValue)
            },
            titleItem: element.targetName,
            imagePath: element.targetImage,
            isToAdd: flagValue,
          ),
        ),
      );
    });
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      cardWidth: 900,
      childComponent: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: this._itemElements(),
        ),
      ),
    );
  }



}