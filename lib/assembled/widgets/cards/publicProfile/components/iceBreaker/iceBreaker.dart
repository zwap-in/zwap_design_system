/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// widget to show iceBreaker inside the profile card
class IceBreaker extends StatelessWidget{

  /// The iceBreaker text value
  final String iceBreakerValue;

  IceBreaker({Key? key,
    required this.iceBreakerValue
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: BaseText(
            texts: [Utils.getIt<LocalizationClass>().dynamicValue("wantTalkAboutTitle")],
            textsColor: [DesignColors.pinkyPrimary],
            baseTextsType: [BaseTextType.title],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: BaseText(
            texts: [this.iceBreakerValue],
            baseTextsType: [BaseTextType.normal],
          ),
        ),
      ],
    );
  }

}