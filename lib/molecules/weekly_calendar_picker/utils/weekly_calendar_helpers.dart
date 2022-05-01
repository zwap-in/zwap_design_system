part of weekly_calendar_picker;

enum _ZwapWeeklyCalendarTimesTypes { daily, weekly, custom }

enum ZwapWeeklyCalendarHandleFilter {
  /// Permit the action
  allow,

  /// Stop the action
  cancel,

  /// For some exception this means to replace the item with an other one, for other have the same values of [cancel]
  replace,
}

/// Types of Errors that Calendar Filters can throw
enum _ZwapWeeklyCalendarFilterErrors {
  maxCount,
  maxPerDay,
  maxPerWeek,
  maxPerDoubleWeek,
  maxPerWeekDay,
  maxPerMonth,
}

class _CustomTimeOfDay extends TimeOfDay {
  final bool hidden;

  _CustomTimeOfDay({required this.hidden, required int hour, required int minute}) : super(hour: hour, minute: minute);

  _CustomTimeOfDay.fromTimeOfDay(TimeOfDay timeOfDay, {this.hidden = false}) : super(hour: timeOfDay.hour, minute: timeOfDay.minute);

  _CustomTimeOfDay copyWith({
    bool? hidden,
    int? hour,
    int? minute,
  }) {
    return _CustomTimeOfDay(
      hidden: hidden ?? this.hidden,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return (other is _CustomTimeOfDay && other.hour == hour && other.minute == minute) ||
        (other is DateTime && other.hour == hour && other.minute == minute);
  }

  @override
  int get hashCode => hidden.hashCode;

  @override
  String toString() => '_CustomTimeOfDay(hidden: $hidden, time: ${super.toString()})';
}
/*
class _ZwapPickFilterResponse {
  ZwapWeeklyCalendarHandleFilter handler;
  _ZwapWeeklyCalendarFilterErrors? error;

  _ZwapPickFilterResponse(this.handler, {this.error});
}

class ZwapWeeklyCalendarTimes {
  final _ZwapWeeklyCalendarTimesTypes _type;

  final List<TimeOfDay>? _simgleDayTimes;
  final Map<int, List<TimeOfDay>>? _weeklyTimes;
  final Map<DateTime, List<TimeOfDay>>? _customTimes;

  ZwapWeeklyCalendarTimes.daily({required List<TimeOfDay> dailyTimes})
      : this._simgleDayTimes = dailyTimes,
        this._customTimes = null,
        this._weeklyTimes = null,
        this._type = _ZwapWeeklyCalendarTimesTypes.daily;

  ZwapWeeklyCalendarTimes.weekly({required Map<int, List<TimeOfDay>> weeklyTimes})
      : this._weeklyTimes = weeklyTimes,
        this._customTimes = null,
        this._simgleDayTimes = null,
        this._type = _ZwapWeeklyCalendarTimesTypes.weekly;

  ZwapWeeklyCalendarTimes.custom({required Map<DateTime, List<TimeOfDay>> customTimes})
      : this._customTimes = customTimes,
        this._simgleDayTimes = null,
        this._weeklyTimes = null,
        this._type = _ZwapWeeklyCalendarTimesTypes.custom;
}

class ZwapWeeklyCalendarPickFilter {
  final int? maxCount;

  final int? maxPerDay;
  final int? maxPerWeek;

  final Map<int, int>? maxPerWeekDay;
  final Map<DateTime, int>? maxPerDayCustom;

  /// All keys (DateTimes) will be rounded up to the Monday of the week
  final Map<DateTime, int>? maxPerWeekCustom;

  final DateTime? minDay;
  final DateTime? maxDay;

  /// If not null [onFilterCatch] will be called only on this slots
  final FutureOr<ZwapWeeklyCalendarHandleFilter?> Function(TupleType<DateTime, TimeOfDay>)? onFilterCatch;

  /// The default handler is used onlt when onFilterCatch is not not but his response is null
  final ZwapWeeklyCalendarHandleFilter _defaultErrorHandler;

  final bool Function(TupleType<DateTime, TimeOfDay> slot)? disableWhere;

  /// This will visually disable all past slot
  ZwapWeeklyCalendarPickFilter.notPast({this.onFilterCatch, bool includeToday = true})
      : this.maxCount = null,
        this.minDay = includeToday ? DateTime.now() : DateTime.now().add(Duration(days: -1)),
        this.maxPerDay = null,
        this.maxPerWeek = null,
        this.maxPerWeekDay = null,
        this.maxPerDayCustom = null,
        this.maxPerWeekCustom = null,
        this._defaultErrorHandler = ZwapWeeklyCalendarHandleFilter.cancel,
        this.disableWhere = null,
        this.maxDay = null;

  ZwapWeeklyCalendarPickFilter.maxPerWeek(int maxPerWeek, {this.onFilterCatch, ZwapWeeklyCalendarHandleFilter? defaultHandler})
      : this.maxCount = null,
        this.minDay = null,
        this.maxPerDay = null,
        this.maxPerWeek = maxPerWeek,
        this.maxPerWeekDay = null,
        this.maxPerDayCustom = null,
        this.maxPerWeekCustom = null,
        this._defaultErrorHandler = defaultHandler ?? ZwapWeeklyCalendarHandleFilter.cancel,
        this.disableWhere = null,
        this.maxDay = null;

  ZwapWeeklyCalendarPickFilter.maxSelected(this.maxCount, {this.onFilterCatch, ZwapWeeklyCalendarHandleFilter? defaultHandler})
      : this.maxPerDay = null,
        this.maxPerWeek = null,
        this.maxPerWeekDay = null,
        this.maxPerDayCustom = null,
        this.maxPerWeekCustom = null,
        this.minDay = null,
        this._defaultErrorHandler = defaultHandler ?? ZwapWeeklyCalendarHandleFilter.cancel,
        this.disableWhere = null,
        this.maxDay = null;

  //TODO (Marchetti): Remove this visual decoration (moved to show filters)
  /// This will visually disable all slots where [disableWhere(slot)] return true
  ZwapWeeklyCalendarPickFilter.disableWhere(this.disableWhere, {this.onFilterCatch, ZwapWeeklyCalendarHandleFilter? defaultHandler})
      : this.maxCount = null,
        this.maxPerDay = null,
        this.maxPerWeek = null,
        this.maxPerWeekDay = null,
        this.maxPerDayCustom = null,
        this.maxPerWeekCustom = null,
        this.minDay = null,
        this._defaultErrorHandler = defaultHandler ?? ZwapWeeklyCalendarHandleFilter.cancel,
        this.maxDay = null;

  ZwapWeeklyCalendarPickFilter.handlePickItem(
    TupleType<DateTime, TimeOfDay> item, {
    FutureOr<ZwapWeeklyCalendarHandleFilter?> Function(TupleType<DateTime, TimeOfDay>)? onPickItem,
    ZwapWeeklyCalendarHandleFilter? defaultHandler,
  })  : this.maxCount = null,
        this.maxPerDay = null,
        this.maxPerWeek = null,
        this.maxPerWeekDay = null,
        this.maxPerDayCustom = null,
        this.maxPerWeekCustom = null,
        this.minDay = null,
        this.onFilterCatch = null,
        this.disableWhere = null,
        this._defaultErrorHandler = defaultHandler ?? ZwapWeeklyCalendarHandleFilter.cancel,
        this.maxDay = null;

  ZwapWeeklyCalendarPickFilter.handlePickItems(
    List<TupleType<DateTime, TimeOfDay>> items, {
    FutureOr<ZwapWeeklyCalendarHandleFilter?> Function(TupleType<DateTime, TimeOfDay>)? onPickItem,
    ZwapWeeklyCalendarHandleFilter? defaultHandler,
  })  : this.maxCount = null,
        this.maxPerDay = null,
        this.maxPerWeek = null,
        this.maxPerWeekDay = null,
        this.maxPerDayCustom = null,
        this.maxPerWeekCustom = null,
        this.disableWhere = null,
        this.onFilterCatch = onPickItem,
        this.minDay = null,
        this._defaultErrorHandler = defaultHandler ?? ZwapWeeklyCalendarHandleFilter.cancel,
        this.maxDay = null;

  ZwapWeeklyCalendarPickFilter({
    this.onFilterCatch,
    this.maxPerDay,
    this.maxPerWeek,
    this.maxPerWeekDay,
    this.maxPerDayCustom,
    this.maxPerWeekCustom,
    this.maxDay,
    this.minDay,
    this.disableWhere,
    this.maxCount,
  }) : this._defaultErrorHandler = ZwapWeeklyCalendarHandleFilter.cancel;

  Future<_ZwapPickFilterResponse> _evaluateFilter(Map<DateTime, List<TimeOfDay>> selected, _ZwapWeeklyCalendarPickerItem newItem) async {
    int _countWeekElements({DateTime? initialDate}) {
      DateTime _tmp = initialDate ?? newItem.date.pureDate;

      DateTime _firstOfWeek = _tmp.firstOfWeek.subtract(Duration(seconds: 100));
      DateTime _lastOfWeel = _firstOfWeek.add(Duration(days: 7));

      List<int> _subTotals =
          selected.keys.where((d) => d.isAfter(_firstOfWeek) && d.isBefore(_lastOfWeel)).map((d) => selected[d]?.length ?? 0).toList();
      return _subTotals.isEmpty ? 0 : _subTotals.reduce((v, e) => v += e);
    }

    bool _evaluateMaxCount() {
      if (maxCount == null) return true;
      try {
        return (selected.keys.map((k) => selected[k]!.length).reduce((v, e) => v += e)) + 1 < maxCount!;
      } catch (e) {
        return true;
      }
    }

    bool _evaluateMaxPerDay() {
      if (maxPerDay == null) return true;
      return (selected[newItem.date.pureDate] ?? []).length + 1 <= maxPerDay!;
    }

    bool _evaluateMaxPerWeek() {
      if (maxPerWeek == null) return true;
      return _countWeekElements() + 1 <= maxPerWeek!;
    }

    bool _evaluateMaxPerWeekDay() {
      if (maxPerWeekDay == null || maxPerWeekDay![newItem.date.weekday] == null) return true;
      return (selected[newItem.date.pureDate] ?? []).length + 1 <= maxPerWeekDay![newItem.date.weekday]!;
    }

    bool _evaluateMaxPerDayCustom() {
      if (maxPerDayCustom == null || !maxPerDayCustom!.containsKey(newItem.date.pureDate)) return true;
      return (selected[newItem.date] ?? []).length + 1 <= maxPerDayCustom![newItem.date.pureDate]!;
    }

    bool _evaluateMaxPerWeekCustom() {
      if (maxPerWeekCustom == null || (!maxPerDayCustom!.keys.map((k) => k.firstOfWeek.pureDate).contains(newItem.date.firstOfWeek.pureDate)))
        return true;

      return _countWeekElements() + 1 <= maxPerDayCustom!.map((k, v) => MapEntry(k.firstOfWeek.pureDate, v))[newItem.date.firstOfWeek]!;
    }

    bool _evaluateMaxDay() {
      if (maxDay == null) return true;
      return newItem.date.pureDate.isBefore(maxDay!);
    }

    bool _evaluateMinDay() {
      if (minDay == null) return true;
      return newItem.date.pureDate.isAfter(minDay!);
    }

    _ZwapWeeklyCalendarFilterErrors? _error = !_evaluateMaxCount()
        ? _ZwapWeeklyCalendarFilterErrors.maxCount
        : !_evaluateMaxPerDay()
            ? _ZwapWeeklyCalendarFilterErrors.maxPerDay
            : !_evaluateMaxPerWeek()
                ? _ZwapWeeklyCalendarFilterErrors.maxPerWeek
                : !_evaluateMaxPerWeekDay()
                    ? _ZwapWeeklyCalendarFilterErrors.maxPerWeekDay
                    : !_evaluateMaxPerDayCustom()
                        ? _ZwapWeeklyCalendarFilterErrors.maxPerDayCustom
                        : !_evaluateMaxPerWeekCustom()
                            ? _ZwapWeeklyCalendarFilterErrors.maxPerWeekCustom
                            : null;

    if (_error != null && _defaultErrorHandler == ZwapWeeklyCalendarHandleFilter.replace)
      return _ZwapPickFilterResponse(
        ZwapWeeklyCalendarHandleFilter.replace,
        error: _error,
      );

    bool _res = _evaluateMaxCount() &&
        _evaluateMaxPerDay() &&
        _evaluateMaxPerWeek() &&
        _evaluateMaxPerWeekDay() &&
        _evaluateMaxPerDayCustom() &&
        _evaluateMaxPerWeekCustom() &&
        _evaluateMaxDay() &&
        _evaluateMinDay();

    ZwapWeeklyCalendarHandleFilter? _handler;

    if (_res && onFilterCatch != null) _handler = await onFilterCatch!(TupleType(a: newItem.date, b: newItem.time)) ?? _defaultErrorHandler;

    return _ZwapPickFilterResponse(
      _handler == null ? ZwapWeeklyCalendarHandleFilter.allow : _handler,
      error: _handler == ZwapWeeklyCalendarHandleFilter.replace ? _error : null,
    );
  }
}
 */