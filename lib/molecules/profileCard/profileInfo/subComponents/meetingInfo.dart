import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';

import 'package:zwap_design_system/atoms/atoms.dart';

class MeetingInfo extends StatelessWidget{

  final int totalMeetings;

  MeetingInfo({Key? key,
    required this.totalMeetings
  }): super(key: key);

  Widget build(BuildContext context){
    return this.totalMeetings > 0
        ? Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5),
      child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "${this.totalMeetings}",
              style: ZwapTypography.bodySemiBold().apply(color: ZwapColors.primary700),
            ),
            TextSpan(text: " ${Utils.translatedText("profile_meeting")}", style: ZwapTypography.bodyRegular().apply(color: ZwapColors.neutral500))
          ])),
    )
        : Container();
  }

}