/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/link.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import '../../typography/zwapTypography.dart';

import '../base/zwapText.dart';
import '../base/zwap_gradient_text.dart';

//FEATURE (Marchetti): Move ZwapType and Color in a ZwapTextStyle and standardize all types

enum ZwapLinkTarget {
  blank,
  defaultTarget,
  self,
}

class ZwapTextSpan {
  final String text;

  List<ZwapTextSpan> children;

  /// FEATURE (Marchetti): Add the co-existency of gesture recognizer and link widger
  ///! if one of the text spans has links this will be ignored
  final TapGestureRecognizer? gestureRecognizer;

  final TextStyle? textStyle;

  /// if != null link widget will be added on this textspan only
  final Uri? linkToUri;

  /// Used only if linkToUri != null
  final ZwapLinkTarget linkTarget;

  ZwapTextSpan({
    required this.text,
    this.textStyle,
    this.children = const [],
    this.linkToUri,
    this.gestureRecognizer,
    this.linkTarget = ZwapLinkTarget.defaultTarget,
  });

  ZwapTextSpan.fromZwapTypography({
    required this.text,
    ZwapTextType? textType,
    Color? textColor,
    this.linkToUri,
    this.children = const [],
    this.gestureRecognizer,
    this.linkTarget = ZwapLinkTarget.defaultTarget,
  }) : this.textStyle = textType == null
            ? textColor != null
                ? TextStyle(color: textColor)
                : null
            : getTextStyle(textType).copyWith(color: textColor);

  InlineSpan _toInlineSpan() => TextSpan(
        text: text,
        style: textStyle,
        recognizer: gestureRecognizer,
        children: this.children.map((zwapTS) => zwapTS._toInlineSpan()).toList(),
      );
}

/// Gradient test spans supports only the onTap
/// gesture
class ZwapGradientTextSpan extends ZwapTextSpan {
  final List<Color> colors;
  final List<double>? stops;
  final Alignment? begin;
  final Alignment? end;

  final LinearGradient? _gradient;

  ZwapGradientTextSpan({
    required String text,
    required this.colors,
    TextStyle? textStyle,
    List<ZwapTextSpan> children = const [],
    Uri? linkToUri,
    TapGestureRecognizer? gestureRecognizer,
    ZwapLinkTarget linkTarget = ZwapLinkTarget.defaultTarget,
    this.begin,
    this.end,
    this.stops,
  })  : this._gradient = null,
        super(
          text: text,
          children: children,
          gestureRecognizer: gestureRecognizer,
          linkTarget: linkTarget,
          linkToUri: linkToUri,
          textStyle: textStyle?.copyWith(color: Colors.white),
        );

  ZwapGradientTextSpan.fromZwapTypography({
    required String text,
    required this.colors,
    ZwapTextType? textType,
    Uri? linkToUri,
    List<ZwapTextSpan> children = const [],
    TapGestureRecognizer? gestureRecognizer,
    ZwapLinkTarget linkTarget = ZwapLinkTarget.defaultTarget,
    this.begin,
    this.end,
    this.stops,
  })  : this._gradient = null,
        super.fromZwapTypography(
          text: text,
          children: children,
          gestureRecognizer: gestureRecognizer,
          linkTarget: linkTarget,
          linkToUri: linkToUri,
          textColor: Colors.white,
          textType: textType,
        );

  ZwapGradientTextSpan.fromGradient({
    required String text,
    required LinearGradient gradient,
    required TextStyle textStyle,
    List<ZwapTextSpan> children = const [],
    Uri? linkToUri,
    TapGestureRecognizer? gestureRecognizer,
    ZwapLinkTarget linkTarget = ZwapLinkTarget.defaultTarget,
  })  : this.colors = [],
        this.begin = null,
        this.end = null,
        this.stops = null,
        this._gradient = gradient,
        super(
          text: text,
          children: children,
          gestureRecognizer: gestureRecognizer,
          linkTarget: linkTarget,
          linkToUri: linkToUri,
          textStyle: textStyle.copyWith(color: Colors.white),
        );

  @override
  InlineSpan _toInlineSpan() => WidgetSpan(
    alignment: PlaceholderAlignment.bottom,
        child: GestureDetector(
          onTap: () {
            if (gestureRecognizer != null && gestureRecognizer!.onTap != null) gestureRecognizer!.onTap!();
          },
          child: _gradient != null
              ? ZwapGradientText.fromGradient(
                  gradient: _gradient!,
                  style: textStyle!,
                  text: text,
                )
              : ZwapGradientText.custom(
                  style: this.textStyle ?? TextStyle(),
                  text: text,
                  colors: colors,
                  begin: begin,
                  end: end,
                  stops: stops,
                ),
        ),
      );
}

