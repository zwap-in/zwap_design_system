part of weekly_calendar_picker;

//TODO (Marchetti): Add disabled weekdays

class ZwapWeeklyCalendarShowFilter {
  /// If true all the items in the past are disabled
  final bool _disablePast;

  /// If true all the items in the past are not showed
  final bool _hidePast;

  /// List of the weekdays to show. Must contains sorted 1 to 7 values
  final List<int> _showedWeekdays;

  /// Days before [_firstDay] are not showed
  final DateTime? _firstDay;

  /// Days after [_lastDay] are not showed
  final DateTime? _lastDay;

  /// Days after [_disableAfter] are disabled
  final DateTime? _disableAfter;

  /// This items are disabled
  final List<_ZwapWeeklyCalendarPickerItem> _disabledItems;

  //TODO (Marchetti): Improve custom decorations llowing the user customize per day, per days ranges or by other useful ways
  final Map<_ZwapWeeklyCalendarPickerItem, WCPDateSlotWidgetDecorations> _customSlotsDecorations;

  ZwapWeeklyCalendarShowFilter._({
    required bool disablePast,
    required List<int> showedWeekdays,
    required DateTime? firstDay,
    required DateTime? lastDay,
    required bool hidePast,
    required List<_ZwapWeeklyCalendarPickerItem> disabledItems,
    required DateTime? disableAfter,
    Map<_ZwapWeeklyCalendarPickerItem, WCPDateSlotWidgetDecorations>? customSlotsDecorations,
  })  : this._disablePast = disablePast,
        this._showedWeekdays = showedWeekdays,
        this._hidePast = hidePast,
        this._firstDay = firstDay,
        this._lastDay = lastDay,
        this._disabledItems = disabledItems,
        this._disableAfter = disableAfter,
        this._customSlotsDecorations = customSlotsDecorations ?? {};

  //? TODO -> customize days in the past
  /// All days in the past will not showed
  ZwapWeeklyCalendarShowFilter.hidePast()
      : this._disablePast = false,
        this._hidePast = true,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = null,
        this._disableAfter = null,
        this._disabledItems = const [],
        this._customSlotsDecorations = {};

  /// All days in the past will be disabled
  ZwapWeeklyCalendarShowFilter.disablePast()
      : this._disablePast = true,
        this._hidePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = null,
        this._disableAfter = null,
        this._disabledItems = const [],
        this._customSlotsDecorations = {};

  ZwapWeeklyCalendarShowFilter.disableAfter(DateTime dateTime)
      : this._disablePast = true,
        this._hidePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = null,
        this._disabledItems = const [],
        this._disableAfter = dateTime,
        this._customSlotsDecorations = {};

  //? TODO -> customize by week day
  ZwapWeeklyCalendarShowFilter.showWeekDays(List<int> weekDays)
      : _disablePast = false,
        this._hidePast = false,
        this._lastDay = null,
        this._showedWeekdays = weekDays,
        this._firstDay = null,
        this._disableAfter = null,
        this._disabledItems = const [],
        this._customSlotsDecorations = {};

  //? TODO -> customize day after a date
  ZwapWeeklyCalendarShowFilter.after(DateTime date)
      : _disablePast = false,
        this._hidePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = date,
        this._lastDay = null,
        this._disabledItems = const [],
        this._disableAfter = null,
        this._customSlotsDecorations = {};

  //? TODO -> customize day before a date
  ZwapWeeklyCalendarShowFilter.before(DateTime date)
      : _disablePast = false,
        this._hidePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = date,
        this._disableAfter = null,
        this._disabledItems = const [],
        this._customSlotsDecorations = {};

  //? TODO -> customize day betweek two date
  ZwapWeeklyCalendarShowFilter.between(DateTime start, DateTime end)
      : _disablePast = false,
        this._hidePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = start,
        this._lastDay = end,
        this._disabledItems = const [],
        this._disableAfter = null,
        this._customSlotsDecorations = {};

  ZwapWeeklyCalendarShowFilter.disableItem(
    DateTime date,
    TimeOfDay time, {
    WCPDateSlotWidgetDecorations? customDecorations,
  })  : _disablePast = false,
        this._hidePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = null,
        this._disabledItems = [_ZwapWeeklyCalendarPickerItem(date, _CustomTimeOfDay.fromTimeOfDay(time, hidden: true))],
        this._disableAfter = null,
        this._customSlotsDecorations = {
          if (customDecorations != null) _ZwapWeeklyCalendarPickerItem(date, _CustomTimeOfDay.fromTimeOfDay(time, hidden: true)): customDecorations,
        };

