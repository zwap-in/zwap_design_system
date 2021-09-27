/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// Component to rendering the logo of Zwap
class ZwapLogo extends StatelessWidget{

  /// The optionally width
  final double? width;

  /// The optionally height
  final double? height;

  ZwapLogo({Key? key,
    this.width,
    this.height
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage("assets/images/brand/icon.png", package: "zwap_design_system"),
      width: this.width ?? 50,
      height: this.height ?? 50,
    );
  }


}