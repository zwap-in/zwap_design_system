part of weekly_calendar_picker;

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

//TODO (Marchetti): Impove adding time ranges
/// Types of ranges for a pick filter
enum _PickFilterSlotRangeType {
  /// All slots are included
  all,

  /// All slots between two dates are included
  range,

  /// Only slots inside the slots list are included
  list,
}

class _PickFilterSlotRange {
  final _PickFilterSlotRangeType _type;

  /// When [_type] is _PickFilterSlotRangeType.range this value is used as start of range
  ///
  /// If null, the range has no start and all dates before [end] are included
  final DateTime? start;

  /// When [_type] is _PickFilterSlotRangeType.range this value is used as end of range
  ///
  /// If null, the range has no end and all dates after [start] are included
  final DateTime? end;

  /// When [_type] is _PickFilterSlotRangeType.list this value contains all this slots in a "custom" range
  final List<TupleType<DateTime, TimeOfDay>> slots;

  const _PickFilterSlotRange.all()
      : _type = _PickFilterSlotRangeType.all,
        this.start = null,
        this.end = null,
        this.slots = const [];

  /// If both [start] and [end] of range are null, this range is the same as _PickFilterSlotRange.all()
  const _PickFilterSlotRange.between({
    this.start,
    this.end,
  })  : _type = _PickFilterSlotRangeType.range,
        this.slots = const [];

  const _PickFilterSlotRange.after({
    this.start,
  })  : _type = _PickFilterSlotRangeType.range,
        this.end = null,
        this.slots = const [];

  const _PickFilterSlotRange.before({
    this.end,
  })  : _type = _PickFilterSlotRangeType.range,
        this.start = null,
        this.slots = const [];

  _PickFilterSlotRange.singleSlot(TupleType<DateTime, TimeOfDay> slot)
      : this._type = _PickFilterSlotRangeType.list,
        this.end = null,
        this.start = null,
        this.slots = [slot];

  const _PickFilterSlotRange.slots(this.slots)
      : _type = _PickFilterSlotRangeType.list,
        this.start = null,
        this.end = null;
}

class ZwapWeeklyCalendarPickFilter {
  /// Used as default value if [onFilterCatch] invocation returns true
  ///
  /// If is null [ZwapWeeklyCalendarHandleFilter.allow] will be used
  final ZwapWeeklyCalendarHandleFilter? _defaultHandler;

  /// [onFilterCatch] will be called only on this slots
  final _PickFilterSlotRange _filterSlotsRange;

  /// Called when a slot in the range has been tapped. In the results is null [_defaultHandler] values is used instead
  final FutureOr<ZwapWeeklyCalendarHandleFilter?> Function(TupleType<DateTime, TimeOfDay>)? onFilterCatch;

  ZwapWeeklyCalendarPickFilter._({
    ZwapWeeklyCalendarHandleFilter? defaultHandler,
    required _PickFilterSlotRange filterSlotsRange,
    this.onFilterCatch,
  })  : this._defaultHandler = defaultHandler,
        this._filterSlotsRange = filterSlotsRange;

  /// Make inpossible to select date in the past
  ///
  /// Changing the [defaultHandler] different results can be obtained
  ///
  /// You can override this filter providing a onFilterCatch callback
  ZwapWeeklyCalendarPickFilter.notPast({
    this.onFilterCatch,
    ZwapWeeklyCalendarHandleFilter? defaultHandler = ZwapWeeklyCalendarHandleFilter.cancel,
    bool includeToday = true,
  })  : this._defaultHandler = defaultHandler,
        this._filterSlotsRange = _PickFilterSlotRange.before(end: includeToday ? DateTime.now() : DateTime.now().add(Duration(days: -1)));

  /// Make inpossible to select date before a provided date
  ///
  /// Changing the [defaultHandler] different results can be obtained
  ///
  /// You can override this filter providing a [onFilterCatch] callback
  ZwapWeeklyCalendarPickFilter.notBefore({
    required DateTime end,
    this.onFilterCatch,
    ZwapWeeklyCalendarHandleFilter? defaultHandler = ZwapWeeklyCalendarHandleFilter.cancel,
  })  : this._defaultHandler = defaultHandler,
        this._filterSlotsRange = _PickFilterSlotRange.before(end: end);

