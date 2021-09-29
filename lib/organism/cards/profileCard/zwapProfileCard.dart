/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';
import 'package:zwap_design_system/organism/cards/avatarInfo/zwapAvatarInfo.dart';
import 'package:zwap_utils/zwap_utils.dart';

import '../../../molecules/card/zwapCard.dart';

class ZwapProfileCard extends StatelessWidget {

  /// The profile card title
  final String title;

  /// The profile card subTitle
  final String subTitle;

  /// The button text
  final String buttonText;

  /// The callBack function on button click
  final Function() buttonClickCallBack;

  /// The profile color
  final Color profileColor;

  /// Is this profile verified?
  final bool isVerified;

  final String? imagePath;

  final bool isExternalAsset;

  ZwapProfileCard({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.buttonText,
    required this.buttonClickCallBack,
    required this.profileColor,
    this.isVerified = true,
    this.isExternalAsset = false,
    this.imagePath
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => this.buttonClickCallBack(),
      child: ZwapCard(
          zwapCardType: ZwapCardType.levelZero,
          child: Column(
            children: [
              ZwapAvatarInfo(
                  imagePath: this.imagePath,
                  isExternalAsset: isExternalAsset,
                  title: this.title,
                  subTitle: this.subTitle,
                  profileColor: this.profileColor
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: ZwapButton(
                    onPressedCallBack: () => this.buttonClickCallBack(),
                    zwapButtonContentType: ZwapButtonContentType.noIcon,
                    zwapButtonStatus: ZwapButtonStatus.defaultStatus,
                    zwapButtonType: ZwapButtonType.primary,
                    text: Utils.translatedText("view_profile_button"),
                    height: 40,
                    width: 50,
                  ),
                ),
              )
            ],
          )),
    );
  }
}

