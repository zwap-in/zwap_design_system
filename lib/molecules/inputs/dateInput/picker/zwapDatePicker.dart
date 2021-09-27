/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

import '../../../card/zwapCard.dart';

/// The provider state to handle the input date picker
class ZwapDatePickerProviderState extends ChangeNotifier{

  /// The current start year
  int currentYear;

  /// The selected year value
  late int selectedYear;

  /// The callBack function to handle the year selection
  final Function(int year) callBack;

  ZwapDatePickerProviderState({required this.callBack, required this.currentYear}){
    this.selectedYear = this.currentYear;
  }

  /// Moving forward or back inside the date picker
  void changeView(bool isForward){
    if(isForward){
      this.currentYear += 10;
    }
    else{
      this.currentYear -= 10;
    }
    notifyListeners();
  }

  /// The current title inside the date picker value
  String get currentTitle => "${this.currentYear} - ${this.currentYear + 9}";

  /// It selects the year
  void selectYear(int year){
    this.selectedYear = year;
    this.callBack(year);
    notifyListeners();
  }

}

/// Component to rendering date picker input
class ZwapDatePicker extends StatelessWidget{

  /// The max year to show
  final int maxYear;

  /// The min year to show
  final int minYear;

  ZwapDatePicker({Key? key,
    required this.minYear,
    this.maxYear = 2099,
  }): super(key: key);

  /// It gets the calendar title row
  Widget _getCalendarTitle(){
    return Consumer<ZwapDatePickerProviderState>(
      builder: (context, provider, child){
        return Row(
          children: [
            Flexible(
              child: provider.currentYear - 10 >= this.minYear ? InkWell(
                onTap: () => provider.changeView(false),
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
                  text: provider.currentTitle,
                  textColor: ZwapColors.shades100,
                  zwapTextType: ZwapTextType.body1Regular,
                ),
              ),
            ),
            Flexible(
              child: provider.currentYear + 10 < this.maxYear  ? InkWell(
                onTap: () => provider.changeView(true),
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
    );
  }

  /// It gets the grid view inside the calendar picker
  Widget _getYearsGridView(){
    return Consumer<ZwapDatePickerProviderState>(
      builder: (context, provider, child){
        return Center(
          child: ZwapGridView<int>(
              children: List<int>.generate(10, ((index) => (provider.currentYear + index))),
              maxElementsPerRow: 3,
              maxHeight: 50,
              getChildWidget: (int element) => InkWell(
                onTap: () => provider.selectYear(element),
                child: ZwapText(
                  textAlign: TextAlign.center,
                  zwapTextType: ZwapTextType.body1Regular,
                  text: element.toString(),
                  textColor: ZwapColors.shades100,
                ),
              )
          ),
        );
      }
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