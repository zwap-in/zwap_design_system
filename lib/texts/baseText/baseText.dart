/// IMPORTING THE THIRD PARTY LIBRARIES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// Component to show a base text
class BaseText extends StatelessWidget{
  
  /// The custom text to display
  final String text;

  /// The custom text style for this text
  final TextStyle textStyle;

  /// The custom alignment of the text. Default = Alignment.center
  final Alignment alignment;

  /// The padding container of the text. Default = EdgeInsets.all(20)
  final EdgeInsets paddingContainer; 

  /// The align of this text. Default = TextAlign.center
  final TextAlign textAlign;

  BaseText({Key? key,
    required this.text,
    required this.textStyle,
    this.alignment = Alignment.center,
    this.textAlign = TextAlign.center,
    this.paddingContainer = const EdgeInsets.all(20)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.paddingContainer,
      child: Container(
        alignment: this.alignment,
        child: Text(
          this.text,
          style: this.textStyle,
          textAlign: this.textAlign,
        ),
      ),
    );
  }

}