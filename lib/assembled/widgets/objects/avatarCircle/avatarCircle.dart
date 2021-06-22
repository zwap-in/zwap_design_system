/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Widget to display an avatar image inside a circle
class AvatarCircle extends StatelessWidget{

  /// The image asset for this avatar widget circle
  final String imagePath;

  AvatarCircle({Key? key,
    required this.imagePath,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      new ClipRRect(
        borderRadius: new BorderRadius.circular(80.0),
        child: CustomAsset(
          imageHeight: 100,
          imageWidth: 100,
          assetPathUrl: this.imagePath != "" ? this.imagePath : "assets/images/placeholders/boyAvatar.png",
          isInternal: this.imagePath == "" ,
        )
    );
  }

}