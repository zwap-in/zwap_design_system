/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom image to display an item inside the edit target card
class TargetItem extends StatelessWidget{

  /// The image path of the target inside the current item
  final String imagePath;

  /// The title of the current target
  final String titleItem;

  /// Is this target to add or to remove
  final bool isToAdd;

  /// The callBack function to trigger on click on the button inside the target item
  final Function() buttonTriggered;

  TargetItem({Key? key,
    required this.imagePath,
    required this.titleItem,
    required this.buttonTriggered,
    this.isToAdd = true,
  }): super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: DesignColors.greyPrimary),
          bottom: BorderSide(width: 1.0, color: DesignColors.greyPrimary),
          left: BorderSide(width: 1.0, color: DesignColors.greyPrimary),
          right: BorderSide(width: 1.0, color: DesignColors.greyPrimary)
        ),
        borderRadius: BorderRadius.circular(ConstantsValue.radiusValue),
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: CustomAsset(
                  assetPathUrl: this.imagePath,
                  isInternal: false,
                ),
              ),
              flex: 0,
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 5),
                child:  BaseText(
                  texts: [this.titleItem],
                  baseTextsType: [BaseTextType.normal],
                )
              ),
              flex: 3,
            ),
            Flexible(
              child: this.isToAdd ? BaseButton(
                buttonTypeStyle: ButtonTypeStyle.lightBlueButton,
                onPressedCallback: () => this.buttonTriggered(),
                buttonText: LocalizationClass.of(context).dynamicValue("addButton"),
              ) : BaseButton(
                buttonTypeStyle: ButtonTypeStyle.pinkyButton,
                onPressedCallback: () => this.buttonTriggered(),
                buttonText: LocalizationClass.of(context).dynamicValue("removeButton"),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }



}