  /// If [customDecorations] is not null, [singleCustomDecorations] will be ignored
  ZwapWeeklyCalendarShowFilter.disableItems(
    List<TupleType<DateTime, TimeOfDay>> disabledItems, {
    WCPDateSlotWidgetDecorations? customDecorations,
    Map<TupleType<DateTime, TimeOfDay>, WCPDateSlotWidgetDecorations?>? singleCustomDecorations,
  })  : _disablePast = false,
        this._hidePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = null,
        this._disableAfter = null,
        this._disabledItems =
            disabledItems.map((e) => _ZwapWeeklyCalendarPickerItem(e.a, _CustomTimeOfDay.fromTimeOfDay(e.b, hidden: true))).toList(),
        this._customSlotsDecorations = customDecorations != null
            ? {
                for (TupleType<DateTime, TimeOfDay> t in disabledItems)
                  _ZwapWeeklyCalendarPickerItem(t.a, _CustomTimeOfDay.fromTimeOfDay(t.b, hidden: true)): customDecorations,
              }
            : {
                for (TupleType<DateTime, TimeOfDay> t in disabledItems)
                  if ((singleCustomDecorations ?? {})[t] != null)
                    _ZwapWeeklyCalendarPickerItem(t.a, _CustomTimeOfDay.fromTimeOfDay(t.b, hidden: true)): singleCustomDecorations![t]!,
              };

  ZwapWeeklyCalendarShowFilter.customizeItem(
    DateTime date,
    TimeOfDay time, {
    WCPDateSlotWidgetDecorations? customDecorations,
  })  : _disablePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._hidePast = false,
        this._firstDay = null,
        this._lastDay = null,
        this._disableAfter = null,
        this._disabledItems = [],
        this._customSlotsDecorations = {
          if (customDecorations != null) _ZwapWeeklyCalendarPickerItem(date, _CustomTimeOfDay.fromTimeOfDay(time, hidden: true)): customDecorations,
        };

  /// One of [customDecorations] or [singleCustomDecorations] must be not null
  ///
  /// If both are provided, [customDecorations] will be used for all slots
  ZwapWeeklyCalendarShowFilter.customizeItems(
    List<TupleType<DateTime, TimeOfDay>> customizedItems, {
    WCPDateSlotWidgetDecorations? customDecorations,
    Map<TupleType<DateTime, TimeOfDay>, WCPDateSlotWidgetDecorations?>? singleCustomDecorations,
  })  : _disablePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._hidePast = false,
        this._lastDay = null,
        this._disabledItems = [],
        this._disableAfter = null,
        this._customSlotsDecorations = customDecorations != null
            ? {
                for (TupleType<DateTime, TimeOfDay> t in customizedItems)
                  _ZwapWeeklyCalendarPickerItem(t.a, _CustomTimeOfDay.fromTimeOfDay(t.b, hidden: true)): customDecorations,
              }
            : {
                for (TupleType<DateTime, TimeOfDay> t in customizedItems)
                  if ((singleCustomDecorations ?? {})[t] != null)
                    _ZwapWeeklyCalendarPickerItem(t.a, _CustomTimeOfDay.fromTimeOfDay(t.b, hidden: true)): singleCustomDecorations![t]!,
              };

  /// Merge two filters and return a new filter with more relevant paramether between both
  ZwapWeeklyCalendarShowFilter _mergeWith(ZwapWeeklyCalendarShowFilter other) {
    return ZwapWeeklyCalendarShowFilter._(
      disablePast: _disablePast || other._disablePast,
      hidePast: _hidePast || other._hidePast,
      showedWeekdays: _showedWeekdays.length < other._showedWeekdays.length ? _showedWeekdays : other._showedWeekdays,
      firstDay: _firstDay == null && other._firstDay == null
          ? null
          : _firstDay == null || other._firstDay == null
              ? _firstDay ?? other._firstDay
              : _firstDay!.isBefore(other._firstDay!)
                  ? _firstDay
                  : other._firstDay,
      lastDay: _lastDay == null && other._lastDay == null
          ? null
          : _lastDay == null || other._lastDay == null
              ? _lastDay ?? other._lastDay
              : _lastDay!.isBefore(other._lastDay!)
                  ? _lastDay
                  : other._lastDay,
      disabledItems: {..._disabledItems, ...other._disabledItems}.toList(),
      customSlotsDecorations: {..._customSlotsDecorations, ...other._customSlotsDecorations},
      disableAfter: _disableAfter == null && other._disableAfter == null
          ? null
          : _disableAfter == null || other._disableAfter == null
              ? _disableAfter ?? other._disableAfter
              : _disableAfter!.isBefore(other._disableAfter!)
                  ? _disableAfter
                  : other._disableAfter,
    );
  }
}
