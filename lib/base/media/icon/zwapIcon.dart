/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// Custom widget to render custom icon with pre-defined params
class ZwapIcon extends StatelessWidget {

  /// The icon inside this custom icon
  final IconData icon;

  /// The callBack pressed function
  final Function() callBackPressedFunction;

  /// The icon color inside this custom icon
  final Color? iconColor;

  ZwapIcon({Key? key,
    required this.icon,
    required this.callBackPressedFunction,
    this.iconColor
  }): super(key: key);

  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(this.icon),
        padding: EdgeInsets.zero,
        color: this.iconColor,
        iconSize: 18,
        alignment: Alignment.center,
        onPressed: () => this.callBackPressedFunction()
    );
  }
}