  /// Make inpossible to select date after a provided date
  ///
  /// Changing the [defaultHandler] different results can be obtained
  ///
  /// You can override this filter providing a [onFilterCatch] callback
  ZwapWeeklyCalendarPickFilter.notAfter({
    required DateTime start,
    this.onFilterCatch,
    ZwapWeeklyCalendarHandleFilter? defaultHandler = ZwapWeeklyCalendarHandleFilter.cancel,
  })  : this._defaultHandler = defaultHandler,
        this._filterSlotsRange = _PickFilterSlotRange.after(start: start);

  /// Make inpossible to select date inside the provided range
  ///
  /// Changing the [defaultHandler] different results can be obtained
  ///
  /// You can override this filter providing a [onFilterCatch] callback
  ZwapWeeklyCalendarPickFilter.notBetween({
    required DateTime start,
    required DateTime end,
    this.onFilterCatch,
    ZwapWeeklyCalendarHandleFilter? defaultHandler = ZwapWeeklyCalendarHandleFilter.cancel,
  })  : this._defaultHandler = defaultHandler,
        this._filterSlotsRange = _PickFilterSlotRange.between(start: start, end: end);

  /// Make inpossible to select this slots
  ///
  /// Changing the [defaultHandler] different results can be obtained
  ///
  /// You can override this filter providing a [onFilterCatch] callback
  ZwapWeeklyCalendarPickFilter.disableSlots({
    required List<TupleType<DateTime, TimeOfDay>> slots,
    this.onFilterCatch,
    ZwapWeeklyCalendarHandleFilter? defaultHandler = ZwapWeeklyCalendarHandleFilter.cancel,
  })  : this._defaultHandler = defaultHandler,
        this._filterSlotsRange = _PickFilterSlotRange.slots(slots);

  Future<_ZwapPickFilterResponse> _evaluateFilter(List<TupleType<DateTime, TimeOfDay>> selected, _ZwapWeeklyCalendarPickerItem newItem) async {
    //? Verify if newItem is in this filter range, if not [ZwapWeeklyCalendarHandleFilter.allow] is returned
    switch (_filterSlotsRange._type) {
      case _PickFilterSlotRangeType.all:
        break;
      case _PickFilterSlotRangeType.range:
        if (_filterSlotsRange.start != null &&
            _filterSlotsRange.end != null &&
            newItem.date.isBefore(_filterSlotsRange.start!) &&
            newItem.date.isAfter(_filterSlotsRange.end!))
          return _ZwapPickFilterResponse(ZwapWeeklyCalendarHandleFilter.allow);
        else if (_filterSlotsRange.start != null && newItem.date.isBefore(_filterSlotsRange.start!))
          return _ZwapPickFilterResponse(ZwapWeeklyCalendarHandleFilter.allow);
        else if (_filterSlotsRange.end != null && newItem.date.isAfter(_filterSlotsRange.end!))
          return _ZwapPickFilterResponse(ZwapWeeklyCalendarHandleFilter.allow);
        break;
      case _PickFilterSlotRangeType.list:
        print(_filterSlotsRange.slots.map((e) => e.a));
        print(_filterSlotsRange.slots.map((e) => e.b));
        print(newItem);
        if (!_filterSlotsRange.slots
            .any((s) => s.a.pureDate.isAtSameMomentAs(newItem.date.pureDate) && newItem.time.hour == s.b.hour && newItem.time.minute == s.b.minute)) {
          return _ZwapPickFilterResponse(ZwapWeeklyCalendarHandleFilter.allow);
        }
        break;
    }

    ZwapWeeklyCalendarHandleFilter? _handler = _defaultHandler;
    if (onFilterCatch != null) _handler = await onFilterCatch!(TupleType(a: newItem.date, b: newItem.time)) ?? _defaultHandler;

    return _ZwapPickFilterResponse(_handler ?? ZwapWeeklyCalendarHandleFilter.allow);
  }
}

