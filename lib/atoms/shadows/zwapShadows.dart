/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// Custom box shadow with custom properties and custom painting
class CustomBoxShadow extends BoxShadow {

  /// Custom blur style
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.inner,
    double spreadRadius = 4
  }) : super(color: color, offset: offset, blurRadius: blurRadius, spreadRadius: 4);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows)
        result.maskFilter = null;
      return true;
    }());
    return result;
  }
}

/// Constants class to rendering different kind of box shadows
class ZwapShadow {
  /// None box shadow level
  static BoxShadow? get levelZero => null;

  /// The first level of shadow
  static BoxShadow get levelOne => BoxShadow(
      color: Color.fromRGBO(139, 149, 170, 0.20),
      blurRadius: 11,
      spreadRadius: 4,
      offset: Offset(0, 4));

  /// The second level of shadow
  static BoxShadow get levelTwo => CustomBoxShadow(
      color: Color.fromRGBO(139, 149, 170, 0.20),
      blurRadius: 20,
      spreadRadius: 0,
      offset: Offset(0, 5),
  );

  /// The third level of shadow
  static BoxShadow get levelThree => BoxShadow(
      color: Color.fromRGBO(139, 149, 170, 0.20),
      blurRadius: 128,
      spreadRadius: 4,
      offset: Offset(0, 24)
  );
}
