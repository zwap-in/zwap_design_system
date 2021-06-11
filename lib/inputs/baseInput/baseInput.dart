/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/design/colors.dart';
import 'package:zwap_design_system/inputs/styles.dart';

/// base input widget
class BaseInput extends StatelessWidget {

  /// The placeholder text to show in the input text
  final String placeholderText;

  /// The bool flag to show or hide the text. Default = false
  final bool isSensibleInformation;

  /// The callback function on change value on the input text
  final Function(dynamic value) changeValue;

  /// The hint validator text. Default = ""
  final String hintValidatorText;

  /// The input color text. Default = DesignColors.blackPrimary
  final Color inputColorText;

  /// Align of the text in the input. Default = TextAlign.start
  final TextAlign textAlign;

  /// Text style for this input text. Default = TextInputStyle.textStyleInput
  final TextStyle textStyle;

  /// The custom input type. Default = input-text
  final String inputType;

  /// The input decoration for this widget. Default = TextInputStyle.baseInputFieldDecoration
  final InputDecoration inputDecoration;


  BaseInput({Key? key,
    required this.placeholderText,
    required this.changeValue,
    this.inputType = "input-text",
    this.isSensibleInformation = false,
    this.hintValidatorText = "",
    this.inputColorText = DesignColors.blackPrimary,
    this.textAlign = TextAlign.start,
    this.textStyle = TextInputStyle.textStyleInput,
    this.inputDecoration = TextInputStyle.baseInputFieldDecoration
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
          keyboardType: this.inputType != "input-text" ? TextInputType.number : TextInputType.text,
          cursorColor: this.inputColorText,
          obscureText: this.isSensibleInformation,
          textAlign: this.textAlign,
          style: this.textStyle,
          validator: (value){
            if(value == null || value.isEmpty){
              return this.hintValidatorText;
            }
            return null;
          },
          onChanged: (dynamic value) => {
            this.changeValue(value)
          },
          decoration: this.inputDecoration
        )
    );
  }
}
