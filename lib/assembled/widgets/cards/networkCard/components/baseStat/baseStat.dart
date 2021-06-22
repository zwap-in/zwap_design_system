import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

class BaseStat extends StatelessWidget{

  final String title;

  final String numberStat;

  final String graphImage;

  BaseStat({Key? key,
    required this.title,
    required this.numberStat,
    required this.graphImage
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: CustomIcon(
                callBackPressedFunction: () {  },
                icon: Icons.photo_camera_front,
              ),
              flex: 0,
            ),
            Flexible(
                child: BaseText(
                  texts: [this.title],
                  baseTextsType: [BaseTextType.normal],
                )
            )
          ],
        ),
        Row(
          children: [
            Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  child: BaseText(
                    texts: [this.numberStat],
                    baseTextsType: [BaseTextType.normal],
                  ),
                ),
              flex: 0,
            ),
            Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: CustomAsset(
                    assetPathUrl: this.graphImage,
                    isInternal: true,
                  ),
                ),
            )
          ],
        ),
      ],
    );
  }



}