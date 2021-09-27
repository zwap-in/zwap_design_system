/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import '../../typography/zwapTypography.dart';

import '../base/zwapText.dart';

/// Component to rendering multi text style
class ZwapTextMultiStyle extends StatelessWidget {

  /// Each text with a custom type and custom color and optionally a recognizer
  final Map<String, TupleType<TapGestureRecognizer?, TupleType<ZwapTextType, Color>>> texts;

  ZwapTextMultiStyle({
    Key? key,
    required this.texts,
  }) : super(key: key);

  /// It write each text with correct style and correct color
  List<TextSpan> _getTexts() {
    List<TextSpan> finals = [];
    this.texts.forEach((key, TupleType<TapGestureRecognizer?, TupleType<ZwapTextType, Color>> value) {
      if(value.a != null){
        finals.add(TextSpan(
          text: key,
          style: getTextStyle(value.b.a).apply(color: value.b.b),
          recognizer: value.a
        ));
      }
      else{
        finals.add(TextSpan(
          text: key,
          style: getTextStyle(value.b.a).apply(color: value.b.b)
        ));
      }
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> children = this._getTexts();
    return RichText(text: TextSpan(children: List<TextSpan>.generate(children.length, (index) => children[index])));
  }
}
