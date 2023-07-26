/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/molecules/toast/zwapToast.dart';
import 'package:zwap_utils/zwap_utils.dart';

//FEATURE (Marchetti): Move ZwapType and Color in a ZwapTextStyle and standardize all types

enum ZwapLinkTarget {
  blank,
  defaultTarget,
  self,
}

class ZwapTextSpan {
  /// Attention: if you use a [ZwapTranslation] with [useLongPress] = true
  /// the [onSecondayTap] is used instead of [onLongPress]
  final Pattern text;

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

  InlineSpan _toInlineSpan(BuildContext context, void Function() updateWidget) {
    if (text is ZwapTranslation) {
      final TapGestureRecognizer _gestureRecognizer = gestureRecognizer ?? TapGestureRecognizer();
      final ZwapTranslation _t = text as ZwapTranslation;

      void _handleEdit() {
        if (ZwapTranslation.showEditTextModal != null) {
          ZwapTranslation.showEditTextModal!(context, updateWidget, _t.key);
          return;
        }
        throw Exception("Did you forget to add a showEditTextModal handler in [ZwapTranslation]?");
      }

      if (ZwapTranslation.enableEdits && _t.enableEdit) {
        if (_t.useLongPress) {
          _gestureRecognizer.onSecondaryTap = _handleEdit;
        } else {
          _gestureRecognizer.onTap = _handleEdit;
        }
      }

      return TextSpan(
        text: _t.getTranslation(),
        style: textStyle,
        onEnter: !_t.enableEdit
            ? null
            : (_) => ZwapToasts.showInfoToast(
                  _t.useLongPress ? "Right click to edit" : "Click to edit",
                  context: context,
                  duration: const Duration(milliseconds: 1300),
                ),
        recognizer: _gestureRecognizer,
        children: this.children.map((zwapTS) => zwapTS._toInlineSpan(context, updateWidget)).toList(),
      );
    }

    return TextSpan(
      text: text is String ? text as String : text.toString(),
      style: textStyle,
      recognizer: gestureRecognizer,
      children: this.children.map((zwapTS) => zwapTS._toInlineSpan(context, updateWidget)).toList(),
    );
  }
}

/// Gradient test spans supports only the onTap
/// gesture
class ZwapGradientTextSpan extends ZwapTextSpan {
  final List<Color> colors;
  final List<double>? stops;
  final Alignment? begin;
  final Alignment? end;

  final LinearGradient? _gradient;

  final double? forcedHeight;
  final Offset? forcedTranslation;

