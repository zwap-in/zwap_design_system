import 'dart:math';

import 'package:flutter/material.dart';

class InitialTextController extends TextEditingController {
  final String fixedInitialString;
  final TextStyle? fixedInitialStringStyle;

  InitialTextController({String? text, required this.fixedInitialString, this.fixedInitialStringStyle})
      : super(text: '$fixedInitialString${text ?? ''}') {
    super.value = value.copyWith(selection: TextSelection.collapsed(offset: fixedInitialString.length));
  }

  @override
  set value(TextEditingValue newValue) {
    if (newValue.text.isEmpty) newValue = newValue.copyWith(text: fixedInitialString);

    if (newValue.text.length < fixedInitialString.length) return;
    if (newValue.selection.baseOffset < fixedInitialString.length)
      newValue = newValue.copyWith(
        selection: TextSelection(
          baseOffset: fixedInitialString.length,
          extentOffset: max(newValue.selection.extentOffset, fixedInitialString.length),
        ),
      );

    if (newValue.selection.baseOffset > newValue.selection.extentOffset && newValue.selection.extentOffset < fixedInitialString.length)
      newValue = newValue.copyWith(
        selection: TextSelection(
          baseOffset: newValue.selection.baseOffset,
          extentOffset: max(newValue.selection.extentOffset, fixedInitialString.length),
        ),
      );

    if (newValue.text.substring(0, fixedInitialString.length) != fixedInitialString)
      newValue = newValue.copyWith(
        text: text.replaceRange(0, fixedInitialString.length, fixedInitialString),
      );

    super.value = newValue;
  }

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    List<InlineSpan> children = [TextSpan(text: fixedInitialString, style: fixedInitialStringStyle ?? style)];

    if (value.text.length > fixedInitialString.length) children.add(TextSpan(text: value.text.substring(fixedInitialString.length)));

    return TextSpan(style: style, children: children);
  }
}
