import 'package:flutter/material.dart';
import 'package:zwap_design_system/molecules/longText/zwapLongText.dart';
import 'package:zwap_design_system/organism/organism.dart';

class ZwapTextSection extends StatelessWidget{

  final String title;

  final String corpusText;

  final int maxChars;

  final String readMoreText;

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