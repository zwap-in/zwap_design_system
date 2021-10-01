/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import '../colors/zwapColors.dart';

/// The text type to get different typo in base of the current device sizes
enum ZwapTextType {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  subTitleRegular,
  subTitleSemiBold,
  subTitleBold,
  captionRegular,
  captionSemiBold,
  captionBold,
  buttonText,
  body1Regular,
  body1SemiBold,
  body1Bold,
  body2Regular,
  body2SemiBold,
  body2Bold,
  body3Regular,
  body3SemiBold,
  body3Bold
}

/// Custom typography style for zwap design system kit
class ZwapTypography {
  static TextStyle h1() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: -1.5,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle h2() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: -0.5,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle h3() {
    return TextStyle(
        fontSize: 0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle h4() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.25,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle h5() {
    return TextStyle(
        fontSize: 0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle h6() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.15,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle subtitleRegular() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.15,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsRegular",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle subtitleSemiBold() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsSemiBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle subtitleBold() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.15,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle captionRegular() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.4,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsRegular",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle captionSemiBold() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.4,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsSemiBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle captionBold() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.4,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle buttonText() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.4,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsSemiBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle body1Regular() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsRegular",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle body1SemiBold() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsSemiBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle body1Bold() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.5,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle body2Regular() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.25,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsRegular",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle body2SemiBold() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.25,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsSemiBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle body2Bold() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.25,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }


  static TextStyle body3Regular() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.25,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsRegular",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle body3SemiBold() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.25,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsSemiBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }

  static TextStyle body3Bold() {
    return TextStyle(
        fontSize: 0,
        letterSpacing: 0.25,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontFamily: "PoppinsBold",
        height: 1.5,
        package: "zwap_design_system",
        color: ZwapColors.shades100);
  }
}
