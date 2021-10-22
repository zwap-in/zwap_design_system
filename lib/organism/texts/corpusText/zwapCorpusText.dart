/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// Custom component to rendering the text in a standard style
class ZwapCorpusText extends StatelessWidget{

  /// The custom text to rendering inside this component
  final String text;

  ZwapCorpusText({Key? key,
    required this.text
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZwapText(
      text: this.text,
      textColor: ZwapColors.neutral700,
      zwapTextType: ZwapTextType.body1Regular,
    );
  }



}