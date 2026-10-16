library zwap.calendar_input;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

import 'package:zwap_design_system/ext_packages/calendar_date_picker_2/calendar_date_picker2.dart' as calendar;

part 'zwap_calendar_input_provider.dart';

extension _DateExt on DateTime? {
  DateTime? get pureDate => this == null ? null : DateTime(this!.year, this!.month, this!.day);

  bool isEqualTo(DateTime? other) {
    other = other.pureDate;
    if (this == null) return other == null;

    return this?.day == other?.day && this?.month == other?.month && this?.year == other?.year;
  }
}

/// Colors of the calendar overlay opened by [ZwapCalendarInput] and [ZwapDatePicker].
/// Every null field keeps the default Zwap color.
class ZwapCalendarOverlayColors {
  /// Overlay surface
  final Color? backgroundColor;

  /// Selected day highlight
  final Color? selectionColor;

  /// Days, weekdays and month/year controls text color
  final Color? textColor;

  /// Text color of the selected day
  final Color? selectedTextColor;

  /// Text color of the disabled days
  final Color? disabledTextColor;

  /// Decorations of the "Done" button, default to [ZwapButtonDecorations.primaryLight]
  final ZwapButtonDecorations? doneButtonDecorations;

  const ZwapCalendarOverlayColors({
    this.backgroundColor,
    this.selectionColor,
    this.textColor,
    this.selectedTextColor,
    this.disabledTextColor,
    this.doneButtonDecorations,
  });

  calendar.CalendarDatePicker2Config get config => calendar.CalendarDatePicker2Config(
        selectedDayHighlightColor: selectionColor ?? ZwapColors.primary700,
        disabledDayTextStyle: disabledTextColor == null ? null : TextStyle(color: disabledTextColor),
      );

  /// The calendar reads days, weekdays, controls, arrows and years from the
  /// Material [ColorScheme]: wrap it so every part uses these colors.
  Widget wrapCalendar(BuildContext context, Widget calendar) {
    final ThemeData theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        // Null fields keep the ambient scheme, as before these colors existed
        colorScheme: theme.colorScheme.copyWith(
          primary: selectionColor ?? ZwapColors.primary700,
          onPrimary: selectedTextColor,
          onSurface: textColor,
        ),
      ),
      child: calendar,
    );
  }
}

class ZwapCalendarInput extends StatefulWidget {
  final DateTime? selectedDate;
  final void Function(DateTime?)? onDateSelected;

  /// If true user can cancel the value inside the input
  ///
  /// If false, the [onDateSelected] callback can't pass null
  /// as argument
  ///
  /// Default to fasle
  final bool canRemoveDate;

  /// You should use onlt 'd', 'M' and 'y' characters
  ///
  ///  Default to `dd/MM/yyyy`
  ///
  /// See intl for more details
  final String dateFormatString;

  /// Showed only when [selectedDate] is null
  final String? placeholder;

  /// If not provided the widget will be as small as possible
  final double? width;

  /// If true only dates after DateTime.now() will be enabled
  ///
  /// Default to false
  final bool onlyFutureDates;

  /// Used to translate those keys:
  /// * done_cta
  ///
  /// If not provided default copy will be used
  final String Function(String)? translateText;

  final Color? borderColor;
  final Color? backgroundColor;
  final double radius;
  final Alignment textAlign;

  final Color? textColor;

  final String? label;
  final Color? labelTextColor;
  final Color? labelBackgroundColor;

  final double? height;
  final EdgeInsets? internalPadding;

  /// Colors of the calendar overlay, default from [ZwapComponentsTheme]
  final ZwapCalendarOverlayColors? overlayColors;

