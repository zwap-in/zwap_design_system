import 'package:flutter/material.dart';

import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/objects/objects.dart';

class LanguageSection extends StatelessWidget{

  final List<LanguageData> languages;

  LanguageSection({Key? key,
    required this.languages
  }): super(key: key);

  /// It gets the languages info row
  Widget build(BuildContext context) {
    Widget finalWidget = Container();
    if (this.languages.length > 0) {
      List<Widget> childrenWidget = [];
      this.languages.forEach((LanguageData element) {
        childrenWidget.add(Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: ZwapText(
              text: element.flagCode
                  .toUpperCase()
                  .replaceAllMapped(RegExp(r'[A-Z]'), (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397)),
              textColor: ZwapColors.error400,
              zwapTextType: ZwapTextType.h2,
            ),
          ),
          flex: 0,
          fit: FlexFit.tight,
        ));
      });
      finalWidget = Row(
        children: List<Widget>.generate(childrenWidget.length, (index) => childrenWidget[index]),
      );
    }
    return finalWidget;
  }

}