  ZwapGradientTextSpan({
    required Pattern text,
    required this.colors,
    TextStyle? textStyle,
    List<ZwapTextSpan> children = const [],
    Uri? linkToUri,
    TapGestureRecognizer? gestureRecognizer,
    ZwapLinkTarget linkTarget = ZwapLinkTarget.defaultTarget,
    this.begin,
    this.end,
    this.stops,
    this.forcedHeight,
    this.forcedTranslation,
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
    required Pattern text,
    required this.colors,
    ZwapTextType? textType,
    Uri? linkToUri,
    List<ZwapTextSpan> children = const [],
    TapGestureRecognizer? gestureRecognizer,
    ZwapLinkTarget linkTarget = ZwapLinkTarget.defaultTarget,
    this.begin,
    this.end,
    this.stops,
    this.forcedHeight,
    this.forcedTranslation,
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
    required Pattern text,
    required LinearGradient gradient,
    required TextStyle textStyle,
    List<ZwapTextSpan> children = const [],
    Uri? linkToUri,
    TapGestureRecognizer? gestureRecognizer,
    this.forcedHeight,
    ZwapLinkTarget linkTarget = ZwapLinkTarget.defaultTarget,
    this.forcedTranslation,
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
  InlineSpan _toInlineSpan(BuildContext context, void Function() updateWidget) {
    return WidgetSpan(
      child: GestureDetector(
        onTap: () {
          if (gestureRecognizer != null && gestureRecognizer!.onTap != null) gestureRecognizer!.onTap!();
        },
        child: Transform.translate(
          offset: forcedTranslation ?? Offset.zero,
          child: Container(
            height: forcedHeight,
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
        ),
      ),
    );
  }
}

/// Component to rendering multi text style
///
/// If no style is provided to this widget or to a text spans tree, DefaultTextStyle will be used
class ZwapRichText extends StatefulWidget {
  final TextAlign? textAlign;

  final bool _isSafeText;

  /// Each text with a custom type and custom color and optionally a recognizer
  final Map<String, TupleType<TapGestureRecognizer?, TupleType<ZwapTextType, Color>>> texts;

  final List<ZwapTextSpan> textSpans;

  final TextStyle? style;

  final int? maxLines;

  /// Default to [TextOverflow.ellipsis]
  final TextOverflow textOverflow;

  @Deprecated("Use the ZwapRichText.safeText(...) instead. This will be removed in the future.")
  ZwapRichText({
    Key? key,
    required this.texts,
    this.style,
    this.textAlign,
    this.maxLines,
    this.textOverflow = TextOverflow.clip,
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
    this.maxLines,
    this.textOverflow = TextOverflow.clip,
  })  : this.texts = {},
        this._isSafeText = true,
        super(key: key);

  ZwapRichText.zwapTypografy({
    Key? key,
    required this.textSpans,
    required ZwapTextType textType,
    Color? textColor,
    this.textAlign,
    this.maxLines,
    this.textOverflow = TextOverflow.ellipsis,
  })  : this.texts = {},
        this.style = getTextStyle(textType).copyWith(color: textColor),
        this._isSafeText = true,
        super(key: key);

  @override
  State<ZwapRichText> createState() => _ZwapRichTextState();
}

class _ZwapRichTextState extends State<ZwapRichText> {
  /// It write each text with correct style and correct color
  List<TextSpan> _getTexts() {
    List<TextSpan> finals = [];
    this.widget.texts.forEach((key, TupleType<TapGestureRecognizer?, TupleType<ZwapTextType, Color>> value) {
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

    if (widget._isSafeText)
      children = this.widget.textSpans.map((e) => e._toInlineSpan(context, () => setState(() {}))).toList();
    else
      children = _getTexts();

    if (widget._isSafeText && widget.textSpans.any((t) => t.linkToUri != null))
      return _LinkedMultyStyleText(textSpans: widget.textSpans, textAlign: widget.textAlign);

    return RichText(
      text: TextSpan(
        children: List<InlineSpan>.generate(children.length, (index) => children[index]),
        style: widget.style,
      ),
      textAlign: widget.textAlign ?? TextAlign.start,
      maxLines: widget.maxLines,
      overflow: widget.textOverflow,
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
                children: widget.textSpans.map(
                  (span) {
                    if (span.text is ZwapTranslation) {
                      final TapGestureRecognizer _gestureRecognizer = span.gestureRecognizer ?? TapGestureRecognizer();
                      final ZwapTranslation _t = span.text as ZwapTranslation;

                      void _handleEdit() {
                        if (ZwapTranslation.showEditTextModal != null) {
                          ZwapTranslation.showEditTextModal!(context, () => setState(() {}), _t.key);
                          return;
                        }
                        throw Exception("Did you forget to add a showEditTextModal handler in [ZwapTranslation]?");
                      }

                      if (_t.enableEdit) {
                        if (_t.useLongPress) {
                          _gestureRecognizer.onSecondaryTap = _handleEdit;
                        } else {
                          _gestureRecognizer.onTap = _handleEdit;
                        }
                      }

                      return TextSpan(
                        text: _t.getTranslation(),
                        mouseCursor: span.linkToUri != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
                        style: span.textStyle ?? widget.style,
                        recognizer: _gestureRecognizer,
                        onEnter: (_) {
                          if (ZwapTranslation.enableEdits && _t.enableEdit) {
                            ZwapToasts.showInfoToast(
                              _t.useLongPress ? "Right click to edit" : "Click to edit",
                              context: context,
                              duration: const Duration(milliseconds: 1300),
                            );
                          }

                          setState(() {
                            currentUri = span.linkToUri;
                            currentLinkTarget = _getLinkTarget(span.linkTarget);
                          });
                        },
                      );
                    }

                    return TextSpan(
                      text: span.text is String ? span.text as String : span.text.toString(),
                      mouseCursor: span.linkToUri != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
                      style: span.textStyle ?? widget.style,
                      recognizer: span.gestureRecognizer,
                      onEnter: (_) {
                        setState(() {
                          currentUri = span.linkToUri;
                          currentLinkTarget = _getLinkTarget(span.linkTarget);
                        });
                      },
                    );
                  },
                ).toList()),
            textAlign: widget.textAlign ?? TextAlign.start,
          ),
        );
      },
    );
  }
}
