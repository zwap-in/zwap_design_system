/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING DESIGN SYSTEM KIT COMPONENTS
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

/// Custom component to rendering a card with some stat
class ZwapCardStat extends StatefulWidget{

  /// The stat title
  final String statTitle;

  /// The stat value
  final int statValue;

  ZwapCardStat({Key? key,
    required this.statTitle,
    required this.statValue
  }): super(key: key);

  _ZwapCardStatState createState() => _ZwapCardStatState();

}

/// Custom state management for this component
class _ZwapCardStatState extends State<ZwapCardStat>{

  /// Is this component hovered or not
  bool _isHovered = false;

  /// It handles the hover on this component
  void handleHover(bool isHovered){
    setState(() {
      this._isHovered = isHovered;
    });
  }

  Widget build(BuildContext context){
    return InkWell(
      onHover: (bool isHovered) => this.handleHover(isHovered),
      onTap: () => {},
      child: ZwapCard(
        elevationLevel: this._isHovered ? 1 : 0,
        zwapCardType: this._isHovered ? ZwapCardType.levelThree : ZwapCardType.levelZero,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: getMultipleConditions(40.0, 40.0, 30.0, 20.0, 10.0), vertical: getMultipleConditions(20.0, 20.0, 20.0, 20.0, 20.0)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: ZwapText(
                  text: widget.statTitle,
                  zwapTextType: ZwapTextType.body1SemiBold,
                  textColor: ZwapColors.neutral500,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: ZwapText(
                  text: "${widget.statValue.toString()}",
                  zwapTextType: ZwapTextType.h3,
                  textColor: ZwapColors.neutral700,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}