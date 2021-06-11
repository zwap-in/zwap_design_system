/// IMPORTING THE THIRD PARTY LIBRARIES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/design/colors.dart';


/// This is the a component to display many text with different styles inside a text component
class MultiTexts extends StatelessWidget{

  /// The list of the text to display inside this span
  final List<TextSpan> texts;

  /// The custom alignment of this text. Default = Alignment.center
  final Alignment alignment;

  /// The padding sizes of the text inside the container. Default = EdgeInsets.zero
  final EdgeInsets paddingDimensions;

  /// The font size of the text. Default = 18.0
  final double fontSize;

  /// The color of the text. Default = DesignColors.BlackPrimary
  final Color colorText;

  MultiTexts({Key? key,
    required this.texts,
    this.alignment = Alignment.center,
    this.paddingDimensions = EdgeInsets.zero,
    this.colorText = DesignColors.blackPrimary,
    this.fontSize = 18.0
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: this.alignment,
      child: Padding(
        padding: this.paddingDimensions,
        child: RichText(
          text: new TextSpan(
            // Note: Styles for TextSpans must be explicitly defined.
            // Child text spans will inherit styles from parent
            style: new TextStyle(
              fontSize: this.fontSize,
              color: this.colorText,
            ),
            children: this.texts,
          ),
        ),
      ),
    );
  }

}