/// Component to rendering multi text style
///
/// If no style is provided to this widget or to a text spans tree, DefaultTextStyle will be used
class ZwapRichText extends StatelessWidget {
  final bool _isSafeText;

  /// Each text with a custom type and custom color and optionally a recognizer
  final Map<String, TupleType<TapGestureRecognizer?, TupleType<ZwapTextType, Color>>> texts;

  final List<ZwapTextSpan> textSpans;

  final TextAlign? textAlign;

  final TextStyle? style;

  @Deprecated("Use the ZwapRichText.safeText(...) instead. This will be removed in the future.")
  ZwapRichText({
    Key? key,
    required this.texts,
    this.style,
    this.textAlign,
  })  : this.textSpans = [],
        this._isSafeText = false,
        super(key: key);

  /// This components allow you to display multiple style text using ZwapTextSpans and not a Map<String, ...>
  ///
  /// Doing so, you can put multiple time the same string
  ZwapRichText.safeText({
    Key? key,
    required this.textSpans,
    this.style,
    this.textAlign,
  })  : this.texts = {},
        this._isSafeText = true,
        super(key: key);

  ZwapRichText.zwapTypografy({
    Key? key,
    required this.textSpans,
    required ZwapTextType textType,
    Color? textColor,
    this.textAlign,
  })  : this.texts = {},
        this.style = getTextStyle(textType).copyWith(color: textColor),
        this._isSafeText = true,
        super(key: key);

  /// It write each text with correct style and correct color
  List<TextSpan> _getTexts() {
    List<TextSpan> finals = [];
    this.texts.forEach((key, TupleType<TapGestureRecognizer?, TupleType<ZwapTextType, Color>> value) {
      if (value.a != null) {
        finals.add(TextSpan(text: key, style: getTextStyle(value.b.a).apply(color: value.b.b), recognizer: value.a));
      } else {
        finals.add(TextSpan(text: key, style: getTextStyle(value.b.a).apply(color: value.b.b)));
      }
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {
    late List<InlineSpan> children;

    if (_isSafeText)
      children = this.textSpans.map((e) => e._toInlineSpan()).toList();
    else
      children = _getTexts();

    if (_isSafeText && textSpans.any((t) => t.linkToUri != null)) return _LinkedMultyStyleText(textSpans: textSpans, textAlign: textAlign);

    return RichText(
      text: TextSpan(
        children: List<InlineSpan>.generate(children.length, (index) => children[index]),
        style: style,
      ),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}

class _LinkedMultyStyleText extends StatefulWidget {
  final List<ZwapTextSpan> textSpans;
  final TextAlign? textAlign;

  final TextStyle? style;

  const _LinkedMultyStyleText({
    required this.textSpans,
    this.textAlign,
    this.style,
    Key? key,
  }) : super(key: key);

  @override
  State<_LinkedMultyStyleText> createState() => _LinkedMultyStyleTextState();
}

class _LinkedMultyStyleTextState extends State<_LinkedMultyStyleText> {
  Uri? currentUri;
  LinkTarget? currentLinkTarget;

  LinkTarget _getLinkTarget(ZwapLinkTarget target) {
    switch (target) {
      case ZwapLinkTarget.blank:
        return LinkTarget.blank;
      case ZwapLinkTarget.defaultTarget:
        return LinkTarget.defaultTarget;
      case ZwapLinkTarget.self:
        return LinkTarget.self;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: currentUri,
      target: currentLinkTarget ?? LinkTarget.defaultTarget,
      builder: (context, followLink) {
        return GestureDetector(
          onTap: followLink,
          child: RichText(
            text: TextSpan(
                style: widget.style,
                children: widget.textSpans
                    .map(
                      (span) => TextSpan(
                        text: span.text,
                        mouseCursor: span.linkToUri != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
                        style: span.textStyle,
                        onEnter: (_) {
                          setState(() {
                            currentUri = span.linkToUri;
                            currentLinkTarget = _getLinkTarget(span.linkTarget);
                          });
                        },
                      ),
                    )
                    .toList()),
            textAlign: widget.textAlign ?? TextAlign.start,
          ),
        );
      },
    );
  }
}
