/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom widget to show an icon with a text aside
class IconText extends StatelessWidget{

  /// The text to display with the icon aside
  final BaseText text;

  /// The icon to display with text aside
  final IconData? icon;

  /// The icon color
  final Color? iconColor;

  /// The icon image path
  final String? iconImage;

  /// A custom bool flag to check if this element has the possibility to be clickable. Default = false
  final bool canClick;

  /// A custom callBack function to handle the click on this base text
  final Function()? callBackFunction;

  IconText({Key? key,
    required this.text,
    this.icon,
    this.iconImage,
    this.canClick = false,
    this.iconColor,
    this.callBackFunction,
  }) : super(key: key) {
    if(this.canClick){
      assert(this.callBackFunction != null, "callBack function on text click could not be null");
    }
    else{
      assert(this.callBackFunction == null, "callBack function on text not clickable must be null");
    }
    if(this.icon == null){
      assert(this.iconImage != null, "Icon image could not be null on icon data null");
      assert(this.iconColor == null, "Icon color must be null on icon equals to null");
    }
    else{
      assert(this.iconImage == null, "Icon image must bu null on icon data not null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: this.iconImage != null ?
          CustomAsset(assetPathUrl: this.iconImage!, imageHeight: 30, imageWidth: 30,) : CustomIcon(
            iconColor: this.iconColor,
            callBackPressedFunction: () {  },
            icon: this.icon!,
          ),
          flex: 0,
        ),
        Flexible(
          child: this.text,
          flex: 0,
        )
      ],
    );
  }

}