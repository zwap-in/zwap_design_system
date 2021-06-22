/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';


/// Custom widget to display the calendar picker with custom design
class CalendarPicker extends StatefulWidget{

  /// The days range per week to show inside the calendar picker
  final List<int> daysRange;

  /// The optional number of days to go on when it selects go on on the calendar picker
  final int? daysGoOn;

  /// The optional number of days to go back when it selects go back on the calendar picker
  final int? daysGoBack;

  /// The slots per each day to show inside this calendar picker
  final Map<DateTime, List<TimeOfDay>>? slotsPerDay;

  /// From which year the calendar has to starts
  final int? startYear;

  /// To which year the calendar has to ends
  final int? endYear;

  /// From which month the calendar has to starts
  final int? startMonth;

  /// To which month the calendar has to ends
  final int? endMonth;

  /// Boolean flag to start from current date or from the current week starter
  final bool startFromCurrent;

  CalendarPicker({Key? key,
    required this.daysRange,
    this.daysGoOn,
    this.daysGoBack,
    this.slotsPerDay,
    this.startYear,
    this.endYear,
    this.startMonth,
    this.endMonth,
    this.startFromCurrent = true
  }): super(key: key);

  _CalendarPickerState createState() => _CalendarPickerState();

}

class _CalendarPickerState extends State<CalendarPicker>{

  DateTime _startDatetime = DateTime.now();

  void changeStart(bool isAdding){
    int daysGoOn = widget.daysGoOn ?? widget.daysRange.length;
    int daysGoBack = widget.daysGoBack ?? widget.daysRange.length;
    setState(() {
      _startDatetime = isAdding ? _startDatetime.add(Duration(days: daysGoOn)) : _startDatetime.subtract(Duration(days: daysGoBack));
    });
  }

  List<Widget> _getSlots(List<TimeOfDay> slots){
    List<Widget> finals = [];
    slots.forEach((TimeOfDay element) {
      finals.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: BaseText(
            texts: ["${element.hour}:${element.minute != 0 ? element.minute : ("${element.minute.toString()}0")}"],
            baseTextsType: [BaseTextType.normal],
          ),
        )
      );
    });
    return finals;
  }

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

  Map<DateTime, List<TimeOfDay>> _plotDaysSlot(){
    Map<DateTime, List<TimeOfDay>> tmp = {
      DateTime(2021, 6, 8) : [TimeOfDay(hour: 13, minute: 0), TimeOfDay(hour: 17, minute: 0), TimeOfDay(hour: 19, minute: 0)],
      DateTime(2021, 6, 9) : [TimeOfDay(hour: 13, minute: 0), TimeOfDay(hour: 17, minute: 0), TimeOfDay(hour: 19, minute: 0)],
      DateTime(2021, 6, 10) : [TimeOfDay(hour: 13, minute: 0), TimeOfDay(hour: 17, minute: 0), TimeOfDay(hour: 19, minute: 0)],
      DateTime(2021, 6, 11) : [TimeOfDay(hour: 13, minute: 0), TimeOfDay(hour: 17, minute: 0), TimeOfDay(hour: 19, minute: 0)]
    };
    return tmp;
  }

  List<Widget> _plotChildren(){
    List<Widget> finals = [];
    Map<DateTime, List<TimeOfDay>> daysPlotted = this._plotDaysSlot();
    daysPlotted.forEach((DateTime key, List<TimeOfDay> value) {
      finals.add(
          Flexible(
            child: this._getDaysSlot(Constants.weekDayAbbrName(context)[key.weekday]!, Constants.monthlyAbbrName(context)[key.month]!, key.day, value),
            flex: 1,
          )
      );
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
                child: BaseButton(
                  iconButton: Icons.arrow_back_ios,
                  buttonText: "",
                  buttonTypeStyle: ButtonTypeStyle.continueButton,
                  onPressedCallback: () => this.changeStart(false),
                )
            ),
            Flexible(
              child: BaseText(
                texts: ["${Constants.monthlyName(context)[_startDatetime.month]} ${_startDatetime.year}"],
                baseTextsType: [BaseTextType.normal],
              ),
            ),
            Flexible(
                child: BaseButton(
                  iconButton: Icons.arrow_forward_ios,
                  buttonText: "",
                  buttonTypeStyle: ButtonTypeStyle.continueButton,
                  onPressedCallback: () => this.changeStart(true),
                )
            ),
          ],
        ),
        Row(
          children: this._plotChildren(),
        ),
      ],
    );
  }


}