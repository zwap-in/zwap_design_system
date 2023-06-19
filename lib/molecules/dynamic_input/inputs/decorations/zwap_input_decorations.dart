import 'package:flutter/rendering.dart';

class ZwapInputDecorations {
  final Color? borderColor;
  final Color? hoveredBorderColor;
  final Color? backgroundColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? secondaryTextColor;

  //* overlay
  final Color? overlayColor;
  final Color? overlayTextColor;
  final Color? overlaySecondaryTextColor;
  final Color? overlayHoverColor;

  ZwapInputDecorations({
    this.borderColor,
    this.hoveredBorderColor,
    this.backgroundColor,
    this.hintColor,
    this.textColor,
    this.secondaryTextColor,
    this.overlayColor,
    this.overlayTextColor,
    this.overlaySecondaryTextColor,
    this.overlayHoverColor,
  });
}
