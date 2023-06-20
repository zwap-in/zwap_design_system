import 'package:flutter/rendering.dart';

class ZwapInputDecorations {
  final Color? borderColor;
  final Color? hoveredBorderColor;
  final Color? backgroundColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? secondaryTextColor;
  final Color? labelColor;

  //* overlay
  final Color? overlayColor;
  final Color? overlaySelectedColor;
  final Color? overlayTextColor;
  final Color? overlaySecondaryTextColor;
  final Color? overlayHoverColor;
  final Color? overlaySelectedTextColor;

  ZwapInputDecorations({
    this.borderColor,
    this.labelColor,
    this.hoveredBorderColor,
    this.backgroundColor,
    this.hintColor,
    this.textColor,
    this.secondaryTextColor,
    this.overlayColor,
    this.overlayTextColor,
    this.overlaySecondaryTextColor,
    this.overlayHoverColor,
    this.overlaySelectedColor,
    this.overlaySelectedTextColor,
  });
}
