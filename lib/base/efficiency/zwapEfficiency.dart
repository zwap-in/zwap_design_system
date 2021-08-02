/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';
import 'package:zwap_design_system/base/text/zwapText.dart';
import 'package:zwap_design_system/base/card/zwapCard.dart';
import 'package:zwap_design_system/base/progress/progress.dart';

/// Custom widget to display the efficient percent of the profile
class ZwapEfficiency extends StatelessWidget{

  /// The percent to show inside the efficiency component
  final double percent;

  /// The card width
  final double? cardWidth;

  /// The title of this card component
  final String efficiencyTitleText;

  ZwapEfficiency({Key? key,
    required this.percent,
    required this.efficiencyTitleText,
    this.cardWidth
  }): super(key: key);

  /// It builds the desktop layout
  Widget _desktopLayout(BuildContext context){
    return ZwapCard(
        cardWidth: this.cardWidth,
        childComponent: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: ZwapText(
                  texts: [this.efficiencyTitleText],
                  baseTextsType: [ZwapTextType.title],
                  textAlignment: Alignment.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: CircularPercentIndicator(
                  radius: 130.0,
                  animation: true,
                  animationDuration: 1200,
                  lineWidth: 15.0,
                  percent: this.percent,
                  center: ZwapText(
                    texts: ["${this.percent * 100}%"],
                    baseTextsType: [ZwapTextType.title],
                    textsColor: [DesignColors.pinkyPrimary],
                    textAlignment: Alignment.center,
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  backgroundColor: Colors.white,
                  progressColor: DesignColors.pinkyPrimary,
                ),
              )
            ],
          ),
        )
    );
  }

  /// It builds the mobile layout
  Widget _mobileLayout(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: ZwapText(
            texts: ["${this.efficiencyTitleText}: ${this.percent * 100}%"],
            baseTextsType: [ZwapTextType.title],
            textsColor: [DesignColors.pinkyPrimary],
          ),
        ),
        LinearPercentIndicator(
          padding: EdgeInsets.only(top: 3),
          percent: this.percent,
          progressColor: DesignColors.bluePrimary,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int _deviceType = Utils.getIt<Generic>().deviceType();
    return _deviceType < 3 ? this._mobileLayout(context) : this._desktopLayout(context);
  }


}