/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';


/// Custom buttons on the bottom of the widget like card or any container
class BottomButtons extends StatelessWidget{

  /// The text of the continue button
  final String continueButtonText;

  /// The continue button callBack function
  final Function() continueButtonCallBackFunction;

  /// The text of the back button
  final String? backButtonText;

  /// The back button callBack function
  final Function()? backButtonCallBackFunction;

  /// Optional icon inside the left button
  final IconData? leftButtonIcon;

  /// Optional icon inside the right button
  final IconData? rightButtonIcon;

  BottomButtons({Key? key,
    required this.continueButtonText,
    required this.continueButtonCallBackFunction,
    this.backButtonText,
    this.backButtonCallBackFunction,
    this.leftButtonIcon,
    this.rightButtonIcon,
  }): super(key: key){
   if(this.backButtonText != null){
     assert(this.backButtonCallBackFunction != null, "callBack back button function could not be null");
   }
   else{
     assert(this.backButtonCallBackFunction == null, "callBack back button function must be null");
   }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        this.backButtonText != null ? (Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 7),
            child: BaseButton(
              iconButton: this.leftButtonIcon,
              buttonTypeStyle: ButtonTypeStyle.backButton,
              onPressedCallback: () => this.backButtonCallBackFunction!(),
              buttonText: this.backButtonText!,
            ),
          ),
          flex: 0,
        )) : Container(),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 7),
            child: BaseButton(
              iconButton: this.rightButtonIcon,
              buttonTypeStyle: ButtonTypeStyle.continueButton,
              onPressedCallback: () => this.continueButtonCallBackFunction(),
              buttonText: this.continueButtonText,
            ),
          ),
          flex: 0,
        )
      ],
    );
  }

}