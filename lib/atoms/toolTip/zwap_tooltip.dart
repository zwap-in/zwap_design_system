import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:zwap_design_system/atoms/atoms.dart';
import 'package:zwap_design_system/extensions/globalKeyExtension.dart';

import '../clippers/zwap_message_clipper.dart';

enum TooltipPosition {
  top,
  rigth,
  bottom;

  DecorationDirection get decorationDirection {
    switch (this) {
      case TooltipPosition.top:
        return DecorationDirection.bottom;
      case TooltipPosition.rigth:
        return DecorationDirection.left;
      case TooltipPosition.bottom:
        return DecorationDirection.top;
    }
  }

  Alignment get alignment {
    switch (this) {
      case TooltipPosition.top:
        return Alignment.topCenter;
      case TooltipPosition.rigth:
        return Alignment.centerRight;
      case TooltipPosition.bottom:
        return Alignment.bottomCenter;
    }
  }
}

extension on Alignment {
  DecorationDirection get decorationDirection {
    if (this == Alignment.topCenter)
      return DecorationDirection.bottom;
    else if (this == Alignment.centerRight)
      return DecorationDirection.left;
    else if (this == Alignment.bottomCenter) {
      return DecorationDirection.top;
    }

    return DecorationDirection.right;
  }
}

class ZwapTooltip extends StatefulWidget {
  /// Useful when the whole app is wrapped inside a widget that make
  /// Overlay.of(context) have different size from the screen size
  ///
  /// Default to Offset.zero
  static Offset globalCorrectPosition = Offset.zero;

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
  final TooltipPosition? position;

  /// Use this argument to move the overlay around
  ///
  /// This offset will be summed to the relative offset
  /// of the tooltip overlay
  @Deprecated("User [offset] instead")
  final Offset? transationOffset;

  /// Use this argument to move the overlay around
  /// of a custom amount
  final Offset offset;

  /// The alignment of the tooltip overlay
  /// relative to the [child] provided
  final Alignment tooltipAlignment;

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
    @Deprecated("Use [tooltipAlignment] instead") this.position,
    @Deprecated("Use [offset] instead") this.transationOffset,
    this.offset = Offset.zero,
    this.tooltipAlignment = Alignment.bottomCenter,
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
    @Deprecated("Use [tooltipAlignment] instead") this.position,
    @Deprecated("Use [offset] instead") this.transationOffset,
    this.offset = Offset.zero,
    this.tooltipAlignment = Alignment.bottomCenter,
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
    if (_showTooltip != widget.showTooltip) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (!widget.showTooltip && (_entry?.mounted ?? false)) {
            _hideOverlay();
          }
          setState(() => _showTooltip = widget.showTooltip);
        },
      );
    }

    super.didUpdateWidget(oldWidget);
  }

  void _showOverlay() {
    if (!_showTooltip || _entry != null) return;

    Overlay.of(context).insert(
      _entry = OverlayEntry(
        builder: (context) => _ZwapTooltipOverlay(
          key: _overlayKey,
          backgroundColor: widget.backgroundColor,
          animationDuration: widget.animationDuration,
          tooltipAlignment: widget.position?.alignment ?? widget.tooltipAlignment,
          style: widget.style ?? getTextStyle(ZwapTextType.mediumBodyRegular).copyWith(color: ZwapColors.shades0),
          message: widget.message,
          padding: widget.padding,
          decorationOffset: widget.decorationTranslation,
          builder: widget.builder,
          simple: widget.simple,
          targetKey: _key,
          offset: widget.transationOffset ?? widget.offset,
          borderColor: widget.borderColor,
          radius: widget.radius,
        ),
      ),
    );

    if (widget.disappearAfter != null) {
      _disappearTimer = Timer(widget.disappearAfter!, () => _hideOverlay());
    }
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
      onEnter: (isHovered) async {
        _shouldShowTooltip = true;
        await Future.delayed(widget.delay);

        if (_shouldShowTooltip) _showOverlay();
      },
      onExit: (isHovered) {
        _shouldShowTooltip = false;
        _hideOverlay();
      },
      child: SizedBox(
        key: _key,
        child: widget.child,
      ),
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

  final EdgeInsets padding;

  final Duration animationDuration;
  final double decorationOffset;

  final bool simple;

  final Color? borderColor;
  final Color? backgroundColor;

  final double radius;

  final GlobalKey targetKey;

  final Alignment tooltipAlignment;
  final Offset offset;

  const _ZwapTooltipOverlay({
    required this.message,
    required this.builder,
    required this.style,
    required this.tooltipAlignment,
    required this.padding,
    required this.animationDuration,
    required this.decorationOffset,
    required this.radius,
    required this.simple,
    required this.offset,
    required this.targetKey,
    this.borderColor,
    this.backgroundColor,
    Key? key,
  })  : assert(message != null || builder != null, "A message or a builder callback must be provided"),
        super(key: key);

  @override
  State<_ZwapTooltipOverlay> createState() => _ZwapTooltipOverlayState();
}

