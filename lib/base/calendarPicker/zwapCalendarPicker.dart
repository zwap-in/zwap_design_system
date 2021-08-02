/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/colors.dart';
import 'package:zwap_design_system/base/text/zwapText.dart';
import 'package:zwap_design_system/base/media/media.dart';
import 'package:zwap_design_system/base/layouts/layouts.dart';

/// The state of the calendar picker
class ZwapCalendarPickerState extends ChangeNotifier{

  /// The current date from which start
  DateTime? currentDate;

  /// The date start of the current view inside the picker
  late DateTime dateStart;

  /// The date end of the current view inside the picker
  final DateTime dateEnd;

  /// The slots per day to show inside it the days
  final Map<int, List<TimeOfDay>> slotsPerDay;

  /// The selected dates
  final Set selectedDates;

  /// The max number of slot you can select
  final int maxSelections;

  ZwapCalendarPickerState({
    required this.dateEnd,
    required this.slotsPerDay,
    required this.selectedDates,
    required this.maxSelections
  }){
    Map<DateTime, List<TimeOfDay>> daysPlotted = this._plotDaysSlot();
    this.currentDate = daysPlotted.keys.first;
    this.dateStart = daysPlotted.keys.first;
  }

  /// It changes the start date view of the calendar picker
  void changeStart(bool isAdding){
    Map<DateTime, List<TimeOfDay>> daysPreviousPlotted = this._plotDaysSlot();
    if(isAdding){
      DateTime tmp = daysPreviousPlotted.keys.last.add(Duration(days: 1));
      if(tmp.isBefore(this.dateEnd)){
        this.currentDate = tmp;
      }
    }
    else{
      int numDays = this._getMaxSlotsView;
      DateTime current = daysPreviousPlotted.keys.first;
      int i = 0;
      while(i < numDays){
        if(current == this.dateStart){
          break;
        }
        current = current.subtract(Duration(days: 1));
        if(this.slotsPerDay.containsKey(current.weekday)){
          i++;
        }
      }
      this.currentDate = current;
    }
    notifyListeners();
  }

  int get _getMaxSlotsView{
    int deviceType = Utils.getIt<Generic>().deviceType();
    int maxSlots = deviceType < 4 ? deviceType + 1 : 4;
    return maxSlots;
  }

  /// It plots the slots mapping in base of the current date showed
  Map<DateTime, List<TimeOfDay>> _plotDaysSlot(){
    Map<DateTime, List<TimeOfDay>> finals = {};
    DateTime now = DateTime.now();
    DateTime tmp = this.currentDate ?? DateTime.now();
    int i = 0;
    while(i < this._getMaxSlotsView){
      DateTime tmpCheck = DateTime(now.year, now.month, now.day);
      DateTime tmpCheckTwo = DateTime(tmp.year, tmp.month, tmp.day);
      if(this.slotsPerDay.keys.toList().contains(tmp.weekday) && this.slotsPerDay.containsKey(tmp.weekday) && !tmpCheck.isAtSameMomentAs(tmpCheckTwo)){
        finals[tmp] = this.slotsPerDay[tmp.weekday]!;
        i++;
      }
      DateTime nextTmp = tmp.add(Duration(days: 1));
      if(nextTmp.isAfter(this.dateEnd)){
        break;
      }
      else{
        tmp = nextTmp;
      }
    }
    return finals;
  }

  /// It handles the click on the date
  void handleDate(DateTime date){
    if(this.selectedDates.contains(date)){
      this.selectedDates.remove(date);
    }
    else{
      if(this.selectedDates.length < this.maxSelections){
        this.selectedDates.add(date);
      }
    }
    notifyListeners();
  }


}

/// THe calendar picker to show the slots date
class ZwapCalendarPicker extends StatelessWidget{

  /// CallBack to handle the key name for any text
  final Function(String key) handleKeyName;

  ZwapCalendarPicker({Key? key,
    required this.handleKeyName
  }): super(key: key);

  /// It retrieves the slots per each day
  List<Widget> _getSlots(List<TimeOfDay> slots, DateTime date, ZwapCalendarPickerState provider){
    List<Widget> finals = [];
    slots.forEach((TimeOfDay element) {
      DateTime current = DateTime(date.year, date.month, date.day, element.hour, element.minute);
      bool isSelected = provider.selectedDates.contains(current);
      finals.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: InkResponse(
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => provider.handleDate(current),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? DesignColors.pinkyPrimary : Colors.transparent,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 20, top: 20, bottom: 20, left: 20),
                child: ZwapText(
                  textAlignment: Alignment.center,
                  texts: ["${element.hour}:${Utils.plotMinute(element.minute)}"],
                  baseTextsType: [ZwapTextType.normal],
                ),
              ),
            ),
          ),
        )
      );
    });
    return finals;
  }

  /// It retrieves all slots column
  Widget _getDaysSlot(DateTime key, List<TimeOfDay> slots, ZwapCalendarPickerState provider){
    String weekDayName = this.handleKeyName(Constants.weekDayAbbrName()[key.weekday]!);
    String monthlyAbbrName = this.handleKeyName(Constants.monthlyAbbrName()[key.month]!);
    int day = key.day;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: ZwapText(
              texts: [weekDayName],
              textAlignment: Alignment.center,
              baseTextsType: [ZwapTextType.title],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: ZwapText(
              texts: ["$monthlyAbbrName $day"],
              baseTextsType: [ZwapTextType.normal],
              textAlignment: Alignment.center,
              textsColor: [DesignColors.greyPrimary],
            ),
          ),
          ZwapVerticalScroll(
              childComponent: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: this._getSlots(slots, key, provider),
                ),
              )
          )
        ],
      ),
    );
  }

  /// It plots all days to show in a responsive way
  Map<Widget, Map<String, int>> _plotChildren(ZwapCalendarPickerState provider){
    Map<Widget, Map<String, int>> finals = {};
    Map<DateTime, List<TimeOfDay>> daysPlotted = provider._plotDaysSlot();
    daysPlotted.forEach((DateTime key, List<TimeOfDay> value) {
      Widget tmp = this._getDaysSlot(key, value, provider);
      finals[tmp] = {
        'xl': 3, 'lg': 3, 'md': 4, 'sm': 6, 'xs': 12
      };
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {
    return ZwapVerticalScroll(
        childComponent: Consumer<ZwapCalendarPickerState>(
          builder: (builder, provider, child){
            return Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: ZwapIcon(
                        icon: Icons.arrow_back_ios,
                        callBackPressedFunction: () => provider.changeStart(false),
                      ),
                      flex: 0,
                    ),
                    Expanded(
                      child: ZwapText(
                        textAlignment: Alignment.center,
                        texts: ["${this.handleKeyName(Constants.monthlyName()[provider.currentDate!.month]!)} ${provider.currentDate!.year}"],
                        baseTextsType: [ZwapTextType.normal],
                      ),
                    ),
                    Flexible(
                      child: ZwapIcon(
                        icon: Icons.arrow_forward_ios,
                        callBackPressedFunction: () => provider.changeStart(true),
                      ),
                      flex: 0,
                    ),
                  ],
                ),
                Consumer<ZwapCalendarPickerState>(
                    builder: (builder, provider, child){
                      return ResponsiveRow(
                        children: this._plotChildren(provider),
                      );
                    }
                )
              ],
            );
          }
        )
    );
  }


}