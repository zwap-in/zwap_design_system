import 'package:flutter/widgets.dart';
import 'package:zwap_design_system/atoms/input/zwapInput.dart';
import 'package:zwap_design_system/molecules/calendar_input/zwap_calendar_input.dart';

/// Default colors for the Zwap components, provided once above the app.
///
/// Components read it during build when the caller does not pass explicit
/// colors, so they rebuild when it changes (e.g. after a theme switch).
/// Every null field keeps the original Zwap default.
class ZwapComponentsTheme extends InheritedWidget {
  /// Defaults of [ZwapInput], see [ZwapInputColors]
  final ZwapInputColors? inputColors;

  /// Defaults of the [ZwapCalendarInput] and [ZwapDatePicker] overlays
  final ZwapCalendarOverlayColors? calendarColors;

  /// [NewModal] surface
  final Color? modalBackgroundColor;

  /// [NewModal] divider under the title section
  final Color? modalDividerColor;

  /// [NewModalTopRightWidget] close icon
  final Color? modalIconColor;

  const ZwapComponentsTheme({
    required super.child,
    this.inputColors,
    this.calendarColors,
    this.modalBackgroundColor,
    this.modalDividerColor,
    this.modalIconColor,
    super.key,
  });

  /// The closest [ZwapComponentsTheme], registering a dependency on it
  static ZwapComponentsTheme? maybeOf(BuildContext context) => context.dependOnInheritedWidgetOfExactType<ZwapComponentsTheme>();

  @override
  bool updateShouldNotify(ZwapComponentsTheme oldWidget) =>
      inputColors != oldWidget.inputColors ||
      calendarColors != oldWidget.calendarColors ||
      modalBackgroundColor != oldWidget.modalBackgroundColor ||
      modalDividerColor != oldWidget.modalDividerColor ||
      modalIconColor != oldWidget.modalIconColor;
}
