/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

import 'upcoming.dart';

/// The meeting details abstract class to pass to the UpComing card
class MeetingDetails{

  /// The title of the UpComing card
  final String title;

  /// The meeting datetime
  final DateTime dateTime;

  MeetingDetails({
    required this.title,
    required this.dateTime
  });
}

/// The upComing card to display the upcoming meetings
class UpComingCard extends StatelessWidget{

  /// The next upcoming meeting
  final List<MeetingDetails> upcomingMeetings;

  UpComingCard({Key? key,
    required this.upcomingMeetings,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    
    List<Widget> _children = [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: BaseText(
          texts: [LocalizationClass.of(context).dynamicValue("nextMeetings")],
          baseTextsType: [BaseTextType.title],
        ),
      )
    ];
    
    this.upcomingMeetings.forEach((element) { 
      _children.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: UpComingMeeting(title: element.title, datetime: element.dateTime),
        )
      );
    });

    _children.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: BaseButton(
          buttonText: LocalizationClass.of(context).dynamicValue("schedule"),
          buttonTypeStyle: ButtonTypeStyle.continueButton,
          onPressedCallback: (){},
          iconButton: FontAwesomeIcons.globe,
        ),
      )
    );

    _children.add(
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: BaseText(
          texts: [LocalizationClass.of(context).dynamicValue("viewAllMeetings")],
          baseTextsType: [BaseTextType.normalBold],
          textsColor: [DesignColors.bluePrimary],
          textAlignment: Alignment.center,
        ),
      )
    );
    
    return CustomCard(
      cardWidth: 400,
      childComponent: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: VerticalScroll(
          childComponent: Column(
            children: _children,
          ),
        ),
      ),
    );
  }



}