  /// Date are compared only with day, month and year. So DateTime(2022, 10, 4, 23, 53)
  /// is the same date of DateTime(2022, 10, 4, 8, 12, 33)
  const ZwapCalendarInput({
    this.overlayColors,
    this.canRemoveDate = false,
    this.dateFormatString = 'dd/MM/yyyy',
    this.onDateSelected,
    this.selectedDate,
    this.placeholder,
    this.width,
    this.onlyFutureDates = false,
    this.translateText,
    this.borderColor,
    this.backgroundColor,
    this.radius = 8,
    this.textAlign = Alignment.centerLeft,
    this.textColor,
    this.label,
    this.labelTextColor,
    this.labelBackgroundColor,
    this.height,
    this.internalPadding,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapCalendarInput> createState() => _ZwapCalendarInputState();
}

class _ZwapCalendarInputState extends State<ZwapCalendarInput> {
  final GlobalKey _inputKey = GlobalKey();
  late final double _height;

  late final _ZwapCalendarInputProvider _calendarProvider;

  bool _hovered = false;

  OverlayEntry? _calendarEntry;
  bool get _isCalendarOpen => _calendarEntry?.mounted ?? false;

  @override
  void initState() {
    super.initState();
    _height = widget.height ?? 40;
    _calendarProvider = _ZwapCalendarInputProvider(
      onDatePicked: widget.onDateSelected,
      translateText: widget.translateText,
      initialDate: widget.selectedDate,
    );
  }

  @override
  void didUpdateWidget(covariant ZwapCalendarInput oldWidget) {
    if ((widget.selectedDate == null) != (_calendarProvider.selectedDate == null)) {
      _calendarProvider.updateDate(widget.selectedDate);
    } else if (widget.selectedDate != null && _calendarProvider.selectedDate?.isAtSameMomentAs(widget.selectedDate!) == false) {
      _calendarProvider.updateDate(widget.selectedDate);
    }

    // The overlay reads [widget] in its own entry: rebuild it so an open
    // calendar picks up new colors from the parent.
    if (_isCalendarOpen) WidgetsBinding.instance.addPostFrameCallback((_) => _calendarEntry?.markNeedsBuild());

    super.didUpdateWidget(oldWidget);
  }

  void _toggleCalendar() {
    if (_isCalendarOpen)
      _closeCalendar();
    else
      _openCalendar();
  }

  void _openCalendar() {
    if (_calendarEntry != null) return;

    final Rect? _inputRect = _inputKey.globalPaintBounds;
    if (_inputRect == null) return;

    Overlay.of(context).insert(
      _calendarEntry = OverlayEntry(
        builder: (_) => ChangeNotifierProvider<_ZwapCalendarInputProvider>.value(
          value: _calendarProvider,
          child: ZwapOverlayEntryWidget(
            onAutoClose: () => _calendarEntry = null,
            entity: _calendarEntry,
            child: ZwapOverlayEntryChild(
              top: _inputRect.top + _height + 8,
              left: _inputRect.left,
              child: _CalendarPickerOverlay(
                onlyFutureDates: widget.onlyFutureDates,
                onDonePressed: () => _closeCalendar(),
                colors: widget.overlayColors,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _closeCalendar() {
    if (!_isCalendarOpen) return;

    _calendarEntry?.remove();
    _calendarEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ZwapCalendarInputProvider>.value(
      value: _calendarProvider,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: _toggleCalendar,
          child: Builder(
            builder: (context) {
              final DateTime? _selectedDate = context.select<_ZwapCalendarInputProvider, DateTime?>((pro) => pro.selectedDate);

              return Stack(
                children: [
                  Positioned(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: widget.label == null ? null : const EdgeInsets.only(top: 8),
                      curve: Curves.decelerate,
                      key: _inputKey,
                      width: widget.width ?? 140,
                      height: _height,
                      decoration: BoxDecoration(
                        color: widget.backgroundColor ?? (_hovered ? ZwapColors.primary100 : ZwapColors.shades0),
                        border: widget.borderColor == null ? null : Border.all(color: widget.borderColor!),
                        borderRadius: BorderRadius.circular(widget.radius ?? 8),
                        boxShadow: [
                          if (widget.backgroundColor == null && _hovered)
                            BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 2,
                              spreadRadius: 0,
                              color: ZwapColors.primary900Dark.withOpacity(0.05),
                            ),
                        ],
                      ),
                      padding: widget.internalPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Align(
                        alignment: widget.textAlign,
                        child: Row(
                          mainAxisSize: widget.width == double.infinity ? MainAxisSize.max : MainAxisSize.min,
                          children: [
                            if (widget.width == double.infinity)
                              Expanded(
                                child: ZwapText(
                                  text: _selectedDate == null ? widget.placeholder ?? '' : DateFormat(widget.dateFormatString).format(_selectedDate),
                                  zwapTextType: ZwapTextType.mediumBodyRegular,
                                  textColor: widget.textColor ?? (_hovered ? ZwapColors.primary700 : ZwapColors.primary900Dark),
                                ),
                              )
                            else
                              Flexible(
                                child: ZwapText(
                                  text: _selectedDate == null ? widget.placeholder ?? '' : DateFormat(widget.dateFormatString).format(_selectedDate),
                                  zwapTextType: ZwapTextType.mediumBodyRegular,
                                  textColor: widget.textColor ?? (_hovered ? ZwapColors.primary700 : ZwapColors.primary900Dark),
                                ),
                              ),
                            const SizedBox(width: 12),
                            ZwapIcons.icons(
                              'calendar',
                              iconSize: 16,
                              iconColor: widget.textColor ?? (_hovered ? ZwapColors.primary700 : ZwapColors.primary900Dark),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (widget.label != null)
                    Positioned(
                      left: 12,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        color: widget.labelBackgroundColor ?? widget.backgroundColor,
                        child: ZwapText(
                          text: widget.label!,
                          zwapTextType: ZwapTextType.smallBodyRegular,
                          textColor: widget.labelTextColor ?? widget.textColor ?? Colors.grey,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CalendarPickerOverlay extends StatefulWidget {
  final bool onlyFutureDates;
  final Function() onDonePressed;
  final ZwapCalendarOverlayColors? colors;

  const _CalendarPickerOverlay({
    required this.onDonePressed,
    required this.onlyFutureDates,
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

  String get _defaultCopy {
    final String languageCode = Localizations.localeOf(context).languageCode;

    switch (languageCode.toLowerCase()) {
      case 'it':
        return 'Fine';
      default:
        return 'Done';
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? _selectedDate = context.select<_ZwapCalendarInputProvider, DateTime?>((pro) => pro.selectedDate);
    final String Function(String)? _translateText = context.select<_ZwapCalendarInputProvider, String Function(String)?>((pro) => pro.translateText);

    final String _doneCTA = _translateText == null ? _defaultCopy : _translateText('done_cta');
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
                    calendar.CalendarDatePicker2(
                      config: colors.config,
                      initialValue: [_selectedDate],
                      selectableDayPredicate:
                          widget.onlyFutureDates ? (date) => date.isAfter(DateTime.now().subtract(const Duration(days: 1))) : null,
                      onValueChanged: (date) => context.read<_ZwapCalendarInputProvider>().selectedDate = date.firstOrNull,
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
