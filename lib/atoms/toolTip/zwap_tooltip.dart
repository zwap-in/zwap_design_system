import 'package:flutter/material.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

import '../clippers/zwap_message_clipper.dart';

enum TooltipPosition {
  top,
  rigth,
  bottom,
}

class ZwapTooltip extends StatefulWidget {
  final String message;
  final TextStyle? style;

  final EdgeInsets padding;

  final Widget child;
  final TooltipPosition position;

  final Offset transationOffset;
  final double decorationTranslation;

  final Duration animationDuration;

  final bool showTooltip;

  const ZwapTooltip({
    required this.message,
    required this.child,
    this.decorationTranslation = 0,
    this.style,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    this.position = TooltipPosition.bottom,
    this.transationOffset = Offset.zero,
    this.animationDuration = const Duration(milliseconds: 200),
    this.showTooltip = true,
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapTooltip> createState() => _ZwapTooltipState();
}

class _ZwapTooltipState extends State<ZwapTooltip> {
  final GlobalKey _key = GlobalKey();
  final GlobalKey<_ZwapTooltipOverlayState> _overlayKey = GlobalKey();
  OverlayEntry? _entry;

  late bool _showTooltip;

  @override
  void initState() {
    super.initState();
    _showTooltip = widget.showTooltip;
  }

  @override
  void didUpdateWidget(covariant ZwapTooltip oldWidget) {
    if (_showTooltip != widget.showTooltip) setState(() => _showTooltip = widget.showTooltip);
    super.didUpdateWidget(oldWidget);
  }

  void _showOverlay() {
    if (!_showTooltip || _entry != null) return;

    final Rect? _childRect = _key.globalPaintBounds;
    if (_childRect == null) return;

    Offset _position = widget.transationOffset;
    late final DecorationDirection _direction;

    switch (widget.position) {
      case TooltipPosition.top:
        _position += _childRect.topLeft - Offset(_widgetWidth / 2, 0);
        _direction = DecorationDirection.bottom;
        break;
      case TooltipPosition.rigth:
        _position += _childRect.topRight + Offset(0, _widgetHeight / 2);
        _direction = DecorationDirection.left;
        break;
      case TooltipPosition.bottom:
        _position += _childRect.bottomLeft - Offset(_widgetWidth / 2, 0);
        _direction = DecorationDirection.top;
        break;
    }

    Overlay.of(context)?.insert(
      _entry = OverlayEntry(
        builder: (context) => Positioned(
          top: _position.dy,
          left: _position.dx,
          child: _ZwapTooltipOverlay(
            key: _overlayKey,
            animationDuration: widget.animationDuration,
            direction: _direction,
            style: widget.style ?? getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.shades0),
            message: widget.message,
            padding: widget.padding,
            decorationOffset: widget.decorationTranslation,
          ),
        ),
      ),
    );
  }

  double get _widgetWidth {
    var span = TextSpan(text: widget.message, style: widget.style);

    var tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: double.infinity);

    return tp.width;
  }

  double get _widgetHeight {
    var span = TextSpan(text: widget.message, style: widget.style);

    var tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: double.infinity);

    return tp.height;
  }

  void _hideOverlay() async {
    if (_entry == null) return;

    await _overlayKey.currentState?.close();
    _entry!.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      key: _key,
      onEnter: (isHovered) => _showOverlay(),
      onExit: (isHovered) => _hideOverlay(),
      child: widget.child,
    );
  }
}

class _ZwapTooltipOverlay extends StatefulWidget {
  final String message;
  final TextStyle style;

  final DecorationDirection direction;
  final EdgeInsets padding;

  final Duration animationDuration;
  final double decorationOffset;

  const _ZwapTooltipOverlay({
    required this.message,
    required this.style,
    required this.direction,
    required this.padding,
    required this.animationDuration,
    required this.decorationOffset,
    Key? key,
  }) : super(key: key);

  @override
  State<_ZwapTooltipOverlay> createState() => _ZwapTooltipOverlayState();
}

class _ZwapTooltipOverlayState extends State<_ZwapTooltipOverlay> {
  double _opacity = 0;

  Future<void> close() async {
    setState(() => _opacity = 0);
    await Future.delayed(widget.animationDuration);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() => _opacity = 1));
  }

  @override
  Widget build(BuildContext context) {
    late final EdgeInsets _extraPadding;

    switch (widget.direction) {
      case DecorationDirection.top:
        _extraPadding = EdgeInsets.only(top: 12);
        break;
      case DecorationDirection.right:
        _extraPadding = EdgeInsets.only(right: 12);
        break;
      case DecorationDirection.bottom:
        _extraPadding = EdgeInsets.only(bottom: 12);
        break;
      case DecorationDirection.left:
        _extraPadding = EdgeInsets.only(left: 12);
        break;
    }

    return Material(
      color: ZwapColors.transparent,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: widget.animationDuration,
        child: ClipPath(
          clipper: ZwapMessageClipper(
            direction: widget.direction,
            decorationOffset: widget.decorationOffset,
          ),
          child: Container(
            color: ZwapColors.shades100.withOpacity(.7),
            padding: widget.padding + _extraPadding,
            child: ZwapText.customStyle(
              text: widget.message,
              customTextStyle: widget.style,
            ),
          ),
        ),
      ),
    );
  }
}
