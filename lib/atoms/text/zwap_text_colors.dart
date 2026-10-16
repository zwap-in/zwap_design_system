import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';

/// Colors used by [ZwapText] and [ZwapRichText] for the parts that
/// have no dedicated parameter (links, overflow tooltip, selection).
///
/// Provide it once above the app: texts read it during build, so they
/// rebuild when it changes (e.g. after a theme switch).
class ZwapTextColors extends InheritedWidget {
  /// Color of the highlighted urls, emails and phone numbers
  final Color linkColor;

  /// Background of the tooltip showed when the text overflows
  final Color tooltipBackgroundColor;

  /// Border of the tooltip showed when the text overflows
  final Color tooltipBorderColor;

  /// Text color of the tooltip showed when the text overflows
  final Color tooltipTextColor;

  /// Selection color of selectable texts
  final Color selectionColor;

  const ZwapTextColors({
    required super.child,
    this.linkColor = ZwapColors.primary400,
    this.tooltipBackgroundColor = ZwapColors.primary900Dark,
    this.tooltipBorderColor = ZwapColors.text65,
    this.tooltipTextColor = ZwapColors.shades0,
    this.selectionColor = ZwapColors.primary400,
    super.key,
  });

  static const ZwapTextColors _defaults = ZwapTextColors(child: SizedBox());

  /// The closest [ZwapTextColors], or the default Zwap colors if none is provided
  static ZwapTextColors of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ZwapTextColors>() ?? _defaults;

  @override
  bool updateShouldNotify(ZwapTextColors oldWidget) =>
      linkColor != oldWidget.linkColor ||
      tooltipBackgroundColor != oldWidget.tooltipBackgroundColor ||
      tooltipBorderColor != oldWidget.tooltipBorderColor ||
      tooltipTextColor != oldWidget.tooltipTextColor ||
      selectionColor != oldWidget.selectionColor;
}
