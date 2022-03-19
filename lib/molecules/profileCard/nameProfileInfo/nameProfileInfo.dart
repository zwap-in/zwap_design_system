/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:zwap_design_system/objects/objects.dart';
import 'package:zwap_design_system/molecules/profileCard/nameLanguagesRow/nameLanguagesRow.dart';
import 'package:zwap_design_system/molecules/profileCard/profileInfo/profileInfo.dart';


/// The provider state for NameAndInfoProfileWidget hoovering
class NameAndInfoProfileWidgetProvider extends ChangeNotifier {
  /// Is hovering the section or not
  bool isHoveredSection = false;

  /// It handles the hover on section
  void hoverSection(bool newValue) {
    this.isHoveredSection = newValue;
    notifyListeners();
  }
}

class NameAndInfoProfileWidget extends StatelessWidget {

  final PublicUser publicUser;

  NameAndInfoProfileWidget({Key? key,
    required this.publicUser
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NameAndInfoProfileWidgetProvider>(
      create: (_) => NameAndInfoProfileWidgetProvider(),
      builder: (context, child) {
        return InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => {},
          onHover: (bool newValue) => context.read<NameAndInfoProfileWidgetProvider>().hoverSection(newValue),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 5.5, bottom: 1, right: 5, left: 5),
                child: NameLanguagesRow(
                  name: this.publicUser.name,
                  surname: this.publicUser.surname,
                  isTopUser: this.publicUser.isTopUser,
                  languages: this.publicUser.getLanguages,
                  isPremium: this.publicUser.isPremium,
                ),
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                  child: ProfileInfo(
                    locationInfo: this.publicUser.getLocationInfo,
                    totalMeetings: this.publicUser.totalMeetings,
                    invitedBy: this.publicUser.invitedBy,
                    username: this.publicUser.username,
                    roleCompanyInfo: this.publicUser.getRoleCompanyInfo,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}