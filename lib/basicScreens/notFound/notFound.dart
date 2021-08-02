/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Not found content default screen
class NotFound extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZwapAsset(
              assetPathUrl: "assets/images/brand.png",
              isInternal: true,
            ),
            Padding(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              child: ZwapText(
                texts: [Utils.translatedText("notFoundTitle")],
                baseTextsType: [ZwapTextType.normalBold],
                textAlignment: Alignment.center,
              ),
            )
          ],
        ),
      ),
    );
  }


}