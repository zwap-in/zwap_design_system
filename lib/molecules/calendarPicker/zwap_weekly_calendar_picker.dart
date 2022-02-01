/// IMPORTING THIRD PARTY PACKAGES
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';
import 'package:zwap_design_system/molecules/molecules.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/scrollArrows/zwapScrollArrow.dart';

import 'package:collection/collection.dart';
import 'package:zwap_design_system/extensions/dateTimeExtension.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

enum _ZwapWeeklyCalendarTimesTypes { daily, weekly, custom }

enum ZwapWeeklyCalendarHandleFilter {
  /// Permit the action
  allow,

  /// Stop the action
  cancel,
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
  final int? maxPerDay;
  final int? maxPerWeek;

  final Map<int, int>? maxPerWeekDay;
  final Map<DateTime, int>? maxPerDayCustom;

  /// All keys (DateTimes) will be rounded up to the Monday of the week
  final Map<DateTime, int>? maxPerWeekCustom;

  final DateTime? minDay;
  final DateTime? maxDay;

  final FutureOr<ZwapWeeklyCalendarHandleFilter?> Function(TupleType<DateTime, TimeOfDay>)? onFilterCatch;

  ZwapWeeklyCalendarPickFilter.notPast({this.onFilterCatch, bool includeToday = true})
      : this.minDay = includeToday ? DateTime.now() : DateTime.now().add(Duration(days: -1)),
        this.maxPerDay = null,
        this.maxPerWeek = null,
        this.maxPerWeekDay = null,
        this.maxPerDayCustom = null,
        this.maxPerWeekCustom = null,
        this.maxDay = null;

  ZwapWeeklyCalendarPickFilter.maxPerWeek(int maxPerWeek, {this.onFilterCatch})
      : this.minDay = null,
        this.maxPerDay = null,
        this.maxPerWeek = maxPerWeek,
        this.maxPerWeekDay = null,
        this.maxPerDayCustom = null,
        this.maxPerWeekCustom = null,
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
  });

  Future<ZwapWeeklyCalendarHandleFilter> _evaluateFilter(Map<DateTime, List<TimeOfDay>> selected, _ZwapWeeklyCalendarPickerItem newItem) async {
    int _countWeekElements({DateTime? initialDate}) {
      DateTime _tmp = initialDate ?? newItem.date.pureDate;

      DateTime _firstOfWeek = _tmp.firstOfWeek;
      DateTime _lastOfWeel = _firstOfWeek.add(Duration(days: 7));

      List<int> _subTotals = selected.keys.where((d) => d.isAfter(_firstOfWeek) && d.isBefore(_lastOfWeel)).map((d) => selected[d]?.length ?? 0).toList();
      return _subTotals.isEmpty ? 0 : _subTotals.reduce((v, e) => v += e);
    }

    bool _evaluateMaxPerDay() {
      if (maxPerDay == null) return true;
      return (selected[newItem.date.pureDate] ?? []).length + 1 <= maxPerDay!;
    }

    bool _evaluateMaxPerWeek() {
      if (maxPerWeek == null) return true;
      return _countWeekElements() + 1 <= maxPerWeek!;
    }

    bool _evaluateMacPerWeekDay() {
      if (maxPerWeekDay == null || maxPerWeekDay![newItem.date.weekday] == null) return true;
      return (selected[newItem.date.pureDate] ?? []).length + 1 <= maxPerWeekDay![newItem.date.weekday]!;
    }

    bool _evaluateMapPerDayCustom() {
      if (maxPerDayCustom == null || !maxPerDayCustom!.containsKey(newItem.date.pureDate)) return true;
      return (selected[newItem.date] ?? []).length + 1 <= maxPerDayCustom![newItem.date.pureDate]!;
    }

    bool _evaluateMaxPerWeekCustom() {
      if (maxPerWeekCustom == null || (!maxPerDayCustom!.keys.map((k) => k.firstOfWeek.pureDate).contains(newItem.date.firstOfWeek.pureDate))) return true;

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

    bool _res = _evaluateMaxPerDay() && _evaluateMaxPerWeek() && _evaluateMacPerWeekDay() && _evaluateMapPerDayCustom() && _evaluateMaxPerWeekCustom() && _evaluateMaxDay() && _evaluateMinDay();

    ZwapWeeklyCalendarHandleFilter? _handler;

    if (!_res && onFilterCatch != null) _handler = await onFilterCatch!(TupleType(a: newItem.date, b: newItem.time));

    return _res ? ZwapWeeklyCalendarHandleFilter.allow : _handler ?? ZwapWeeklyCalendarHandleFilter.cancel;
  }
}

