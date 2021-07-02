import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

class EditTargetState extends ChangeNotifier{

  Map<TargetData, bool> targetsValue = {};

  final List<TargetData> targets;

  EditTargetState({required this.targets}){
    this.targets.forEach((element) {
      this.targetsValue[element] = false;
    });
  }

  void changeTargetsMapping(TargetData element, bool newValue){
    this.targetsValue[element] = newValue;
    notifyListeners();
  }

}

class EditTargets extends StatelessWidget{

  final List<TargetData> targets;

  EditTargets({Key? key,
    required this.targets
  }): super(key: key);

  List<Widget> _itemElements(EditTargetState provider){
    List<Widget> tmp = [];
    provider.targetsValue.forEach((TargetData element, bool flagValue) {
      tmp.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: TargetItem(
            buttonTriggered: () => {
              provider.changeTargetsMapping(element, !flagValue)
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
    Utils.getIt.registerFactory(() => EditTargetState(targets: this.targets));
    return CustomCard(
      cardWidth: 900,
      childComponent: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: ProviderCustomer<EditTargetState>(
          childWidget: (EditTargetState provider){
            return Column(
              children: this._itemElements(provider),
            );
          }
        ),
      ),
    );
  }



}