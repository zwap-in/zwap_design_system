/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// The multi select form field
class ZwapMultiSelectFormFieldItem {

  /// The text to display on the list element
  String label;

  /// a boolean determining weather the element is selected or not
  bool isSelected;

  /// The value of the item, intended to be exploited later
  dynamic value;

  /// The style to apply to the label of the list
  final ZwapTextType labelStyle;

  /// The leading component inside the dropdown list element
  final Widget? leading;

  /// The trailing component inside the dropdown list element
  final Widget? trailing;

  ZwapMultiSelectFormFieldItem({
    required this.label,
    required this.value,
    this.isSelected = false,
    this.labelStyle = ZwapTextType.body1Regular,
    this.leading,
    this.trailing,
  });
}