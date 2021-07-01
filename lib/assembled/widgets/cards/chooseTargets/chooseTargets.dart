/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taastrap/colStrap/colStrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The class to handle the targets state
class TargetsState extends ChangeNotifier{

  /// The targets mapping selected state
  Map<TargetData, bool> targetsMapping = {};

  /// The targets list
  final List<TargetData> targets;

  TargetsState({required this.targets}){
    this.targets.forEach((TargetData element) {
      this.targetsMapping[element] = false;
    });
  }

  /// Selecting any target
  void selectTarget(TargetData element){
    this.targetsMapping[element] = this.targetsMapping[element]!;
    notifyListeners();
  }

}


/// The choose targets card element
class ChooseTargets extends StatelessWidget{

  /// The back button callBack function
  final Function() backButtonCallBack;

  /// The continue button callBack function
  final Function() continueButtonCallBack;

  final TargetsState provider;

  ChooseTargets({Key? key,
    required this.backButtonCallBack,
    required this.continueButtonCallBack,
    required this.provider
  }): super(key: key);

  /// It retrieves the responsive way to choose the targets inside this custom card
  Map<Widget, Map<String, int>> targetsRow(){
    Map<Widget, Map<String, int>> children = {};
    this.provider.targetsMapping.forEach((TargetData element, bool value) {
      Widget tmp = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: value ? DesignColors.pinkyPrimary : Colors.black
          )
        ),
        child: InkResponse(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => this.provider.selectTarget(element),
          child: ImageCard(
            imagePath: element.targetImage,
            textCard: element.targetName,
          ),
        ),
      );
      children[tmp] = {'xl': 3, 'lg': 3, 'md': 4, 'sm': 6, 'xs': 6};
    });
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return BaseComplete(
        childrenWidget: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: BaseText(
              texts: [LocalizationClass.of(context).dynamicValue("choiceTargetsTitle")],
              baseTextsType: [BaseTextType.title],
              textsColor: [DesignColors.pinkyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: BaseText(
              texts: [LocalizationClass.of(context).dynamicValue("choiceTargetsSubTitle")],
              baseTextsType: [BaseTextType.subTitle],
              textsColor: [DesignColors.greyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ResponsiveRow(
              children: this.targetsRow(),
            ),
          ),
        ],
        backButtonCallBack: () => this.backButtonCallBack(),
        continueButtonCallBack: () => this.continueButtonCallBack()
    );
  }


}