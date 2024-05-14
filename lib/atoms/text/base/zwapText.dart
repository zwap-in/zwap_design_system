library zwap.text;

import 'package:flutter/gestures.dart';

/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:ui' as ui; // Importa 'dart:ui' per accedere a TextPainter e ParagraphStyle

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

part 'zwap_gradient_text.dart';

class ZwapTranslation extends Pattern {
  static Future<void> Function(BuildContext context, void Function() updateValue, String textKey)? showEditTextModal;

  /// Used to translate keys, must be not null and not return null
  ///
  /// The [arguments] can be provided for each string, usually used for
  /// insert dynamic values inside the string
  static String? Function(String, Map<String, dynamic> arguments)? translate;

  /// If this value is true, the text will be editable
  static bool enableEdits = false;

  /// This value will be used to retrieve the translation
  /// from the [translate] function
  final String key;

  /// If this value is false, the text will not be editable
  /// even if the [ZwapTranslation] is in edit mode
  final bool enableEdit;

  /// If true the edit action is triggered by a long press
  /// instead of a simple tap
  final bool useLongPress;

  /// If not null, the [_decorate] function will be called
  /// each time the [ZwapTranslation] is rendered
  ///
  /// This function can be used to merge the string fetched from
  /// the [translate] function with other strings, such as commas
  /// or other characters
  ///
  /// Example:
  /// ```
  /// ZwapTranslation.translate = (key, _) => { "hello": "Hello" }[key];
  ///
  /// ZwapTranslation(
  ///   key: "hello",
  ///   decorate: (text) => "$text!"
  /// )
  /// ```
  ///
  /// Here the rendered text is "Hello!", but the editable value is only the [text] parameter,
  /// so "Hello".
  final String Function(String)? _decorate;

  /// The [arguments] property is used to insert dynamic values
  /// inside the string
  ///
  /// Provided to the translate function
  final Map<String, dynamic> arguments;

  /// If true the '\n' character will be replaced with a new line
  /// character
  ///
  /// Default value is true
  final bool castLineBreaks;

  /// The [key] property is used to retrive the string from the
  /// [ZwapTranslation.translate] function
  ///
  /// Use the [enableEdit] property to enable/disable the edit mode
  /// for this specific [ZwapTranslation]
  ///
  /// Use the [_decorate] property to decorate the string with other
  /// characters
  ///
  /// Use the [useLongPress] property to enable the edit mode with a
  /// long press instead of a simple tap. Useful when the text is clickable
  ///
  /// The [arguments] property are deferred to the [translate] function, usually
  /// used to insert dynamic values inside the string
  ///
  /// ---
  ///
  /// Example:
  /// ```
  /// /// THe translate function return the string in base of the key
  /// /// replacing the arguments
  /// ZwapTranslation.translate = (key, args) {...};
  ///
  /// ZwapTranslation(
  ///   key: "greeter",
  ///   decorate: (text) => "$text!",
  ///   arguments: { "name": "John" }
  /// )
  /// ```
  ///
  /// In this example the actual rendered string is "Hello John!". While editing only the
  /// "greeter" key string will be actually changed. The dynamic name is provided using
  /// the [arguments] property and the exclamation mark do not belong to the editable string
  ///
  /// ---
  ///
  /// Use [castLineBreaks] to replace the '\n' character with a new line character
  ZwapTranslation(
    this.key, {
    this.enableEdit = true,
    this.useLongPress = false,
    String Function(String)? decorate,
    this.arguments = const {},
    this.castLineBreaks = true,
  }) : _decorate = decorate;

