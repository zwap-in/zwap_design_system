/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// The component to rendering a star rating bar
class ZwapStarRating extends StatelessWidget {
  /// The title for this rating bar component
  final String? ratingTitle;

  /// It handles the changes inside the rating bar
  final Function(double newRating)? onRatingChanged;

  /// The stars max number
  final int starCount;

  /// The current stars rating
  final double rating;

  /// The stars color
  final Color? color;

  /// The optionally star size
  final double? starSize;

  ZwapStarRating({this.ratingTitle, this.onRatingChanged, this.starCount = 5, this.rating = .0, this.color, this.starSize});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (ratingTitle != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ZwapText(
              text: this.ratingTitle!,
              textColor: ZwapColors.neutral700,
              zwapTextType: ZwapTextType.bodySemiBold,
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: getMultipleConditions<double>(10, 10, 10, 0, 0)),
          child: ZwapStars(
            onStarClick: this.onRatingChanged,
            starCount: this.starCount,
            starSize: this.starSize ?? 16,
            rating: this.rating,
            defaultColor: this.color ?? ZwapColors.neutral200,
          ),
        )
      ],
    );
  }
}
