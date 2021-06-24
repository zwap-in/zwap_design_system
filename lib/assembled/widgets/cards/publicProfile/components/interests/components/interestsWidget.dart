/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

import 'interestsRow.dart';

/// A custom widget to display interests inside a custom element inside the profile card
class InterestsWidget extends StatelessWidget{

  /// The interests list to show inside this custom widget
  final List<String> interestsList;

  InterestsWidget({Key? key,
    required this.interestsList
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: BaseText(
            texts: [LocalizationClass.of(context).dynamicValue("interestedInTitle")],
            textsColor: [DesignColors.pinkyPrimary],
            baseTextsType: [BaseTextType.title],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: InterestsRow(
              interestsList: this.interestsList
          ),
        )
      ],
    );
  }


}