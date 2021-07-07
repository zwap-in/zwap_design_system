/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// A custom screen to notify that this current device is not supported at the moment
class NotSupportedScreen extends StatelessWidget {

  /// The image path to display the brand icon inside this screen
  final String imagePath;

  NotSupportedScreen({Key? key,
    required this.imagePath
  }): super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: VerticalScroll(
            childComponent: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomAsset(
                  assetPathUrl: this.imagePath,
                  isInternal: true,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  child: BaseText(
                    texts: [Utils.translatedText("notSupportedScreenTitle")],
                    baseTextsType: [BaseTextType.title],
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