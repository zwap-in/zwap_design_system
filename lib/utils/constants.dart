/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/translations/translations.dart';

/// The constants class to retrieve some constants values
class Constants{

  /// The name of the month
  static Map<int, String> monthlyName(BuildContext context){
    return {
      1:  LocalizationClass.of(context).dynamicValue("january"),
      2:  LocalizationClass.of(context).dynamicValue("february"),
      3:  LocalizationClass.of(context).dynamicValue("march"),
      4:  LocalizationClass.of(context).dynamicValue("april"),
      5:  LocalizationClass.of(context).dynamicValue("may"),
      6:  LocalizationClass.of(context).dynamicValue("june"),
      7:  LocalizationClass.of(context).dynamicValue("july"),
      8:  LocalizationClass.of(context).dynamicValue("august"),
      9:  LocalizationClass.of(context).dynamicValue("september"),
      10: LocalizationClass.of(context).dynamicValue("october"),
      11: LocalizationClass.of(context).dynamicValue("november"),
      12: LocalizationClass.of(context).dynamicValue("december"),
    };
  }

  /// The abbreviation of the months name
  static Map<int, String> monthlyAbbrName(BuildContext context){
    return {
      1:  LocalizationClass.of(context).dynamicValue("januaryAbbr"),
      2:  LocalizationClass.of(context).dynamicValue("februaryAbbr"),
      3:  LocalizationClass.of(context).dynamicValue("marchAbbr"),
      4:  LocalizationClass.of(context).dynamicValue("aprilAbbr"),
      5:  LocalizationClass.of(context).dynamicValue("mayAbbr"),
      6:  LocalizationClass.of(context).dynamicValue("juneAbbr"),
      7:  LocalizationClass.of(context).dynamicValue("julyAbbr"),
      8:  LocalizationClass.of(context).dynamicValue("augustAbbr"),
      9:  LocalizationClass.of(context).dynamicValue("septemberAbbr"),
      10: LocalizationClass.of(context).dynamicValue("octoberAbbr"),
      11: LocalizationClass.of(context).dynamicValue("novemberAbbr"),
      12: LocalizationClass.of(context).dynamicValue("decemberAbbr"),
    };
  }

  /// The abbreviations name for the week days
  static Map<int, String> weekDayAbbrName(BuildContext context){
    return {
      1:  LocalizationClass.of(context).dynamicValue("mondayAbbr"),
      2:  LocalizationClass.of(context).dynamicValue("tuesdayAbbr"),
      3:  LocalizationClass.of(context).dynamicValue("wednesdayAbbr"),
      4:  LocalizationClass.of(context).dynamicValue("thursdayAbbr"),
      5:  LocalizationClass.of(context).dynamicValue("fridayAbbr"),
      6:  LocalizationClass.of(context).dynamicValue("saturdayAbbr"),
      7:  LocalizationClass.of(context).dynamicValue("sundayAbbr"),
    };
  }

}