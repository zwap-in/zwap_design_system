part of weekly_calendar_picker;

/// The state of the calendar picker
class ZwapWeeklyCalendarPickerProvider extends ChangeNotifier {
  /// The date of the first day of the current week
  late DateTime __currentWeek;

  /// The times from the widget
  late ZwapWeeklyCalendarTimes _calendarTimes;

  /// The filtes from the widget
  late List<ZwapWeeklyCalendarPickFilter> _filters;

  /// The showing filter from the widget
  late ZwapWeeklyCalendarShowFilter? _showFilter;

  /// The current selected items
  late List<_ZwapWeeklyCalendarPickerItem> _selected;

  /// The hovered date inside the calendar picker
  _ZwapWeeklyCalendarPickerItem? _hoveredItem;

  /// Callback function from widget
  late Function(List<TupleType<DateTime, TimeOfDay>>)? _onChange;

  DateTime get currentWeek => __currentWeek;

  List<_ZwapWeeklyCalendarPickerItem> get selected => _selected;
  _ZwapWeeklyCalendarPickerItem? get hoveredItem => _hoveredItem;

  set _currentWeek(DateTime value) => value != __currentWeek ? {__currentWeek = value, notifyListeners()} : null;
  set hoveredItem(_ZwapWeeklyCalendarPickerItem? value) => _hoveredItem != value ? {_hoveredItem = value, notifyListeners()} : null;

  ZwapWeeklyCalendarPickerProvider({
    required ZwapWeeklyCalendarTimes calendarTimes,
    required List<ZwapWeeklyCalendarPickFilter> filters,
    required ZwapWeeklyCalendarShowFilter? showFilter,
    List<_ZwapWeeklyCalendarPickerItem>? initialSelectedItems,
    Function(List<TupleType<DateTime, TimeOfDay>>)? onChange,
    DateTime? initialDate,
  }) {
    this.__currentWeek = (initialDate ?? DateTime.now()).firstOfWeek;
    this._selected = initialSelectedItems ?? [];
    this._calendarTimes = calendarTimes;
    this._filters = filters;
    this._showFilter = showFilter;
    this._onChange = onChange;
  }

  void toggleItem(_ZwapWeeklyCalendarPickerItem item) async {
    int _i = _selected.indexWhere((e) => e.date.pureDate == item.date.pureDate && e.time == item.time);

    //? Se elemento presente semplicemente rimuovo
    if (_i > -1) {
      _selected.removeAt(_i);
      if (_onChange != null) _onChange!(_selected.map((i) => TupleType(a: i.date, b: i.time)).toList());

      notifyListeners();
      return;
    }
    for (ZwapWeeklyCalendarPickFilter _f in _filters) {
      _ZwapPickFilterResponse _filterRes = await _f._evaluateFilter(_selected.map((s) => TupleType(a: s.date, b: s.time)).toList(), item);

      if (_filterRes.handler == ZwapWeeklyCalendarHandleFilter.cancel) return;
      if (_filterRes.handler == ZwapWeeklyCalendarHandleFilter.replace) {
        if (_filterRes.error == null) return;
        try {
          switch (_filterRes.error!) {
            case _ZwapWeeklyCalendarFilterErrors.maxCount:
              toggleItem(_selected.first);
              break;
            case _ZwapWeeklyCalendarFilterErrors.maxPerDay:
              toggleItem(_selected.lastWhere((e) => e.date.isAtSameMomentAs(item.date)));
              break;
            case _ZwapWeeklyCalendarFilterErrors.maxPerWeek:
              toggleItem(_selected.lastWhere((e) => e.date.firstOfWeek.isAtSameMomentAs(item.date.firstOfWeek)));
              break;
            case _ZwapWeeklyCalendarFilterErrors.maxPerWeekDay:
              toggleItem(_selected.lastWhere((e) => e.date.weekday == item.date.weekday));
              break;
            case _ZwapWeeklyCalendarFilterErrors.maxPerDoubleWeek:
              toggleItem(_selected.lastWhere((e) => e.date.weekday == item.date.weekday));
              break;
            case _ZwapWeeklyCalendarFilterErrors.maxPerMonth:
              // TODO: Handle this case.
              break;
          }
        } catch (e) {
          return;
        }
      }
    }

    _selected.add(item);

    if (_onChange != null) _onChange!(_selected.map((i) => TupleType(a: i.date, b: i.time)).toList());

    notifyListeners();
  }

  /// Return [true] if day should be showed, false otherwise
  bool _checkIfShowWidget(DateTime day) {
    if (_showFilter == null) return true;

    final bool _hideBecouseInPast = _showFilter!._hidePast && day.isBefore(DateTime.now());
    final bool _hideBecouseBeforeFirst = _showFilter!._firstDay != null && day.isBefore(_showFilter!._firstDay!);
    final bool _hideBecouseAfterLast = _showFilter!._lastDay != null && day.isAfter(_showFilter!._firstDay!);

    return !(_hideBecouseAfterLast || _hideBecouseInPast || _hideBecouseBeforeFirst);
  }

