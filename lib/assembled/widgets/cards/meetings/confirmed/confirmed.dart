import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

class MeetingConfirmed extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      childComponent: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: CustomAsset(
              assetPathUrl: "",
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: BaseText(
              texts: ["Il tuo meeting è confermato"],
              baseTextsType: [BaseTextType.title],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 10),
            child: BaseText(
              texts: ["Ecco quali sono i prossimi passi"],
              baseTextsType: [BaseTextType.normal],
              textsColor: [DesignColors.greyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: BaseText(
              texts: ["uno"],
              baseTextsType: [BaseTextType.normal],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: BaseButton(
              iconButton: Icons.group_add,
                buttonText: "Scopri chi è su Zwap",
                buttonTypeStyle: ButtonTypeStyle.continueButton,
                onPressedCallback: (){}
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: BaseButton(
                buttonText: "Vedi i tuoi meeting",
                buttonTypeStyle: ButtonTypeStyle.backButton,
                onPressedCallback: (){}
            ),
          ),
        ],
      ),
    );
  }

}