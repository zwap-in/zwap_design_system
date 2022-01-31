/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zwap_utils/zwap_utils.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/scrollArrows/zwapScrollArrow.dart';

/// The state of the calendar picker
class ZwapCalendarPickerState extends ChangeNotifier {
  /// The current date from which start
  DateTime? currentDate;

  /// The hovered date inside the calendar picker
  TupleType<DateTime, TimeOfDay>? hoveredDate;

  /// The date start of the current view inside the picker
  late DateTime dateStart;

  /// The date end of the current view inside the picker
  final DateTime dateEnd;

  /// The slots per day to show inside it the days
  final Map<int, List<TimeOfDay>> slotsPerDay;

  /// The selected dates
  final Set<DateTime> selectedDates;

  /// The max number of slot you can select
  final int maxSelections;

  /// The set of the dates that must be disabled
  final Set<DateTime>? disabledDates;

  ZwapCalendarPickerState({
    required this.dateEnd,
    required this.slotsPerDay,
    required this.selectedDates,
    required this.maxSelections,
    this.disabledDates
  }) {
    Map<DateTime, List<TimeOfDay>> daysPlotted = this._plotDaysSlot();
    this.currentDate = daysPlotted.keys.first;
    this.dateStart = daysPlotted.keys.first;
  }

  /// It changes the start date view of the calendar picker
  void changeStart(bool isAdding) {
    Map<DateTime, List<TimeOfDay>> daysPreviousPlotted = this._plotDaysSlot();
    if (isAdding) {
      DateTime tmp = daysPreviousPlotted.keys.last.add(Duration(days: 1));
      if (tmp.isBefore(this.dateEnd)) {
        this.currentDate = tmp;
      }
    } else {
      int numDays = this._getMaxSlotsView;
      DateTime current = daysPreviousPlotted.keys.first;
      int i = 0;
      while (i < numDays) {
        if (current == this.dateStart) {
          break;
        }
        current = current.subtract(Duration(days: 1));
        if (this.slotsPerDay.containsKey(current.weekday)) {
          i++;
        }
      }
      this.currentDate = current;
    }
    notifyListeners();
  }

  /// It returns the max slots per each responsive view
  int get _getMaxSlotsView {
    late int deviceType;
    try {
      deviceType = Utils.getIt<Generic>().deviceType();
    } catch (e) {
      deviceType = 3;
    }
    int maxSlots = deviceType < 3 ? 3 : 4;
    return maxSlots;
  }

  /// It plots the slots mapping in base of the current date showed
  Map<DateTime, List<TimeOfDay>> _plotDaysSlot() {
    Map<DateTime, List<TimeOfDay>> finals = {};
    DateTime now = (DateTime.now()).add(Duration(days: 1));
    DateTime tmp = this.currentDate ?? now;
    int i = 0;
    while (i < this._getMaxSlotsView) {
      DateTime tmpCheck = DateTime(now.year, now.month, now.day);
      DateTime tmpCheckTwo = DateTime(tmp.year, tmp.month, tmp.day);
      if (this.slotsPerDay.keys.toList().contains(tmp.weekday) && this.slotsPerDay.containsKey(tmp.weekday) && !tmpCheck.isAtSameMomentAs(tmpCheckTwo)) {
        finals[tmp] = this.slotsPerDay[tmp.weekday]!;
        i++;
      }
      DateTime nextTmp = tmp.add(Duration(days: 1));
      if (nextTmp.isAfter(this.dateEnd)) {
        break;
      } else {
        tmp = nextTmp;
      }
    }

    finals.forEach((key, value) => finals[key] = value..sort((a, b) => a.hour == b.hour ? a.minute.compareTo(b.minute) : a.hour.compareTo(b.hour)));

    return finals;
  }

  /// It handles the click on the date
  void handleDate(DateTime date) {
    Set<DateTime> elements = this.disabledDates ?? Set<DateTime>();
    if(!elements.contains(date)){
      if (this.selectedDates.contains(date)) {
        this.selectedDates.remove(date);
      } else {
        if (this.selectedDates.length + elements.length <= this.maxSelections) {
          this.selectedDates.add(date);
        } else if (this.selectedDates.isNotEmpty) {
          this.selectedDates.remove(this.selectedDates.last);
          this.selectedDates.add(date);
        }
      }
    }
    notifyListeners();
  }

