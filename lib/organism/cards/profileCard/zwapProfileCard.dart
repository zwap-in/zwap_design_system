/// IMPORTING THIRD PARTY PACKAGES
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/molecules/molecules.dart';
import 'package:zwap_design_system/organism/cards/avatarInfo/zwapAvatarInfo.dart';
import 'package:zwap_utils/zwap_utils.dart';

class ZwapProfileCard extends StatefulWidget {

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

  /// The image path for the asset inside the card
  final String? imagePath;

  /// Is the asset in the profile card an external asset?
  final bool isExternalAsset;

  /// The card width
  final double? cardWidth;

  ZwapProfileCard({Key? key,
    required this.title,
    required this.subTitle,
    required this.buttonText,
    required this.buttonClickCallBack,
    required this.profileColor,
    this.isVerified = true,
    this.isExternalAsset = false,
    this.imagePath,
    this.cardWidth
  }) : super(key: key);

  _ZwapProfileCardState createState() => _ZwapProfileCardState();

}


class _ZwapProfileCardState extends State<ZwapProfileCard>{

  bool _isHovered = false;

  void _hoverCard(bool isHovered){
    setState(() {
      this._isHovered = isHovered;
    });
  }

  ZwapAvatarInfo get _avatarInfo => ZwapAvatarInfo(
      imagePath: widget.imagePath,
      isExternalAsset: widget.isExternalAsset,
      title: widget.title,
      subTitle: widget.subTitle,
      profileColor: widget.profileColor
  );

  ZwapButton get _profileButton => ZwapButton(
    onPressedCallBack: () => widget.buttonClickCallBack(),
    zwapButtonContentType: ZwapButtonContentType.noIcon,
    zwapButtonStatus: ZwapButtonStatus.defaultStatus,
    zwapButtonType: ZwapButtonType.primary,
    text: Utils.translatedText("view_profile_button"),
    height: 40,
    width: 50,
  );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (bool isHover) => this._hoverCard(isHover),
      onTap: () => widget.buttonClickCallBack(),
      child: ZwapCard(
          cardWidth: widget.cardWidth,
          elevationLevel: this._isHovered ? 1 : 0,
          zwapCardType: this._isHovered ? ZwapCardType.levelThree : ZwapCardType.levelZero,
          child: Column(
            children: [
              this._avatarInfo,
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: this._profileButton,
                ),
              )
            ],
          )),
    );
  }

}
