/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

class ZwapTranslation extends Pattern {
  static Future<void> Function(BuildContext context, Future<void> Function(String newValue) overrideValue, String originalText)? showEditTextModal;

  /// Used to translate keys, must be not null and not return null
  static String? Function(String)? translate;

  /// Called each time user edit the value of the translation
  static Future<void> Function(String key, dynamic newValue)? updateValue;

  /// If this value is true, the text will be editable
  static bool enableEdits = false;

  /// This value will be used to retrieve the translation
  /// from the [translate] function
  final String key;

  /// If this value is false, the text will not be editable
  /// even if the [ZwapTranslation] is in edit mode
  final bool enableEdit;

  ZwapTranslation(this.key, {this.enableEdit = true});

  String getTranslation() {
    assert(translate != null, "Did you forget to add a translate function handler in [ZwapTranslation]?");
    final String? _res = translate!(key);

    if (_res == null) {
      throw Exception("The key [$key] is not present in the translation file");
    }

    return _res;
  }

  @override
  Iterable<Match> allMatches(String string, [int start = 0]) {
    throw UnimplementedError("[ZwapTranslation] does not support [allMatches] method");
  }

  @override
  Match? matchAsPrefix(String string, [int start = 0]) {
    throw UnimplementedError("[ZwapTranslation] does not support [matchAsPrefix] method");
  }

  @override
  String toString() => key;
}

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
      return ZwapTypography.h1();
    case ZwapTextType.h2:
      return ZwapTypography.h2();
    case ZwapTextType.h3:
      return ZwapTypography.h3();
    case ZwapTextType.h4:
      return ZwapTypography.h4();
    case ZwapTextType.h5:
      return ZwapTypography.h5();
    case ZwapTextType.captionRegular:
      return ZwapTypography.captionRegular();
    case ZwapTextType.captionSemiBold:
      return ZwapTypography.captionSemiBold();
    case ZwapTextType.buttonText:
      return ZwapTypography.buttonText();
    case ZwapTextType.bodyRegular:
      return ZwapTypography.bodyRegular();
    case ZwapTextType.bodySemiBold:
      return ZwapTypography.bodySemiBold();
    case ZwapTextType.extraHeading:
      return ZwapTypography.extraHeading;
    case ZwapTextType.bigHeading:
      return ZwapTypography.bigHeading;
    case ZwapTextType.mediumHeading:
      return ZwapTypography.mediumHeading;
    case ZwapTextType.semiboldH1:
      return ZwapTypography.semiboldH1;
    case ZwapTextType.heavyH1:
      return ZwapTypography.heavyH1;
    case ZwapTextType.semiboldH2:
      return ZwapTypography.semiboldH2;
    case ZwapTextType.heavyH2:
      return ZwapTypography.heavyH2;
    case ZwapTextType.semiboldH3:
      return ZwapTypography.semiboldH3;
    case ZwapTextType.heavyH3:
      return ZwapTypography.heavyH3;
    case ZwapTextType.smallBodyLight:
      return ZwapTypography.smallBodyLight;
    case ZwapTextType.smallBodyRegular:
      return ZwapTypography.smallBodyRegular;
    case ZwapTextType.smallBodyMedium:
      return ZwapTypography.smallBodyMedium;
    case ZwapTextType.smallBodySemibold:
      return ZwapTypography.smallBodySemibold;
    case ZwapTextType.smallBodyBold:
      return ZwapTypography.smallBodyBold;
    case ZwapTextType.smallBodyExtraBold:
      return ZwapTypography.smallBodyExtraBold;
    case ZwapTextType.smallBodyBlack:
      return ZwapTypography.smallBodyBlack;
    case ZwapTextType.mediumBodyLight:
      return ZwapTypography.mediumBodyLight;
    case ZwapTextType.mediumBodyRegular:
      return ZwapTypography.mediumBodyRegular;
    case ZwapTextType.mediumBodyMedium:
      return ZwapTypography.mediumBodyMedium;
    case ZwapTextType.mediumBodySemibold:
      return ZwapTypography.mediumBodySemibold;
    case ZwapTextType.mediumBodyBold:
      return ZwapTypography.mediumBodyBold;
    case ZwapTextType.mediumBodyExtraBold:
      return ZwapTypography.mediumBodyExtraBold;
    case ZwapTextType.mediumBodyBlack:
      return ZwapTypography.mediumBodyBlack;
    case ZwapTextType.bigBodyLight:
      return ZwapTypography.bigBodyLight;
    case ZwapTextType.bigBodyRegular:
      return ZwapTypography.bigBodyRegular;
    case ZwapTextType.bigBodyMedium:
      return ZwapTypography.bigBodyMedium;
    case ZwapTextType.bigBodySemibold:
      return ZwapTypography.bigBodySemibold;
    case ZwapTextType.bigBodyBold:
      return ZwapTypography.bigBodyBold;
    case ZwapTextType.bigBodyExtraBold:
      return ZwapTypography.bigBodyExtraBold;
    case ZwapTextType.bigBodyBlack:
      return ZwapTypography.bigBodyBlack;
    case ZwapTextType.textButton:
      return ZwapTypography.textButton;
    case ZwapTextType.extraSmallBodyRegular:
      return ZwapTypography.extraSmallBodyRegular;
  }
}

