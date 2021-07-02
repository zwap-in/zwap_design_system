/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The constants class to retrieve some constants values
class Constants{

  /// The name of the month
  static Map<int, String> monthlyName(){
    return {
      1:  Utils.getIt<LocalizationClass>().dynamicValue("january"),
      2:  Utils.getIt<LocalizationClass>().dynamicValue("february"),
      3:  Utils.getIt<LocalizationClass>().dynamicValue("march"),
      4:  Utils.getIt<LocalizationClass>().dynamicValue("april"),
      5:  Utils.getIt<LocalizationClass>().dynamicValue("may"),
      6:  Utils.getIt<LocalizationClass>().dynamicValue("june"),
      7:  Utils.getIt<LocalizationClass>().dynamicValue("july"),
      8:  Utils.getIt<LocalizationClass>().dynamicValue("august"),
      9:  Utils.getIt<LocalizationClass>().dynamicValue("september"),
      10: Utils.getIt<LocalizationClass>().dynamicValue("october"),
      11: Utils.getIt<LocalizationClass>().dynamicValue("november"),
      12: Utils.getIt<LocalizationClass>().dynamicValue("december"),
    };
  }

  /// The abbreviation of the months name
  static Map<int, String> monthlyAbbrName(){
    return {
      1:  Utils.getIt<LocalizationClass>().dynamicValue("januaryAbbr"),
      2:  Utils.getIt<LocalizationClass>().dynamicValue("februaryAbbr"),
      3:  Utils.getIt<LocalizationClass>().dynamicValue("marchAbbr"),
      4:  Utils.getIt<LocalizationClass>().dynamicValue("aprilAbbr"),
      5:  Utils.getIt<LocalizationClass>().dynamicValue("mayAbbr"),
      6:  Utils.getIt<LocalizationClass>().dynamicValue("juneAbbr"),
      7:  Utils.getIt<LocalizationClass>().dynamicValue("julyAbbr"),
      8:  Utils.getIt<LocalizationClass>().dynamicValue("augustAbbr"),
      9:  Utils.getIt<LocalizationClass>().dynamicValue("septemberAbbr"),
      10: Utils.getIt<LocalizationClass>().dynamicValue("octoberAbbr"),
      11: Utils.getIt<LocalizationClass>().dynamicValue("novemberAbbr"),
      12: Utils.getIt<LocalizationClass>().dynamicValue("decemberAbbr"),
    };
  }

  /// The abbreviations name for the week days
  static Map<int, String> weekDayAbbrName(){
    return {
      1:  Utils.getIt<LocalizationClass>().dynamicValue("mondayAbbr"),
      2:  Utils.getIt<LocalizationClass>().dynamicValue("tuesdayAbbr"),
      3:  Utils.getIt<LocalizationClass>().dynamicValue("wednesdayAbbr"),
      4:  Utils.getIt<LocalizationClass>().dynamicValue("thursdayAbbr"),
      5:  Utils.getIt<LocalizationClass>().dynamicValue("fridayAbbr"),
      6:  Utils.getIt<LocalizationClass>().dynamicValue("saturdayAbbr"),
      7:  Utils.getIt<LocalizationClass>().dynamicValue("sundayAbbr"),
    };
  }

  /// The regex for custom email
  static String get emailRegex => r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$";

}