/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/constants/zwapConstants.dart';
import 'package:zwap_design_system/atoms/shadows/zwapShadows.dart';
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';

/// The possible card types
enum ZwapCardType { levelZero, levelOne, levelTwo, levelThree }

/// Custom component to render the card
class ZwapCard extends StatelessWidget {

  /// The card type
  final ZwapCardType zwapCardType;

  /// The child component of this card
  final Widget child;

  /// The card width
  final double? cardWidth;

  /// The card height
  final double? cardHeight;

  /// The background color for this card
  final Color? backgroundColor;

  /// The border color for this custom card
  final Color? borderColor;

  /// The radius for this custom card
  final double? cardRadius;

  /// The elevation level for this card
  final double? elevationLevel;

  /// Optional border width for the box decoration inside the card
  final double? borderWidth;

  ZwapCard({Key? key,
    required this.zwapCardType,
    required this.child,
    this.backgroundColor,
    this.cardHeight,
    this.borderColor,
    this.cardRadius,
    this.cardWidth,
    this.elevationLevel = 0,
    this.borderWidth
  }) : super(key: key);

  /// It retrieves the box shadow for this card in base of the type
  BoxShadow? _getBoxShadow() {
    switch (this.zwapCardType) {
      case ZwapCardType.levelZero:
        return ZwapShadow.levelZero;
      case ZwapCardType.levelOne:
        return ZwapShadow.levelOne;
      case ZwapCardType.levelTwo:
        return ZwapShadow.levelTwo;
      case ZwapCardType.levelThree:
        return ZwapShadow.levelThree;
    }
  }

  @override
  Widget build(BuildContext context) {
    BoxShadow? boxShadow = this.elevationLevel != 0 ? this._getBoxShadow() : ZwapShadow.levelZero;
    return Container(
      height: this.cardHeight,
      width: this.cardWidth,
      padding: EdgeInsets.zero,
      child: new Card(
        elevation: this.elevationLevel,
        color: this.backgroundColor ?? ZwapColors.shades0,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: this.borderColor ?? Colors.transparent, width: this.borderWidth ?? 0.5,
              ),
              borderRadius: BorderRadius.circular(this.cardRadius ?? ZwapRadius.tabBarRadius)
          ),
          child: this.child,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: this.borderColor ?? Colors.transparent, width: this.borderWidth ?? 0.5,
          ),
          borderRadius: BorderRadius.circular(this.cardRadius ?? ZwapRadius.tabBarRadius),
        ),
      ),
      decoration: BoxDecoration(
          boxShadow: this.elevationLevel != 0 ? ([boxShadow!]) : null
      ),
    );
  }
}
