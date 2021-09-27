/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/organism/organism.dart';

/// Widget to rendering the common connections info
class ZwapCommonConnections extends StatelessWidget{

  /// The text for this widget
  final String commonConnectionsText;

  /// The image paths for the common connection accounts
  final Map<String, bool> imagePaths;

  ZwapCommonConnections({Key? key,
    required this.commonConnectionsText,
    required this.imagePaths
  }): super(key: key);

  Widget build(BuildContext context){
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: ZwapGroupedAvatars(
              avatarImagePaths: imagePaths,
            ),
          ),
          flex: 0,
          fit: FlexFit.tight,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 4),
            child: ZwapText(
              textColor: ZwapColors.neutral700,
              zwapTextType: ZwapTextType.body2Regular,
              text: this.commonConnectionsText,
            ),
          ),
          flex: 0,
          fit: FlexFit.tight,
        )
      ],
    );
  }

}