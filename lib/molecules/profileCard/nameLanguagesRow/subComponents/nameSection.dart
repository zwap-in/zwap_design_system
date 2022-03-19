import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

import 'package:zwap_design_system/atoms/atoms.dart';

class NameSection extends StatelessWidget{

  final String name;

  final String surname;

  final bool isTopUser;

  final bool isPremium;

  NameSection({Key? key,
    required this.name,
    required this.surname,
    required this.isTopUser,
    required this.isPremium
  }): super(key: key);

  /// It gets the name section and optionally the verified icon
  Widget build(BuildContext context) {
    Widget textWidget = ZwapText.selectable(
      text: "${this.name} ${this.surname}",
      zwapTextType: ZwapTextType.h1,
      textColor: ZwapColors.neutral800,
    );
    return this.isTopUser || this.isPremium
        ? Row(
      children: [
        Flexible(
          child: textWidget,
          flex: 0,
          fit: FlexFit.tight,
        ),
        Flexible(
          child: this.isPremium
              ? Padding(
            padding: EdgeInsets.only(left: 10, top: getMultipleConditions<double>(10, 10, 5, 5, 3)),
            child: Container(), /// TODO change with icon
          )
              : Container(),
          flex: 0,
          fit: FlexFit.tight,
        ),
        Flexible(
          child: this.isTopUser
              ? Padding(
            padding: EdgeInsets.only(left: 10, top: getMultipleConditions<double>(10, 10, 5, 5, 3)),
            child: Icon(
              Icons.verified,
              color: Color(0xFF42A5F5),
              size: 22,
            ),
          )
              : Container(),
          flex: 0,
          fit: FlexFit.tight,
        )
      ],
    )
        : textWidget;
  }

}