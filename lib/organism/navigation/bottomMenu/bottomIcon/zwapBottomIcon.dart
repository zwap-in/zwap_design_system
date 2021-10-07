/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// Custom icon to show inside the bottom navigation bar as item
class ZwapBottomIconMenu extends BottomNavigationBarItem{

  /// The optionally codePoint for the IconData
  final int? codePoint;

  /// The optionally icon data to display inside the bottom icon
  final IconData? iconData;

  ZwapBottomIconMenu({
    this.codePoint,
    this.iconData
  }) : super(
        tooltip: "",
        backgroundColor: Colors.white,
        icon: Icon(
          iconData != null ? iconData : IconData(
              codePoint!,
              fontFamily: "ZwapIcons",
            fontPackage: "zwap_design_system"
          ),
          size: 30,
          color: Colors.black,
        ),
        label: ""
      );


}