/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:zwap_design_system/base/base.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

import 'targetsRow.dart';

/// It creates the targets component to show title and many rows as targets inside a card
class TargetsWidget extends StatelessWidget{

  /// The targets mapping info
  final Map<String, Map<String, dynamic>> targetsMappingInfo;

  TargetsWidget({Key? key,
    required this.targetsMappingInfo
  }): super(key: key);


  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          BaseText(
            texts: [Utils.getIt<LocalizationClass>().dynamicValue('targetsTitle')],
            baseTextsType: [BaseTextType.title],
            textsColor: [DesignColors.pinkyPrimary],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 23),
            child: TargetsRow(targetsMappingInfo: this.targetsMappingInfo),
          )
        ],
      );
  }
}