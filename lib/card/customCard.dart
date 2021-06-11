/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/design/colors.dart';
import 'package:zwap_design_system/design/constants.dart';

/// Custom card component to show a card as box
class CustomCard extends StatelessWidget {

  /// The child component of this card
  final Widget childComponent;

  /// The custom radius circular of the card. Default = _boxShadows
  final List<BoxShadow> boxShadows;

  /// The custom border of this custom card. Default = _borderDecoration
  final Border border;

  /// The radius value of this custom card. Default = ConstantsValue.cardRadiusValue
  final double cardRadius;

  /// The card elevation. Default = 0
  final double cardElevation;

  /// The card width
  final double? cardWidth;

  /// The card height
  final double? cardHeight;

  /// The default value for the box shadows possible values
  static const List<BoxShadow> _boxShadows = [
    BoxShadow(
        color: DesignColors.whiteShadowColor,
        blurRadius: 11,
        spreadRadius: 4,
        offset: Offset(0, 0)
    )
  ];

  /// The default value for the border decoration of the card
  static const Border _borderDecoration = Border(
      top: BorderSide(color: Colors.transparent),
      bottom: BorderSide(color: Colors.transparent),
      right: BorderSide(color: Colors.transparent),
      left: BorderSide(color:Colors.transparent)
  );

  CustomCard({Key? key,
    required this.childComponent,
    this.cardRadius = ConstantsValue.cardRadiusValue,
    this.boxShadows = _boxShadows,
    this.border = _borderDecoration,
    this.cardElevation = 0,
    this.cardWidth,
    this.cardHeight
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: SizedBox(
        child: new Card(
            elevation: this.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(this.cardRadius),
            ),
            child: Container(
              width: this.cardWidth,
              height: this.cardHeight,
              child: this.childComponent,
            )
        ),
      ),
      decoration: BoxDecoration(
          border: this.border,
          boxShadow: this.boxShadows
      ),
    );
  }
}
