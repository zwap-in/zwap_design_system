/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

/// Component to rendering stat value with circular progress indicator
class ZwapCircularStat extends StatelessWidget{

  /// The stat value
  final double statValue;

  /// The stat progress color
  final Color statColor;

  /// The progress color for this stat progress indicator
  final Color progressColor;

  /// The background color for this circular progress indicator
  final Color backgroundStatColor;

  /// The stat title
  final String statTitle;

  /// The line width for this circular progress indicator
  final double lineWidth;

  ZwapCircularStat({Key? key,
    required this.statValue,
    required this.statColor,
    required this.statTitle,
    required this.backgroundStatColor,
    required this.progressColor,
    this.lineWidth = 10
  }): super(key: key);

  Widget build(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ZwapCircularPercentIndicator(
                radius: 100,
                percent: this.statValue,
                backgroundColor: this.backgroundStatColor,
                progressColor: this.progressColor,
                lineWidth: this.lineWidth,
              ),
              Center(
                child: ZwapText(
                  zwapTextType: ZwapTextType.body1Regular,
                  text: "${(this.statValue * 100).toInt().toString()}%",
                  textColor: ZwapColors.neutral500,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ZwapText(
            textColor: this.statColor,
            text: this.statTitle,
            zwapTextType: ZwapTextType.body1SemiBold,
          ),
        )
      ],
    );
  }

}