/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zwap_utils/zwap_utils.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/scrollArrows/zwapScrollArrow.dart';

import 'package:collection/collection.dart';
import 'package:zwap_design_system/extensions/dateTimeExtension.dart';

enum _ZwapWeeklyCalendarTimesTypes { daily, weekly, custom }

enum ZwapWeeklyCalendarHandleFilter { allow, ignore, replace }

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

class ZwapWeeklyCanlendarPickFilter {
  final int? maxPerDay;
  final int? maxPerWeek;

  final Map<int, int>? maxPerWeekDay;
  final Map<DateTime, int>? maxPerDayCustom;
  final Map<DateTime, int>? maxPerWeekCustom;

  final DateTime? minDay;
  final DateTime? maxDay;

  final ZwapWeeklyCalendarHandleFilter Function(TupleType<DateTime, TimeOfDay>)? onFilterCatch;

  ZwapWeeklyCanlendarPickFilter.notPast({this.onFilterCatch, bool includeToday = true})
      : this.minDay = includeToday ? DateTime.now() : DateTime.now().add(Duration(days: -1)),
        this.maxPerDay = null,
        this.maxPerWeek = null,
        this.maxPerWeekDay = null,
        this.maxPerDayCustom = null,
        this.maxPerWeekCustom = null,
        this.maxDay = null;

  ZwapWeeklyCanlendarPickFilter.maxPerWeek(int maxPerWeek, {this.onFilterCatch})
      : this.minDay = null,
        this.maxPerDay = null,
        this.maxPerWeek = maxPerWeek,
        this.maxPerWeekDay = null,
        this.maxPerDayCustom = null,
        this.maxPerWeekCustom = null,
        this.maxDay = null;

  ZwapWeeklyCanlendarPickFilter({
    this.onFilterCatch,
    this.maxPerDay,
    this.maxPerWeek,
    this.maxPerWeekDay,
    this.maxPerDayCustom,
    this.maxPerWeekCustom,
    this.maxDay,
    this.minDay,
  });

  Future<bool> _evaluateFilter(Map<DateTime, List<TimeOfDay>> selected, _ZwapWeeklyCalendarPickerItem newItem) async {
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

    return _evaluateMaxPerDay() && _evaluateMaxPerWeek() && _evaluateMacPerWeekDay() && _evaluateMapPerDayCustom() && _evaluateMaxPerWeekCustom() && _evaluateMaxDay() && _evaluateMinDay();
  }
}

class ZwapWeeklyCalendarShowFilter {
  final bool _disablePast;
  final List<int> _showedWeekdays;
  final DateTime? _firstDay;
  final DateTime? _lastDay;
  final List<_ZwapWeeklyCalendarPickerItem> _disabledItems;

  ZwapWeeklyCalendarShowFilter._({
    required bool disablePast,
    required List<int> showedWeekdays,
    required DateTime? firstDay,
    required DateTime? lastDay,
    required List<_ZwapWeeklyCalendarPickerItem> disabledItems,
  })  : this._disablePast = disablePast,
        this._showedWeekdays = showedWeekdays,
        this._firstDay = firstDay,
        this._lastDay = lastDay,
        this._disabledItems = disabledItems;

  ZwapWeeklyCalendarShowFilter.notPast()
      : this._disablePast = true,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = null,
        this._disabledItems = const [];

  ZwapWeeklyCalendarShowFilter.showWeekDays(List<int> weekDays)
      : _disablePast = false,
        this._showedWeekdays = weekDays,
        this._firstDay = null,
        this._lastDay = null,
        this._disabledItems = const [];

  ZwapWeeklyCalendarShowFilter.after(DateTime date)
      : _disablePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = date,
        this._lastDay = null,
        this._disabledItems = const [];

  ZwapWeeklyCalendarShowFilter.before(DateTime date)
      : _disablePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = date,
        this._disabledItems = const [];

  ZwapWeeklyCalendarShowFilter.between(DateTime first, DateTime last)
      : _disablePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = first,
        this._lastDay = last,
        this._disabledItems = const [];

  ZwapWeeklyCalendarShowFilter.disableItem(DateTime date, TimeOfDay time)
      : _disablePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = null,
        this._disabledItems = [_ZwapWeeklyCalendarPickerItem(date, time)];

