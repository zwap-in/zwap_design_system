/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// The component to rendering a star rating bar
class ZwapStarRating extends StatelessWidget {

  /// The title for this rating bar component
  final String ratingTitle;

  /// It handles the changes inside the rating bar
  final Function(double newRating)? onRatingChanged;

  /// The stars max number
  final int starCount;

  /// The current stars rating
  final double rating;

  /// The stars color
  final Color? color;

  ZwapStarRating({
    required this.ratingTitle,
    this.onRatingChanged,
    this.starCount = 5,
    this.rating = .0,
    this.color
  });

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
        color: color ?? ZwapColors.error400,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? ZwapColors.error400,
      );
    }
    return new InkResponse(
      onTap: this.onRatingChanged != null ? () => this.onRatingChanged!(index + 1.0) : null,
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ZwapText(
            text: this.ratingTitle,
            textColor: ZwapColors.neutral700,
            zwapTextType: ZwapTextType.body1SemiBold,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(children: new List.generate(starCount, (index) => buildStar(context, index))),
        )
      ],
    );
  }
}