import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

import '../clippers/zwap_message_clipper.dart';

enum TooltipPosition {
  top,
  rigth,
  bottom,
}

class ZwapTooltip extends StatefulWidget {
  /// Message showed inside tooltip overlay
  final String? message;

  /// [message] text style
  final TextStyle? style;

  /// Padding applied to overlay content
  final EdgeInsets padding;

  /// The tooltip position relative to the [child] provided
  ///
  /// Eg, if [position] in [TooltipPosition.rigth] the tooltip overlay
  /// will be showed to the rigth of the provided [child]
  final TooltipPosition position;

  /// Use this argument to move the overlay around
  ///
  /// This offset will be summed to the relative offset
  /// of the tooltip overlay
  final Offset transationOffset;

  /// Use this to move the arrow decoration of the tooltip.
  ///
  /// Default: 0, ie in the center of the "main" border, where
  /// the "main" border in:
  /// * top border if [position] is [TooltipPosition.bottom]
  /// * bottom border if [position] is [TooltipPosition.top]
  /// * left border if [position] is [TooltipPosition.rigth]
  final double decorationTranslation;

  /// * left border if [position] is [TooltipPosition.rigth]
  final Duration animationDuration;

  /// You can deactivate the tooltip visualization
  /// simply setting [showTooltip] to false
  ///
  /// Default to true
  final bool showTooltip;

  /// [ZwapTooltip] will wait the mouse to be hovering the
  /// widget for at least this time before showing tooltip
  ///
  /// Default to [Duration.zero]
  final Duration delay;

  /// [ZwapTooltip] will use this duration as the maximum
  /// time an overlay can be showed
  ///
  /// Ie: the overlay is automatically closed after this
  /// delay
  ///
  /// Default to 5 seconds
  ///
  /// Set this to [null] to disable auto close
  final Duration? disappearAfter;

  final Widget child;

  /// If provided the returned widget is placed inside tooltip
  /// instead of the [message] string
  ///
  /// Obviously, [style] will have no effect
  final Widget Function(BuildContext)? builder;

  /// If true no edges will have the decoration, so [decorationTranslation]
  /// and [position] will have no effect
  ///
  /// Default to false
  final bool simple;

  /// The color of the borders
  final Color? borderColor;

  /// The color of the background
  final Color? backgroundColor;

  /// The radius of the borders and the decoration
  final double radius;

  /// Show a customized tooltip message when user hover
  /// this widget with mouse
  ///
  /// In mobile devices (type 2, 1 and 0) the tooltip is showed
  /// both on long tap and on mouse hover
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
    this.delay = Duration.zero,
    this.disappearAfter = const Duration(seconds: 5),
    this.simple = false,
    this.borderColor,
    this.backgroundColor,
    this.radius = 14,
    Key? key,
  })  : this.builder = null,
        super(key: key);

  /// Show a customized tooltip message when user hover
  /// this widget with mouse
  ///
  /// In mobile devices (type 2, 1 and 0) the tooltip is showed
  /// both on long tap and on mouse hover
  const ZwapTooltip.builder({
    required this.builder,
    required this.child,
    this.decorationTranslation = 0,
    this.style,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    this.position = TooltipPosition.bottom,
    this.transationOffset = Offset.zero,
    this.animationDuration = const Duration(milliseconds: 200),
    this.showTooltip = true,
    this.delay = Duration.zero,
    this.disappearAfter = const Duration(seconds: 5),
    this.simple = false,
    this.borderColor,
    this.backgroundColor,
    this.radius = 14,
    Key? key,
  })  : this.message = null,
        super(key: key);

  @override
  State<ZwapTooltip> createState() => _ZwapTooltipState();
}

class _ZwapTooltipState extends State<ZwapTooltip> {
  final GlobalKey _key = GlobalKey();
  final GlobalKey<_ZwapTooltipOverlayState> _overlayKey = GlobalKey();
  OverlayEntry? _entry;

  late bool _showTooltip;

  /// When user enter the hover region this value is set to true.
  /// If the user exit this area this will be setted to false.
  ///
  /// If after the [widget.delay] delay this value is still true
  /// the overlay is showed
  bool _shouldShowTooltip = false;

  /// Used to make overlay disappear after [widget.disappearAfter]
  Timer? _disappearTimer;

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

