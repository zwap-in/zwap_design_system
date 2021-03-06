import 'package:flutter/widgets.dart';

enum DecorationDirection { top, right, botttom, left }

/// Clip as rounded border rectangle with an "arrow" decoration
class ZwapMessageClipper extends CustomClipper<Path> {
  final double radius;
  late final Size decorationSize;
  final DecorationDirection direction;

  /// With decoration offset = 0 the decoration is in the middle
  double? decorationOffset;

  ZwapMessageClipper({
    this.radius = 14,
    Size? decorationSize,
    this.direction = DecorationDirection.top,
    this.decorationOffset,
  }) : this.decorationSize =
            decorationSize ?? ([DecorationDirection.top, DecorationDirection.botttom].contains(direction) ? Size(20, 12) : Size(12, 20));

  @override
  Path getClip(Size size) {
    final _decorationOffset = (size.width - 2 * radius) / 2 + (decorationOffset ?? 0); //TODO: offset

    switch (direction) {
      case DecorationDirection.top:
        return Path()
          ..moveTo(radius, decorationSize.height)
          ..lineTo(radius + _decorationOffset - decorationSize.width / 2, decorationSize.height)
          ..lineTo(radius + _decorationOffset - 3, 3)
          ..arcToPoint(Offset(radius + _decorationOffset + 3, 3), radius: Radius.circular(4))
          ..lineTo(radius + _decorationOffset + decorationSize.width / 2, decorationSize.height)
          ..lineTo(size.width - radius, decorationSize.height)
          ..arcToPoint(Offset(size.width, decorationSize.height + radius), radius: Radius.circular(radius))
          ..lineTo(size.width, size.height - radius)
          ..arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius))
          ..lineTo(radius, size.height)
          ..arcToPoint(Offset(0, size.height - radius), radius: Radius.circular(radius))
          ..lineTo(0, radius + decorationSize.height)
          ..arcToPoint(Offset(radius, decorationSize.height), radius: Radius.circular(radius));
      case DecorationDirection.right:
        throw UnimplementedError();
      /* return Path()
          ..moveTo(radius, 0)
          ..lineTo(size.width - radius - decorationSize.width, 0)
          ..arcToPoint(Offset(size.width - decorationSize.width, radius), radius: Radius.circular(radius))
          ..lineTo(size.width - decorationSize.width, size.height - radius)
          ..arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius))
          ..lineTo(radius + decorationSize.width, size.height)
          ..arcToPoint(Offset(decorationSize.width, size.height - radius), radius: Radius.circular(radius))
          ..lineTo(decorationSize.width, radius + decorationSize.height + _decorationOffset)
          ..lineTo(3, radius + decorationSize.height / 2 + 3 + _decorationOffset)
          ..arcToPoint(Offset(3, radius + decorationSize.height / 2 - 3 + _decorationOffset), radius: Radius.circular(4))
          ..lineTo(decorationSize.width, radius + _decorationOffset)
          ..lineTo(decorationSize.width, radius)
          ..arcToPoint(Offset(decorationSize.width + radius, 0), radius: Radius.circular(radius)); */
      case DecorationDirection.botttom:
        return Path()
          ..moveTo(radius, 0)
          ..lineTo(size.width - radius, 0)
          ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius))
          ..lineTo(size.width, size.height - radius - decorationSize.height)
          ..arcToPoint(Offset(size.width - radius, size.height - decorationSize.height), radius: Radius.circular(radius))
          ..lineTo(radius + _decorationOffset + decorationSize.width, size.height - decorationSize.height)
          ..lineTo(radius + _decorationOffset + decorationSize.width / 2 + 3, size.height - 3)
          ..arcToPoint(Offset(radius + _decorationOffset + decorationSize.width / 2 - 3, size.height - 3), radius: Radius.circular(4))
          ..lineTo(radius + _decorationOffset + decorationSize.width / 2 - 3, size.height - 3)
          ..lineTo(radius + _decorationOffset, size.height - decorationSize.height)
          ..lineTo(radius, size.height - decorationSize.height)
          ..arcToPoint(Offset(0, size.height - radius - decorationSize.height), radius: Radius.circular(radius))
          ..lineTo(0, radius)
          ..arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
      case DecorationDirection.left:
        return Path()
          ..moveTo(radius + decorationSize.width, 0)
          ..lineTo(size.width - radius, 0)
          ..arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius))
          ..lineTo(size.width, size.height - radius)
          ..arcToPoint(Offset(size.width - radius, size.height), radius: Radius.circular(radius))
          ..lineTo(radius + decorationSize.width, size.height)
          ..arcToPoint(Offset(decorationSize.width, size.height - radius), radius: Radius.circular(radius))
          ..lineTo(decorationSize.width, radius + decorationSize.height + _decorationOffset)
          ..lineTo(3, radius + decorationSize.height / 2 + 3 + _decorationOffset)
          ..arcToPoint(Offset(3, radius + decorationSize.height / 2 - 3 + _decorationOffset), radius: Radius.circular(4))
          ..lineTo(decorationSize.width, radius + _decorationOffset)
          ..lineTo(decorationSize.width, radius)
          ..arcToPoint(Offset(decorationSize.width + radius, 0), radius: Radius.circular(radius));
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> path) => false;
}
