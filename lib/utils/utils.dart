/// IMPORTING THIRD PARTY PACKAGES
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Utilities class functions
class Utils{

  /// Custom function to change screen
  static void goToScreen(String name, BuildContext context, Map<String, String>? args){
    log("Changing screen to $name");
    String queryArgs = "";
    if(args != null){
      queryArgs += "?";
      args.forEach((key, value) {
        queryArgs += "$key=$value&";
      });
      queryArgs = queryArgs.substring(0, queryArgs.length - 1);
    }
    Navigator.pushReplacementNamed(context, "/$name$queryArgs");
  }

  /// Custom function to open external url
  static Future<void> launchInBrowser(String url) async {
    log("Open external url $url in browser");
  }

  /// Copy on clipboard dynamic text
  static Future<void> copy(String text) async {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      showCustomToast(text);
      return;
    } else {
      showCustomToast(text);
    }
  }

  /// It retrieves the color hex value from a Color value
  static String colorString(Color color){
    String colorString = color.toString();
    String valueString = colorString.split('(0x')[1].split(')')[0];
    return "#$valueString";
  }

  /// show custom message inside a toast
  static void showCustomToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        webPosition: "center",
        webBgColor: Utils.colorString(DesignColors.greyPrimary),
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: DesignColors.greyPrimary,
        textColor: DesignColors.blackPrimary,
        timeInSecForIosWeb: 2
    );
  }

  /// Evaluate the number from custom string
  static int evalNumber(String text){
    return int.tryParse(text) ?? -1;
  }

  /// Validate a regex with a dynamic value and a string
  static bool validateRegex(String regexString, dynamic value){
    return RegExp(regexString).hasMatch(value.toString());
  }

  /// It retrieves the date string format from a DateTime object
  static String getDateString(DateTime datetime){
    return "${datetime.day} - ${Constants.monthlyName()[datetime.month]} - ${datetime.year}";
  }

  /// Retrieve the GetIt object
  static GetIt get getIt => GetIt.instance;

  /// Register any T instance with GetIt
  static void registerType<T extends Object>(T instance){
    if(Utils.getIt.isRegistered<T>()){
      Utils.getIt.unregister<T>();
    }
    Utils.getIt.registerFactory<T>(() => instance);
  }

  /// It retrieves the dynamic translated text in base of any key
  static String translatedText(String key){
    return Utils.getIt<LocalizationClass>().dynamicValue(key);
  }

  /// It retrieves the dynamic translated text in base of any key
  static int iconData(String key){
    int? codePoint = Utils.getIt<IconDataDict>().iconDict[key];
    return codePoint != null ? codePoint : -1;
  }

  /// Plotting the minute to show as a String
  static String plotMinute(int minute){
    return minute == 0 ? "${minute.toString()}0" : minute.toString();
  }
}

/// The tuple type to use inside this platform
class TupleType<T, F>{

  T a;

  F b;

  TupleType({required this.a, required this.b});

}


/// Add some custom methods to the DateTime object
extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    int days = (day - this.weekday) % DateTime.daysPerWeek;
    return this.add(
      Duration(
        days: days != 0 ? days : 7,
      ),
    );
  }
}