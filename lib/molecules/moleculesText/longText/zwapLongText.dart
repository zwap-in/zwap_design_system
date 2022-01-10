/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

/// Custom component to crop long text with a read more option
class ZwapLongText extends StatefulWidget {

  /// The text inside this component
  final String text;

  /// The text to read more text
  final String readMoreText;

  /// The text to read less text
  final String readLessText;

  /// The max chars to display
  final int maxChars;

  ZwapLongText({
    Key? key,
    required this.text,
    required this.readMoreText,
    required this.readLessText,
    this.maxChars = 50,
  }) : super(key: key);

  @override
  _ZwapLongTextState createState() => new _ZwapLongTextState();
}

/// The state to handle this component
class _ZwapLongTextState extends State<ZwapLongText> {
  /// The first half of the text
  late String firstHalf;

  /// The second half of the text
  late String secondHalf;

  /// Is the text cropped
  bool flag = true;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > widget.maxChars) {
      firstHalf = widget.text.substring(0, widget.maxChars);
      secondHalf = widget.text.substring(widget.maxChars, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  void didUpdateWidget(ZwapLongText oldWidget){
    super.didUpdateWidget(oldWidget);
    if (widget.text.length > widget.maxChars) {
      firstHalf = widget.text.substring(0, widget.maxChars);
      secondHalf = widget.text.substring(widget.maxChars, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  /// It gets the text component to compress it and decompress it
  Widget _getText() {
    TapGestureRecognizer recognizer = TapGestureRecognizer();
    recognizer.onTap = () => {
      setState(() {
        flag = !flag;
      })
    };
    return ZwapTextMultiStyle(
      texts: {
        flag ? (firstHalf + "...") : (firstHalf + secondHalf): TupleType(a: null, b: TupleType(a: ZwapTextType.bodyRegular, b: ZwapColors.neutral600)),
        flag ? " ${widget.readMoreText}" : " ${widget.readLessText}": TupleType(a: recognizer, b: TupleType(a: ZwapTextType.bodySemiBold, b: ZwapColors.neutral700))
      },
    );
  }

  /// It gets the normal text widget
  Widget normalText(){
    return ZwapText(
      text: firstHalf,
      textColor: ZwapColors.neutral600,
      zwapTextType: ZwapTextType.bodyRegular,
    );
  }

  @override
  Widget build(BuildContext context) {
    return secondHalf.isEmpty ? this.normalText()  : this._getText();
  }
}
