/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// Custom icon to show inside the bottom navigation bar as item
class ZwapBottomIconMenu extends BottomNavigationBarItem{

  /// The optionally codePoint for the IconData
  final int? codePoint;

  /// The optionally font family from which retrieve the codePoint
  final String? fontFamily;

  /// The optionally icon data to display inside the bottom icon
  final IconData? iconData;

  ZwapBottomIconMenu({
    this.codePoint,
    this.fontFamily,
    this.iconData
  }) : super(
        tooltip: "",
        backgroundColor: Colors.white,
        icon: Icon(
          iconData != null ? iconData : IconData(
              codePoint!,
              fontFamily: fontFamily!
          ),
          size: 30,
          color: Colors.black,
        ),
        label: ""
      );


}