  String getTranslation() {
    assert(translate != null, "Did you forget to add a translate function handler in [ZwapTranslation]?");
    String? _res = translate!(key, arguments!);

    if (_res == null) {
      throw Exception("The key [$key] is not present in the translation file");
    }

    if (castLineBreaks) {
      _res = _res.replaceAll(r"\n", "\n");
    }

    if (_decorate != null) return _decorate!(_res);
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
  String toString() => getTranslation();

  final List<Function()> _notifiers = [];

  /// Used to ad "cascade" callback on notify. Used
  /// in gradient texts thats are not updating with the child (ZwapText)
  /// updated
  void _addNotifierMirror(Function() onNotify) => _notifiers.add(onNotify);

  /// Used to notify the parent that the child has been updated
  /// and it needs to be updated too
  void _dispatchNotify() => _notifiers.forEach((element) => element());
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
class ZwapText extends StatefulWidget implements ResponsiveWidget {
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

  /// The line height for this text (in pixels)
  ///
  /// Really useful when design is in figma
  final double? lineHeight;

  /// The letter spacing for this text (in percent)
  ///
  /// Really useful when design is in figma
  final double? letterSpacing;

  final GlobalKey? parentKey;

  final bool showTooltipIfOverflow;

  @Deprecated("This field is now ignored, use [doNotHighlightHyperLinks] to remove the automatic highlight of urls")
  final bool highlightUrls;

  /// If true, automatic highlight of urls will be disabled
  ///
  /// Default to false
  final bool doNotHighlightHyperLinks;

  static double convertFontSpacing(double percent, [double fontSize = 16]) => fontSize * percent / 100;
  static double convertFontHeight(double lineHeight, [double fontSize = 16]) => lineHeight / fontSize;

  ZwapText({
    Key? key,
    required this.text,
    required this.zwapTextType,
    required this.textColor,
    this.textAlign,
    this.maxLines,
    this.textOverflow,
    this.lineHeight,
    this.letterSpacing,
    this.parentKey,
    this.showTooltipIfOverflow = false,
    this.highlightUrls = false,
    this.doNotHighlightHyperLinks = false,
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
    this.lineHeight,
    this.letterSpacing,
    this.parentKey,
    this.showTooltipIfOverflow = false,
    this.highlightUrls = false,
    this.doNotHighlightHyperLinks = false,
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
    this.lineHeight,
    this.letterSpacing,
    this.parentKey,
    this.showTooltipIfOverflow = false,
    this.highlightUrls = false,
    this.doNotHighlightHyperLinks = false,
  })  : this.customTextStyle = null,
        _selectable = true,
        super(key: key);

  static bool isTextOverflow(
    String text,
    Rect boundingRect,
    TextStyle textStyle,
    int maxLines,
  ) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: boundingRect.width);
    return textPainter.didExceedMaxLines;
  }

  @override
  State<ZwapText> createState() => _ZwapTextState();

  @override
  double getSize() {
    return 0;
  }
}

class _ZwapTextState extends State<ZwapText> {
  String get actualText {
    if (widget.text is String) {
      return widget.text as String;
    } else if (isZwapTranslation) {
      return (widget.text as ZwapTranslation).getTranslation();
    }

    return widget.text.toString();
  }

  bool get isZwapTranslation => widget.text is ZwapTranslation;

  bool? _isTextOverlowing;

  bool get isTextOverflowing {
    if (!widget.showTooltipIfOverflow) return false;
    if (widget.parentKey == null) return false;

    _isTextOverlowing = ZwapText.isTextOverflow(
      actualText,
      widget.parentKey?.globalPaintBounds ?? Rect.zero,
      widget.customTextStyle ?? getTextStyle(this.widget.zwapTextType),
      widget.maxLines ?? 1,
    );

    return _isTextOverlowing!;
  }

  final RegExp _urlRegExp = RegExp(
    r"(http|https|ftp)://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(/\S*)?",
    caseSensitive: false,
  );

  final RegExp _emailRegExp = RegExp(
    r"([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)",
    caseSensitive: false,
  );

  final RegExp _telRegExp = RegExp(
    r'\+?\d[\d -]{8,12}\d',
    caseSensitive: false,
  );

  RegExp get _globalRegExp {
    return RegExp([_urlRegExp, _emailRegExp, _telRegExp].map((e) => '(${e.pattern})').join("|"), caseSensitive: false);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = widget.customTextStyle ?? getTextStyle(this.widget.zwapTextType).apply(color: this.widget.textColor);

    if (widget.lineHeight != null) {
      _textStyle = _textStyle.copyWith(
        height: ZwapText.convertFontHeight(widget.lineHeight!, _textStyle.fontSize ?? 16),
      );
    }

    if (widget.letterSpacing != null) {
      _textStyle = _textStyle.copyWith(
        letterSpacing: ZwapText.convertFontSpacing(widget.letterSpacing!, _textStyle.fontSize ?? 16),
      );
    }

    bool _containsUrls = actualText.contains(_globalRegExp);

    Widget _highlighText() {
      final List<Match> matches = _globalRegExp.allMatches(actualText).toList();
      final List<String> _splittedText = actualText.split(_globalRegExp);

      return ZwapRichText.safeText(
        selectable: _splittedText.length > 1,
        textSpans: _splittedText
            .map((text) {
              return ZwapTextSpan(
                text: text,
                textStyle: _textStyle,
              );
            })
            .toList()
            .spread(
              matches.map((match) {
                final bool isEmail = _emailRegExp.hasMatch(match.group(0) ?? '');
                final bool isTel = !isEmail && _telRegExp.hasMatch(match.group(0) ?? '');

                return ZwapTextSpan(
                  text: match.group(0) ?? '',
                  textStyle: _textStyle.copyWith(
                    color: ZwapColors.primary400,
                    decoration: isEmail || isTel ? null : TextDecoration.underline,
                    decorationColor: ZwapColors.primary400,
                    decorationThickness: 1.2,
                  ),
                  cursor: SystemMouseCursors.click,
                  gestureRecognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (isEmail) {
                        launchUrlString("mailto:${match.group(0)}");
                        return;
                      } else if (isTel) {
                        launchUrlString("tel:${match.group(0)}");
                        return;
                      }
                      launchUrlString(match.group(0)!);
                    },
                );
              }).toList(),
            ),
      );
    }

