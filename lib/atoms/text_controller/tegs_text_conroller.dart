import 'dart:math';

import 'package:flutter/material.dart';

class TagsTextController extends TextEditingController {
  TagsTextController({String? text}) : super();

  @override
  set value(TextEditingValue newValue) {
    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final String text = value.text;
    late int indexOf;

    List<InlineSpan> _spans = [];

    if ((indexOf = text.indexOf("7")) != -1) {
      _spans.add(TextSpan(text: text.substring(0, indexOf)));
      _spans.add(
          WidgetSpan(child: Container(padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4), color: Colors.purple, child: Text("ciao"))));
      _spans.add(TextSpan(text: text.substring(indexOf + 1)));
    } else
      _spans = [TextSpan(text: text)];

    return TextSpan(style: style, children: _spans);
  }
}
