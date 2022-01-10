/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/molecules/moleculesText/smallTitle/zwapSmallTitle.dart';
import 'package:zwap_design_system/molecules/moleculesText/corpusText/zwapCorpusText.dart';
import 'package:zwap_design_system/molecules/moleculesText/longText/zwapLongText.dart';

/// Text section with title and text inside
class ZwapTextSection extends StatelessWidget{

  /// The title for this text section
  final String title;

  /// The corpus text for this text section
  final String corpusText;

  /// The max chars to crop or not the long text
  final int maxChars;

  /// The read more text
  final String readMoreText;

  /// The read less text
  final String readLessText;

  ZwapTextSection({Key? key,
    required this.title,
    required this.corpusText,
    this.maxChars = 50,
    this.readMoreText = "Read more",
    this.readLessText = "Read less"
  }): super(key: key);

  Widget build(BuildContext context){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ZwapSmallTitle(title: this.title,),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: this.maxChars == -1 ? ZwapCorpusText(text: this.corpusText) :ZwapLongText(text: this.corpusText, readMoreText: readMoreText, readLessText: readLessText),
        )
      ],
    );
  }


}