  ZwapWeeklyCalendarShowFilter.disableItems(List<TupleType<DateTime, TimeOfDay>> disabledItems)
      : _disablePast = false,
        this._showedWeekdays = [1, 2, 3, 4, 5, 6, 7],
        this._firstDay = null,
        this._lastDay = null,
        this._disabledItems = disabledItems.map((e) => _ZwapWeeklyCalendarPickerItem(e.a, e.b)).toList();

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
  late List<ZwapWeeklyCanlendarPickFilter> _filters;

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
    required List<ZwapWeeklyCanlendarPickFilter> filters,
    List<_ZwapWeeklyCalendarPickerItem>? initialSelectedItems,
    DateTime? initialDate,
  }) {
    this.__currentWeek = (initialDate ?? DateTime.now()).firstOfWeek;
    this._selected = initialSelectedItems ?? [];
    this._calendarTimes = calendarTimes;
    this._filters = filters;
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

    for (ZwapWeeklyCanlendarPickFilter _f in _filters) if (!(await _f._evaluateFilter(_organizedTimes, item))) return;

    _selected.add(item);
    notifyListeners();
  }

  void nextWeek() => _currentWeek = __currentWeek.add(Duration(days: 7, hours: 23)).firstOfWeek;
  void precedentWeek() => _currentWeek = __currentWeek.add(Duration(days: -7, hours: 23)).firstOfWeek;

  Map<DateTime, List<TimeOfDay>> get currentWeekTimes {
    final List<int> _seven = List.generate(7, (i) => i);

    switch (_calendarTimes._type) {
      case _ZwapWeeklyCalendarTimesTypes.daily:
        return {
          for (int i in _seven) __currentWeek.add(Duration(days: i)): _calendarTimes._simgleDayTimes!,
        };
      case _ZwapWeeklyCalendarTimesTypes.weekly:
        return {
          for (int i in _seven) __currentWeek.add(Duration(days: i)): _calendarTimes._weeklyTimes![__currentWeek.add(Duration(days: i)).weekday] ?? [],
        };
      case _ZwapWeeklyCalendarTimesTypes.custom:
        return {
          for (int i in _seven) __currentWeek.add(Duration(days: i)): _calendarTimes._customTimes![__currentWeek.add(Duration(days: i))] ?? [],
        };
    }
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
  final List<ZwapWeeklyCanlendarPickFilter> pickFilters;

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
  /// It retrieves all slots column
  Widget _getDaysSlot(BuildContext context, DateTime day) {
    String weekDayName = Constants.weekDayAbbrName()[day.weekday]!;
    final Map<DateTime, List<TimeOfDay>> _showedDays = context.select<ZwapWeeklyCalendarPickerProvider, Map<DateTime, List<TimeOfDay>>>((pro) => pro.currentWeekTimes);

    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
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
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: _showedDays[day]!.map(
                (TimeOfDay time) {
                  final List<_ZwapWeeklyCalendarPickerItem> _selected = context.select<ZwapWeeklyCalendarPickerProvider, List<_ZwapWeeklyCalendarPickerItem>>((pro) => pro.selected);

                  final bool isSelected = _selected.contains(_ZwapWeeklyCalendarPickerItem(day, time));
                  final bool isHovered = context.select<ZwapWeeklyCalendarPickerProvider, bool>((pro) => pro.hoveredItem?.date == day && pro.hoveredItem?.time == time);

                  final bool disabled = widget._showFilter?._disabledItems.where((i) => i.date == day && i.time == time).isNotEmpty ?? false;

                  if (day.day == 25) {
                    print(isSelected);
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: InkWell(
                      onTap: disabled ? null : () => context.read<ZwapWeeklyCalendarPickerProvider>().toggleItem(_ZwapWeeklyCalendarPickerItem(day, time)),
                      onHover: disabled ? null : (bool isHovered) => context.read<ZwapWeeklyCalendarPickerProvider>().hoveredItem = isHovered ? _ZwapWeeklyCalendarPickerItem(day, time) : null,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: disabled
                                ? Colors.transparent
                                : isSelected
                                    ? isHovered
                                        ? ZwapColors.primary200
                                        : ZwapColors.primary100
                                    : isHovered
                                        ? ZwapColors.neutral300
                                        : Colors.transparent,
                          ),
                          color: disabled
                              ? Colors.transparent
                              : isSelected
                                  ? isHovered
                                      ? ZwapColors.primary50
                                      : ZwapColors.primary100
                                  : isHovered
                                      ? ZwapColors.neutral100
                                      : Colors.transparent,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
                          child: ZwapText(
                            text: "${time.hour}:${Utils.plotMinute(time.minute)}",
                            textColor: isSelected
                                ? disabled
                                    ? ZwapColors.primary800
                                    : ZwapColors.primary400
                                : disabled
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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ZwapVerticalScroll(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ZwapWeeklyCalendarPickerProvider>(
            create: (_) => ZwapWeeklyCalendarPickerProvider(
              calendarTimes: widget.times,
              filters: widget.pickFilters,
              initialDate: widget.initialDay,
              initialSelectedItems: widget.selected?.map((i) => _ZwapWeeklyCalendarPickerItem(i.a, i.b)).toList(),
            ),
          )
        ],
        child: Builder(
          builder: (context) {
            final DateTime _firstDayOfWeek = context.select<ZwapWeeklyCalendarPickerProvider, DateTime>((pro) => pro.currentWeek);
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
                            text: "${this.widget.handleKeyName(Constants.monthlyName()[_firstDayOfWeek.month]!)}",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (DateTime d in _showedDays.keys) _getDaysSlot(context, d),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
