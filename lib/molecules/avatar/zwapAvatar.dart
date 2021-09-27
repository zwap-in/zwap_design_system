/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// Component to rendering an avatar image asset with standard style
class ZwapAvatar extends StatelessWidget {

  /// Is this icon an external asset? Default = false
  final bool isExternal;

  /// Icon size inside this zwap avatar
  final double size;

  /// The image path for this avatar component
  final String? imagePath;

  ZwapAvatar({Key? key,
    this.isExternal = false,
    this.size = 38,
    this.imagePath,
  }) : super(key: key);

  /// It gets the image from external or local file
  dynamic _getImage() {
    return this.isExternal && this.imagePath != null
        ? NetworkImage(this.imagePath!)
        : AssetImage(this.imagePath != null ? this.imagePath! : "assets/images/placeholders/avatar.png",
        package: "zwap_design_system");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: this.size,
          backgroundColor: Color(0xFFF1F1F1),
          child: CircleAvatar(
            radius: this.size,
            backgroundImage: this._getImage(),
          ),
        ),
      ],
    );
  }
}
