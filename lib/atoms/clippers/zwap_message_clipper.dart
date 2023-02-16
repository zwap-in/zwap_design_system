import 'package:flutter/widgets.dart';

enum DecorationDirection { top, right, bottom, left }

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
            decorationSize ?? ([DecorationDirection.top, DecorationDirection.bottom].contains(direction) ? Size(20, 12) : Size(12, 20));

  @override
  Path getClip(Size size) {
    late final _decorationOffset;
    switch (direction) {
      case DecorationDirection.top:
      case DecorationDirection.bottom:
        _decorationOffset = (size.width - 2 * radius - decorationSize.width) / 2 + (decorationOffset ?? 0); //TODO: offset
        break;
      case DecorationDirection.right:
      case DecorationDirection.left:
        _decorationOffset = (size.height - 2 * radius - decorationSize.height) / 2 + (decorationOffset ?? 0); //TODO: offset
        break;
    }

    final Radius _borderRadius = Radius.circular(radius);

    switch (direction) {
      case DecorationDirection.top:
        return Path()
          ..moveTo(radius, decorationSize.height)
          ..lineTo(radius + _decorationOffset - decorationSize.width / 2, decorationSize.height)
          ..lineTo(radius + _decorationOffset - 3, 3)
          ..arcToPoint(Offset(radius + _decorationOffset + 3, 3), radius: Radius.circular(4))
          ..lineTo(radius + _decorationOffset + decorationSize.width / 2, decorationSize.height)
          ..lineTo(size.width - radius, decorationSize.height)
          ..arcToPoint(Offset(size.width, decorationSize.height + radius), radius: _borderRadius)
          ..lineTo(size.width, size.height - radius)
          ..arcToPoint(Offset(size.width - radius, size.height), radius: _borderRadius)
          ..lineTo(radius, size.height)
          ..arcToPoint(Offset(0, size.height - radius), radius: _borderRadius)
          ..lineTo(0, radius + decorationSize.height)
          ..arcToPoint(Offset(radius, decorationSize.height), radius: _borderRadius);
      case DecorationDirection.right:
        return Path()
          ..moveTo(radius, 0)
          ..lineTo(size.width - radius - decorationSize.width, 0)
          ..arcToPoint(Offset(size.width - decorationSize.width, radius), radius: _borderRadius)
          ..lineTo(size.width - decorationSize.width, radius + _decorationOffset)
          ..lineTo(size.width - 3, radius + _decorationOffset + decorationSize.height / 2 - 3)
          ..arcToPoint(Offset(size.width - 3, radius + _decorationOffset + decorationSize.height / 2 + 3), radius: Radius.circular(4))
          ..lineTo(size.width - decorationSize.width, radius + _decorationOffset + decorationSize.height)
          ..lineTo(size.width - decorationSize.width, size.height - radius)
          ..arcToPoint(Offset(size.width - radius - decorationSize.width, size.height), radius: _borderRadius)
          ..lineTo(radius, size.height)
          ..arcToPoint(Offset(0, size.height - radius), radius: _borderRadius)
          ..lineTo(0, radius)
          ..arcToPoint(Offset(radius, 0), radius: _borderRadius);
      case DecorationDirection.bottom:
        return Path()
          ..moveTo(radius, 0)
          ..lineTo(size.width - radius, 0)
          ..arcToPoint(Offset(size.width, radius), radius: _borderRadius)
          ..lineTo(size.width, size.height - radius - decorationSize.height)
          ..arcToPoint(Offset(size.width - radius, size.height - decorationSize.height), radius: _borderRadius)
          ..lineTo(radius + _decorationOffset + decorationSize.width, size.height - decorationSize.height)
          ..lineTo(radius + _decorationOffset + decorationSize.width / 2 + 3, size.height - 3)
          ..arcToPoint(Offset(radius + _decorationOffset + decorationSize.width / 2 - 3, size.height - 3), radius: Radius.circular(4))
          ..lineTo(radius + _decorationOffset + decorationSize.width / 2 - 3, size.height - 3)
          ..lineTo(radius + _decorationOffset, size.height - decorationSize.height)
          ..lineTo(radius, size.height - decorationSize.height)
          ..arcToPoint(Offset(0, size.height - radius - decorationSize.height), radius: _borderRadius)
          ..lineTo(0, radius)
          ..arcToPoint(Offset(radius, 0), radius: _borderRadius);
      case DecorationDirection.left:
        return Path()
          ..moveTo(radius + decorationSize.width, 0)
          ..lineTo(size.width - radius, 0)
          ..arcToPoint(Offset(size.width, radius), radius: _borderRadius)
          ..lineTo(size.width, size.height - radius)
          ..arcToPoint(Offset(size.width - radius, size.height), radius: _borderRadius)
          ..lineTo(radius + decorationSize.width, size.height)
          ..arcToPoint(Offset(decorationSize.width, size.height - radius), radius: _borderRadius)
          ..lineTo(decorationSize.width, radius + decorationSize.height + _decorationOffset)
          ..lineTo(3, radius + decorationSize.height / 2 + 3 + _decorationOffset)
          ..arcToPoint(Offset(3, radius + decorationSize.height / 2 - 3 + _decorationOffset), radius: Radius.circular(4))
          ..lineTo(decorationSize.width, radius + _decorationOffset)
          ..lineTo(decorationSize.width, radius)
          ..arcToPoint(Offset(decorationSize.width + radius, 0), radius: _borderRadius);
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> path) => false;
}
