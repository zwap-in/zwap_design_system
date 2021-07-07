/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The constants class to retrieve some constants values
class Constants{

  /// The name of the month
  static Map<int, String> monthlyName(){
    return {
      1:  Utils.translatedText("january"),
      2:  Utils.translatedText("february"),
      3:  Utils.translatedText("march"),
      4:  Utils.translatedText("april"),
      5:  Utils.translatedText("may"),
      6:  Utils.translatedText("june"),
      7:  Utils.translatedText("july"),
      8:  Utils.translatedText("august"),
      9:  Utils.translatedText("september"),
      10: Utils.translatedText("october"),
      11: Utils.translatedText("november"),
      12: Utils.translatedText("december"),
    };
  }

  /// The abbreviation of the months name
  static Map<int, String> monthlyAbbrName(){
    return {
      1:  Utils.translatedText("januaryAbbr"),
      2:  Utils.translatedText("februaryAbbr"),
      3:  Utils.translatedText("marchAbbr"),
      4:  Utils.translatedText("aprilAbbr"),
      5:  Utils.translatedText("mayAbbr"),
      6:  Utils.translatedText("juneAbbr"),
      7:  Utils.translatedText("julyAbbr"),
      8:  Utils.translatedText("augustAbbr"),
      9:  Utils.translatedText("septemberAbbr"),
      10: Utils.translatedText("octoberAbbr"),
      11: Utils.translatedText("novemberAbbr"),
      12: Utils.translatedText("decemberAbbr"),
    };
  }

  /// The abbreviations name for the week days
  static Map<int, String> weekDayAbbrName(){
    return {
      1:  Utils.translatedText("mondayAbbr"),
      2:  Utils.translatedText("tuesdayAbbr"),
      3:  Utils.translatedText("wednesdayAbbr"),
      4:  Utils.translatedText("thursdayAbbr"),
      5:  Utils.translatedText("fridayAbbr"),
      6:  Utils.translatedText("saturdayAbbr"),
      7:  Utils.translatedText("sundayAbbr"),
    };
  }

  /// The regex for custom email
  static String get emailRegex => r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$";

}