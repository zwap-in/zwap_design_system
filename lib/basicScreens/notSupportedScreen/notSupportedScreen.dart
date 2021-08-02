/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// A custom screen to notify that this current device is not supported at the moment
class NotSupportedScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ZwapVerticalScroll(
            childComponent: Column(
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
                    texts: [Utils.translatedText("notSupportedScreenTitle")],
                    baseTextsType: [ZwapTextType.title],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}