class ZwapWeeklyCalendarShowFilter {
  final bool _disablePast;
  final List<int> _showedWeekdays;
  final DateTime? _firstDay;
  final DateTime? _lastDay;
  final List<_ZwapWeeklyCalendarPickerItem> _disabledItems;

  final Map<_ZwapWeeklyCalendarPickerItem, Function(TupleType<DateTime, TimeOfDay>)?> _onDayTap;

  ZwapWeeklyCalendarShowFilter._({
    required bool disablePast,
    required List<int> showedWeekdays,
    required DateTime? firstDay,
    required DateTime? lastDay,
    required List<_ZwapWeeklyCalendarPickerItem> disabledItems,
    required Map<_ZwapWeeklyCalendarPickerItem, Function(TupleType<DateTime, TimeOfDay>)?> onDayTap,
  })  : this._disablePast = disablePast,
        this._showedWeekdays = showedWeekdays,
        this._firstDay = firstDay,
        this._lastDay = lastDay,
        this._disabledItems = disabledItems,
        this._onDayTap = onDayTap;

  ZwapWeeklyCalendarShowFilter.notPast()
      : this._disablePast = true,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = null,
        this._disabledItems = const [],
        this._onDayTap = {};

  ZwapWeeklyCalendarShowFilter.showWeekDays(List<int> weekDays)
      : _disablePast = false,
        this._showedWeekdays = weekDays,
        this._firstDay = null,
        this._lastDay = null,
        this._disabledItems = const [],
        this._onDayTap = {};

  ZwapWeeklyCalendarShowFilter.after(DateTime date)
      : _disablePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = date,
        this._lastDay = null,
        this._disabledItems = const [],
        this._onDayTap = {};

  ZwapWeeklyCalendarShowFilter.before(DateTime date)
      : _disablePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = date,
        this._disabledItems = const [],
        this._onDayTap = {};

  ZwapWeeklyCalendarShowFilter.between(DateTime first, DateTime last)
      : _disablePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = first,
        this._lastDay = last,
        this._disabledItems = const [],
        this._onDayTap = {};

  ZwapWeeklyCalendarShowFilter.disableItem(DateTime date, TimeOfDay time, {Function(TupleType<DateTime, TimeOfDay>)? onDayTap})
      : _disablePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = null,
        this._disabledItems = [_ZwapWeeklyCalendarPickerItem(date, time)],
        this._onDayTap = {_ZwapWeeklyCalendarPickerItem(date, time): onDayTap};

  /// If [onThoseDaysTap] is not null, [onDayTap] will be ignored
  ZwapWeeklyCalendarShowFilter.disableItems(List<TupleType<DateTime, TimeOfDay>> disabledItems,
      {Function(TupleType<DateTime, TimeOfDay>)? onThoseDaysTap, Map<TupleType<DateTime, TimeOfDay>, Function(TupleType<DateTime, TimeOfDay>)?>? onDayTap})
      : _disablePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = null,
        this._disabledItems = disabledItems.map((e) => _ZwapWeeklyCalendarPickerItem(e.a, e.b)).toList(),
        this._onDayTap = onThoseDaysTap != null
            ? {for (TupleType<DateTime, TimeOfDay> t in disabledItems) _ZwapWeeklyCalendarPickerItem(t.a, t.b): onThoseDaysTap}
            : {for (TupleType<DateTime, TimeOfDay> t in onDayTap?.keys ?? []) _ZwapWeeklyCalendarPickerItem(t.a, t.b): onDayTap![t]};

  /// Merge two filters and return a new filter with more relevant paramether between both
  ZwapWeeklyCalendarShowFilter _mergeWith(ZwapWeeklyCalendarShowFilter other) {
    return ZwapWeeklyCalendarShowFilter._(
      disablePast: _disablePast || other._disablePast,
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
      onDayTap: {..._onDayTap, ...other._onDayTap},
    );
  }
}

