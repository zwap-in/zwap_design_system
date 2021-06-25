/// IMPORTING THE THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

enum ButtonTypeStyle{
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
class BaseButton extends StatelessWidget{

  /// The type of the button to show with custom style
  final ButtonTypeStyle buttonTypeStyle;

  /// The text displayed on the button
  final String buttonText;

  /// The callback function triggered on click on the button
  final Function() onPressedCallback;

  /// The optional icon inside the button as an icon
  final IconData? iconButton;

  /// The optional image inside the button as an icon
  final String? imagePath;

  /// The order to display the icon and text inside the button. Default = 0
  final int orderKind;

  final Color? iconColor;

  BaseButton({Key? key,
    required this.buttonText,
    required this.buttonTypeStyle,
    required this.onPressedCallback,
    this.iconButton,
    this.orderKind = 0,
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
  Widget iconWidget(){
    return this.iconButton != null || this.imagePath != null?
    Padding(
      padding: EdgeInsets.only(right: 4),
      child: this.iconButton != null ? CustomIcon(
        icon: this.iconButton!,
        iconColor: this.iconColor,
        callBackPressedFunction: () {  },
      ) : CustomAsset(assetPathUrl: this.imagePath!, isInternal: true,),
    ) : Container();
  }

  /// The button style in base of the button type
  ButtonStyle _getButtonStyle(){
    Color backgroundColor, borderColor;
    switch(this.buttonTypeStyle){
      case ButtonTypeStyle.pinkyButton:
        backgroundColor = DesignColors.pinkyPrimary;
        borderColor = DesignColors.pinkyPrimary;
        break;
      case ButtonTypeStyle.continueButton:
        backgroundColor = DesignColors.blueButton;
        borderColor = DesignColors.blueButton;
        break;
      case ButtonTypeStyle.backButton:
        backgroundColor = Colors.white;
        borderColor = Colors.white;
        break;
      case ButtonTypeStyle.lightBlueButton:
        backgroundColor = DesignColors.lightBlueButton;
        borderColor = DesignColors.lightBlueButton;
        break;
      case ButtonTypeStyle.socialButtonGoogle:
        backgroundColor = Colors.white;
        borderColor = DesignColors.googleColor;
        break;
      case ButtonTypeStyle.socialButtonLinkedin:
        backgroundColor = Colors.white;
        borderColor = DesignColors.linkedinColor;
        break;
      case ButtonTypeStyle.baseInputButton:
        backgroundColor = DesignColors.pinkyPrimary;
        borderColor = DesignColors.pinkyPrimary;
        break;
      case ButtonTypeStyle.greyButton:
        backgroundColor = DesignColors.whiteCard;
        borderColor = DesignColors.greyPrimary;
        break;
    }
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: this.buttonTypeStyle == ButtonTypeStyle.baseInputButton ?
                BorderRadius.only(
                  topLeft: Radius.zero,
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.circular(ConstantsValue.radiusValue),
                  topRight: Radius.circular(ConstantsValue.radiusValue)
                ) : BorderRadius.all(Radius.circular(ConstantsValue.radiusValue)),
                side: BorderSide(color: borderColor)
            )
        )
    );
  }

  /// The button text color in base of the button type
  Color _getTextButtonColor(){
    switch(this.buttonTypeStyle){
      case ButtonTypeStyle.pinkyButton:
        return Colors.white;
      case ButtonTypeStyle.baseInputButton:
        return Colors.white;
      case ButtonTypeStyle.continueButton:
        return Colors.white;
      case ButtonTypeStyle.backButton:
        return DesignColors.bluePrimary;
      case ButtonTypeStyle.lightBlueButton:
        return DesignColors.bluePrimary;
      case ButtonTypeStyle.socialButtonGoogle:
        return DesignColors.googleColor;
      case ButtonTypeStyle.socialButtonLinkedin:
        return DesignColors.linkedinColor;
      case ButtonTypeStyle.greyButton:
        return DesignColors.blackPrimary;
    }
  }


  /// It returns the text inside this button
  Widget textWidget(){
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: BaseText(
        texts: [this.buttonText],
        baseTextsType: [BaseTextType.normal],
        textsColor: [this._getTextButtonColor()],
        textAlignment: Alignment.center,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    int _deviceSize = DeviceInherit.of(context).deviceType;

    return TextButton(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child:  Row(
          mainAxisSize: MainAxisSize.min,
          children: _deviceSize < 3 && (this.imagePath != null || this.iconButton != null) ?
          [
            Expanded(
              child: this.iconWidget(),
            )
          ] : [
            Flexible(
              child: this.iconWidget(),
              flex: 0,
            ),
            Flexible(
              child: this.textWidget(),
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