/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// The component to rendering a star rating bar
class ZwapStars extends StatelessWidget {

  /// The title for this rating bar component
  final String ratingTitle;

  /// The stars max number
  final int starCount;

  /// The current stars rating
  final double rating;

  /// The stars color
  final Color? color;

  ZwapStars({Key? key,
    required this.ratingTitle,
    this.starCount = 5,
    this.rating = .0,
    this.color
  }): super(key: key);

  /// It builds the star rating bar
  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: Theme.of(context).buttonColor,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? ZwapColors.warning300,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? ZwapColors.warning300,
      );
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}