class _ZwapWeeklyCalendarPickerItem {
  final DateTime date;
  final TimeOfDay time;

  const _ZwapWeeklyCalendarPickerItem(this.date, this.time);

  @override
  operator ==(Object other) {
    return other is _ZwapWeeklyCalendarPickerItem && date.isAtSameMomentAs(other.date) && time == other.time;
  }

  @override
  int get hashCode => date.hashCode ^ time.hashCode;

  @override
  String toString() => '$date : $time';
}

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
    DateTime? initialDate,
  }) {
    this.__currentWeek = (initialDate ?? DateTime.now()).firstOfWeek;
    this._selected = initialSelectedItems ?? [];
    this._calendarTimes = calendarTimes;
    this._filters = filters;
    this._showFilter = showFilter;
  }

  void toggleItem(_ZwapWeeklyCalendarPickerItem item) async {
    int _i = _selected.indexWhere((e) => e.date.pureDate == item.date.pureDate && e.time == item.time);

    //? Se elemento presente semplicemente rimuovo
    if (_i > -1) {
      _selected.removeAt(_i);
      notifyListeners();
      return;
    }

    //? Verifico se per vari filtri posso selezionare il valore
    Map<DateTime, List<TimeOfDay>> _organizedTimes = {};
    for (_ZwapWeeklyCalendarPickerItem i in _selected)
      if (_organizedTimes.containsKey(i.date.pureDate))
        _organizedTimes[i.date.pureDate]!.add(i.time);
      else
        _organizedTimes[i.date.pureDate] = [i.time];

    for (ZwapWeeklyCalendarPickFilter _f in _filters) if ((await _f._evaluateFilter(_organizedTimes, item)) == ZwapWeeklyCalendarHandleFilter.cancel) return;

    _selected.add(item);
    notifyListeners();
  }

  bool _checkDay(DateTime day) {
    if (_showFilter == null) return true;

    final bool _disableBecouseInPast = _showFilter!._disablePast && day.isBefore(DateTime.now());
    final bool _disableBecouseBeforeFirst = _showFilter!._firstDay != null && day.isBefore(_showFilter!._firstDay!);
    final bool _disableBecouseAfterLast = _showFilter!._lastDay != null && day.isAfter(_showFilter!._firstDay!);

    return !(_disableBecouseAfterLast || _disableBecouseInPast || _disableBecouseBeforeFirst);
  }

  void nextWeek() => _currentWeek = __currentWeek.add(Duration(days: 7, hours: 23)).firstOfWeek;
  void precedentWeek() => _currentWeek = __currentWeek.add(Duration(days: -7, hours: 23)).firstOfWeek;

  Map<DateTime, List<TimeOfDay>> get currentWeekTimes {
    final List<int> _weekDays = _showFilter?._showedWeekdays ?? [1, 2, 3, 4, 5, 6, 7];

    late Map<DateTime, List<TimeOfDay>> _res;

    DateTime _tmp = DateTime.now();

    switch (_calendarTimes._type) {
      case _ZwapWeeklyCalendarTimesTypes.daily:
        _res = {
          for (int i in _weekDays)
            if (_checkDay(_tmp = __currentWeek.add(Duration(days: i - 1)))) _tmp: _calendarTimes._simgleDayTimes!,
        };
        break;
      case _ZwapWeeklyCalendarTimesTypes.weekly:
        _res = {
          for (int i in _weekDays)
            if (_checkDay(_tmp = __currentWeek.add(Duration(days: i - 1)))) _tmp: _calendarTimes._weeklyTimes![__currentWeek.add(Duration(days: i)).weekday] ?? [],
        };
        break;
      case _ZwapWeeklyCalendarTimesTypes.custom:
        _res = {
          for (int i in _weekDays)
            if (_checkDay(_tmp = __currentWeek.add(Duration(days: i - 1)))) _tmp: _calendarTimes._customTimes![__currentWeek.add(Duration(days: i))] ?? [],
        };
        break;
    }

    return _res.map((k, v) => MapEntry<DateTime, List<TimeOfDay>>(k.pureDate, v..sort((a, b) => a.hour.compareTo(b.hour) == 0 ? a.minute.compareTo(b.minute) : a.hour.compareTo(b.hour))));
  }
}

