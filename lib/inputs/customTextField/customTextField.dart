/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import '../styles.dart';

/// custom text field to enter text with many lines
class CustomTextField extends StatelessWidget{

  /// The custom placeholder for the text field in input
  final String placeholder;

  /// The max lines number for the text field. Default = 3
  final int maxLinesNumber;

  /// The padding dimensions for the text field area. Default = const EdgeInsets.symmetric(vertical: 10)
  final EdgeInsets paddingDimensions;

  /// The input decoration for this text field input
  final InputDecoration? inputDecoration;

  /// Custom callback to handle saving the data in this input field
  final Function(String value) handleChange;

  CustomTextField({Key? key,
    required this.placeholder,
    required this.handleChange,
    this.maxLinesNumber = 3,
    this.paddingDimensions = const EdgeInsets.symmetric(vertical: 10),
    this.inputDecoration
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.paddingDimensions,
      child: TextField(
        maxLines: this.maxLinesNumber,
        keyboardType: TextInputType.multiline,
        onChanged: (String value) {
          this.handleChange(value);
        },
        decoration: TextInputStyle.getTextFieldDecoration(this.placeholder),
      ),
    );
  }

}