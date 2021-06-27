import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

class NotFound extends StatelessWidget{

  final String imagePath;

  NotFound({Key? key,
    required this.imagePath
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomAsset(
                assetPathUrl: this.imagePath
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: BaseText(
                texts: [LocalizationClass.of(context).dynamicValue("notFoundTitle")],
                baseTextsType: [BaseTextType.normalBold],
                textAlignment: Alignment.center,
              ),
            )
          ],
        ),
      ),
    );
  }


}