/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/molecules/avatar/zwapAvatar.dart';
import 'package:zwap_design_system/objects/objects.dart';

import 'profileMinimumInfo/profileMinimumInfo.dart';
import 'nameProfileInfo/nameProfileInfo.dart';


/// The profile card component
class ProfileCard extends StatefulWidget {

  final PublicUser publicUser;

  ProfileCard({Key? key,
    required this.publicUser
  }): super(key: key);

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  /// It gets the profile card body content
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: getMultipleConditions(40.0, 40.0, 30.0, 20.0, 10.0)),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20, right: 5, left: 5),
                child: ZwapAvatar(
                  avatarImage: Image.network(widget.publicUser.getAvatarPic),
                  size: 100,
                ),
              ),
              NameAndInfoProfileWidget(
                publicUser: widget.publicUser,
              ),
              widget.publicUser.hasMinimumInfo
                  ? ProfileMinimumInfo(
                      publicUser: widget.publicUser,
                    )
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}