  /// It handles the hovering on some date inside the calendar picker
  void hoverDate(TupleType<DateTime, TimeOfDay>? date) {
    this.hoveredDate = date;
    notifyListeners();
  }
}

/// THe calendar picker to show the slots date
class ZwapCalendarPicker extends StatelessWidget {
  /// CallBack to handle the key name for any text
  final Function(String key) handleKeyName;

  ZwapCalendarPicker({Key? key, required this.handleKeyName}) : super(key: key);

  /// It retrieves the slots per each day
  List<Widget> _getSlots(List<TimeOfDay> slots, DateTime date, ZwapCalendarPickerState provider) {
    List<Widget> finals = [];
    Set<DateTime> elements = provider.disabledDates ?? Set<DateTime>();
    slots.forEach((TimeOfDay element) {
      final DateTime current = DateTime(date.year, date.month, date.day, element.hour, element.minute);
      final bool isSelected = provider.selectedDates.contains(current) || elements.contains(current);
      final bool isHovered = provider.hoveredDate != null && provider.hoveredDate!.a == date && provider.hoveredDate!.b == element;

      finals.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: InkWell(
          onTap: () => provider.handleDate(current),
          onHover: (bool isHovered) => provider.hoverDate(isHovered ? TupleType(a: date, b: element) : null),
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? isHovered
                        ? ZwapColors.primary200
                        : ZwapColors.primary100
                    : isHovered
                        ? ZwapColors.neutral300
                        : Colors.transparent,
              ),
              color: isSelected
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
                text: "${element.hour}:${Utils.plotMinute(element.minute)}",
                textColor: isSelected ? ZwapColors.primary800 : ZwapColors.neutral800,
                zwapTextType: isSelected ? ZwapTextType.bodySemiBold : ZwapTextType.bodyRegular,
              ),
            ),
          ),
        ),
      ));
    });
    return finals;
  }

  /// It retrieves all slots column
  Widget _getDaysSlot(DateTime key, List<TimeOfDay> slots, ZwapCalendarPickerState provider) {
    String weekDayName = Constants.weekDayAbbrName()[key.weekday]!;
    int day = key.day;
    List<Widget> children = this._getSlots(slots, key, provider);
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: ZwapText(
              text: this.handleKeyName(weekDayName),
              textColor: ZwapColors.neutral800,
              zwapTextType: ZwapTextType.bodySemiBold,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: ZwapText(
              textColor: ZwapColors.neutral800,
              text: "$day",
              zwapTextType: ZwapTextType.bodySemiBold,
            ),
          ),
          ZwapVerticalScroll(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: List<Widget>.generate(children.length, ((index) => children[index])),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// It gets the calendar picker title section
  Widget _getCalendarPickerTitle(ZwapCalendarPickerState provider) {
    int _currentMonth = (provider.currentDate!.add(Duration(days: provider.slotsPerDay.keys.firstWhere((e) => provider.slotsPerDay.keys.every((_e) => e <= _e)) - 1))).month;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: ZwapScrollArrow(
            isRight: false,
            onClickCallBack: () => provider.changeStart(false),
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
                text: "${this.handleKeyName(Constants.monthlyName()[_currentMonth]!)}",
                textColor: ZwapColors.neutral700,
              ),
            ),
          ),
        ),
        Flexible(
          child: ZwapScrollArrow(
            isRight: true,
            onClickCallBack: () => provider.changeStart(true),
          ),
          fit: FlexFit.tight,
          flex: 0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ZwapVerticalScroll(child: Consumer<ZwapCalendarPickerState>(builder: (builder, provider, child) {
      Map<DateTime, List<TimeOfDay>> daysPlotted = provider._plotDaysSlot();
      return Column(
        children: [
          this._getCalendarPickerTitle(provider),
          ResponsiveRow<Map<Widget, Map<String, int>>>(
            children: Map<Widget, Map<String, int>>.fromIterable(daysPlotted.keys.toList(),
                key: (item) => this._getDaysSlot(item, daysPlotted[item]!, provider), value: (item) => {'xl': 3, 'lg': 3, 'md': 4, 'sm': 4, 'xs': 4}),
          )
        ],
      );
    }));
  }
}
