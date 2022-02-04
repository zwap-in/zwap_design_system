/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  FontSizeDevice({required this.desktopM, required this.desktopS, required this.tablet, required this.mobileM, required this.mobileS});

  /// It retrieves the correct font size in base of the device type
  double getFontSize() {
    return getMultipleConditions<double>(this.desktopM, this.desktopS, this.tablet, this.mobileM, this.mobileM);
  }
}

/// It returns the text style in base of the different text type
TextStyle getTextStyle(ZwapTextType typeText) {
  switch (typeText) {
    case ZwapTextType.h1:
      return GoogleFonts.lato(textStyle: ZwapTypography.h1());
    case ZwapTextType.h2:
      return GoogleFonts.lato(textStyle: ZwapTypography.h2());
    case ZwapTextType.h3:
      return GoogleFonts.lato(textStyle: ZwapTypography.h3());
    case ZwapTextType.h4:
      return GoogleFonts.lato(textStyle: ZwapTypography.h4());
    case ZwapTextType.h5:
      return GoogleFonts.lato(textStyle: ZwapTypography.h5());
    case ZwapTextType.captionRegular:
      return GoogleFonts.lato(textStyle: ZwapTypography.captionRegular());
    case ZwapTextType.captionSemiBold:
      return GoogleFonts.lato(textStyle: ZwapTypography.captionSemiBold());
    case ZwapTextType.buttonText:
      return GoogleFonts.lato(textStyle: ZwapTypography.buttonText());
    case ZwapTextType.bodyRegular:
      return GoogleFonts.lato(textStyle: ZwapTypography.bodyRegular());
    case ZwapTextType.bodySemiBold:
      return GoogleFonts.lato(textStyle: ZwapTypography.bodySemiBold());
  }
}

/// It plots the text size in base of the current style and current chars
Size getTextSize(String text, ZwapTextType textType, {double? maxWidth}) {
  final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: getTextStyle(textType)), maxLines: 1, textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: maxWidth ?? double.infinity);
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

  final int? maxLines;

  final TextOverflow? textOverflow;

  final TextStyle? customTextStyle;

  ZwapText({
    Key? key,
    required this.text,
    required this.zwapTextType,
    required this.textColor,
    this.textAlign,
    this.maxLines,
    this.textOverflow,
  })  : this.customTextStyle = null,
        super(key: key);

  ZwapText.customStyle({
    Key? key,
    required this.text,
    required this.customTextStyle,
    this.textAlign,
    this.maxLines,
    this.textOverflow,
  })  : assert(customTextStyle != null),
        this.zwapTextType = ZwapTextType.bodyRegular,
        this.textColor = customTextStyle!.color ?? Colors.white,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      maxLines: maxLines,
      overflow: textOverflow,
      textScaleFactor: 1,
      textAlign: this.textAlign,
      style: customTextStyle ?? getTextStyle(this.zwapTextType).apply(color: this.textColor),
    );
  }

  @override
  double getSize() {
    return getTextSize(this.text, this.zwapTextType).width;
  }
}
