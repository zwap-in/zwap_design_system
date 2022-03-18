/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import '../colors/zwapColors.dart';

/// The text type to get different typo in base of the current device sizes
///
///! Caution:
///  * buttonText: is the old version of buttonText (desing system 1.0)
///  * textButton: is the new version of buttonText (desing system 1.1)
enum ZwapTextType {
  h1,
  h2,
  h3,
  h4,
  h5,
  captionRegular,
  captionSemiBold,

  /// This is the old version of buttonText (desing system 1.0)
  buttonText,
  bodyRegular,
  bodySemiBold,
  extraHeading,
  bigHeading,
  mediumHeading,
  semiboldH1,
  heavyH1,
  semiboldH2,
  heavyH2,
  semiboldH3,
  heavyH3,
  smallBodyMedium,
  smallBodyRegular,
  mediumBodyRegular,
  mediumBodyMedium,
  bigBodyRegular,
  bigBodySemibold,

  /// This is the new version of buttonText (desing system 1.1)
  textButton,
}

/// Custom typography style for zwap design system kit
class ZwapTypography {
  static TextStyle h1() {
    return TextStyle(
        fontSize: 24,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 1.6,
        color: ZwapColors.shades100,
        fontFamily: 'SFUIText');
  }

  static TextStyle h2() {
    return TextStyle(
        fontSize: 20,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 1.6,
        color: ZwapColors.shades100,
        fontFamily: 'SFUIText');
  }

  static TextStyle h3() {
    return TextStyle(
        fontSize: 16,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 1.5,
        color: ZwapColors.shades100,
        fontFamily: 'SFUIText');
  }

  static TextStyle h4() {
    return TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, fontStyle: FontStyle.normal, height: 1.43, color: ZwapColors.shades100, fontFamily: 'SFUIText');
  }

  static TextStyle h5() {
    return TextStyle(
        fontSize: 11, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, height: 1.8, color: ZwapColors.shades100, fontFamily: 'SFUIText');
  }

  static TextStyle captionRegular() {
    return TextStyle(
        fontSize: 11,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 1.45,
        color: ZwapColors.shades100,
        fontFamily: 'SFUIText');
  }

  static TextStyle captionSemiBold() {
    return TextStyle(
        fontSize: 11,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 1.45,
        color: ZwapColors.shades100,
        fontFamily: 'SFUIText');
  }

  /// This is the old version (design system 1.) of buttonText
  static TextStyle buttonText() {
    return TextStyle(
        fontSize: 14,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
        height: 1.43,
        color: ZwapColors.shades100,
        fontFamily: 'SFUIText');
  }

  static TextStyle bodyRegular() {
    return TextStyle(
        fontSize: 14,
        letterSpacing: 0,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        height: 1.43,
        color: ZwapColors.shades100,
        fontFamily: 'SFUIText');
  }

  static TextStyle bodySemiBold() {
    return TextStyle(
        fontSize: 14,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        height: 1.43,
        color: ZwapColors.shades100,
        fontFamily: 'SFUIText');
  }
  //? see https://websemantics.uk/tools/font-size-conversion-pixel-point-em-rem-percent/ for convertions

  static const TextStyle extraHeading = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 48,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle bigHeading = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 40,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle mediumHeading = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 32,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle semiboldH1 = TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 24,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle heavyH1 = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 24,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle semiboldH2 = TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 20,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle heavyH2 = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 20,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle semiboldH3 = TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle heavyH3 = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle smallBodyMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle smallBodyRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle mediumBodyRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle mediumBodyMedium = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle bigBodyRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  static const TextStyle bigBodySemibold = TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );

  /// This is the new version (design system 1.1) of buttonText
  static const TextStyle textButton = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: 'SFUIText',
    package: 'zwap_design_system',
  );
}
