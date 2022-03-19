/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING DESIGN SYSTEM KIT COMPONENTS
import 'package:zwap_design_system/molecules/molecules.dart';


/// The profile bio component
class ProfileBio extends StatelessWidget {

  /// The user bio text value
  final String userBio;

  ProfileBio({Key? key,
    required this.userBio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getMultipleConditions<bool>(false, false, false, true, true)
          ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ZwapLongText(
            text: userBio,
            readMoreText: " ${Utils.translatedText("profile_bio_expander")}",
            readLessText: " ${Utils.translatedText("profile_bio_cropped")}",
            maxChars: 200,
          ),
        ],
      )
          : Row(
        children: [
          Expanded(
            child: ZwapLongText(
              text: userBio,
              readMoreText: " ${Utils.translatedText("profile_bio_expander")}",
              readLessText: " ${Utils.translatedText("profile_bio_cropped")}",
              maxChars: 200,
            ),
          ),
        ],
      ),
    );
  }
}
