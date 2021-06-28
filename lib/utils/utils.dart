/// IMPORTING THIRD PARTY PACKAGES
import 'dart:developer';
import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

/// Utilities class functions
class Utils{

  /// Custom function to change screen
  static void goToScreen(String name, BuildContext context, Map<String, String>? args){
    log("Changing screen to $name");
    String queryArgs = "";
    if(args != null){
      args.forEach((key, value) {
        queryArgs += "$key=$value&";
      });
      queryArgs = queryArgs.substring(0, queryArgs.length - 1);
    }
    html.window.history.pushState(null, "", "/$name?$queryArgs");
    Navigator.pushReplacementNamed(context, "/$name?$queryArgs");
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

}

/// The tuple type to use inside this platform
class TupleType<T, F>{

  T a;

  F b;

  TupleType({required this.a, required this.b});

}
