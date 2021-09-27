/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// Constants class to rendering different kind of box shadows
class ZwapShadow {
  /// None box shadow level
  static BoxShadow? get levelZero => null;

  /// The first level of shadow
  static BoxShadow get levelOne => BoxShadow(
      color: Color.fromRGBO(193, 193, 193, 0.25),
      blurRadius: 11,
      spreadRadius: 4,
      offset: Offset(0, 4));

  /// The second level of shadow
  static BoxShadow get levelTwo => BoxShadow(
      color: Color.fromRGBO(18, 27, 33, 0.1),
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset(0, 8));

  /// The third level of shadow
  static BoxShadow get levelThree => BoxShadow(
      color: Color.fromRGBO(100, 100, 100, 0.3),
      blurRadius: 128,
      spreadRadius: 4,
      offset: Offset(0, 24));
}
