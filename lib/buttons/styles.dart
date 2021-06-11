/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/design/colors.dart';
import 'package:zwap_design_system/design/constants.dart';
import 'package:zwap_design_system/design/text.dart';

/// BaseButtonStyle interface to implement in any buttonStyle class
abstract class BaseButtonStyle{

  /// Retrieve the button style for any button style class
  ButtonStyle getButtonStyle(){
    throw UnimplementedError();
  }

  /// Retrieve the text style for any button style class
  TextStyle getTextStyle(){
    throw UnimplementedError();
  }
}


/// The style class button for any continue button
class ContinueButtonStyles implements BaseButtonStyle{

  @override
  ButtonStyle getButtonStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(DesignColors.bluePrimary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(ConstantsValue.radiusValue)),
                side: BorderSide(color: DesignColors.bluePrimary)
            )
        )
    );
  }

  @override
  TextStyle getTextStyle() {
    return TextDesign.defaultNormalTextStyle.apply(fontSizeDelta: 18, color: Colors.white);
  }

}

/// The button style class for any pinky buttons
class PinkyButtonStyles implements BaseButtonStyle{

  @override
  ButtonStyle getButtonStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(DesignColors.pinkyPrimary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(ConstantsValue.radiusValue)),
                side: BorderSide(color: DesignColors.pinkyPrimary)
            )
        )
    );
  }

  @override
  TextStyle getTextStyle() {
    return TextDesign.defaultNormalTextStyle.apply(fontSizeDelta: 10, color: Colors.white);
  }
}

class BackButtonStyles implements BaseButtonStyle{
  @override
  ButtonStyle getButtonStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(ConstantsValue.radiusValue)),
                side: BorderSide(color: Colors.white)
            )
        )
    );
  }

  @override
  TextStyle getTextStyle() {
    return TextDesign.defaultNormalTextStyle.apply(fontSizeDelta: 18, color: DesignColors.bluePrimary);
  }

}

/// The button style class inside the profile card
class ProfileCardButton implements BaseButtonStyle{

  @override
  ButtonStyle getButtonStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(DesignColors.pinkyButton),
        overlayColor: MaterialStateProperty.all(DesignColors.pinkyPrimary),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(ConstantsValue.radiusValue)),
                side: BorderSide(color: DesignColors.pinkyButton)
            )
        )
    );
  }

  @override
  TextStyle getTextStyle() {
    return TextDesign.defaultNormalTextStyle.apply(fontSizeDelta: 15,
        color: DesignColors.blackPrimary);
  }

}

/// The Button style class inside the navbar
class NavBarButton implements BaseButtonStyle{

  @override
  ButtonStyle getButtonStyle() {
     return ButtonStyle(
         backgroundColor: MaterialStateProperty.all(Colors.white),
         side: MaterialStateProperty.all(
             BorderSide(
               color: DesignColors.blackPrimary,
             )
         ), shape: MaterialStateProperty.all<RoundedRectangleBorder>(
         RoundedRectangleBorder(
             borderRadius: BorderRadius.all(Radius.circular(ConstantsValue.radiusValue)),
             side: BorderSide(color: DesignColors.blackPrimary)
         )
     )
     );
  }

  @override
  TextStyle getTextStyle() {
    return TextDesign.defaultNormalTextStyle.apply(fontSizeDelta: 14, color: DesignColors.blackPrimary);
  }
  
}


/// The Google Login button style class
class GoogleLoginButton implements BaseButtonStyle{

  @override
  ButtonStyle getButtonStyle() {
      return ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          side: MaterialStateProperty.all(
              BorderSide(
                color: DesignColors.googleBlue,
              )
          ), shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(ConstantsValue.radiusValue)),
              side: BorderSide(color: DesignColors.googleBlue)
          )
      )
      );
  }

  @override
  TextStyle getTextStyle() {
    return TextDesign.defaultNormalTextStyle.apply(fontSizeDelta: 14, color: DesignColors.googleBlue);
  }

}

/// The Linkedin Login button style class
class LinkedinLoginButton implements BaseButtonStyle{
  @override
  ButtonStyle getButtonStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        side: MaterialStateProperty.all(
            BorderSide(
              color: DesignColors.linkedinBlue,
            )
        ), shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(ConstantsValue.radiusValue)),
            side: BorderSide(color: DesignColors.linkedinBlue)
        )
    )
    );
  }

  @override
  TextStyle getTextStyle() {
    return TextDesign.defaultNormalTextStyle.apply(fontSizeDelta: 14, color: DesignColors.linkedinBlue);
  }

}

/// The button interest style class
class ButtonInterestStyle implements BaseButtonStyle{

  @override
  ButtonStyle getButtonStyle() {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(DesignColors.lightBlue),
        side: MaterialStateProperty.all(
            BorderSide(
              color: DesignColors.lightBlue,
            )
        ), shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(ConstantsValue.radiusValue)),
            side: BorderSide(color: DesignColors.lightBlue)
        )
      )
    );
  }

  @override
  TextStyle getTextStyle() {
    return TextDesign.defaultNormalTextStyle.apply(fontSizeDelta: 14, color: DesignColors.bluePrimary);
  }

}


/// The social login button styles class
class SocialLoginButton{

  GoogleLoginButton googleLoginButton = GoogleLoginButton();

  LinkedinLoginButton linkedinLoginButton = LinkedinLoginButton();


}