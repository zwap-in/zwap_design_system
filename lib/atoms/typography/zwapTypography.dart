/// IMPORTING THIRD PARTY PACKAGES
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

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
  extraSmallBodyRegular,
  smallBodyLight,
  smallBodyRegular,
  smallBodyMedium,
  smallBodySemibold,
  smallBodyBold,
  smallBodyExtraBold,
  smallBodyBlack,
  mediumBodyLight,
  mediumBodyRegular,
  mediumBodyMedium,
  mediumBodySemibold,
  mediumBodyBold,
  mediumBodyExtraBold,
  mediumBodyBlack,
  bigBodyLight,
  bigBodyRegular,
  bigBodyMedium,
  bigBodySemibold,
  bigBodyBold,
  bigBodyExtraBold,
  bigBodyBlack,

  /// This is the new version of buttonText (desing system 1.1)
  textButton
}

extension ZwapTextTypeExt on ZwapTextType {
  TextStyle copyWith({
    bool? inherit,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    ui.TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<ui.Shadow>? shadows,
    List<ui.FontFeature>? fontFeatures,
    List<ui.FontVariation>? fontVariations,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    TextOverflow? overflow,
  }) =>
      getTextStyle(this).copyWith(
        inherit: inherit,
        color: color,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        leadingDistribution: leadingDistribution,
        locale: locale,
        foreground: foreground,
        background: background,
        shadows: shadows,
        fontFeatures: fontFeatures,
        fontVariations: fontVariations,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        debugLabel: debugLabel,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        overflow: overflow,
      );
}

enum ZwapFontFamilies {
  sfUiText,
  manrope;

  String get _name {
    switch (this) {
      case ZwapFontFamilies.sfUiText:
        return 'SFUIText';
      case ZwapFontFamilies.manrope:
        return 'Manrope';
    }
  }
}

/// Custom typography style for zwap design system kit
class ZwapTypography {
  ZwapFontFamilies fontFamily;

  ZwapTypography._({this.fontFamily = ZwapFontFamilies.sfUiText});

  static ZwapTypography? _instance;
  static ZwapTypography get instance => _instance ??= ZwapTypography._();

  static TextStyle h1() {
    return TextStyle(
      fontSize: 24,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      height: 1.6,
      color: ZwapColors.shades100,
      fontFamily: instance.fontFamily._name,
      package: 'zwap_design_system',
    );
  }

  static TextStyle h2() {
    return TextStyle(
      fontSize: 20,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      height: 1.6,
      color: ZwapColors.shades100,
      fontFamily: instance.fontFamily._name,
      package: 'zwap_design_system',
    );
  }

  static TextStyle h3() {
    return TextStyle(
      fontSize: 16,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      height: 1.5,
      color: ZwapColors.shades100,
      fontFamily: instance.fontFamily._name,
      package: 'zwap_design_system',
    );
  }

  static TextStyle h4() {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      height: 1.43,
      color: ZwapColors.shades100,
      fontFamily: instance.fontFamily._name,
      package: 'zwap_design_system',
    );
  }

  static TextStyle h5() {
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.normal,
      height: 1.8,
      color: ZwapColors.shades100,
      fontFamily: instance.fontFamily._name,
      package: 'zwap_design_system',
    );
  }

  static TextStyle captionRegular() {
    return TextStyle(
      fontSize: 11,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      height: 1.45,
      color: ZwapColors.shades100,
      fontFamily: instance.fontFamily._name,
      package: 'zwap_design_system',
    );
  }

  static TextStyle captionSemiBold() {
    return TextStyle(
      fontSize: 11,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      height: 1.45,
      color: ZwapColors.shades100,
      fontFamily: instance.fontFamily._name,
      package: 'zwap_design_system',
    );
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
      fontFamily: instance.fontFamily._name,
      package: 'zwap_design_system',
    );
  }

  static TextStyle bodyRegular() {
    return TextStyle(
      fontSize: 14,
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.normal,
      height: 1.43,
      color: ZwapColors.shades100,
      fontFamily: instance.fontFamily._name,
      package: 'zwap_design_system',
    );
  }

  static TextStyle bodySemiBold() {
    return TextStyle(
      fontSize: 14,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      height: 1.43,
      color: ZwapColors.shades100,
      fontFamily: instance.fontFamily._name,
      package: 'zwap_design_system',
    );
  }
  //? see https://websemantics.uk/tools/font-size-conversion-pixel-point-em-rem-percent/ for convertions

  static TextStyle extraHeading = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 48,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle bigHeading = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 40,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle mediumHeading = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 32,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle semiboldH1 = TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 24,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle heavyH1 = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 24,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle semiboldH2 = TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 20,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle heavyH2 = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 20,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle semiboldH3 = TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle heavyH3 = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle extraSmallBodyRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 11,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle smallBodyLight = TextStyle(
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle smallBodyRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle smallBodyMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle smallBodySemibold = TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle smallBodyBold = TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle smallBodyExtraBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle smallBodyBlack = TextStyle(
    fontWeight: FontWeight.w900,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle mediumBodyLight = TextStyle(
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle mediumBodyRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle mediumBodyMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle mediumBodySemibold = TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle mediumBodyBold = TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle mediumBodyExtraBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle mediumBodyBlack = TextStyle(
    fontWeight: FontWeight.w900,
    fontStyle: FontStyle.normal,
    fontSize: 14,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle bigBodyLight = TextStyle(
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle bigBodyRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle bigBodyMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle bigBodySemibold = TextStyle(
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle bigBodyBold = TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle bigBodyExtraBold = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  static TextStyle bigBodyBlack = TextStyle(
    fontWeight: FontWeight.w900,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    letterSpacing: -0.24,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );

  /// This is the new version (design system 1.1) of buttonText
  static TextStyle textButton = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 16,
    height: 1.43,
    color: ZwapColors.shades100,
    fontFamily: instance.fontFamily._name,
    package: 'zwap_design_system',
  );
}
