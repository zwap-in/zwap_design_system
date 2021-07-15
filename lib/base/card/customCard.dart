/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

enum CardStyleType{
  defaultCard,
  leftBlueBorderCard
}


/// Custom card component to show a card as box
class CustomCard extends StatelessWidget {

  /// The child component of this card
  final Widget childComponent;

  /// The card width
  final double? cardWidth;

  /// The card height
  final double? cardHeight;

  /// The card type to define the style of this card
  final CardStyleType cardStyleType;

  final Color borderColor;

  CustomCard({Key? key,
    required this.childComponent,
    this.cardWidth,
    this.cardHeight,
    this.cardStyleType = CardStyleType.defaultCard,
    this.borderColor = Colors.transparent
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    /// The default value for the box shadows possible values
    List<BoxShadow> _boxShadows = [
      BoxShadow(
          color: DesignColors.whiteShadowColor,
          blurRadius: 11,
          spreadRadius: 4,
          offset: Offset(0, 0)
      )
    ];

    /// The default value for the border decoration of the card
    Border _borderDecoration = Border(
        top: BorderSide(color: this.borderColor),
        bottom: BorderSide(color: this.borderColor),
        right: BorderSide(color: this.borderColor),
        left: BorderSide(color: this.borderColor)
    );

    return new Container(
      child: SizedBox(
        child: new Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ConstantsValue.cardRadiusValue),
            ),
            child: Container(
              decoration: this.cardStyleType == CardStyleType.leftBlueBorderCard ? BoxDecoration(
                  border: Border(
                      left: BorderSide(color: DesignColors.bluePrimary, width: 7)
                  )
              ) : null,
              width: this.cardWidth,
              height: this.cardHeight,
              child: this.childComponent,
            )
        ),
      ),
      decoration: BoxDecoration(
          border: _borderDecoration,
          boxShadow: _boxShadows
      ),
    );
  }
}
