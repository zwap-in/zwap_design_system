import 'package:flutter/material.dart';

class ZwapAvatarImageClipper extends CustomClipper<Path> {
  final double factor;
  final double radius;

  ZwapAvatarImageClipper({this.factor = 4, this.radius = 14});

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width - radius, 0)
      ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius))
      ..lineTo(size.width - factor, size.height - radius)
      ..arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius))
      ..lineTo(radius, size.height)
      ..arcToPoint(Offset(factor, size.height - radius), radius: Radius.circular(radius))
      ..lineTo(0, radius)
      ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