//TODO (Marchetti): Implements more max filter such as time range max, single days max, single week max

enum _ZwapWeeklyCalendarPickMaxFilterType { all, byWeekDay, daily, weekly, biweekly, monthly }

class ZwapWeeklyCalendarPickMaxFilter extends ZwapWeeklyCalendarPickFilter {
  final int maxCount;
  final _ZwapWeeklyCalendarPickMaxFilterType _type;

  /// If [_type] == _ZwapWeeklyCalendarPickMaxFilterType.byWeekDay this is used to know which day consider
  final int? weekDay;

  /// If provided this callback notifiy that an select action have been interrupted (with the default handler provided) from this filter
  final FutureOr Function()? notifyFilterCatch;

  /// Check if the current selected slots are less or equal to provided [maxCount]
  ///
  /// If their are more the onFilterCatch will be called. If null value is returned defaultHandler will be used
  ZwapWeeklyCalendarPickMaxFilter.all({
    required this.maxCount,
    this.notifyFilterCatch,
    ZwapWeeklyCalendarHandleFilter? defaultHandler,
  })  : this._type = _ZwapWeeklyCalendarPickMaxFilterType.all,
        this.weekDay = null,
        super._(
          filterSlotsRange: _PickFilterSlotRange.all(),
          defaultHandler: defaultHandler ?? ZwapWeeklyCalendarHandleFilter.cancel,
          onFilterCatch: null,
        );

  /// Check if the current selected slots are less or equal to provided [maxCount]
  ///
  /// If their are more the onFilterCatch will be called. If null value is returned defaultHandler will be used
  ZwapWeeklyCalendarPickMaxFilter.daily({
    required this.maxCount,
    this.notifyFilterCatch,
    ZwapWeeklyCalendarHandleFilter? defaultHandler,
  })  : this._type = _ZwapWeeklyCalendarPickMaxFilterType.daily,
        this.weekDay = null,
        super._(
          filterSlotsRange: _PickFilterSlotRange.all(),
          defaultHandler: defaultHandler ?? ZwapWeeklyCalendarHandleFilter.cancel,
          onFilterCatch: null,
        );

  /// Check if the current selected slots are less or equal to provided [maxCount]
  ///
  /// If their are more the onFilterCatch will be called. If null value is returned defaultHandler will be used
  ZwapWeeklyCalendarPickMaxFilter.byWeekDay({
    required this.maxCount,
    required int weekDay,
    this.notifyFilterCatch,
    ZwapWeeklyCalendarHandleFilter? defaultHandler,
  })  : this._type = _ZwapWeeklyCalendarPickMaxFilterType.byWeekDay,
        this.weekDay = weekDay,
        super._(
          filterSlotsRange: _PickFilterSlotRange.all(),
          defaultHandler: defaultHandler ?? ZwapWeeklyCalendarHandleFilter.cancel,
          onFilterCatch: null,
        );

  /// Check if the current selected slots are less or equal to provided [maxCount]
  ///
  /// If their are more the onFilterCatch will be called. If null value is returned defaultHandler will be used
  ZwapWeeklyCalendarPickMaxFilter.weekly({
    required this.maxCount,
    this.notifyFilterCatch,
    ZwapWeeklyCalendarHandleFilter? defaultHandler,
  })  : this._type = _ZwapWeeklyCalendarPickMaxFilterType.weekly,
        this.weekDay = null,
        super._(
          filterSlotsRange: _PickFilterSlotRange.all(),
          defaultHandler: defaultHandler ?? ZwapWeeklyCalendarHandleFilter.cancel,
          onFilterCatch: null,
        );

