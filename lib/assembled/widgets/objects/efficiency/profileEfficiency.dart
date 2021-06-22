/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom widget to display the efficient percent of the profile
class ProfileEfficiency extends StatelessWidget{

  /// The percent to show inside the efficiency component
  final double percent;

  /// The card width
  final double cardWidth;

  ProfileEfficiency({Key? key,
    required this.percent,
    required this.cardWidth
  }): super(key: key);

  Widget _desktopLayout(BuildContext context){
    return CustomCard(
        cardWidth: this.cardWidth,
        childComponent: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: BaseText(
                  texts: [LocalizationClass.of(context).dynamicValue("profileEfficiency")],
                  baseTextsType: [BaseTextType.title],
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
                  center: BaseText(
                    texts: ["${this.percent * 100}%"],
                    baseTextsType: [BaseTextType.title],
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

  Widget _mobileLayout(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: BaseText(
            texts: ["${LocalizationClass.of(context).dynamicValue("profileEfficiency")}: ${this.percent * 100}%"],
            baseTextsType: [BaseTextType.title],
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
    int _deviceType = DeviceInherit.of(context).deviceType;
    return _deviceType < 3 ? this._mobileLayout(context) : this._desktopLayout(context);
  }


}