/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

import '../../cards/cards.dart';

/// The banner card to complete the profile
class ZwapCompleteProfilePopup extends StatelessWidget {
  
  /// The title for this complete profile banner
  final String title;

  /// The subtitle for this complete profile banner
  final String subTitle;

  /// The text inside the right button inside the complete profile banner
  final String rightButtonText;

  /// The avatar image path inside the complete profile banner
  final String avatarImagePath;

  /// Is this asset an external asset?
  final bool isExternalAsset;

  ZwapCompleteProfilePopup(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.rightButtonText,
      required this.avatarImagePath,
      this.isExternalAsset = true})
      : super(key: key);

  /// It gets the padding for the internal card in a responsive way
  EdgeInsets _getCardInternalPadding() {
    int deviceType = Utils.getIt<Generic>().deviceType();
    if (deviceType == 4) {
      return EdgeInsets.symmetric(horizontal: 50, vertical: 20);
    } else if (deviceType == 3) {
      return EdgeInsets.symmetric(horizontal: 20, vertical: 20);
    } else if (deviceType == 2) {
      return EdgeInsets.symmetric(horizontal: 40, vertical: 20);
    } else if (deviceType == 1) {
      return EdgeInsets.symmetric(horizontal: 30, vertical: 10);
    } else {
      return EdgeInsets.symmetric(horizontal: 10, vertical: 10);
    }
  }

  /// It gets the internal padding between the two bottom buttons
  EdgeInsets _getBottomButtonsPadding(bool isRight){
    int deviceType = Utils.getIt<Generic>().deviceType();
    double internalPadding = 35;
    if (deviceType == 4) {
      return isRight ? EdgeInsets.only(right: internalPadding) : EdgeInsets.only(left: internalPadding);
    } else if (deviceType == 3) {
      return isRight ? EdgeInsets.only(right: internalPadding * 0.8) : EdgeInsets.only(left: internalPadding * 0.8);
    } else if (deviceType == 2) {
      return isRight ? EdgeInsets.only(right: internalPadding * 0.7) : EdgeInsets.only(left: internalPadding * 0.7);
    } else if (deviceType == 1) {
      return isRight ? EdgeInsets.only(right: internalPadding * 0.6) : EdgeInsets.only(left: internalPadding * 0.6);
    } else {
      return isRight ? EdgeInsets.only(right: internalPadding * 0.5) : EdgeInsets.only(left: internalPadding * 0.5);
    }
  }
  
  /// It handles setup profile
  void _onSetupProfile(){
    
  }

  @override
  Widget build(BuildContext context) {
    return ZwapCard(
      cardWidth: 770,
      backgroundColor: ZwapColors.primary700,
      child: Padding(
        padding: this._getCardInternalPadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ZwapAvatar(
                imagePath: this.avatarImagePath,
                isExternal: this.isExternalAsset,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: ZwapText(
                text: this.title,
                zwapTextType: ZwapTextType.h3,
                textColor: ZwapColors.shades0,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                width: 480,
                child: ZwapText(
                  text: this.subTitle,
                  textAlign: TextAlign.center,
                  zwapTextType: ZwapTextType.body1Regular,
                  textColor: ZwapColors.shades0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Flexible(
                flex: 0,
                fit: FlexFit.tight,
                child: Padding(
                  padding: this._getBottomButtonsPadding(false),
                  child: ZwapButton(
                    fullAxis: true,
                    zwapButtonStatus: ZwapButtonStatus.defaultStatus,
                    zwapButtonContentType: ZwapButtonContentType.noIcon,
                    onPressedCallBack: () => this._onSetupProfile(),
                    text: this.rightButtonText,
                    zwapButtonType: ZwapButtonType.flat,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      zwapCardType: ZwapCardType.levelZero,
    );
  }
}
