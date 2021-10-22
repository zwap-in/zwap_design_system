/// IMPORTING THIRD PARTY PACKAGES
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

/// The avatar info component to display inside a card
class ZwapAvatarInfo extends StatelessWidget{

  /// The title for this card info user
  final String title;

  /// The text type for the title
  final ZwapTextType titleTextType;

  /// The subtitle for this card info user
  final String subTitle;

  /// The text type for the subtitle
  final ZwapTextType subTitleTextType;

  /// The profile color
  final Color profileColor;

  /// The profile icon aside to this component
  final Icon profileIcon;

  /// Is this asset an external asset
  final bool isExternalAsset;

  /// The image path for the avatar icon
  final String? imagePath;

  /// The optional image size for this avatar info component
  final double? imageSize;

  /// The optional radius for this container
  final double? containerRadius;

  ZwapAvatarInfo({Key? key,
    required this.title,
    required this.titleTextType,
    required this.subTitle,
    required this.subTitleTextType,
    required this.profileColor,
    required this.profileIcon,
    this.isExternalAsset = false,
    this.imagePath,
    this.imageSize,
    this.containerRadius
  }): super(key: key);

  /// It gets the widget inside the title section
  Widget _getTitleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 0,
          fit: FlexFit.tight,
          child: Padding(
            padding: EdgeInsets.only(right: 3),
            child: ZwapText(
              textColor: ZwapColors.neutral800,
              zwapTextType: this.titleTextType,
              text: this.title,
            ),
          ),
        ),
        Flexible(
            flex: 0,
            fit: FlexFit.tight,
            child: Padding(
              padding: EdgeInsets.only(left: 3),
              child: this.profileIcon,
            ))
      ],
    );
  }

  double _getTitleSize(){
    double titleSize = getTextSize(this.title, ZwapTextType.body2SemiBold).width;
    return titleSize + (this.profileIcon.size! + 3 + 3);
  }


  double getSize(){
    double titleSize = this._getTitleSize();
    double subTitleSize = getTextSize(this.subTitle, ZwapTextType.captionRegular).width;
    return max(40, (max(titleSize, subTitleSize)));
  }

  Widget build(BuildContext context){
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: this.profileColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(this.containerRadius ?? ZwapRadius.popupRadius),
                    topRight: Radius.circular(this.containerRadius ?? ZwapRadius.popupRadius)),
              ),
              height: getMultipleConditions(83.0, 67.0, 50.0, 90.0, 86.0),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, 25),
                child: ZwapAvatar(
                  imagePath: this.imagePath,
                  isExternal: this.isExternalAsset,
                  size: this.imageSize ?? 60,
                ),
              ),
            )
          ],
        ),
        Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: this._getTitleWidget(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: ZwapText(
                  text: this.subTitle,
                  zwapTextType: this.subTitleTextType,
                  textColor: ZwapColors.neutral500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}