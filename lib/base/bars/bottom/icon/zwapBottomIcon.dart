/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';

/// Custom icon to show inside the bottom navigation bar as item
class ZwapBottomIconMenu extends BottomNavigationBarItem{

  /// Is this icon selected?
  final bool isSelected;

  /// The optionally codePoint for the IconData
  final int? codePoint;

  /// The optionally font family from which retrieve the codePoint
  final String? fontFamily;

  /// The optionally icon data to display inside the bottom icon
  final IconData? iconData;

  ZwapBottomIconMenu({
    required this.isSelected,
    this.codePoint,
    this.fontFamily,
    this.iconData
  }) :
        super(
            tooltip: "",
            backgroundColor: Colors.white,
            icon: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: isSelected ? DesignColors.pinkyPrimary : Colors.white,
                  borderRadius: BorderRadius.circular(30)
              ),
              child:  Icon(
                iconData != null ? iconData :
                IconData(
                    codePoint!,
                    fontFamily: fontFamily!
                ),
                size: 30,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            label: ""
  );


}