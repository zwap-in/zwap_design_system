/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING DESIGN SYSTEM PACKAGES
import 'package:zwap_design_system/organism/organism.dart';

/// Custom responsive component to display a profile card
class ZwapResponsiveProfileCard extends StatelessWidget implements ResponsiveWidget{

  /// The card title
  final String title;

  /// The card subtitle
  final String subTitle;

  /// The profile card image
  final String imagePath;

  /// Is this card an external asset
  final bool isExternalAsset;

  /// The icon inside this profile card
  final Icon profileIconCard;

  /// The color for this profile card
  final Color cardColor;

  /// The width for this card
  final double cardWidth;

  /// CallBack click function on button click
  final Function() onButtonClick;

  final double? avatarImageSize;

  ZwapResponsiveProfileCard({Key? key,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.isExternalAsset,
    required this.profileIconCard,
    required this.cardColor,
    required this.cardWidth,
    required this.onButtonClick,
    this.avatarImageSize
  }): super(key: key);

  @override
  double getSize() {
    return this.cardWidth;
  }

  Widget build(BuildContext context){
    return ZwapProfileCard(
      title: this.title,
      subTitle: this.subTitle,
      buttonText: Utils.translatedText("card_button_explore"),
      buttonClickCallBack: () => this.onButtonClick(),
      imagePath: this.imagePath,
      isExternalAsset: this.isExternalAsset,
      profileColor: this.cardColor,
      cardWidth: this.cardWidth,
      imageSize: this.avatarImageSize,
      profileIconCard: this.profileIconCard,
    );
  }

}

