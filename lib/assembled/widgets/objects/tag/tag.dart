/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

enum TagStyleType{
  pinkyTag,
  blueTag
}


/// Custom element to render a tag element similar to a button element
class TagElement extends StatelessWidget{

  /// The interest text inside this widget
  final String tagText;

  /// The tag element style type
  final TagStyleType tagStyleType;

  TagElement({Key? key,
    required this.tagText,
    this.tagStyleType = TagStyleType.blueTag
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(ConstantsValue.radiusValue)),
          color: this.tagStyleType == TagStyleType.blueTag ? DesignColors.lightBlueButton : DesignColors.pinkyPrimary
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: BaseText(
          texts: [this.tagText],
          baseTextsType: [BaseTextType.normal],
          textsColor: [this.tagStyleType == TagStyleType.blueTag ? DesignColors.bluePrimary : Colors.white],
        ),
      ),
    );
  }
}