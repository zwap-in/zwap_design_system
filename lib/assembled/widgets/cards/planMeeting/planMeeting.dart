/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom card to schedule and plan a custom meeting
class PlanMeetingCard extends StatelessWidget{

  /// The filters to customize the planning
  final List<NetworkFilterElement> filters;

  /// The days range to show inside the calendar picker
  final List<int> daysRange;

  /// The slots mapping to show custom hour slots for each day
  final Map<int, List<TimeOfDay>> slotsMapping;

  PlanMeetingCard({Key? key,
    required this.filters,
    required this.daysRange,
    required this.slotsMapping
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
              filters: this.filters,
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