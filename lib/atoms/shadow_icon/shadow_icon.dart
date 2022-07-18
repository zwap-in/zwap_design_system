import 'package:flutter/material.dart';

/// Basically two rounded container with different colors
/// and a icon (ie a widget) inside
class ZwapShadowIcon extends StatelessWidget {
  final Color ligthColor;
  final Color backgoundColor;
  final Widget child;
  final double size;

  /// The ratio between the size of the small circle
  /// and the second one.
  ///
  /// Default to 0.7183098
  final double ratio;

  const ZwapShadowIcon({
    required this.backgoundColor,
    required this.ligthColor,
    required this.child,
    this.ratio = 0.7183098,
    this.size = 71,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Color _lightBgColor;
    late final Color _bgColor;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: ligthColor,
        borderRadius: BorderRadius.circular(78),
      ),
      child: Center(
        child: Container(
          height: size * ratio,
          width: size * ratio,
          decoration: BoxDecoration(
            color: backgoundColor,
            borderRadius: BorderRadius.circular(51),
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