    Overlay.of(context).insert(
      _entry = OverlayEntry(
        builder: (context) => Positioned(
          top: _position.dy,
          left: _position.dx,
          child: _ZwapTooltipOverlay(
            key: _overlayKey,
            backgroundColor: widget.backgroundColor,
            animationDuration: widget.animationDuration,
            direction: _direction,
            style: widget.style ?? getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.shades0),
            message: widget.message,
            padding: widget.padding,
            decorationOffset: widget.decorationTranslation,
            builder: widget.builder,
            simple: widget.simple,
            borderColor: widget.borderColor,
            radius: widget.radius,
          ),
        ),
      ),
    );

    if (widget.disappearAfter != null) {
      _disappearTimer = Timer(widget.disappearAfter!, () => _hideOverlay());
    }
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
    _disappearTimer?.cancel();
    if (_entry == null) return;

    await _overlayKey.currentState?.close();
    _entry?.remove();
    _entry = null;
  }

  @override
  void deactivate() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _hideOverlay());
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _hideOverlay());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool _isSmall = getMultipleConditions(false, false, true, true, true);

    final Widget _bigScreenWidget = MouseRegion(
      key: _key,
      onEnter: (isHovered) async {
        _shouldShowTooltip = true;
        await Future.delayed(widget.delay);

        if (_shouldShowTooltip) _showOverlay();
      },
      onExit: (isHovered) {
        _shouldShowTooltip = false;
        _hideOverlay();
      },
      child: widget.child,
    );

    if (_isSmall)
      return GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onLongPress: () => _showOverlay(),
        child: _bigScreenWidget,
      );

    return _bigScreenWidget;
  }
}

class _ZwapTooltipOverlay extends StatefulWidget {
  final String? message;
  final Widget Function(BuildContext)? builder;

  final TextStyle style;

  final DecorationDirection direction;
  final EdgeInsets padding;

  final Duration animationDuration;
  final double decorationOffset;

  final bool simple;

  final Color? borderColor;
  final Color? backgroundColor;

  final double radius;

  const _ZwapTooltipOverlay({
    required this.message,
    required this.builder,
    required this.style,
    required this.direction,
    required this.padding,
    required this.animationDuration,
    required this.decorationOffset,
    required this.radius,
    required this.simple,
    this.borderColor,
    this.backgroundColor,
    Key? key,
  })  : assert(message != null || builder != null, "A message or a builder callback must be provided"),
        super(key: key);

  @override
  State<_ZwapTooltipOverlay> createState() => _ZwapTooltipOverlayState();
}

class _ZwapTooltipOverlayState extends State<_ZwapTooltipOverlay> {
  double _opacity = 0;

  Future<void> close() async {
    if (!mounted) return;
    setState(() => _opacity = 0);
    await Future.delayed(widget.animationDuration);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() => _opacity = 1));
  }

  @override
  Widget build(BuildContext context) {
    late final EdgeInsets _extraPadding;

    if (widget.simple)
      _extraPadding = EdgeInsets.zero;
    else
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

    final Widget content = Container(
      color: widget.backgroundColor ?? ZwapColors.shades100.withOpacity(.7),
      padding: widget.padding + _extraPadding,
      child: widget.message == null
          ? widget.builder!(context)
          : ZwapText.customStyle(
              text: widget.message!,
              customTextStyle: widget.style,
            ),
    );

    Widget _wrapContent(Widget child) {
      if (widget.borderColor != null) {
        child = ClipPath(
          clipper: ZwapMessageClipper(
            direction: widget.direction,
            decorationOffset: widget.decorationOffset,
            radius: widget.radius + 1,
          ),
          child: Container(
            color: widget.borderColor,
            padding: const EdgeInsets.all(1),
            child: child,
          ),
        );
      }

      return Material(
        color: ZwapColors.transparent,
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: widget.animationDuration,
          child: child,
        ),
      );
    }

    if (widget.simple)
      return _wrapContent(
        ClipRRect(borderRadius: BorderRadius.circular(widget.radius), child: content),
      );

    return _wrapContent(
      ClipPath(
        clipper: ZwapMessageClipper(
          direction: widget.direction,
          decorationOffset: widget.decorationOffset,
          radius: widget.radius,
        ),
        child: content,
      ),
    );
  }
}
