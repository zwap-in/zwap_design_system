/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';


/// Standard component to render a checkbox with Zwap standard style
class ZwapCheckBoxText extends StatelessWidget {

  /// The text inside this checkbox component
  final String text;

  /// It handles the click on checkbox
  final Function(bool isSelected) onCheckBoxClick;

  /// Initial bool value for this checkbox
  final bool initialValue;

  /// On text click on checkbox
  final Function()? onTextClick;

  ZwapCheckBoxText({Key? key,
    required this.text,
    required this.onCheckBoxClick,
    this.initialValue = false,
    this.onTextClick
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Widget text = ZwapText(
      text: this.text,
      zwapTextType: getMultipleConditions<ZwapTextType>(ZwapTextType.bodyRegular, ZwapTextType.bodyRegular, ZwapTextType.captionRegular, ZwapTextType.captionRegular, ZwapTextType.captionRegular),
      textColor: this.onTextClick != null ? ZwapColors.primary700 : ZwapColors.neutral800,
    );
    return Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          flex: 0,
          child: ZwapCheckBox(
            initialValue: this.initialValue,
            onCheckBoxClick: (bool value) => this.onCheckBoxClick(value),
          ),
        ),
        Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 6),
              child: this.onTextClick != null ? InkWell(
                onTap: () => this.onTextClick!(),
                child: text,
              ) : text,
            ))
      ],
    );
  }
}
