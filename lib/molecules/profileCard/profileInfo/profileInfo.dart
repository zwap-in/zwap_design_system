/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING DESIGN SYSTEM PACKAGES KIT
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/objects/objects.dart';

import 'subComponents/inviterInfo.dart';
import 'subComponents/meetingInfo.dart';

/// Component to show the profile info inside the profile screen
class ProfileInfo extends StatelessWidget {
  final int totalMeetings;

  final String username;

  final String locationInfo;

  final String roleCompanyInfo;

  final InvitedByUser? invitedBy;

  ProfileInfo(
      {Key? key,
      required this.totalMeetings,
      required this.username,
      required this.locationInfo,
      required this.roleCompanyInfo,
      required this.invitedBy})
      : super(key: key);

  /// It retrieves the widgets about the info of the user
  String _getInfoWidgets() {
    bool usernameCheck = false;
    bool roleCompanyCheck = false;
    String finalText = "";
    if (username != "") {
      usernameCheck = true;
      finalText += "@${this.username} ";
    }
    if (roleCompanyInfo != "") {
      if (usernameCheck) {
        finalText += " | ";
      }
      roleCompanyCheck = true;
      finalText += roleCompanyInfo;
    }
    if (locationInfo != "") {
      if (roleCompanyCheck || usernameCheck) {
        finalText += " | ";
      }
      finalText += locationInfo;
    }
    return finalText;
  }

  @override
  Widget build(BuildContext context) {
    String finalText = this._getInfoWidgets();
    Widget profileInfoText = ZwapText.selectable(
      text: finalText,
      textColor: ZwapColors.neutral500,
      zwapTextType: ZwapTextType.bodyRegular,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 1.5),
          child: getMultipleConditions(
              profileInfoText,
              profileInfoText,
              profileInfoText,
              SizedBox(
                width: 275,
                child: profileInfoText,
              ),
              SizedBox(
                width: 220,
                child: profileInfoText,
              )),
        ),
        InviterInfo(invitedBy: invitedBy),
        MeetingInfo(totalMeetings: totalMeetings)
      ],
    );
  }
}
