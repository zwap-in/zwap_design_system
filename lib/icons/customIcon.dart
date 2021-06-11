/// IMPORTING THE THIRD PARTY LIBRARIES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

/// This is a component to render a custom icon with a custom asset from local or network
class CustomIcon extends StatelessWidget{

  /// The asset path of the custom image displayed in the icon
  final String assetPathUrl;

  /// The custom alignment of this icon. Default = Alignment.center
  final Alignment alignment;

  /// The padding dimensions size of this custom icon. Default = const EdgeInsets.all(20)
  final EdgeInsets paddingContainer;

  /// Is the icon an internal asset?. Default = false
  final bool isInternal;

  /// The final width of the image inside this custom icon. Default = 52
  final double imageWidth;

  /// The final height of the image inside this custom icon. Default = 52
  final double imageHeight;

  /// The bool flag to check if an svg asset is a string tag or a real asset. Default = true
  final bool isAsset;

  CustomIcon({Key? key,
    required this.assetPathUrl,
    this.alignment = Alignment.center,
    this.isInternal = false,
    this.paddingContainer = const EdgeInsets.all(0),
    this.imageHeight = 52,
    this.imageWidth = 52,
    this.isAsset = true
  }) : super(key: key);

  /// it returns a normal image asset from local storage or local network
  Image _normalImageAsset(){
    return this.isInternal ? Image.asset(this.assetPathUrl,
      width: this.imageWidth,
      height: this.imageHeight,
    ) : Image.network(
      this.assetPathUrl,
      width: this.imageWidth,
      height: this.imageHeight,);
  }

  /// It returns a svg asset from local storage, network or string tag
  SvgPicture _svgImageAsset(){
    return this.isInternal ? (
      this.isAsset ? SvgPicture.asset(
        this.assetPathUrl,
        width: this.imageHeight,
        height: this.imageHeight,
      ) : SvgPicture.string(
        this.assetPathUrl,
        width: this.imageHeight,
        height: this.imageHeight,
      )
    ) : SvgPicture.network(
      this.assetPathUrl,
      width: this.imageHeight,
      height: this.imageHeight,);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.paddingContainer,
      child: Container(
          alignment: this.alignment,
          child: this.assetPathUrl.split(".").last != "png" ? this._svgImageAsset() : this._normalImageAsset()
      ),
    );
  }

}