  void nextWeek() => _currentWeek = __currentWeek.add(Duration(days: 7, hours: 23)).firstOfWeek;
  void precedentWeek() => _currentWeek = __currentWeek.add(Duration(days: -7, hours: 23)).firstOfWeek;

  Map<DateTime, List<_CustomTimeOfDay>> get currentWeekTimes {
    late List<_CustomTimeOfDay> _dayTimesSummary;

    final List<int> _weekDays = _showFilter?._showedWeekdays ?? [1, 2, 3, 4, 5, 6, 7];
    late Map<DateTime, List<_CustomTimeOfDay>> _res;
    late List<_CustomTimeOfDay> _emptyDays;

    DateTime _tmp = DateTime.now();

    List<_CustomTimeOfDay> _fillTimesOfDay(List<Object> _times, {bool a = false}) {
      late List<_CustomTimeOfDay> _converted;

      if (_times.isEmpty)
        _converted = [];
      else if (_times.first is TimeOfDay)
        _converted = (_times as List<TimeOfDay>).map((t) => _CustomTimeOfDay.fromTimeOfDay(t)).toList();
      else
        _converted = _times as List<_CustomTimeOfDay>;

      if (_converted.length >= _dayTimesSummary.length) return _converted;

      List<_CustomTimeOfDay> _missingTimes = (List<_CustomTimeOfDay>.from(_dayTimesSummary)..removeWhere((time) => _times.contains(time)))
          .map((time) => time.copyWith(hidden: true))
          .toList();
      return [..._converted, ..._missingTimes];
    }

    switch (_calendarTimes._type) {
      case _ZwapWeeklyCalendarTimesTypes.daily:
        _dayTimesSummary = {
          for (int i in _weekDays)
            if (_checkIfShowWidget(_tmp = __currentWeek.add(Duration(days: i - 1)))) ..._calendarTimes._simgleDayTimes!,
        }.toList().map((t) => _CustomTimeOfDay.fromTimeOfDay(t)).toList();

        // TODO (Marchetti): Implement empty days for daily calendar times
        _res = {
          for (int i in _weekDays)
            if (_checkIfShowWidget(_tmp = __currentWeek.add(Duration(days: i - 1)))) _tmp.pureDate: _fillTimesOfDay(_calendarTimes._simgleDayTimes!),
        };

        break;
      case _ZwapWeeklyCalendarTimesTypes.weekly:
        _dayTimesSummary = {
          ..._calendarTimes._weeklyTimes!.entries.map((e) => e.value).reduce((v, e) => [...v, ...e]),
        }.toList().map((t) => _CustomTimeOfDay.fromTimeOfDay(t)).toList();

        _emptyDays = [];

        _res = {
          for (int i in _weekDays)
            if (_checkIfShowWidget(_tmp = __currentWeek.add(Duration(days: i - 1))))
              _tmp.pureDate: _fillTimesOfDay(_calendarTimes._weeklyTimes![__currentWeek.add(Duration(days: i - 1)).weekday] ?? _emptyDays),
        };

        break;
      case _ZwapWeeklyCalendarTimesTypes.custom:
        _dayTimesSummary = {
          for (int i in _weekDays)
            if (_checkIfShowWidget(_tmp = __currentWeek.add(Duration(days: i - 1))))
              ..._calendarTimes._customTimes![__currentWeek.add(Duration(days: i))] ?? [],
        }.toList().map((t) => _CustomTimeOfDay.fromTimeOfDay(t)).toList();

        _emptyDays = List<TimeOfDay>.from(_calendarTimes._weeklyTimes!.entries.firstOrNull?.value ?? [])
            .map((t) => _CustomTimeOfDay.fromTimeOfDay(t, hidden: true))
            .toList();

        _res = {
          for (int i in _weekDays)
            if (_checkIfShowWidget(_tmp = __currentWeek.add(Duration(days: i - 1))))
              _tmp.pureDate: _fillTimesOfDay(_calendarTimes._customTimes![__currentWeek.add(Duration(days: i))] ?? _emptyDays),
        };
        break;
    }

    return _res.map((k, v) => MapEntry<DateTime, List<_CustomTimeOfDay>>(
        k.pureDate, v..sort((a, b) => a.hour.compareTo(b.hour) == 0 ? a.minute.compareTo(b.minute) : a.hour.compareTo(b.hour))));
  }

  void widgetSelectedUpdated(List<_ZwapWeeklyCalendarPickerItem> items) {
    _selected = items;
    notifyListeners();
  }
}
