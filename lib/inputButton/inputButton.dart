/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/buttons/baseButton/baseButton.dart';
import 'package:zwap_design_system/buttons/styles.dart';
import 'package:zwap_design_system/inputs/baseInput/baseInput.dart';

/// custom widget to display an input text with a button side by input
class InputButton extends StatelessWidget{

  /// The placeholder text inside the input widget
  final String placeholderInput;

  /// The button text inside the button aside the input widget
  final String buttonText;

  /// The custom callBack function on changing the input value
  final Function(dynamic value) handleChange;

  /// The custom callBack function on button click
  final Function() handleClick;

  /// Are the information inside this input sensitive?. Default = false
  final bool isSensitiveInformation;

  /// The input type for this input inside this component. Default = input-text
  final String inputType;


  InputButton({Key? key,
    required this.placeholderInput,
    required this.buttonText,
    required this.handleChange,
    required this.handleClick,
    this.inputType = "input-text",
    this.isSensitiveInformation = false,
  }): super(key: key);

  /// The button style
  final PinkyButtonStyles _pinkyButtonStyles = PinkyButtonStyles();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            height: 32,
            child: BaseInput(
              inputType: this.inputType,
              isSensibleInformation: this.isSensitiveInformation,
              placeholderText: this.placeholderInput, changeValue: (dynamic value) => this.handleChange(value),
            ),
          ),
          flex: 2,
        ),
        Expanded(
          child: Container(
            transform: Matrix4.translationValues(-5.0, 0.0, 0.0),
            child: BaseButton(
              buttonText: this.buttonText,
              buttonStyle: this._pinkyButtonStyles.getButtonStyle(),
              paddingButton: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              onPressedCallback: () => this.handleClick,
              buttonTextStyle: this._pinkyButtonStyles.getTextStyle(),
            ),
          ),
          flex: 1,
        ),
      ],
    );
  }

}