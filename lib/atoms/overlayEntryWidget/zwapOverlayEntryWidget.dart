import 'package:flutter/material.dart';

extension ZwapOverlayEntryChildExt on GlobalKey<ZwapOverlayEntryChildState> {
  void updatePosition({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) =>
      currentState?._updatePosition(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
        width: width,
        height: height,
      );
}

class ZwapOverlayEntryChild extends StatefulWidget {
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
  State<ZwapOverlayEntryChild> createState() => ZwapOverlayEntryChildState();
}

class ZwapOverlayEntryChildState extends State<ZwapOverlayEntryChild> {
  late double? _left;
  late double? _top;
  late double? _right;
  late double? _bottom;
  late double? _width;
  late double? _height;

  @override
  void initState() {
    super.initState();

    _left = widget.left;
    _top = widget.top;
    _right = widget.right;
    _bottom = widget.bottom;
    _width = widget.width;
    _height = widget.height;
  }

  @override
  void didUpdateWidget(covariant ZwapOverlayEntryChild oldWidget) {
    setState(() {
      _left = widget.left;
      _top = widget.top;
      _right = widget.right;
      _bottom = widget.bottom;
      _width = widget.width;
      _height = widget.height;
    });

    super.didUpdateWidget(oldWidget);
  }

  void _updatePosition({
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) =>
      setState(() {
        if (left != null) _left = left;
        if (top != null) _top = top;
        if (right != null) _right = right;
        if (bottom != null) _bottom = bottom;
        if (width != null) _width = width;
        if (height != null) _height = height;
      });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 75),
      curve: Curves.decelerate,
      left: _left,
      top: _top,
      right: _right,
      bottom: _bottom,
      width: _width,
      height: _height,
      child: GestureDetector(behavior: HitTestBehavior.opaque, child: widget.child, onTap: () {}),
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