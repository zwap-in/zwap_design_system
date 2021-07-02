import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zwap_design_system/zwap_design_system.dart';

/// Reschedule card component
class ScheduledCard extends StatelessWidget{

  /// The meeting scheduled info
  final Map<DateTime, List<MeetingDetails>> scheduled;

  /// The callBack function to reschedule any meeting
  final Function(int pk) rescheduleMeetingCallback;

  /// The callback function to cancel any meeting
  final Function(int pk) cancelMeetingCallBack;

  ScheduledCard({Key? key,
    required this.scheduled,
    required this.rescheduleMeetingCallback,
    required this.cancelMeetingCallBack
  }): super(key: key);

  /// It retrieves the info about all widgets
  List<Widget> _meetingsList(List<MeetingDetails> meetings){
    List<Widget> finals = [];
    meetings.forEach((element) {
      String dateTime = "${element.dateTimeStart.hour}:${element.dateTimeStart.minute} - ${element.dateTimeEnd.hour}:${element.dateTimeEnd.minute}";
      finals.add(
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Flexible(
                  child: CustomCheckbox(isDone: true,)
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 30),
                  child: BaseText(
                    texts: ["$dateTime - ${element.title}"],
                    baseTextsType: [BaseTextType.normal],
                  ),
                ),
                flex: 2,
              ),
              Flexible(
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: BaseButton(
                          iconButton: FontAwesomeIcons.trash,
                          buttonText: Utils.getIt<LocalizationClass>().dynamicValue('rescheduleButton'),
                          buttonTypeStyle: ButtonTypeStyle.greyButton,
                          onPressedCallback: () => this.rescheduleMeetingCallback(element.pk),
                          iconColor: DesignColors.blackPrimary,
                        ),
                      ),

                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: BaseButton(
                          iconButton: FontAwesomeIcons.trash,
                          buttonText: Utils.getIt<LocalizationClass>().dynamicValue("cancelButton"),
                          buttonTypeStyle: ButtonTypeStyle.greyButton,
                          onPressedCallback: () => this.cancelMeetingCallBack(element.pk),
                          iconColor: DesignColors.blackPrimary,
                        ),
                      ),
                    )
                  ],
                ),
                flex: 2,
              )
            ],
          ),
        ),
      );
    });
    return finals;
  }

  /// It retrieves the info about all day meetings
  List<Widget> _dayMeetings(){
    List<Widget> finals = [];
    this.scheduled.forEach((DateTime key, List<MeetingDetails> value) {
      String dateTimeInfo = "${Constants.weekDayAbbrName()[key.weekday]}, ${key.day} ${Constants.monthlyName()[key.month]} ${key.year}";
      List<Widget> meetingChildren = [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: BaseText(
              texts: ['$dateTimeInfo ', Utils.getIt<LocalizationClass>().dynamicValue('today')],
              baseTextsType: [BaseTextType.normal, BaseTextType.normalBold]
          ),
        )
      ];
      meetingChildren.addAll(this._meetingsList(value));
      finals.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: meetingChildren,
            ),
          )
      );
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _children = [
      Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: BaseText(
          texts: [Utils.getIt<LocalizationClass>().dynamicValue("meetingsScheduledTitle")],
          baseTextsType: [BaseTextType.title],
          textsColor: [DesignColors.pinkyPrimary],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 5),
        child: BaseText(
          texts: [Utils.getIt<LocalizationClass>().dynamicValue("meetingsScheduledSubTitle")],
          baseTextsType: [BaseTextType.subTitle],
          textsColor: [DesignColors.greyPrimary],
        ),
      ),
    ];
    _children.addAll(this._dayMeetings());
    return CustomCard(
        childComponent: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: _children,
          ),
        )
    );
  }

}