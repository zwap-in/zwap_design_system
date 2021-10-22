/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/molecules/molecules.dart';
import 'package:zwap_design_system/organism/cards/avatarInfo/zwapAvatarInfo.dart';
import 'package:zwap_utils/zwap_utils.dart';

class ZwapProfileCard extends StatefulWidget {

  /// The profile card title
  final String title;

  /// The text type for the title
  final ZwapTextType titleTextType;

  /// The profile card subTitle
  final String subTitle;

  /// The text type for the subtitle
  final ZwapTextType subTitleTextType;

  /// The button text
  final String buttonText;

  /// The callBack function on button click
  final Function() buttonClickCallBack;

  /// The profile color
  final Color profileColor;

  /// The icon inside this profile card
  final Icon profileIconCard;

  /// The image path for the asset inside the card
  final String? imagePath;

  /// Is the asset in the profile card an external asset?
  final bool isExternalAsset;

  /// The size for the avatar image
  final double? imageSize;

  /// The card width
  final double? cardWidth;

  ZwapProfileCard({Key? key,
    required this.title,
    required this.subTitle,
    required this.buttonText,
    required this.buttonClickCallBack,
    required this.profileColor,
    required this.profileIconCard,
    this.isExternalAsset = false,
    this.titleTextType = ZwapTextType.h3,
    this.subTitleTextType = ZwapTextType.body1Regular,
    this.imageSize,
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
      titleTextType: widget.titleTextType,
      subTitleTextType: widget.subTitleTextType,
      isExternalAsset: widget.isExternalAsset,
      title: widget.title,
      profileIcon: widget.profileIconCard,
      containerRadius: ZwapRadius.tabBarRadius,
      imageSize: widget.imageSize,
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
          elevationLevel: this._isHovered ? 0.5 : 0,
          borderColor: !this._isHovered ? ZwapColors.primary100 : null,
          zwapCardType: this._isHovered ? ZwapCardType.levelTwo : ZwapCardType.levelZero,
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
