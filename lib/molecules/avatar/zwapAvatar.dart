/// IMPORTING THIRD PARTY PACKAGES
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/atoms/imageShape/zwapImageShape.dart';

/// Component to rendering an avatar image asset with standard style
class ZwapAvatar extends StatelessWidget {

  /// The image widget for the avatar pic
  final Image avatarImage;

  /// Icon size inside this zwap avatar
  final double size;

  final bool hasCustomShape;

  ZwapAvatar({Key? key,
    required this.avatarImage,
    this.size = 38,
    this.hasCustomShape = true,

  }) : super(key: key);

  Color get randomColor {
    List<Color> random = [
      ZwapColors.success200,
      ZwapColors.error200,
      ZwapColors.secondary200,
      ZwapColors.primary100,
    ];
    Random intRandom = Random();
    return random[intRandom.nextInt(4)];
  }


  Widget customShape(){
    return ClipPath(
      clipper: ZwapAvatarImageClipper(factor: 2),
      child: Container(
        height: this.size,
        width: this.size,
        child: this.avatarImage,
        decoration: BoxDecoration(
          color: this.randomColor
        ),
      ),
    );
  }

  Widget normalShape(){
    return Column(
      children: [
        CircleAvatar(
          radius: this.size,
          backgroundColor: Color(0xFFF1F1F1),
          child: CircleAvatar(
            radius: this.size,
            backgroundImage: this.avatarImage.image,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return this.hasCustomShape ? this.customShape() : this.normalShape();
  }
}
