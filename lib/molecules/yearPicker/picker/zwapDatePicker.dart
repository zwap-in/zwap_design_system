/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';


class ZwapDatePicker extends StatefulWidget{

  final int minYear;

  final int maxYear;

  final Function(int newYear) onSelectYear;

  ZwapDatePicker({Key? key,
    required this.minYear,
    required this.onSelectYear,
    this.maxYear = 2099,
  }): super(key: key);

  _ZwapDatePickerState createState() => _ZwapDatePickerState();

}

/// Component to rendering date picker input
class _ZwapDatePickerState extends State<ZwapDatePicker>{

  int _currentYear = 1982;

  int _selectedYear = 0;

  /// Moving forward or back inside the date picker
  void changeView(bool isForward){
    setState(() {
      if(isForward){
        this._currentYear += 10;
      }
      else{
        this._currentYear -= 10;
      }
    });
  }

  /// The current title inside the date picker value
  String get _currentTitle => "${this._currentYear} - ${this._currentYear + 9}";

  /// It selects the year
  void selectYear(int year){
    setState(() {
      this._selectedYear = year;
    });
    widget.onSelectYear(year);
  }

  /// It gets the calendar title row
  Widget _getCalendarTitle(){
    return Row(
      children: [
        Flexible(
          child: this._currentYear - 10 >= widget.minYear ? InkWell(
            onTap: () => this.changeView(false),
            child: Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: ZwapColors.shades100,
            ),
          ) : Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: ZwapColors.neutral300,
          ),
          flex: 0,
          fit: FlexFit.tight,
        ),
        Flexible(
          child: Center(
            child: ZwapText(
              text: this._currentTitle,
              textColor: ZwapColors.shades100,
              zwapTextType: ZwapTextType.bodyRegular,
            ),
          ),
        ),
        Flexible(
          child: this._currentYear + 10 < widget.maxYear  ? InkWell(
            onTap: () => this.changeView(true),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 30,
              color: ZwapColors.shades100,
            ),
          ) : Icon(
            Icons.arrow_forward_ios,
            size: 30,
            color: ZwapColors.neutral300,
          ),
          flex: 0,
          fit: FlexFit.tight,
        ),
      ],
    );
  }

  /// It gets the grid view inside the calendar picker
  Widget _getYearsGridView(){
    return Center(
      child: ZwapGridView<int>(
          children: List<int>.generate(10, ((index) => (this._currentYear + index))),
          maxElementsPerRow: 3,
          maxHeight: 50,
          getChildWidget: (int element) => Container(
            decoration: BoxDecoration(
              color: this._selectedYear == element ? ZwapColors.neutral400 : ZwapColors.shades0,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: InkWell(
              onTap: () => this.selectYear(element),
              child: ZwapText(
                textAlign: TextAlign.center,
                zwapTextType: ZwapTextType.bodyRegular,
                text: element.toString(),
                textColor: ZwapColors.shades100,
              ),
            ),
          )
      ),
    );
  }

  Widget build(BuildContext context){
    return ZwapCard(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: this._getCalendarTitle(),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: this._getYearsGridView(),
            ),
          )
        ],
      ),
      zwapCardType: ZwapCardType.levelOne,
    );

  }

}