/// It plots the text size in base of the current style and current chars
Size getTextSize(String text, ZwapTextType textType, {double? maxWidth}) {
  final TextPainter textPainter =
      TextPainter(text: TextSpan(text: text, style: getTextStyle(textType)), maxLines: 1, textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: maxWidth ?? double.infinity);
  return textPainter.size;
}

Size getTextSizeFromCustomStyle(String text, TextStyle textStyle, {double? maxWidth}) {
  final TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: textStyle), maxLines: 1, textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: maxWidth ?? double.infinity);
  return textPainter.size;
}

/// Return the minWidth occupied by text in a single line
double textWidth(String text, TextStyle style, {TextAlign textAlign = TextAlign.left}) {
  var span = TextSpan(text: text, style: style);
  var tp = TextPainter(maxLines: 1, textAlign: textAlign, textDirection: TextDirection.ltr, text: span);
  tp.layout();

  return tp.width;
}

/// Component to rendering text in base of style and device type
class ZwapText extends StatelessWidget implements ResponsiveWidget {
  /// The text to display inside this rendering
  final Pattern text;

  /// The zwap text type
  final ZwapTextType zwapTextType;

  /// The text color to apply to the final style
  final Color textColor;

  /// The align for this text
  final TextAlign? textAlign;

  final int? maxLines;

  final TextOverflow? textOverflow;

  final TextStyle? customTextStyle;

  final bool _selectable;

  ZwapText({
    Key? key,
    required this.text,
    required this.zwapTextType,
    required this.textColor,
    this.textAlign,
    this.maxLines,
    this.textOverflow,
  })  : this.customTextStyle = null,
        _selectable = false,
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
        _selectable = false,
        this.textColor = customTextStyle!.color ?? Colors.white,
        super(key: key);

  /// Beta
  ZwapText.selectable({
    Key? key,
    required this.text,
    required this.zwapTextType,
    required this.textColor,
    this.textAlign,
    this.maxLines,
    this.textOverflow,
  })  : this.customTextStyle = null,
        _selectable = true,
        super(key: key);

  String get actualText {
    if (text is String) {
      return text as String;
    } else if (isZwapTranslation) {
      return (text as ZwapTranslation).getTranslation();
    }

    return text.toString();
  }

  bool get isZwapTranslation => text is ZwapTranslation;

  @override
  Widget build(BuildContext context) {
    if (_selectable)
      return SelectableText(
        actualText,
        maxLines: maxLines,
        textScaleFactor: 1,
        textAlign: this.textAlign,
        style: customTextStyle ?? getTextStyle(this.zwapTextType).apply(color: this.textColor),
      );

    Text _text() => Text(
          actualText,
          maxLines: maxLines,
          overflow: textOverflow,
          textScaleFactor: 1,
          textAlign: this.textAlign,
          style: customTextStyle ?? getTextStyle(this.zwapTextType).apply(color: this.textColor),
        );

    if (ZwapTranslation.enableEdits && isZwapTranslation)
      return _WrapWithEditTextTooltip(
        text: text as ZwapTranslation,
        builder: _text,
      );
    return _text();
  }

  @override
  double getSize() {
    return getTextSize(actualText, this.zwapTextType).width;
  }
}

class _WrapWithEditTextTooltip extends StatefulWidget {
  final ZwapTranslation text;
  final Text Function() builder;

  const _WrapWithEditTextTooltip({
    required this.text,
    required this.builder,
    super.key,
  });

  @override
  State<_WrapWithEditTextTooltip> createState() => _WrapWithEditTextTooltipState();
}

class _WrapWithEditTextTooltipState extends State<_WrapWithEditTextTooltip> {
  Future<void> overrideValue(String newValue) async {
    if (ZwapTranslation.updateValue != null) {
      await ZwapTranslation.updateValue!(widget.text.toString(), newValue);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Click to edit",
      child: InkWell(
        onTap: () {
          if (ZwapTranslation.showEditTextModal != null) {
            ZwapTranslation.showEditTextModal!(context, overrideValue, widget.text.getTranslation());
            return;
          }

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Edit text"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ZwapText(
                    text: "Text was: ",
                    zwapTextType: ZwapTextType.smallBodySemibold,
                    textColor: ZwapColors.neutral500,
                  ),
                  const SizedBox(height: 4),
                  widget.builder(),
                  const SizedBox(height: 12),
                  TextField(
                    controller: TextEditingController(text: widget.text.getTranslation()),
                    onChanged: (value) => overrideValue(value),
                  ),
                ],
              ),
            ),
          );
        },
        child: widget.builder(),
      ),
    );
  }
}
