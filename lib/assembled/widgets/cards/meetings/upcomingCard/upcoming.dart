/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The UpComing card with next meetings details
class UpComingMeeting extends StatelessWidget{

  /// The meeting title
  final String title;

  /// The datetime for the next meeting
  final DateTime datetime;

  UpComingMeeting({Key? key,
    required this.title,
    required this.datetime
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      cardWidth: 400,
      cardStyleType: CardStyleType.leftBlueBorderCard,
      childComponent: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            BaseText(
              texts: [this.title],
              baseTextsType: [BaseTextType.normalBold],
            ),
            Row(
              children: [
                Flexible(
                    child: BaseText(
                      texts: ["${this.datetime.hour}:${this.datetime.minute} ${this.datetime.day}/${this.datetime.month}"],
                      baseTextsType: [BaseTextType.normal],
                    )
                ),
                Flexible(
                  child: CustomIcon(
                    icon: Icons.settings,
                    callBackPressedFunction: (){},
                    iconColor: DesignColors.greyPrimary,
                  ),
                  flex: 0,
                )
              ],
            )
          ],
        ),
      ),
    );
  }


}