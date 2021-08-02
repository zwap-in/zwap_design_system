/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';
import 'package:zwap_design_system/base/text/zwapText.dart';


/// The kind of tag type for the style
enum ZwapTagStyle{
  pinkyTag,
  blueTag
}


/// Custom element to render a tag element similar to a button element
class ZwapTag extends StatelessWidget{

  /// The interest text inside this widget
  final String tagText;

  /// The tag element style type
  final ZwapTagStyle tagStyleType;

  /// Optionally icon inside this element
  final IconData? icon;

  /// Optionally callBack function on icon click
  final Function()? callBackClick;

  ZwapTag({Key? key,
    required this.tagText,
    this.tagStyleType = ZwapTagStyle.blueTag,
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

  Widget standardComponent(){
    return ZwapText(
      texts: [this.tagText],
      baseTextsType: [ZwapTextType.normal],
      textsColor: [this.tagStyleType == ZwapTagStyle.blueTag ? DesignColors.bluePrimary : Colors.white],
      textAlignment: Alignment.center,
    );
  }

  Widget childWithIcon(){
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
            child: InkWell(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => this.callBackClick!(),
              child: Icon(
                  this.icon
              ),
            ),
          ),
          flex: 1,
        ),
        Expanded(
          child: this.standardComponent(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(ConstantsValue.radiusValue)),
          color: this.tagStyleType == ZwapTagStyle.blueTag ? DesignColors.lightBlueButton : DesignColors.pinkyPrimary
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: this.icon != null ? this.childWithIcon() : this.standardComponent(),
      ),
    );
  }
}