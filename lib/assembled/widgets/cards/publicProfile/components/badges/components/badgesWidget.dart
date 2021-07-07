/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

import 'badgesRow.dart';

/// custom widget to show badges inside the profile card widget
class BadgesWidget extends StatelessWidget{

  /// The targets mapping info
  final Map<String, Map<String, dynamic>> badgesMappingInfo;

  BadgesWidget({Key? key,
    required this.badgesMappingInfo
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: BaseText(
              texts: [Utils.translatedText("memberOfTitle")],
              baseTextsType: [BaseTextType.title],
              textsColor: [DesignColors.pinkyPrimary],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 23),
          child: BadgesRow(
              badgesMappingInfo: this.badgesMappingInfo
          ),
        )
      ],
    );
  }


}