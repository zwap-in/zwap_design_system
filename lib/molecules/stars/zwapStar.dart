/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

enum ZwapStarsPosition{
  center,
  start
}

/// The component to rendering a star rating bar
class ZwapStars extends StatelessWidget {

  /// The title for this rating bar component
  final String ratingTitle;

  /// The stars max number
  final int starCount;

  /// The star size
  final double starSize;

  /// The current stars rating
  final double rating;

  /// The stars color
  final Color? color;

  final ZwapStarsPosition zwapStarsPosition;

  ZwapStars({Key? key,
    required this.ratingTitle,
    required this.zwapStarsPosition,
    required this.starSize,
    this.starCount = 5,
    this.rating = .0,
    this.color,
  }): super(key: key);

  /// It builds the star rating bar
  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
        size: this.starSize,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? ZwapColors.warning300,
        size: this.starSize,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? ZwapColors.warning300,
        size: this.starSize,
      );
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: this.zwapStarsPosition == ZwapStarsPosition.start ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}