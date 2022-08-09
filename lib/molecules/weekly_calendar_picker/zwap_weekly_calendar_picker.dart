library weekly_calendar_picker;

/// IMPORTING THIRD PARTY PACKAGES
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

import 'package:collection/collection.dart';
import 'package:zwap_design_system/extensions/dateTimeExtension.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

import '../scroll_arrow/zwap_scroll_arrow.dart';

part 'utils/weekly_calendar_helpers.dart';
part 'utils/weekly_calendar_show_filter.dart';
part 'utils/weekly_calendar_pick_filter.dart';
part 'provider/weekly_calendar_picker_provider.dart';
part 'components/weekly_calendar_picker_day_slot_widget.dart';
part 'components/weekly_calendar_picker_day_slot_decorations.dart';

//TODO (Marchetti): Add interactivity between filter, such as disable a day when max per day items are selected or same for week
//TODO (Marchetti): Add initial date and auto initial date in base of disabled past and showed days of week

class _ZwapWeeklyCalendarPickerItem {
  final DateTime date;
  final _CustomTimeOfDay time;

  const _ZwapWeeklyCalendarPickerItem(this.date, this.time);

  @override
  operator ==(Object other) {
    return other is _ZwapWeeklyCalendarPickerItem &&
        date.isAtSameMomentAs(other.date) &&
        time.hour == other.time.hour &&
        time.minute == other.time.minute;
  }

  @override
  int get hashCode => date.hashCode ^ time.hashCode;

  @override
  String toString() => '$date : $time';
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

  /// Used to check if user can add a slot to the selected slot
  final List<ZwapWeeklyCalendarPickFilter> pickFilters;

  /// Used to customize or disable some elements
  final ZwapWeeklyCalendarShowFilter? _showFilter;

  /// The decoration assigned by default to all day slots
  final WCPDateSlotWidgetDecorations daySlotDecoration;

  ZwapWeeklyCalendarPicker({
    Key? key,
    this.initialDay,
    required this.times,
    required this.handleKeyName,
    this.daySlotDecoration = const WCPDateSlotWidgetDecorations.standard(),
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

  late final ZwapWeeklyCalendarPickerProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = ZwapWeeklyCalendarPickerProvider(
      calendarTimes: widget.times,
      filters: widget.pickFilters,
      initialDate: widget.initialDay,
      showFilter: widget._showFilter,
      initialSelectedItems: widget.selected?.map((i) => _ZwapWeeklyCalendarPickerItem(i.a, _CustomTimeOfDay.fromTimeOfDay(i.b))).toList(),
      onChange: widget.onChange,
    );

    _verticalScrollLinker = LinkedScrollControllerGroup();
    _columnsScrollControllers = List.generate(7, (i) => _verticalScrollLinker.addAndGet());
  }

  @override
  void didUpdateWidget(covariant ZwapWeeklyCalendarPicker oldWidget) {
    if (!listEquals(widget.selected, oldWidget.selected))
      _provider
          .widgetSelectedUpdated(widget.selected?.map((i) => _ZwapWeeklyCalendarPickerItem(i.a, _CustomTimeOfDay.fromTimeOfDay(i.b))).toList() ?? []);

    super.didUpdateWidget(oldWidget);
  }

  bool _isItemDisabled(_ZwapWeeklyCalendarPickerItem item) {
    if (item.time.hidden) return true;

    final ZwapWeeklyCalendarShowFilter? _filter = widget._showFilter;

    if (_filter == null) return false;

    final bool _isInDisabledList = _filter._disabledItems.where((i) => i.date.pureDate == item.date.pureDate && i.time == item.time).isNotEmpty;
    final bool _isInPast = _filter._disablePast && item.date.isBefore(DateTime.now().endOfDay);
    final bool _isAfterLastDay = _filter._disableAfter != null && item.date.isAfter(_filter._disableAfter!);

    return _isInDisabledList || _isInPast || _isAfterLastDay;
  }

  /// It retrieves all slots column
  Widget _getDaysSlot(BuildContext context, DateTime day) {
    day = day.pureDate;

    String weekDayName = Constants.weekDayAbbrName()[day.weekday]!;
    final Map<DateTime, List<_CustomTimeOfDay>> _showedDays =
        context.select<ZwapWeeklyCalendarPickerProvider, Map<DateTime, List<_CustomTimeOfDay>>>((pro) => pro.currentWeekTimes);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                    (_CustomTimeOfDay time) {
                      final bool isSelected = context
                          .select<ZwapWeeklyCalendarPickerProvider, bool>((pro) => pro.selected.any((s) => s.date.pureDate == day && s.time == time));
                      final bool isHovered = context.select<ZwapWeeklyCalendarPickerProvider, bool>(
                          (pro) => pro.hoveredItem?.date.pureDate == day && pro.hoveredItem?.time == time);
                      final bool isDisabled = _isItemDisabled(_ZwapWeeklyCalendarPickerItem(day, time));

                      final ZwapWeeklyCalendarShowFilter? _showFilter = widget._showFilter;
                      final _ZwapWeeklyCalendarPickerItem _item = _ZwapWeeklyCalendarPickerItem(day, time.copyWith(hidden: true));

                      return WeeklyCalendarPickerDatSlotWidget(
                        content: time.hidden ? "--:--" : "${time.hour}:${Utils.plotMinute(time.minute)}",
                        callback: () => context.read<ZwapWeeklyCalendarPickerProvider>().toggleItem(_ZwapWeeklyCalendarPickerItem(day, time)),
                        disabledCallback: null,
                        onHoverChange: (isHovered) => context.read<ZwapWeeklyCalendarPickerProvider>().hoveredItem =
                            isHovered ? _ZwapWeeklyCalendarPickerItem(day, time) : null,
                        decorations: _showFilter != null && _showFilter._customSlotsDecorations.containsKey(_item)
                            ? _showFilter._customSlotsDecorations[_item]!
                            : widget.daySlotDecoration,
                        disabled: isDisabled,
                        selected: isSelected,
                        hovered: isHovered,
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
        ChangeNotifierProvider<ZwapWeeklyCalendarPickerProvider>.value(
          value: _provider,
        )
      ],
      child: LayoutBuilder(
        builder: (context, size) {
          final Map<DateTime, List<TimeOfDay>> _showedDays =
              context.select<ZwapWeeklyCalendarPickerProvider, Map<DateTime, List<TimeOfDay>>>((pro) => pro.currentWeekTimes);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ZwapScrollArrow(
                      direction: ZwapScrollArrowDirection.left,
                      onTap: () => context.read<ZwapWeeklyCalendarPickerProvider>().precedentWeek(),
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
                          text: _showedDays.isEmpty ? '' : '${this.widget.handleKeyName(Constants.monthlyName()[_showedDays.keys.first.month]!)}',
                          textColor: ZwapColors.neutral700,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: ZwapScrollArrow(
                      direction: ZwapScrollArrowDirection.right,
                      onTap: () => context.read<ZwapWeeklyCalendarPickerProvider>().nextWeek(),
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
    final List<int> _showedWeekDays =
        context.select<ZwapWeeklyCalendarPickerProvider, List<int>>((pro) => pro.currentWeekTimes.keys.map((k) => k.weekday).toList());
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
                onTap: () {},
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
