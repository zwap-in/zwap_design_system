/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/link.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import '../../typography/zwapTypography.dart';

import '../base/zwapText.dart';

enum ZwapLinkTarget {
  blank,
  defaultTarget,
  self,
}

class ZwapTextSpan {
  final String text;

  ///! if one of the text spans has links this will be ignored
  final TapGestureRecognizer? gestureRecognizer;

  final TextStyle textStyle;

  /// if != null link widget will be added on this textspan only
  final Uri? linkToUri;

  /// Used only if linkToUri != null
  final ZwapLinkTarget linkTarget;

  ZwapTextSpan({
    required this.text,
    required this.textStyle,
    this.linkToUri,
    this.gestureRecognizer,
    this.linkTarget = ZwapLinkTarget.defaultTarget,
  });

  TextSpan toTextSpan() => TextSpan(text: text, style: textStyle, recognizer: gestureRecognizer);
}

/// Component to rendering multi text style
class ZwapTextMultiStyle extends StatelessWidget {
  final bool _isCustomStyle;

  /// Each text with a custom type and custom color and optionally a recognizer
  final Map<String, TupleType<TapGestureRecognizer?, TupleType<ZwapTextType, Color>>> texts;

  final List<ZwapTextSpan> textsWithCustomStyles;

  final TextAlign? textAlign;

  ZwapTextMultiStyle({
    Key? key,
    required this.texts,
    this.textAlign,
  })  : this.textsWithCustomStyles = [],
        this._isCustomStyle = false,
        super(key: key);

  ZwapTextMultiStyle.customStyles({
    Key? key,
    required this.textsWithCustomStyles,
    this.textAlign,
  })  : this.texts = {},
        this._isCustomStyle = true,
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
    late List<TextSpan> children;

    if (_isCustomStyle)
      children = this.textsWithCustomStyles.map((e) => e.toTextSpan()).toList();
    else
      children = _getTexts();

    if (_isCustomStyle && textsWithCustomStyles.any((t) => t.linkToUri != null))
      return _LinkedMultyStyleText(textSpans: textsWithCustomStyles, textAlign: textAlign);

    return RichText(
      text: TextSpan(children: List<TextSpan>.generate(children.length, (index) => children[index])),
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}

class _LinkedMultyStyleText extends StatefulWidget {
  final List<ZwapTextSpan> textSpans;
  final TextAlign? textAlign;

  const _LinkedMultyStyleText({required this.textSpans, this.textAlign, Key? key}) : super(key: key);

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
                children: widget.textSpans
                    .map(
                      (span) => TextSpan(
                        text: span.text,
                        mouseCursor: span.linkToUri != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
                        style: span.textStyle,
                        onEnter: (_) {
                          print(followLink);
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
