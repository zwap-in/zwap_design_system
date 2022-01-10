/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL COMPONENTS
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/typography/zwapTypography.dart';
import 'package:zwap_design_system/atoms/text/text.dart';

/// Component to rendering a line item with custom side widgets
class ZwapLineItem extends StatelessWidget{

  /// The title for this line
  final String title;

  /// The subtitle for this line
  final String subTitle;

  /// The left widget inside this line item
  final Widget leftWidget;

  /// The right widget inside this line item
  final Widget rightWidget;

  ZwapLineItem({Key? key,
    required this.title,
    required this.subTitle,
    required this.leftWidget,
    required this.rightWidget
  }): super(key: key);

  Widget build(BuildContext context){
    return Row(
      children: [
        Flexible(
          child: this.leftWidget,
          flex: 0,
          fit: FlexFit.tight,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1),
                  child: ZwapText(
                    text: this.title,
                    textColor: ZwapColors.neutral700,
                    zwapTextType: ZwapTextType.bodySemiBold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1),
                  child: ZwapText(
                    text: this.subTitle,
                    textColor: ZwapColors.neutral500,
                    zwapTextType: ZwapTextType.bodyRegular,
                  ),
                )
              ],
            ),
          ),
        ),
        Flexible(
          child: this.rightWidget,
          flex: 0,
          fit: FlexFit.tight,
        )
      ],
    );
  }



}