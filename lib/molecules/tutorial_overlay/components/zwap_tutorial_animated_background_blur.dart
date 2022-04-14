import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';

class ZwapTutorialAnimatedBackgroundBlur extends StatefulWidget {
  final double sigma;
  final Duration duration;
  final Color? color;

  const ZwapTutorialAnimatedBackgroundBlur({
    required this.sigma,
    required this.duration,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapTutorialAnimatedBackgroundBlur> createState() => _ZwapTutorialAnimatedBackgroundBlurState();
}

class _ZwapTutorialAnimatedBackgroundBlurState extends State<ZwapTutorialAnimatedBackgroundBlur> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final double _sigma = max(0.001, _animationController.value * widget.sigma);
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _sigma, sigmaY: _sigma),
          child: child,
        );
      },
      child: Container(
        color: widget.color ?? ZwapColors.shades100.withOpacity(0.25),
      ),
    );
  }
}
