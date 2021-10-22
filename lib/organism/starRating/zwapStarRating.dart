/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/molecules.dart';

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

  final ZwapStarsPosition zwapStarsPosition;

  final double? starSize;

  ZwapStarRating({
    required this.ratingTitle,
    this.zwapStarsPosition = ZwapStarsPosition.start,
    this.onRatingChanged,
    this.starCount = 5,
    this.rating = .0,
    this.color,
    this.starSize
  });

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
          padding: EdgeInsets.symmetric(vertical: getMultipleConditions(10.0, 10.0, 10.0, 0.0, 0.0)),
          child: ZwapStars(
            zwapStarsPosition: this.zwapStarsPosition,
            ratingTitle: this.ratingTitle,
            starCount: this.starCount,
            starSize: this.starSize ?? 16,
            rating: this.rating,
            color: this.color,
          ),
        )
      ],
    );
  }
}