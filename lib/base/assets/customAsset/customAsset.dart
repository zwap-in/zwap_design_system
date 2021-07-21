/// IMPORTING THE THIRD PARTY LIBRARIES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This is a component to render a custom icon with a custom asset from local or network
class CustomAsset extends StatelessWidget{

  /// The asset path of the custom image displayed in the icon
  final String assetPathUrl;

  /// Is the icon an internal asset
  final bool isInternal;

  /// The final width of the image inside this custom icon. Default = 52
  final double imageWidth;

  /// The final height of the image inside this custom icon. Default = 52
  final double imageHeight;

  CustomAsset({Key? key,
    required this.assetPathUrl,
    this.isInternal = false,
    this.imageHeight = 52,
    this.imageWidth = 52,
  }) : super(key: key);

  /// it returns a normal image asset from local storage or local network
  Image _normalImageAsset(){
    return this.isInternal ?
    Image.asset(this.assetPathUrl,
      width: this.imageWidth,
      height: this.imageHeight,
    ) : Image.network(
      this.assetPathUrl,
      width: this.imageWidth,
      height: this.imageHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return this._normalImageAsset();
  }

}