import 'dart:html';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

import '../../ext_packages/calendar_date_picker_2/calendar_date_picker2.dart';
import '../calendar_input/zwap_calendar_input.dart' show ZwapCalendarOverlayColors;

export '../calendar_input/zwap_calendar_input.dart' show ZwapCalendarOverlayColors;

class ZwapDatePicker extends StatefulWidget {
  /// Used as initial value, when change the
  /// widget will update
  final DateTime? value;

  /// Called when the user selects a date in the picker.
  final Function(DateTime?)? onChange;

  /// Used to format the current value (if not null)
  ///
  /// Default: dd/MM/yyyy
  final String dateFormatter;

  /// If provided, this widget will be places as suffix inside
  /// the input field
  final Widget Function(BuildContext)? decoratorBuilder;

  /// If provided, the date picker days will be enabled
  /// if the function returns true
  final bool Function(DateTime)? enableWhere;

  final double borderRadius;
  final TextStyle? placeholderStyle;
  final TextStyle? textStyle;

  /// Input background, default from the [ZwapComponentsTheme] input colors
  final Color? backgroundColor;

  /// Input border when hovered or when the calendar is open
  final Color? activeBorderColor;

  /// Input border when idle
  final Color? borderColor;

  /// Colors of the calendar overlay, default from [ZwapComponentsTheme]
  final ZwapCalendarOverlayColors? overlayColors;

  const ZwapDatePicker({
    this.backgroundColor,
    this.activeBorderColor,
    this.borderColor,
    this.overlayColors,
    this.value,
    this.onChange,
    this.dateFormatter = 'dd/MM/yyyy',
    this.decoratorBuilder,
    this.enableWhere,
    this.borderRadius = 8,
    this.placeholderStyle,
    this.textStyle,
    super.key,
  });

  @override
  State<ZwapDatePicker> createState() => _ZwapDatePickerState();
}

class _ZwapDatePickerState extends State<ZwapDatePicker> {
  final GlobalKey _inputKey = GlobalKey();
  DateTime? _value;
  bool _hovered = false;
  OverlayEntry? _entry;

  bool get _isEntryOpen => _entry?.mounted ?? false;
  bool get _active => _hovered || _isEntryOpen;

  void _openOverlay() async {
    final double _dx = max(0, min(MediaQuery.of(context).size.width - 320, _inputKey.globalOffset?.dx ?? 0));
    final double _dy = max(0, min(MediaQuery.of(context).size.height - 400, (_inputKey.globalOffset?.dy ?? 0) + 52));

    Overlay.of(context).insert(
      _entry = OverlayEntry(
        builder: (_) => ZwapOverlayEntryWidget(
          entity: _entry,
          onAutoClose: () => _entry = null,
          child: ZwapOverlayEntryChild(
            top: _dy,
            left: _dx,
            child: _CalendarPickerOverlay(
              selectedDate: _value,
              onDatePicked: widget.onChange ?? (_) {},
              onDonePressed: () {
                _entry?.remove();
                _entry = null;
              },
              onlyFutureDates: true,
              enableWhere: widget.enableWhere,
              colors: widget.overlayColors,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant ZwapDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool _areDatesDifferent = _value?.day != widget.value?.day || _value?.month != widget.value?.month || _value?.year != widget.value?.year;

    if (_areDatesDifferent) setState(() => _value = widget.value);

    // The overlay reads [widget] in its own entry: rebuild it so an open
    // calendar picks up new colors from the parent.
    if (_isEntryOpen) WidgetsBinding.instance.addPostFrameCallback((_) => _entry?.markNeedsBuild());
  }

  @override
  void dispose() {
    if (_isEntryOpen) _entry?.remove();
    super.dispose();
  }

  @override
  void deactivate() {
    if (_isEntryOpen) _entry?.remove();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final String _languageCode = Localizations.maybeLocaleOf(context)?.languageCode ?? 'it';
    final ZwapInputColors? _inputColors = ZwapComponentsTheme.maybeOf(context)?.inputColors;

    return InkWell(
      key: _inputKey,
      onTap: _openOverlay,
      onHover: (bool value) => setState(() => _hovered = value),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? _inputColors?.backgroundColor ?? ZwapColors.shades0,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: _active
                ? (widget.activeBorderColor ?? _inputColors?.focussedBorderColor ?? ZwapColors.primary900Dark)
                : (widget.borderColor ?? _inputColors?.borderColor ?? ZwapColors.neutral300),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: ZwapText.customStyle(
                text: _value == null ? 'Seleziona una data' : DateFormat(widget.dateFormatter, _languageCode).format(_value!),
                customTextStyle: (_value == null ? widget.placeholderStyle : widget.textStyle) ??
                    ZwapTextType.bigBodyMedium.copyWith(color: ZwapColors.primary900Dark),
              ),
            ),
            if (widget.decoratorBuilder != null) ...[
              const SizedBox(width: 12),
              Builder(builder: widget.decoratorBuilder!),
            ],
          ],
        ),
      ),
    );
  }
}

class _CalendarPickerOverlay extends StatefulWidget {
  final bool onlyFutureDates;
  final Function(DateTime) onDatePicked;
  final Function() onDonePressed;
  final DateTime? selectedDate;
  final bool Function(DateTime)? enableWhere;
  final ZwapCalendarOverlayColors? colors;

  const _CalendarPickerOverlay({
    required this.onDonePressed,
    required this.onDatePicked,
    required this.onlyFutureDates,
    required this.selectedDate,
    required this.enableWhere,
    required this.colors,
    Key? key,
  }) : super(key: key);

  @override
  State<_CalendarPickerOverlay> createState() => _CalendarPickerOverlayState();
}

class _CalendarPickerOverlayState extends State<_CalendarPickerOverlay> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String _doneCTA = 'Fatto';
    final ZwapCalendarOverlayColors colors =
        widget.colors ?? ZwapComponentsTheme.maybeOf(context)?.calendarColors ?? const ZwapCalendarOverlayColors();

    return Material(
      color: ZwapColors.transparent,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 175),
        curve: Curves.fastOutSlowIn,
        opacity: _visible ? 1 : 0.05,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.decelerate,
          decoration: BoxDecoration(
            boxShadow: [
              if (_visible) ...[
                BoxShadow(color: Color(0x00808080).withOpacity(0.05), blurRadius: 60, offset: Offset(0, 20)),
                BoxShadow(color: Color(0x00808080).withOpacity(0.15), blurRadius: 60, offset: Offset(0, 30), spreadRadius: -4),
              ],
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              width: 300,
              decoration: BoxDecoration(
                color: colors.backgroundColor ?? ZwapColors.shades0,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  colors.wrapCalendar(
                    context,
                    CalendarDatePicker2(
                      config: colors.config,
                      initialValue: [if (widget.selectedDate != null) widget.selectedDate],
                      selectableDayPredicate: widget.enableWhere,
                      onValueChanged: (date) {
                        if (date.firstOrNull != null) widget.onDatePicked(date.first!);
                        widget.onDonePressed();
                      },
                    ),
                  ),
                  ZwapButton(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: double.infinity,
                    height: 44,
                    decorations: colors.doneButtonDecorations ?? ZwapButtonDecorations.primaryLight(),
                    buttonChild: ZwapButtonChild.text(text: _doneCTA, fontSize: 15, fontWeight: FontWeight.w500),
                    onTap: widget.onDonePressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
