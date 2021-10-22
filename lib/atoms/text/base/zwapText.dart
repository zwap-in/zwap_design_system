/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// The device
class FontSizeDevice {

  /// The font size for the desktop M version
  final double desktopM;

  /// The font size for the desktop S version
  final double desktopS;

  /// The font size for the tablet version
  final double tablet;

  /// The font size for the mobile M version
  final double mobileM;

  /// The font size for the mobile S version
  final double mobileS;

  FontSizeDevice(
      {required this.desktopM,
      required this.desktopS,
      required this.tablet,
      required this.mobileM,
      required this.mobileS});

  /// It retrieves the correct font size in base of the device type
  double getFontSize() {
    return getMultipleConditions(this.desktopM, this.desktopS, this.tablet, this.mobileM, this.mobileM);
  }
}

/// It returns the text style in base of the different text type
TextStyle getTextStyle(ZwapTextType typeText) {
  Map<ZwapTextType, FontSizeDevice> fontSizeMapping = {
    ZwapTextType.h1: FontSizeDevice(
        desktopM: 48,
        desktopS: 40,
        tablet: 32,
        mobileM: 24.01,
        mobileS: 16.27
    ),
    ZwapTextType.h2: FontSizeDevice(
        desktopM: 40,
        desktopS: 32,
        tablet: 24.01,
        mobileM: 17.01,
        mobileS: 15.01
    ),
    ZwapTextType.h3: FontSizeDevice(
        desktopM: 24,
        desktopS: 24,
        tablet: 18,
        mobileM: 17,
        mobileS: 15
    ),
    ZwapTextType.h4: FontSizeDevice(
        desktopM: 18,
        desktopS: 18,
        tablet: 17,
        mobileM: 17,
        mobileS: 15
    ),
    ZwapTextType.h5: FontSizeDevice(
        desktopM: 16,
        desktopS: 16,
        tablet: 12,
        mobileM: 12,
        mobileS: 12
    ),
    ZwapTextType.h6: FontSizeDevice(
        desktopM: 14,
        desktopS: 14,
        tablet: 10.50,
        mobileM: 11,
        mobileS: 11),
    ZwapTextType.h7: FontSizeDevice(
        desktopM: 36,
        desktopS: 34,
        tablet: 17,
        mobileM: 17,
        mobileS: 17),
    ZwapTextType.subTitleRegular: FontSizeDevice(
        desktopM: 15,
        desktopS: 15,
        tablet: 11.25,
        mobileM: 10.25,
        mobileS: 8.44),
    ZwapTextType.subTitleSemiBold: FontSizeDevice(
        desktopM: 15,
        desktopS: 15,
        tablet: 11.25,
        mobileM: 10.25,
        mobileS: 8.44),
    ZwapTextType.subTitleBold: FontSizeDevice(
        desktopM: 15,
        desktopS: 15,
        tablet: 11.25,
        mobileM: 10.25,
        mobileS: 8.44),
    ZwapTextType.captionRegular: FontSizeDevice(
        desktopM: 12,
        desktopS: 12,
        tablet: 12,
        mobileM: 12,
        mobileS: 12
    ),
    ZwapTextType.captionSemiBold: FontSizeDevice(
        desktopM: 12,
        desktopS: 12,
        tablet: 12,
        mobileM: 12,
        mobileS: 12
    ),
    ZwapTextType.captionBold: FontSizeDevice(
        desktopM: 12,
        desktopS: 12,
        tablet: 12,
        mobileM: 12,
        mobileS: 12
    ),
    ZwapTextType.buttonText: FontSizeDevice(
        desktopM: 14,
        desktopS: 14,
        tablet: 14,
        mobileM: 14,
        mobileS: 14),
    ZwapTextType.body0Regular: FontSizeDevice(
        desktopM: 20, desktopS: 20, tablet: 12, mobileM: 11, mobileS: 11),
    ZwapTextType.body0SemiBold: FontSizeDevice(
        desktopM: 16, desktopS: 16, tablet: 12, mobileM: 11, mobileS: 11),
    ZwapTextType.body0Bold: FontSizeDevice(
        desktopM: 16, desktopS: 16, tablet: 12, mobileM: 11, mobileS: 11),
    ZwapTextType.body1Regular: FontSizeDevice(
        desktopM: 16, desktopS: 16, tablet: 12, mobileM: 15, mobileS: 15),
    ZwapTextType.body1SemiBold: FontSizeDevice(
        desktopM: 16, desktopS: 16, tablet: 13, mobileM: 13, mobileS: 13),
    ZwapTextType.body1Bold: FontSizeDevice(
        desktopM: 16, desktopS: 16, tablet: 12, mobileM: 11, mobileS: 11),
    ZwapTextType.body2Regular: FontSizeDevice(
        desktopM: 14, desktopS: 14, tablet: 11, mobileM: 13, mobileS: 13),
    ZwapTextType.body2SemiBold: FontSizeDevice(
        desktopM: 14, desktopS: 14, tablet: 11, mobileM: 10, mobileS: 10),
    ZwapTextType.body2Bold: FontSizeDevice(
        desktopM: 14, desktopS: 14, tablet: 11, mobileM: 10, mobileS: 10),
    ZwapTextType.body3Regular: FontSizeDevice(
        desktopM: 11, desktopS: 11, tablet: 11, mobileM: 10, mobileS: 10),
    ZwapTextType.body3SemiBold: FontSizeDevice(
        desktopM: 11, desktopS: 11, tablet: 11, mobileM: 10, mobileS: 10),
    ZwapTextType.body3Bold: FontSizeDevice(
        desktopM: 11, desktopS: 11, tablet: 11, mobileM: 10, mobileS: 10),
  };

  switch (typeText) {
    case ZwapTextType.h1:
      return ZwapTypography.h1().apply(
          fontSizeDelta: fontSizeMapping[ZwapTextType.h1]!.getFontSize());
    case ZwapTextType.h2:
      return ZwapTypography.h2().apply(
          fontSizeDelta: fontSizeMapping[ZwapTextType.h2]!.getFontSize());
    case ZwapTextType.h3:
      return ZwapTypography.h3().apply(
          fontSizeDelta: fontSizeMapping[ZwapTextType.h3]!.getFontSize());
    case ZwapTextType.h4:
      return ZwapTypography.h4().apply(
          fontSizeDelta: fontSizeMapping[ZwapTextType.h4]!.getFontSize());
    case ZwapTextType.h5:
      return ZwapTypography.h5().apply(
          fontSizeDelta: fontSizeMapping[ZwapTextType.h5]!.getFontSize());
    case ZwapTextType.h6:
      return ZwapTypography.h6().apply(
          fontSizeDelta: fontSizeMapping[ZwapTextType.h6]!.getFontSize());
    case ZwapTextType.h7:
      return ZwapTypography.h7().apply(
          fontSizeDelta: fontSizeMapping[ZwapTextType.h7]!.getFontSize());
    case ZwapTextType.subTitleRegular:
      return ZwapTypography.subtitleRegular().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.subTitleRegular]!.getFontSize());
    case ZwapTextType.subTitleSemiBold:
      return ZwapTypography.subtitleSemiBold().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.subTitleSemiBold]!.getFontSize());
    case ZwapTextType.subTitleBold:
      return ZwapTypography.subtitleBold().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.subTitleBold]!.getFontSize());
    case ZwapTextType.captionRegular:
      return ZwapTypography.captionRegular().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.captionRegular]!.getFontSize());
    case ZwapTextType.captionSemiBold:
      return ZwapTypography.captionSemiBold().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.captionSemiBold]!.getFontSize());
    case ZwapTextType.captionBold:
      return ZwapTypography.captionBold().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.captionBold]!.getFontSize());
    case ZwapTextType.buttonText:
      return ZwapTypography.buttonText().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.buttonText]!.getFontSize());
    case ZwapTextType.body0Regular:
      return ZwapTypography.body1Regular().apply(
          fontSizeDelta:
          fontSizeMapping[ZwapTextType.body0Regular]!.getFontSize());
    case ZwapTextType.body0SemiBold:
      return ZwapTypography.body1SemiBold().apply(
          fontSizeDelta:
          fontSizeMapping[ZwapTextType.body0SemiBold]!.getFontSize());
    case ZwapTextType.body0Bold:
      return ZwapTypography.body1Bold().apply(
          fontSizeDelta:
          fontSizeMapping[ZwapTextType.body0Bold]!.getFontSize());
    case ZwapTextType.body1Regular:
      return ZwapTypography.body1Regular().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.body1Regular]!.getFontSize());
    case ZwapTextType.body1SemiBold:
      return ZwapTypography.body1SemiBold().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.body1SemiBold]!.getFontSize());
    case ZwapTextType.body1Bold:
      return ZwapTypography.body1Bold().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.body1Bold]!.getFontSize());
    case ZwapTextType.body2Regular:
      return ZwapTypography.body2Regular().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.body2Regular]!.getFontSize());
    case ZwapTextType.body2SemiBold:
      return ZwapTypography.body2SemiBold().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.body2SemiBold]!.getFontSize());
    case ZwapTextType.body2Bold:
      return ZwapTypography.body2Bold().apply(
          fontSizeDelta:
              fontSizeMapping[ZwapTextType.body2Bold]!.getFontSize());
    case ZwapTextType.body3Regular:
      return ZwapTypography.body2Regular().apply(
          fontSizeDelta:
          fontSizeMapping[ZwapTextType.body3Regular]!.getFontSize());
    case ZwapTextType.body3SemiBold:
      return ZwapTypography.body2SemiBold().apply(
          fontSizeDelta:
          fontSizeMapping[ZwapTextType.body3SemiBold]!.getFontSize());
    case ZwapTextType.body3Bold:
      return ZwapTypography.body2Bold().apply(
          fontSizeDelta:
          fontSizeMapping[ZwapTextType.body3Bold]!.getFontSize());
  }
}


/// It plots the text size in base of the current style and current chars
Size getTextSize(String text, ZwapTextType textType) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: getTextStyle(textType)),
      maxLines: 1, textDirection: TextDirection.ltr
  )..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

/// Component to rendering text in base of style and device type
class ZwapText extends StatelessWidget implements ResponsiveWidget {
  /// The text to display inside this rendering
  final String text;

  /// The zwap text type
  final ZwapTextType zwapTextType;

  /// The text color to apply to the final style
  final Color textColor;

  /// The align for this text
  final TextAlign? textAlign;

  ZwapText(
      {Key? key,
      required this.text,
      required this.zwapTextType,
      required this.textColor,
      this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      textAlign: this.textAlign,
      style: getTextStyle(this.zwapTextType).apply(color: this.textColor),
    );
  }

  @override
  double getSize() {
    return getTextSize(this.text, this.zwapTextType).width;
  }
}
