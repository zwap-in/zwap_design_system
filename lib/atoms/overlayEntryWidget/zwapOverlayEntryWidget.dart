import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ZwapOverlayEntryChild extends StatelessWidget {
  final Widget child;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;

  ZwapOverlayEntryChild({
    Key? key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: GestureDetector(behavior: HitTestBehavior.opaque, child: child, onTap: () {}),
    );
  }
}

class ZwapOverlayEntryWidget extends StatelessWidget {
  /// If true widget will close automatically
  /// on clicking outside child
  ///
  /// Default to true
  final bool autoClose;
  final ZwapOverlayEntryChild child;

  final OverlayEntry? entity;

  final Function()? onAutoClose;

  const ZwapOverlayEntryWidget({
    Key? key,
    this.autoClose = true,
    required this.child,
    required this.entity,
    this.onAutoClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!autoClose) return child;

    void _close() {
      entity?.remove();
      if (onAutoClose != null) onAutoClose!();
    }

    return Positioned(
      top: 0,
      left: 0,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: GestureDetector(
        onTap: () => _close(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Stack(
            children: [child],
          ),
        ),
      ),
    );
  }
}
