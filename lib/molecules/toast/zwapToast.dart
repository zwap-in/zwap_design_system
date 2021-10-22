/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Custom class to show toast message
class ZwapToasts{

  /// It shows the modal
  static void showMeetingConfirmed(String meetingConfirmedText){
    Fluttertoast.showToast(
      msg: meetingConfirmedText,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      webBgColor: "#33FF4A",
      webPosition: "center",
    );
  }

  /// It shows an error toast message
  static void showErrorToast(String errorToastMessage){
    Fluttertoast.showToast(
      msg: errorToastMessage,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      webBgColor: "#FF5733",
      webPosition: "center"
    );
  }

  /// It shows a normal toast message
  static void showNormalToast(String normalMessage){
    Fluttertoast.showToast(
      msg: normalMessage,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      webBgColor: "#FFFFFF",
      webPosition: "center"
    );
  }

}