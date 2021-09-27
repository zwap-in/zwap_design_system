import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

class ZwapCardStat extends StatelessWidget{

  final String statTitle;

  final int statValue;

  ZwapCardStat({Key? key,
    required this.statTitle,
    required this.statValue
  }): super(key: key);

  Widget build(BuildContext context){
    return ZwapCard(
      zwapCardType: ZwapCardType.levelOne,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: getMultipleConditions(40.0, 40.0, 30.0, 30.0, 30.0), vertical: 20),
        child: Column(
          children: [
            ZwapText(
              text: statTitle,
              zwapTextType: ZwapTextType.body1SemiBold,
              textColor: ZwapColors.neutral500,
            ),
            ZwapText(
              text: "${this.statValue.toString()}",
              zwapTextType: ZwapTextType.h3,
              textColor: ZwapColors.neutral700,
            )
          ],
        ),
      ),
    );
  }

}