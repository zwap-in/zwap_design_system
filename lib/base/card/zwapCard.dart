/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';
import 'package:zwap_design_system/base/layouts/layouts.dart';

/// The card style in base of the type
enum ZwapCardStyleType{
  defaultCard,
  leftBlueBorderCard
}

/// Custom card component to show a card as box
class ZwapCard extends StatelessWidget {

  /// The child component of this card
  final Widget childComponent;

  /// The card width
  final double? cardWidth;

  /// The card height
  final double? cardHeight;

  /// The card type to define the style of this card
  final ZwapCardStyleType cardStyleType;

  /// The border color of this card
  final Color borderColor;

  ZwapCard({Key? key,
    required this.childComponent,
    this.cardWidth,
    this.cardHeight,
    this.cardStyleType = ZwapCardStyleType.defaultCard,
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
    Border _borderDecoration = Border.all(
      color: Colors.transparent,
    );

    return new ZwapVerticalScroll(
      childComponent: Container(
        child: SizedBox(
          child: new Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ConstantsValue.cardRadiusValue),
                  side: BorderSide(
                      width: 2,
                      color: this.borderColor
                  )
              ),
              child: Container(
                decoration: this.cardStyleType == ZwapCardStyleType.leftBlueBorderCard ? BoxDecoration(
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
      )
    );
  }
}