/// THe calendar picker to show the slots date
class ZwapWeeklyCalendarPicker extends StatefulWidget {
  /// Verrà arrotondato al lunedi della settamana di [intialDay]
  final DateTime? initialDay;

  /// I dati da mostrare nel picker
  final ZwapWeeklyCalendarTimes times;

  /// CallBack to handle the key name for any text
  final Function(String key) handleKeyName;

  /// The **initial** selected elements
  final List<TupleType<DateTime, TimeOfDay>>? selected;

  /// called each time element is added/removed
  final Function(List<TupleType<DateTime, TimeOfDay>>)? onChange;

  /// Used to check if user can add a time in a date/hour
  final List<ZwapWeeklyCalendarPickFilter> pickFilters;

  /// Used to check to disable / show only some elements
  final ZwapWeeklyCalendarShowFilter? _showFilter;

  ZwapWeeklyCalendarPicker({
    Key? key,
    this.initialDay,
    required this.times,
    required this.handleKeyName,
    this.selected,
    this.onChange,
    this.pickFilters = const [],
    List<ZwapWeeklyCalendarShowFilter> showFilters = const [],
  })  : this._showFilter = showFilters.isNotEmpty ? showFilters.reduce((v, e) => v._mergeWith(e)) : null,
        super(key: key);

  @override
  State<ZwapWeeklyCalendarPicker> createState() => _ZwapWeeklyCalendarPickerState();
}

class _ZwapWeeklyCalendarPickerState extends State<ZwapWeeklyCalendarPicker> {
  final ScrollController _horizontalScrollController = ScrollController();
  late final LinkedScrollControllerGroup _verticalScrollLinker;

  ///! Se un giorno si dovesse implementare per più di 7 colonne prestare attenzione alle prestazioni. Piuttosto renderizzare le colonne come un unico blocco
  late final List<ScrollController> _columnsScrollControllers;

  @override
  void initState() {
    super.initState();

    _verticalScrollLinker = LinkedScrollControllerGroup();
    _columnsScrollControllers = List.generate(7, (i) => _verticalScrollLinker.addAndGet());
  }

  bool _isItemDisabled(_ZwapWeeklyCalendarPickerItem item) {
    final ZwapWeeklyCalendarShowFilter? _filter = widget._showFilter;

    if (_filter == null) return false;

    final bool _isInDisabledList = _filter._disabledItems.where((i) => i.date.pureDate == item.date && i.time == item.time).isNotEmpty;
    final bool _isInPast = _filter._disablePast && item.date.isBefore(DateTime.now());

    bool _isBeforeMin = false;
    bool _isAfterMax = false;

    for (ZwapWeeklyCalendarPickFilter f in widget.pickFilters) {
      if (f.minDay?.isAfter(item.date) ?? false) _isBeforeMin = true;
      if (f.maxDay?.isBefore(item.date) ?? false) _isAfterMax = true;

      if (_isAfterMax || _isBeforeMin) break;
    }

    return _isInDisabledList || _isInPast || _isBeforeMin || _isAfterMax;
  }

