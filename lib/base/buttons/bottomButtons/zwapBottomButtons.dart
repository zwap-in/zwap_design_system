/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import '../classic/zwapButton.dart';


/// Custom buttons on the bottom of the widget such as inside a card or in any container
class ZwapBottomButtons extends StatelessWidget{

  /// The text of the continue button
  final String continueButtonText;

  /// The continue button callBack function
  final Function() continueButtonCallBackFunction;

  /// The text of the optionally back button
  final String? backButtonText;

  /// The optionally back button callBack function
  final Function()? backButtonCallBackFunction;

  ZwapBottomButtons({Key? key,
    required this.continueButtonText,
    required this.continueButtonCallBackFunction,
    this.backButtonText,
    this.backButtonCallBackFunction,
  }): super(key: key){
   if(this.backButtonText != null){
     assert(this.backButtonCallBackFunction != null, "callBack back button function could not be null");
   }
   else{
     assert(this.backButtonCallBackFunction == null, "callBack back button function must be null");
   }
  }

  /// It returns the component inside the desktop view
  Widget desktopView(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        this.backButtonText != null ? (Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 7),
            child: ZwapButton(
              buttonTypeStyle: ZwapButtonType.backButton,
              onPressedCallback: () => this.backButtonCallBackFunction!(),
              buttonText: this.backButtonText!,
            ),
          ),
          flex: 0,
        )) : Container(),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 7),
            child: ZwapButton(
              buttonTypeStyle: ZwapButtonType.continueButton,
              onPressedCallback: () => this.continueButtonCallBackFunction(),
              buttonText: this.continueButtonText,
            ),
          ),
          flex: 0,
        )
      ],
    );
  }

  /// It returns the components inside the mobile view
  Widget mobileView(){
    List<Widget> children = [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: ZwapButton(
          buttonTypeStyle: ZwapButtonType.continueButton,
          onPressedCallback: () => this.continueButtonCallBackFunction(),
          buttonText: this.continueButtonText,
        ),
      )
    ];
    if(this.backButtonText != null){
      children.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: ZwapButton(
              buttonTypeStyle: ZwapButtonType.backButton,
              onPressedCallback: () => this.backButtonCallBackFunction!(),
              buttonText: this.backButtonText!,
            ),
          )
      );
    }
    return Column(
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Utils.getIt<Generic>().deviceType() > 2 ? this.desktopView() : this.mobileView();
  }

}