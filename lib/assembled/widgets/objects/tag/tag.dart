/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The kind of tag type for the style
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

  /// Optionally icon inside this element
  final IconData? icon;

  /// Optionally callBack function on icon click
  final Function()? callBackClick;

  TagElement({Key? key,
    required this.tagText,
    this.tagStyleType = TagStyleType.blueTag,
    this.icon,
    this.callBackClick
  }): super(key: key){
    if(this.icon == null){
      assert(this.callBackClick == null, "callBack click function must be null if icon is null");
    }
    else{
      assert(this.callBackClick != null, "callBack click function must be not null if icon is not null");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(ConstantsValue.radiusValue)),
          color: this.tagStyleType == TagStyleType.blueTag ? DesignColors.lightBlueButton : DesignColors.pinkyPrimary
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: Row(
          children: [
            this.icon != null ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () => this.callBackClick!(),
                child: Icon(
                    this.icon
                ),
              ),
            ) : Container(),
            BaseText(
              texts: [this.tagText],
              baseTextsType: [BaseTextType.normal],
              textsColor: [this.tagStyleType == TagStyleType.blueTag ? DesignColors.bluePrimary : Colors.white],
              textAlignment: Alignment.center,
            )
          ],
        ),
      ),
    );
  }
}