/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/icons/customIcon.dart';

/// Widget to display an avatar image inside a circle
class AvatarCircle extends StatelessWidget{

  /// The image asset for this avatar widget circle
  final String imagePath;

  /// Is this icon an internal asset?. Default = false
  final bool isInternalAsset;

  /// Is this icon an asset or a string tag. Default = true
  final bool isAsset;

  /// The custom background color of this avatar card. Default = Colors.transparent
  final Color backgroundColor;

  /// The radius image. Default = 50.0
  final double radiusImage;

  AvatarCircle({Key? key,
    required this.imagePath,
    this.isInternalAsset = false,
    this.isAsset = true,
    this.backgroundColor = Colors.transparent,
    this.radiusImage = 50.0
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: this.backgroundColor,
        radius: this.radiusImage,
        child: CustomIcon(
          assetPathUrl: this.imagePath,
          isAsset: this.isAsset,
          isInternal: this.isInternalAsset,
        )
    );
  }

}