    Widget _text() => _CustomTooltip(
          text: actualText,
          getIsOverflown: () => isTextOverflowing,
          child: !widget.doNotHighlightHyperLinks && _containsUrls
              ? _highlighText()
              : widget._selectable
                  ? SelectableText(
                      actualText,
                      maxLines: widget.maxLines,
                      textScaleFactor: 1,
                      textAlign: this.widget.textAlign,
                      style: _textStyle,
                    )
                  : Text(
                      actualText,
                      maxLines: widget.maxLines,
                      overflow: widget.textOverflow,
                      textScaleFactor: 1,
                      textAlign: this.widget.textAlign,
                      style: _textStyle,
                    ),
        );

    if (ZwapTranslation.enableEdits && isZwapTranslation)
      return _WrapWithEditTextTooltip(
        text: widget.text as ZwapTranslation,
        builder: _text,
      );
    return _text();
  }
}

class _CustomTooltip extends StatefulWidget {
  final Widget child;
  final bool Function() getIsOverflown;

  final String text;

  const _CustomTooltip({
    required this.child,
    required this.getIsOverflown,
    required this.text,
    super.key,
  });

  @override
  State<_CustomTooltip> createState() => __CustomTooltipState();
}

class __CustomTooltipState extends State<_CustomTooltip> {
  bool _showTooltip = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (isHovering) => setState(() => _showTooltip = widget.getIsOverflown()),
      onExit: (_) => setState(() => _showTooltip = false),
      child: ZwapTooltip(
        position: TooltipPosition.bottom,
        borderColor: ZwapColors.text65,
        backgroundColor: ZwapColors.primary900Dark,
        simple: true,
        style: ZwapTextType.mediumBodyRegular.copyWith(color: ZwapColors.shades0),
        radius: 8,
        transationOffset: const Offset(0, 4),
        message: widget.text,
        showTooltip: _showTooltip,
        child: widget.child,
      ),
    );
  }
}

class _WrapWithEditTextTooltip extends StatefulWidget {
  final ZwapTranslation text;
  final Widget Function() builder;

  const _WrapWithEditTextTooltip({
    required this.text,
    required this.builder,
    super.key,
  });

  @override
  State<_WrapWithEditTextTooltip> createState() => _WrapWithEditTextTooltipState();
}

class _WrapWithEditTextTooltipState extends State<_WrapWithEditTextTooltip> {
  void _updateValue() {
    if (mounted) {
      setState(() {});
      widget.text._dispatchNotify();
    }
  }

  @override
  Widget build(BuildContext context) {
    void _handleEdit() {
      if (ZwapTranslation.showEditTextModal != null) {
        ZwapTranslation.showEditTextModal!(context, _updateValue, widget.text.key);
        return;
      }

      throw Exception("Did you forget to add a showEditTextModal handler in [ZwapTranslation]?");
    }

    Widget _wrapWithTooltip(Widget child) {
      if (widget.text.enableEdit) {
        return Tooltip(
          message: widget.text.useLongPress ? "Long click to edit" : "Click to edit",
          child: child,
        );
      }

      return child;
    }

    return _wrapWithTooltip(
      widget.text.enableEdit
          ? InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              highlightColor: Colors.transparent,
              onLongPress: widget.text.useLongPress ? _handleEdit : null,
              onTap: widget.text.useLongPress ? () {} : _handleEdit,
              child: widget.builder(),
            )
          : widget.builder(),
    );
  }
}

extension _Ext<T> on List<T> {
  List<T> spread(List<T> content) {
    final List<T> _new = [];
    final List<T> _original = List.from(this);

    while (_original.isNotEmpty) {
      _new.add(_original.removeAt(0));
      if (content.isNotEmpty) {
        _new.add(content.removeAt(0));
      }
    }

    if (content.isNotEmpty) {
      _new.addAll(content);
    }

    return _new;
  }
}
