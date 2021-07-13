/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The state of the calendar picker
class CalendarPickerState extends ChangeNotifier{

  /// The current date from which start
  DateTime currentDate = DateTime.now();

  /// The date start from which start the calendar picker dates
  final DateTime dateStart;

  /// The date end where ends the calendar picker dates
  final DateTime dateEnd;

  /// The slots per day to show inside the days
  final Map<int, List<TimeOfDay>> slotsPerDay;

  CalendarPickerState({
    required this.dateStart,
    required this.dateEnd,
    required this.slotsPerDay
  });

  /// Changing the start of the calendar picker
  void changeStart(bool isAdding){
    if(isAdding){
      DateTime tmp = currentDate.add(Duration(days: this.slotsPerDay.keys.toList().length));
      if(tmp.isBefore(this.dateEnd)){
        this.currentDate = tmp;
      }
    }
    else{
      DateTime tmp = currentDate.subtract(Duration(days: this.slotsPerDay.keys.toList().length));
      if(tmp.isAfter(this.dateStart)){
        this.currentDate = tmp;
      }
    }
    notifyListeners();
  }

  Map<DateTime, List<TimeOfDay>> _plotDaysSlot(){
    Map<DateTime, List<TimeOfDay>> finals = {};
    DateTime tmp = this.currentDate;
    int i = 0;
    bool checkNext = false;
    while(i < this.slotsPerDay.keys.toList().length){
      if(this.slotsPerDay.keys.toList().contains(tmp.weekday) && this.slotsPerDay.containsKey(tmp.weekday)){
        finals[tmp] = this.slotsPerDay[tmp.weekday]!;
        checkNext = true;
        i++;
      }
      if (!checkNext){
        DateTime nextTmp = tmp.add(Duration(days: 1));
        if(nextTmp.isAfter(this.dateEnd)){
          break;
        }
        else{
          tmp = nextTmp;
        }
      }
    }
    return finals;

  }


}

/// THe calendar picker to show the date where books
class CalendarPicker extends StatelessWidget{

  /// It retrieves the slots per each day
  List<Widget> _getSlots(List<TimeOfDay> slots){
    List<Widget> finals = [];
    slots.forEach((TimeOfDay element) {
      finals.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: BaseText(
            texts: ["${element.hour}:${Utils.plotMinute(element.minute)}"],
            baseTextsType: [BaseTextType.normal],
          ),
        )
      );
    });
    return finals;
  }

  /// It retrieves all slots
  Widget _getDaysSlot(String weekDay, String monthName, int dayOfMonth, List<TimeOfDay> slots){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: BaseText(
              texts: [weekDay],
              baseTextsType: [BaseTextType.title],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2),
            child: BaseText(
              texts: ["$monthName $dayOfMonth"],
              baseTextsType: [BaseTextType.normal],
              textsColor: [DesignColors.greyPrimary],
            ),
          ),
          VerticalScroll(
              childComponent: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: this._getSlots(slots),
                ),
              )
          )
        ],
      ),
    );
  }

  /// It plots all slots to show
  List<Widget> _plotChildren(CalendarPickerState provider){
    List<Widget> finals = [];
    Map<DateTime, List<TimeOfDay>> daysPlotted = provider._plotDaysSlot();
    daysPlotted.forEach((DateTime key, List<TimeOfDay> value) {
      finals.add(
          Flexible(
            child: this._getDaysSlot(Constants.weekDayAbbrName()[key.weekday]!, Constants.monthlyAbbrName()[key.month]!, key.day, value),
            flex: 1,
          )
      );
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {
    CalendarPickerState provider = context.read<CalendarPickerState>();
    return Column(
      children: [
        Row(
          children: [
            Flexible(
                child: BaseButton(
                  iconButton: Icons.arrow_back_ios,
                  buttonText: "",
                  buttonTypeStyle: ButtonTypeStyle.continueButton,
                  onPressedCallback: () => provider.changeStart(false),
                )
            ),
            Flexible(
              child: BaseText(
                texts: ["${Constants.monthlyName()[provider.currentDate.month]} ${provider.currentDate.year}"],
                baseTextsType: [BaseTextType.normal],
              ),
            ),
            Flexible(
                child: BaseButton(
                  iconButton: Icons.arrow_forward_ios,
                  buttonText: "",
                  buttonTypeStyle: ButtonTypeStyle.continueButton,
                  onPressedCallback: () => provider.changeStart(true),
                )
            ),
          ],
        ),
        Consumer<CalendarPickerState>(
          builder: (builder, provider, child){
            return Row(
              children: this._plotChildren(provider),
            );
          }
        )
      ],
    );
  }


}