class _ZwapTooltipOverlayState extends State<_ZwapTooltipOverlay> {
  final GlobalKey _key = GlobalKey();
  double _opacity = 0;

  /// This offset is used to let tooltip fits screen constraints
  Offset _extraOffset = Offset.zero;

  /// The "normal" position of the tooltip if the content
  /// fits the screen constraints
  Offset _position = Offset.zero;

  Future<void> close() async {
    if (!mounted) return;
    setState(() => _opacity = 0);
    await Future.delayed(widget.animationDuration);
  }

  @override
  void initState() {
    super.initState();

    _position = -ZwapTooltip.globalCorrectPosition;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Rect? _rect = _key.globalPaintBounds;
      if (_rect == null) return;

      _position = _key.safePositionRelatedTo(
            widget.targetKey,
            position: widget.tooltipAlignment,
            translate: widget.offset,
            screenCorrection: ZwapTooltip.globalCorrectPosition,
          ) ??
          Offset.zero;

      /* Size _screenSize = MediaQuery.of(context).size;
      _screenSize = Size(_screenSize.width - ZwapTooltip.globalCorrectPosition.dx, _screenSize.height - ZwapTooltip.globalCorrectPosition.dy);

      final Rect _updatedTooltipRect = _rect.translate(_position.dx, _position.dy);

      double _dx = 0;
      double _dy = 0;

      if (_updatedTooltipRect.left + _updatedTooltipRect.width > _screenSize.width) {
        _dx = _screenSize.width - (_updatedTooltipRect.left + _updatedTooltipRect.width + 16);
      } else if (_updatedTooltipRect.left < 0) {
        _dx = -_updatedTooltipRect.left + 16;
      }

      if (_updatedTooltipRect.top + _updatedTooltipRect.height > _screenSize.height) {
        _dy = _screenSize.height - (_updatedTooltipRect.top + _updatedTooltipRect.height + 16);
      } else if (_updatedTooltipRect.top < 0) {
        _dy = -_updatedTooltipRect.top + 16;
      } */

      // _extraOffset = Offset(_dx, _dy);
      /*   } else {
        _extraOffset = Offset.zero;
      } */

      setState(() => _opacity = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    late final EdgeInsets _extraPadding;

    if (widget.simple)
      _extraPadding = EdgeInsets.zero;
    else
      switch (widget.tooltipAlignment.decorationDirection) {
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
        final Widget _res = Container(
            padding: const EdgeInsets.all(1),
            child: child,
            decoration: BoxDecoration(
              color: widget.borderColor,
              borderRadius: widget.simple ? BorderRadius.circular(widget.radius + 1) : null,
            ));
        if (widget.simple)
          child = _res;
        else
          child = ClipPath(
            clipper: ZwapMessageClipper(
              direction: widget.tooltipAlignment.decorationDirection,
              decorationOffset: widget.decorationOffset,
              radius: widget.radius + 1,
            ),
            child: _res,
          );
      }

      return IgnorePointer(
        child: Material(
          color: ZwapColors.transparent,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: widget.animationDuration,
            child: child,
          ),
        ),
      );
    }

    if (widget.simple)
      return Positioned(
        top: _position.dy + _extraOffset.dy,
        left: _position.dx + _extraOffset.dx,
        child: _wrapContent(
          ClipRRect(
            key: _key,
            borderRadius: BorderRadius.circular(widget.radius),
            child: content,
          ),
        ),
      );

    return Positioned(
      top: _position.dy + _extraOffset.dy,
      left: _position.dx + _extraOffset.dx,
      child: _wrapContent(
        ClipPath(
          key: _key,
          clipper: ZwapMessageClipper(
            direction: widget.tooltipAlignment.decorationDirection,
            decorationOffset: widget.decorationOffset,
            radius: widget.radius,
          ),
          child: content,
        ),
      ),
    );
  }
}
