import 'package:flutter/cupertino.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

class PlanMeetingCard extends StatelessWidget{

  final List<String> networksList;

  PlanMeetingCard({Key? key,
    required this.networksList
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      childComponent: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 5),
            child: BaseText(
              texts: [Utils.translatedText("scheduleNextMeeting")],
              baseTextsType: [BaseTextType.title],
              textsColor: [DesignColors.pinkyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: BaseText(
              texts: [Utils.translatedText("scheduleNextMeetingSubTitle")],
              baseTextsType: [BaseTextType.subTitle],
              textsColor: [DesignColors.greyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: CalendarPicker(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: FiltersPlan(
              networksList: this.networksList,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BaseButton(
                  buttonTypeStyle: ButtonTypeStyle.continueButton,
                  buttonText: Utils.translatedText("schedule"),
                  iconButton: IconData(Utils.iconData("key"), fontFamily: "zwapIcon"),
                  onPressedCallback: () => {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }



}