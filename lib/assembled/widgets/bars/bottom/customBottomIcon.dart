/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom icon to show inside the bottom navigation bar as item
class CustomButtonIcon extends BottomNavigationBarItem{

  /// Is this icon selected?
  final bool isSelected;

  /// The codePoint for the IconData
  final int codePoint;

  /// The font family from which retrieve the codePoint
  final String fontFamily;

  CustomButtonIcon({required this.isSelected, required this.codePoint, required this.fontFamily}) : super(
    tooltip: "",
    backgroundColor: Colors.white,
    icon: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: isSelected ? DesignColors.pinkyPrimary : Colors.white,
          borderRadius: BorderRadius.circular(30)
      ),
      child:  Icon(
        IconData(codePoint, fontFamily: fontFamily),
        size: 30,
        color: isSelected ? Colors.black : Colors.white,
      ),
    ),
    label: ""
  );


}