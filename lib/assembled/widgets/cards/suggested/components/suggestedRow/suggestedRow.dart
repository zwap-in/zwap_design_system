/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';


/// Custom card to retrieve info about any suggested profile
class SuggestedCard extends StatelessWidget{

  /// The profile data about any suggested user
  final User profileData;

  SuggestedCard({Key? key,
    required this.profileData
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: AvatarCircle(imagePath: this.profileData.customData["profilePic"]),
            ),
          flex: 0,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  texts: ["${this.profileData.firstName} ${this.profileData.lastName}"],
                  baseTextsType: [BaseTextType.title],
                ),
                BaseText(
                  texts: ["${this.profileData.customData['role']} @${this.profileData.customData["company"]}"],
                  baseTextsType: [BaseTextType.normal],
                  textsColor: [DesignColors.greyPrimary],
                )
              ],
            ),
          ),
          flex: 0,
        ),
      ],
    );
  }

}