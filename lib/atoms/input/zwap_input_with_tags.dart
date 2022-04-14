import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/input/zwapInput.dart';

///! BETA VERSION -> DO NOT USE IN PRODUCTION

//* Capire come standardizzare con altro input
//* Refactoring altro input

class ZwapInputWithTags extends StatefulWidget {
  const ZwapInputWithTags({Key? key}) : super(key: key);

  @override
  State<ZwapInputWithTags> createState() => _ZwapInputWithTagsState();
}

List<String> stringhe = ['ciao', 'bello'];

class _ZwapInputWithTagsState extends State<ZwapInputWithTags> {
  @override
  Widget build(BuildContext context) {
    return ExtendedTextField(
      specialTextSpanBuilder: _MyBuilder(),
    );
  }
}

class _MyBuilder extends SpecialTextSpanBuilder {
  @override
  SpecialText? createSpecialText(String flag, {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, required int index}) {
    if (stringhe.contains(flag))
      return _Tag(
        startFlag: flag,
        content: flag,
      );
    return null;
  }
}

class _Tag extends SpecialText {
  final String content;

  _Tag({
    required String startFlag,
    required this.content,
  }) : super(startFlag, " ", null, onTap: null);

  @override
  InlineSpan finishText() {
    return ExtendedWidgetSpan(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: ZwapColors.neutral300,
        child: Text(content),
      ),
    );
  }
}