  /// Check if the current selected slots are less or equal to provided [maxCount]
  ///
  /// If their are more the onFilterCatch will be called. If null value is returned defaultHandler will be used
  ZwapWeeklyCalendarPickMaxFilter.biweekly({
    required this.maxCount,
    this.notifyFilterCatch,
    ZwapWeeklyCalendarHandleFilter? defaultHandler,
  })  : this._type = _ZwapWeeklyCalendarPickMaxFilterType.biweekly,
        this.weekDay = null,
        super._(
          filterSlotsRange: _PickFilterSlotRange.all(),
          defaultHandler: defaultHandler ?? ZwapWeeklyCalendarHandleFilter.cancel,
          onFilterCatch: null,
        );

  /// Check if the current selected slots are less or equal to provided [maxCount]
  ///
  /// If their are more the onFilterCatch will be called. If null value is returned defaultHandler will be used
  ZwapWeeklyCalendarPickMaxFilter.monthly({
    required this.maxCount,
    this.notifyFilterCatch,
    ZwapWeeklyCalendarHandleFilter? defaultHandler,
  })  : this._type = _ZwapWeeklyCalendarPickMaxFilterType.monthly,
        this.weekDay = null,
        super._(
          filterSlotsRange: _PickFilterSlotRange.all(),
          defaultHandler: defaultHandler ?? ZwapWeeklyCalendarHandleFilter.cancel,
          onFilterCatch: null,
        );

  @override
  Future<_ZwapPickFilterResponse> _evaluateFilter(List<TupleType<DateTime, TimeOfDay>> selected, _ZwapWeeklyCalendarPickerItem newItem) async {
    late final bool _filterCatched;
    late final _ZwapWeeklyCalendarFilterErrors _error;

    switch (_type) {
      case _ZwapWeeklyCalendarPickMaxFilterType.all:
        _filterCatched = selected.length + 1 > maxCount;
        _error = _ZwapWeeklyCalendarFilterErrors.maxCount;
        break;
      case _ZwapWeeklyCalendarPickMaxFilterType.daily:
        int _dayCount = selected.where((s) => s.a.isAtSameMomentAs(newItem.date)).length;

        _filterCatched = _dayCount + 1 > maxCount;
        _error = _ZwapWeeklyCalendarFilterErrors.maxPerDay;
        break;
      case _ZwapWeeklyCalendarPickMaxFilterType.byWeekDay:
        int _thisWeekDayCount = selected.where((s) => s.a.weekday == this.weekDay!).length;

        _filterCatched = _thisWeekDayCount + 1 > maxCount;
        _error = _ZwapWeeklyCalendarFilterErrors.maxPerWeekDay;
        break;
      case _ZwapWeeklyCalendarPickMaxFilterType.weekly:
        int _weeklyCount = selected.where((s) => s.a.isAfter(newItem.date.firstOfWeek) && s.a.isBefore(newItem.date.endOfWeek)).length;

        print(_weeklyCount);
        _filterCatched = _weeklyCount + 1 > maxCount;
        _error = _ZwapWeeklyCalendarFilterErrors.maxPerWeek;
        break;
      case _ZwapWeeklyCalendarPickMaxFilterType.biweekly:
        int _biweeklyCount =
            selected.where((s) => s.a.isAfter(newItem.date.firstOfWeek) && s.a.isBefore(newItem.date.endOfWeek.add(const Duration(days: 7)))).length;

        _filterCatched = _biweeklyCount + 1 > maxCount;
        _error = _ZwapWeeklyCalendarFilterErrors.maxPerDoubleWeek;
        break;
      case _ZwapWeeklyCalendarPickMaxFilterType.monthly:
        int _monthlyCount = selected.where((s) => s.a.isAfter(newItem.date.firstOfMonth) && s.a.isBefore(newItem.date.endOfMonth)).length;

        _filterCatched = _monthlyCount + 1 > maxCount;
        _error = _ZwapWeeklyCalendarFilterErrors.maxPerMonth;
        break;
    }

    if (_filterCatched) {
      if (notifyFilterCatch != null) await notifyFilterCatch!();
      return _ZwapPickFilterResponse(
        _defaultHandler ?? ZwapWeeklyCalendarHandleFilter.cancel,
        error: _error,
      );
    }

    return _ZwapPickFilterResponse(ZwapWeeklyCalendarHandleFilter.allow);
  }
}