  /// It retrieves all slots column
  Widget _getDaysSlot(BuildContext context, DateTime day) {
    day = day.pureDate;

    String weekDayName = Constants.weekDayAbbrName()[day.weekday]!;
    final Map<DateTime, List<TimeOfDay>> _showedDays = context.select<ZwapWeeklyCalendarPickerProvider, Map<DateTime, List<TimeOfDay>>>((pro) => pro.currentWeekTimes);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: ZwapText(
                text: this.widget.handleKeyName(weekDayName),
                textColor: ZwapColors.neutral800,
                zwapTextType: ZwapTextType.bodySemiBold,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: ZwapText(
                textColor: ZwapColors.neutral800,
                text: "${day.day}",
                zwapTextType: ZwapTextType.bodySemiBold,
              ),
            ),
            SizedBox(height: 7),
            Flexible(
              child: SingleChildScrollView(
                controller: _columnsScrollControllers[day.weekday - 1],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _showedDays[day]!.map(
                    (TimeOfDay time) {
                      final bool isSelected = context.select<ZwapWeeklyCalendarPickerProvider, bool>((pro) => pro.selected.any((s) => s.date.pureDate == day && s.time == time));
                      final bool isHovered = context.select<ZwapWeeklyCalendarPickerProvider, bool>((pro) => pro.hoveredItem?.date.pureDate == day && pro.hoveredItem?.time == time);
                      final bool isDisabled = _isItemDisabled(_ZwapWeeklyCalendarPickerItem(day, time));

                      Function? _disabledCallBack = widget._showFilter != null
                          ? widget._showFilter!._onDayTap[_ZwapWeeklyCalendarPickerItem(day, time)] != null
                              ? () => widget._showFilter!._onDayTap[_ZwapWeeklyCalendarPickerItem(day, time)]!(TupleType(a: day, b: time))
                              : null
                          : null;

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 7.5),
                        child: InkWell(
                          onTap: isDisabled
                              ? _disabledCallBack == null
                                  ? null
                                  : () => _disabledCallBack()
                              : () => context.read<ZwapWeeklyCalendarPickerProvider>().toggleItem(_ZwapWeeklyCalendarPickerItem(day, time)),
                          onHover: isDisabled ? null : (bool isHovered) => context.read<ZwapWeeklyCalendarPickerProvider>().hoveredItem = isHovered ? _ZwapWeeklyCalendarPickerItem(day, time) : null,
                          borderRadius: BorderRadius.circular(10),
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          mouseCursor: isDisabled ? SystemMouseCursors.forbidden : null,
                          child: Container(
                            width: 55,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDisabled
                                    ? ZwapColors.neutral100
                                    : isSelected
                                        ? isHovered
                                            ? ZwapColors.primary200
                                            : ZwapColors.primary100
                                        : isHovered
                                            ? ZwapColors.neutral300
                                            : Colors.transparent,
                              ),
                              color: isDisabled
                                  ? Colors.transparent
                                  : isSelected
                                      ? isHovered
                                          ? ZwapColors.primary50
                                          : ZwapColors.primary100
                                      : isHovered
                                          ? ZwapColors.neutral100
                                          : Colors.transparent,
                            ),
                            child: Center(
                              child: ZwapText(
                                text: "${time.hour}:${Utils.plotMinute(time.minute)}",
                                textColor: isSelected
                                    ? isDisabled
                                        ? ZwapColors.primary800
                                        : ZwapColors.primary400
                                    : isDisabled
                                        ? ZwapColors.neutral300
                                        : ZwapColors.neutral800,
                                zwapTextType: isSelected ? ZwapTextType.bodySemiBold : ZwapTextType.bodyRegular,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ZwapWeeklyCalendarPickerProvider>(
          create: (_) => ZwapWeeklyCalendarPickerProvider(
            calendarTimes: widget.times,
            filters: widget.pickFilters,
            initialDate: widget.initialDay,
            showFilter: widget._showFilter,
            initialSelectedItems: widget.selected?.map((i) => _ZwapWeeklyCalendarPickerItem(i.a, i.b)).toList(),
          ),
        )
      ],
      child: LayoutBuilder(
        builder: (context, size) {
          final Map<DateTime, List<TimeOfDay>> _showedDays = context.select<ZwapWeeklyCalendarPickerProvider, Map<DateTime, List<TimeOfDay>>>((pro) => pro.currentWeekTimes);

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ZwapScrollArrow(
                      isRight: false,
                      onClickCallBack: () => context.read<ZwapWeeklyCalendarPickerProvider>().precedentWeek(),
                    ),
                    flex: 0,
                    fit: FlexFit.tight,
                  ),
                  Flexible(
                    flex: 0,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: ZwapText(
                          zwapTextType: ZwapTextType.h3,
                          text: "${this.widget.handleKeyName(Constants.monthlyName()[_showedDays.keys.first.month]!)}",
                          textColor: ZwapColors.neutral700,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: ZwapScrollArrow(
                      isRight: true,
                      onClickCallBack: () => context.read<ZwapWeeklyCalendarPickerProvider>().nextWeek(),
                    ),
                    fit: FlexFit.tight,
                    flex: 0,
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (DateTime d in _showedDays.keys) _getDaysSlot(context, d),
                    ],
                  ),
                ),
              ),
              if (size.maxWidth < _showedDays.keys.length * 70) ...[
                SizedBox(height: 7),
                _ZwapWeeklyCalendarPickerDaySelector(
                  scrollController: _horizontalScrollController,
                  handleKey: widget.handleKeyName,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ZwapWeeklyCalendarPickerDaySelector extends StatefulWidget {
  final ScrollController scrollController;
  final Function(String key) handleKey;

  _ZwapWeeklyCalendarPickerDaySelector({
    required this.scrollController,
    required this.handleKey,
    Key? key,
  }) : super(key: key);

  static const Map<int, String> _oneLetterDayNames = {
    1: 'mondayOneLetterDay',
    2: 'tuesdayOneLetterDay',
    3: 'wednesdayOneLetterDay',
    4: 'thursdayOneLetterDay',
    5: 'fridayOneLetterDay',
    6: 'saturdayOneLetterDay',
    7: 'sundayOneLetterDay',
  };

  @override
  State<_ZwapWeeklyCalendarPickerDaySelector> createState() => _ZwapWeeklyCalendarPickerDaySelectorState();
}

class _ZwapWeeklyCalendarPickerDaySelectorState extends State<_ZwapWeeklyCalendarPickerDaySelector> {
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey _firstLetterKey = GlobalKey();
  final GlobalKey _lastLetterKey = GlobalKey();

  ScrollController get _scrollController => widget.scrollController;

  double _offset = 0;

  bool _isHovered = false;
  bool _isPanned = false;

  @override
  void initState() {
    super.initState();

    _offset = _scrollController.offset;
    _scrollController.addListener(_scrollListener);

    Future.delayed(const Duration(milliseconds: 50), () => setState(() {}));
  }

  void _scrollListener() {
    setState(() => _offset = _scrollController.offset);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<int> _showedWeekDays = context.select<ZwapWeeklyCalendarPickerProvider, List<int>>((pro) => pro.currentWeekTimes.keys.map((k) => k.weekday).toList());
    final double _scrollWidth = _showedWeekDays.length * 70;

    double? _left;
    double? _width;
    double? _widthCoeffincent;

    Rect? _containerRect = _containerKey.globalPaintBounds;
    Rect? _firstRect = _firstLetterKey.globalPaintBounds;
    Rect? _lastRect = _lastLetterKey.globalPaintBounds;

    if (_containerRect != null && _firstRect != null && _lastRect != null) {
      _widthCoeffincent = _containerRect.width / _scrollWidth;

      _width = (_lastRect.left - _firstRect.left + 2) * _widthCoeffincent + 10;
      _left = _firstRect.left - _containerRect.left + (_offset * _showedWeekDays.length * 17) / _scrollWidth;
    }

    return Container(
      key: _containerKey,
      height: 40,
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _showedWeekDays
                  .mapIndexed(
                    (i, wd) => Container(
                      key: i == 0
                          ? _firstLetterKey
                          : i == _showedWeekDays.length - 1
                              ? _lastLetterKey
                              : null,
                      width: 17,
                      child: ZwapText(
                        text: widget.handleKey(_ZwapWeeklyCalendarPickerDaySelector._oneLetterDayNames[wd]!),
                        textColor: ZwapColors.neutral500,
                        zwapTextType: ZwapTextType.bodySemiBold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          if (_left != null && _width != null && _widthCoeffincent != null)
            Positioned(
              top: 8,
              bottom: 8,
              left: _left,
              width: _width,
              child: InkWell(
                onTap: () => print('adsfasf'),
                onHover: (isHovered) => setState(() => _isHovered = isHovered),
                borderRadius: BorderRadius.circular(4),
                mouseCursor: SystemMouseCursors.move,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onPanStart: (_) => setState(() => _isPanned = true),
                  onPanUpdate: (details) async {
                    final double _tmpOffset = _scrollController.offset + ((details.delta.dx) * _widthCoeffincent! * 4);
                    if (_tmpOffset < 0 || _tmpOffset > (_scrollWidth - _containerRect!.width)) return;

                    _scrollController.jumpTo(_tmpOffset);
                  },
                  onPanEnd: (_) => setState(() => _isPanned = false),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: ZwapColors.primary700, width: 0.7),
                      color: _isHovered || _isPanned ? ZwapColors.primary200.withOpacity(0.25) : Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
