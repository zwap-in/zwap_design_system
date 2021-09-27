/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

/// The avatar info component to display inside a card
class ZwapAvatarInfo extends StatelessWidget{

  /// The title for this card info user
  final String title;

  /// The subtitle for this card info user
  final String subTitle;

  /// The profile color
  final Color profileColor;

  /// Is this user a verified user
  final bool isVerified;

  /// Is this asset an external asset
  final bool isExternalAsset;

  /// The image path for the avatar icon
  final String? imagePath;

  ZwapAvatarInfo({Key? key,
    required this.title,
    required this.subTitle,
    required this.profileColor,
    this.isVerified = false,
    this.isExternalAsset = false,
    this.imagePath,
  }): super(key: key);

  /// It gets the widget inside the title section
  Widget _getTitleWidget() {
    Widget tmp = ZwapText(
      textColor: ZwapColors.neutral800,
      zwapTextType: ZwapTextType.body2SemiBold,
      text: this.title,
    );
    return this.isVerified
        ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 0,
          fit: FlexFit.tight,
          child: Padding(
            padding: EdgeInsets.only(right: 3),
            child: tmp,
          ),
        ),
        Flexible(
            flex: 0,
            fit: FlexFit.tight,
            child: Padding(
              padding: EdgeInsets.only(left: 3),
              child: Icon(
                Icons.verified_sharp,
                color: Color(0xFF42A5F5),
                size: 16,
              ),
            ))
      ],
    ) : tmp;
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
                    topLeft: Radius.circular(ZwapRadius.defaultRadius),
                    topRight: Radius.circular(ZwapRadius.defaultRadius)),
              ),
              height: getMultipleConditions(83.0, 67.0, 50.0, 90.0, 86.0),
            ),
            Center(
              child: Transform.translate(
                offset: Offset(0, 25),
                child: ZwapAvatar(
                  imagePath: this.imagePath,
                  isExternal: this.isExternalAsset,
                  size: 40,
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
                  zwapTextType: ZwapTextType.captionRegular,
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