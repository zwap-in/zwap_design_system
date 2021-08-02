/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The splash screen with custom icon and loader
class SplashScreen extends StatelessWidget {

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
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}