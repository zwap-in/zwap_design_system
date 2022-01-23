import 'package:flutter/material.dart';

class InitialTextController extends TextEditingController {
  final String fixedInitialString;
  final TextStyle? fixedInitialStringStyle;

  InitialTextController({String? text, required this.fixedInitialString, this.fixedInitialStringStyle}) : super(text: '$fixedInitialString ${text ?? ''}');

  @override
  set value(TextEditingValue newValue) {
    if (newValue.text.length < fixedInitialString.length) return;
    if (newValue.selection.baseOffset < fixedInitialString.length + 1) return;

    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    List<InlineSpan> children = [TextSpan(text: fixedInitialString, style: fixedInitialStringStyle ?? style)];

    if (value.text.length > fixedInitialString.length) children.add(TextSpan(text: value.text.substring(fixedInitialString.length)));

    return TextSpan(style: style, children: children);
  }
}
