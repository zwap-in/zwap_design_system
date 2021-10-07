/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

/// Details card about a profile with a text info and optionally an image component
class ZwapDetailsCard extends StatelessWidget{

  /// Is this card selected?
  final bool isSelected;

  /// The title text for this card
  final String title;

  /// The subtitle widget for this card
  final Widget subTitle;

  /// The optionally image path
  final String? imagePath;

  /// Is this image an external asset?
  final bool isExternalImage;

  ZwapDetailsCard({Key? key,
    required this.isSelected,
    required this.title,
    required this.subTitle,
    this.imagePath,
    this.isExternalImage = false
  }): super(key: key);

  /// It gets the text info inside this card
  Widget _getTextInfo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ZwapText(
            text: this.title,
            zwapTextType: ZwapTextType.h4,
            textColor: isSelected ? ZwapColors.shades0 : ZwapColors.neutral800,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: this.subTitle,
        ),
      ],
    );
  }

  /// It gets the final child for this card
  Widget _getChildWidget(){
    return this.imagePath != null ?
    Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 4),
            child: ZwapAvatar(
              imagePath: this.imagePath!,
              isExternal: this.isExternalImage,
            ),
          ),
          flex: 0,
          fit: FlexFit.tight,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 4),
            child: this._getTextInfo(),
          ),
          fit: FlexFit.tight,
          flex: 0,
        )
      ],
    ) : this._getTextInfo();
  }

  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: isSelected ? ZwapColors.primary700 : ZwapColors.shades0,
          borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.buttonRadius)),
          border: Border.all(
              color: isSelected ? ZwapColors.primary700 : ZwapColors.shades0,
              width: 1
          )
      ),
      child: this._getChildWidget(),
    );
  }

}