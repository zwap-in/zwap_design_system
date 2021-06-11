/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PART PACKAGES
import 'package:zwap_design_system/design/colors.dart';

/// Text input style class to manage many styles
class TextInputStyle{

  /// The default input style
  static const TextStyle textStyleInput = TextStyle(
    color: DesignColors.blackPrimary,
  );

  /// The decoration for the base input
  static const InputDecoration baseInputFieldDecoration = InputDecoration(
    border: OutlineInputBorder(),
  );


  /// The input field decoration for the search input
  static const InputDecoration searchInputFieldDecoration = InputDecoration(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: DesignColors.greyPrimary, width: 1.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: DesignColors.greyPrimary, width: 1.0),
    ),
    prefixIcon: Icon(Icons.search),
  );


  /// The field decoration for any text field
  static InputDecoration getTextFieldDecoration(String hintText){
    return new InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DesignColors.greyPrimary, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DesignColors.greyPrimary, width: 1.0),
      ),
      hintText: hintText,
      prefixText: hintText,
    );
  }
}