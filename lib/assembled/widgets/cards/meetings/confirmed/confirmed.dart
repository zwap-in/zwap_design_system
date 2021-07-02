import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

/// The meeting confirmed component
class MeetingConfirmed extends StatelessWidget{

  /// Find other people callBack function
  final Function() findOtherPeople;

  /// View your meeting callBack function
  final Function() viewYourMeeting;

  MeetingConfirmed({Key? key,
    required this.findOtherPeople,
    required this.viewYourMeeting
  }): super(key: key);

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
              texts: [Utils.getIt<LocalizationClass>().dynamicValue("meetingConfirmedTitle")],
              baseTextsType: [BaseTextType.title],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 10),
            child: BaseText(
              texts: [Utils.getIt<LocalizationClass>().dynamicValue("meetingConfirmedSubTitle")],
              baseTextsType: [BaseTextType.normal],
              textsColor: [DesignColors.greyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: BaseText(
              texts: [Utils.getIt<LocalizationClass>().dynamicValue("nextStepsMeetingConfirmed")],
              baseTextsType: [BaseTextType.normal],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: BaseButton(
              iconButton: Icons.group_add,
                buttonText: Utils.getIt<LocalizationClass>().dynamicValue("findPeopleOnZwap"),
                buttonTypeStyle: ButtonTypeStyle.continueButton,
                onPressedCallback: () => this.findOtherPeople()
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: BaseButton(
                buttonText: Utils.getIt<LocalizationClass>().dynamicValue("viewYourMeeting"),
                buttonTypeStyle: ButtonTypeStyle.backButton,
                onPressedCallback: () => this.viewYourMeeting()
            ),
          ),
        ],
      ),
    );
  }

}