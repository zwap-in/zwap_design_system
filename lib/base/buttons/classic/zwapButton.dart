/// IMPORTING THE THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/media/media.dart';
import 'package:zwap_design_system/base/text/zwapText.dart';
import 'package:zwap_design_system/base/theme/theme.dart';


/// Custom button type in base of the type
enum ZwapButtonType{
  pinkyButton,
  continueButton,
  backButton,
  lightBlueButton,
  socialButtonGoogle,
  socialButtonLinkedin,
  baseInputButton,
  greyButton,
}

/// This is the base structure for each button
class ZwapButton extends StatelessWidget{

  /// The type of the button to show with custom style
  final ZwapButtonType buttonTypeStyle;

  /// The text displayed on the button
  final String buttonText;

  /// The callback function triggered on click on the button
  final Function() onPressedCallback;

  /// The optional icon inside the button as an icon
  final IconData? iconButton;

  /// The optional image inside the button as an icon
  final String? imagePath;

  /// The icon color to display inside the button
  final Color? iconColor;

  /// Is Zero padding flag
  final bool isAttachedLeft;

  final bool isAttachedRight;

  ZwapButton({Key? key,
    required this.buttonText,
    required this.buttonTypeStyle,
    required this.onPressedCallback,
    this.isAttachedLeft = false,
    this.isAttachedRight = false,
    this.iconButton,
    this.imagePath,
    this.iconColor,
  }) : super(key: key){
    if(this.iconButton != null){
      assert(this.imagePath == null, "Image must be null if icon button is not equal to None");
    }
    if(this.imagePath != null){
      assert(this.iconButton == null, "Icon must be null if image is not equal to None");
    }
  }

  /// It returns the icon inside this button
  Widget _iconWidget(){
    return this.iconButton != null || this.imagePath != null?
    Padding(
      padding: EdgeInsets.only(right: 4),
      child: this.iconButton != null ? ZwapIcon(
        icon: this.iconButton!,
        iconColor: this.iconColor,
        callBackPressedFunction: () {  },
      ) : ZwapAsset(assetPathUrl: this.imagePath!, isInternal: true,),
    ) : Container();
  }

  BorderRadius _plottingRadiusButton(){
    if(this.isAttachedLeft){
      return BorderRadius.only(
        bottomLeft: Radius.zero,
        topLeft: Radius.zero,
        topRight: Radius.circular(ConstantsValue.radiusValue),
        bottomRight: Radius.circular(ConstantsValue.radiusValue),
      );
    }
    else if(this.isAttachedRight){
      return BorderRadius.only(
        topRight: Radius.zero,
        bottomRight: Radius.zero,
        bottomLeft: Radius.circular(ConstantsValue.radiusValue),
        topLeft: Radius.circular(ConstantsValue.radiusValue),
      );
    }
    else{
      return this.buttonTypeStyle == ZwapButtonType.baseInputButton ?
      BorderRadius.only(
          topLeft: Radius.zero,
          bottomLeft: Radius.zero,
          bottomRight: Radius.circular(ConstantsValue.radiusValue),
          topRight: Radius.circular(ConstantsValue.radiusValue)
      ) : BorderRadius.all(Radius.circular(ConstantsValue.radiusValue));
    }
  }

  /// The button style in base of the button type
  ButtonStyle _getButtonStyle(){
    Color backgroundColor, borderColor;
    switch(this.buttonTypeStyle){
      case ZwapButtonType.pinkyButton:
        backgroundColor = DesignColors.pinkyPrimary;
        borderColor = DesignColors.pinkyPrimary;
        break;
      case ZwapButtonType.continueButton:
        backgroundColor = DesignColors.blueButton;
        borderColor = DesignColors.blueButton;
        break;
      case ZwapButtonType.backButton:
        backgroundColor = Colors.white;
        borderColor = Colors.white;
        break;
      case ZwapButtonType.lightBlueButton:
        backgroundColor = DesignColors.lightBlueButton;
        borderColor = DesignColors.lightBlueButton;
        break;
      case ZwapButtonType.socialButtonGoogle:
        backgroundColor = Colors.white;
        borderColor = DesignColors.googleColor;
        break;
      case ZwapButtonType.socialButtonLinkedin:
        backgroundColor = Colors.white;
        borderColor = DesignColors.linkedinColor;
        break;
      case ZwapButtonType.baseInputButton:
        backgroundColor = DesignColors.pinkyPrimary;
        borderColor = DesignColors.pinkyPrimary;
        break;
      case ZwapButtonType.greyButton:
        backgroundColor = DesignColors.whiteCard;
        borderColor = DesignColors.greyPrimary;
        break;
    }
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: this._plottingRadiusButton(),
                side: BorderSide(color: borderColor)
            )
        )
    );
  }

  /// The button text color in base of the button type
  Color _getTextButtonColor(){
    switch(this.buttonTypeStyle){
      case ZwapButtonType.pinkyButton:
        return Colors.white;
      case ZwapButtonType.baseInputButton:
        return Colors.white;
      case ZwapButtonType.continueButton:
        return Colors.white;
      case ZwapButtonType.backButton:
        return DesignColors.bluePrimary;
      case ZwapButtonType.lightBlueButton:
        return DesignColors.bluePrimary;
      case ZwapButtonType.socialButtonGoogle:
        return DesignColors.googleColor;
      case ZwapButtonType.socialButtonLinkedin:
        return DesignColors.linkedinColor;
      case ZwapButtonType.greyButton:
        return DesignColors.blackPrimary;
    }
  }
  
  /// It returns the text inside this button
  Widget _textWidget(){
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: ZwapText(
        texts: [this.buttonText],
        baseTextsType: [ZwapTextType.normal],
        textsColor: [this._getTextButtonColor()],
        textAlignment: Alignment.center,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    int _deviceSize = Utils.getIt<Generic>().deviceType();
    return TextButton(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child:  Row(
          mainAxisSize: MainAxisSize.min,
          children: _deviceSize < 3 && (this.imagePath != null || this.iconButton != null) ?
          [
            Expanded(
              child: this._iconWidget(),
            )
          ] : [
            Flexible(
              child: this._iconWidget(),
              flex: 0,
            ),
            Flexible(
              child: this._textWidget(),
              flex: 1,
            )
          ],
        ),
      ),
      style: this._getButtonStyle(),
      onPressed: () => this.onPressedCallback(),
    );
  }

}