import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/input/zwapInput.dart';

///! BETA VERSION -> DO NOT USE IN PRODUCTION

//* Capire come standardizzare con altro input
//* Refactoring altro input

class ZwapInputWithTags extends StatefulWidget {
  const ZwapInputWithTags({Key? key}) : super(key: key);

  @override
  State<ZwapInputWithTags> createState() => _ZwapInputWithTagsState();
}

class _ZwapInputWithTagsState extends State<ZwapInputWithTags> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: Row(
        children: [
          Flexible(child: ZwapInput()),
          Container(width: 20, color: Colors.blue),
          Flexible(child: ZwapInput()),
        ],
      ),
    );
  }
}
