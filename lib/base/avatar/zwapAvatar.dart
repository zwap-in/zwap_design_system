/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';
import 'package:zwap_design_system/base/media/media.dart';

/// Widget to display an avatar image inside a circle
class ZwapAvatar extends StatelessWidget{

  /// The image asset for this avatar widget circle
  final String? imagePath;

  /// Check if this image is internal or not
  final bool? isInternal;

  /// The image uploaded
  final XFile? fileImage;

  ZwapAvatar({Key? key,
    this.imagePath,
    this.isInternal,
    this.fileImage
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ClipRRect(
        borderRadius: new BorderRadius.circular(80.0),
        child: Container(
          decoration: BoxDecoration(
            color: DesignColors.blueHeader
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            child: ZwapAsset(
              imageHeight: 100,
              imageWidth: 100,
              imageFile: this.fileImage,
              assetPathUrl: this.imagePath  != null && this.imagePath != "" ? this.imagePath : "assets/images/placeholders/boy.png",
              isInternal: this.isInternal,
            ),
          ),
        )
    );
  }

}