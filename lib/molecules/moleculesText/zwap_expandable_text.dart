import 'package:flutter/cupertino.dart';
import 'package:zwap_design_system/atoms/atoms.dart';

bool willTextExceed(String text, int maxLines, double maxWidth, TextStyle style, {TextAlign textAlign = TextAlign.left}) {
  var span = TextSpan(
    text: text,
    style: style,
  );

  var tp = TextPainter(
    maxLines: maxLines,
    textAlign: textAlign,
    textDirection: TextDirection.ltr,
    text: span,
  );

  tp.layout(maxWidth: maxWidth);

  return tp.didExceedMaxLines;
}

class ZwapExpandableText extends StatefulWidget {
  final String text;
  final ZwapTextType? textType;
  final Color? textColor;

  final TextStyle? customStyle;

  final int maxClosedLines;

  /// Possible keys:
  /// * see_less
  /// * see_more
  final String Function(String) translateKey;

  final TextAlign textAlign;

  ZwapExpandableText({
    required this.text,
    required this.translateKey,
    required this.maxClosedLines,
    required this.textColor,
    required this.textType,
    this.textAlign = TextAlign.center,
    Key? key,
  })  : this.customStyle = null,
        super(key: key);

  ZwapExpandableText.customStyle({
    required this.text,
    required this.translateKey,
    required this.maxClosedLines,
    required this.customStyle,
    this.textAlign = TextAlign.center,
    Key? key,
  })  : this.textColor = null,
        this.textType = null,
        super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ZwapExpandableText> {
  bool _showAllText = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.topCenter,
      curve: Curves.ease,
      child: LayoutBuilder(
        builder: (_, size) {
          final bool _willTextExceed = willTextExceed(
            widget.text,
            widget.maxClosedLines,
            size.maxWidth,
            widget.customStyle ?? getTextStyle(widget.textType!),
            textAlign: TextAlign.justify,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _showAllText
                  ? widget.customStyle == null
                      ? ZwapText(
                          text: widget.text,
                          zwapTextType: widget.textType!,
                          textColor: widget.textColor!,
                          textOverflow: TextOverflow.ellipsis,
                          textAlign: widget.textAlign,
                          maxLines: 100,
                        )
                      : ZwapText.customStyle(
                          text: widget.text,
                          customTextStyle: widget.customStyle!,
                          textOverflow: TextOverflow.ellipsis,
                          textAlign: widget.textAlign,
                          maxLines: 100,
                        )
                  : widget.customStyle == null
                      ? ZwapText(
                          text: widget.text,
                          zwapTextType: widget.textType!,
                          textColor: widget.textColor!,
                          textOverflow: TextOverflow.ellipsis,
                          textAlign: widget.textAlign,
                          maxLines: widget.maxClosedLines,
                        )
                      : ZwapText.customStyle(
                          text: widget.text,
                          customTextStyle: widget.customStyle!,
                          textOverflow: TextOverflow.ellipsis,
                          textAlign: widget.textAlign,
                          maxLines: widget.maxClosedLines,
                        ),
              if (!_showAllText && _willTextExceed)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _showAllText = true;
                    }),
                    child: ZwapText(
                      text: widget.translateKey('see_more'),
                      zwapTextType: ZwapTextType.smallBodyMedium,
                      textColor: ZwapColors.neutral700,
                    ),
                  ),
                )
              else if (_showAllText && _willTextExceed)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _showAllText = false;
                    }),
                    child: ZwapText(
                      text: widget.translateKey('see_less'),
                      zwapTextType: ZwapTextType.smallBodyMedium,
                      textColor: ZwapColors.neutral700,
                    ),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
