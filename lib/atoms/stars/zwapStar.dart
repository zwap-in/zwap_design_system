/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';

/// The position type for each star inside the row component
enum ZwapStarsPosition { center, start }

/// Custom component to rendering some stars icon as a star rating widget
class ZwapStars extends StatefulWidget {
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

  /// The star position inside the row
  final ZwapStarsPosition zwapStarsPosition;

  /// Custom callBack to handle the start component click
  final Function(double newStarRating)? onStarClickCallBack;

  ZwapStars({Key? key, required this.ratingTitle, required this.zwapStarsPosition, required this.starSize, this.starCount = 5, this.rating = .0, this.color, this.onStarClickCallBack})
      : super(key: key);

  _ZwapStarsState createState() => _ZwapStarsState(this.rating);
}

/// The component to rendering a star rating bar
class _ZwapStarsState extends State<ZwapStars> {
  /// The star rating value
  double _rating = 0;

  double? _hover;

  _ZwapStarsState(double initialRating) {
    this._rating = initialRating;
  }

  /// It handles the click on star rating component
  void _clickStarRating(int index) {
    index += 1;
    setState(() {
      this._rating = index.toDouble();
    });
    widget.onStarClickCallBack!(index.toDouble());
  }

  /// It builds the star rating bar
  Widget buildStar(BuildContext context, int index) {
    Icon icon;

    int _tmpRating = (_hover ?? _rating).toInt();
    Color _color = _hover != null ? ZwapColors.warning200 : widget.color ?? ZwapColors.warning300;

    if (index >= _tmpRating) {
      icon = new Icon(
        Icons.star_border,
        color: ZwapColors.neutral500,
        size: widget.starSize,
      );
    } else if (index > _tmpRating - 1 && index < _tmpRating) {
      icon = new Icon(
        Icons.star_half,
        color: _color,
        size: widget.starSize,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: _color,
        size: widget.starSize,
      );
    }

    return widget.onStarClickCallBack != null
        ? InkWell(
            onTap: () => this._clickStarRating(index),
            onHover: (hovered) => setState(() => _hover = hovered ? index.toDouble() + 1 : null),
            child: icon,
          )
        : icon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.zwapStarsPosition == ZwapStarsPosition.start ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: new List.generate(
        widget.starCount,
        (int index) => buildStar(context, index),
      ),
    );
  }
}
