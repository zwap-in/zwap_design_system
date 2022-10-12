import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

import 'package:zwap_design_system/atoms/colors/zwapColors.dart';

class ZwapStars extends StatefulWidget {
  /// The stars max number
  final int starCount;

  /// The star size
  final double starSize;

  /// The current stars rating
  final double rating;

  /// The selected starts color
  final Color selectedColor;

  /// The not selected starts color
  final Color defaultColor;

  /// The selected stars color during hover
  final Color hoverColor;

  /// The ammount of space between the stars
  final double spaceBetweenStart;

  /// Called when user click on a star
  final Function(double value)? onStarClick;

  ZwapStars({
    Key? key,
    this.starSize = 32,
    this.starCount = 5,
    this.rating = .0,
    this.defaultColor = ZwapColors.neutral200,
    this.selectedColor = ZwapColors.warning300,
    this.hoverColor = ZwapColors.warning200,
    this.onStarClick,
    this.spaceBetweenStart = 20,
  }) : super(key: key);

  _ZwapStarsState createState() => _ZwapStarsState(this.rating);
}

class _ZwapStarsState extends State<ZwapStars> {
  /// The star rating value
  double _rating = 0;

  double? _hover;

  _ZwapStarsState(double initialRating) {
    this._rating = initialRating;
  }

  /// It handles the click on star rating component
  void _clickStarRating(double index) {
    index++;
    setState(() => _rating = index);
    if (widget.onStarClick != null) widget.onStarClick!(index);
  }

  /// Builds a single star widget
  Widget _buildStar(BuildContext context, int index) {
    late final Widget icon;

    int _tmpRating = (_hover ?? _rating).toInt();
    Color _color = _hover != null ? widget.hoverColor : widget.selectedColor;

    if (index >= _tmpRating) {
      icon = SvgPicture.asset(
        'assets/images/icons/star_filled.svg',
        color: widget.defaultColor,
        height: widget.starSize,
        width: widget.starSize,
        package: ZwapIcons.fontPackage,
      );
    } else {
      icon = SvgPicture.asset(
        'assets/images/icons/star_filled.svg',
        color: _color,
        height: widget.starSize,
        width: widget.starSize,
        package: ZwapIcons.fontPackage,
      );
    }

    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => this._clickStarRating(index.toDouble()),
      onHover: (hovered) => setState(() => _hover = hovered ? index.toDouble() + 1 : null),
      child: Padding(
        padding: EdgeInsets.only(right: index != widget.starCount - 1 ? widget.spaceBetweenStart : 0),
        child: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.starCount,
        (int index) => _buildStar(context, index),
      ),
    );
  }
}
