part of zwap_tutorial_overlay;

class ZwapSimpleTutorialWidget extends StatefulWidget {
  final GlobalKey focusWidgetKey;

  /// ? Why: Usually some widgets depends on providers or inherited data that fail to be
  /// retrived in a different context
  ///
  /// Wrapping the provided child inside a copy of the needed providers will solve this issue
  final Widget Function(BuildContext context, Widget child)? focusWidgetWrapper;

  final double? width;
  final double? height;
  final Color? backgroundColor;
  final ZwapTutorialStepContent child;
  final Function()? onClose;
  final bool showClose;

  /// If provided showed as footer of the overlay
  final ZwapButton? cta;

  /// The translate offset of the overlay, if zero the overlay if in the bottom center of the focus widget
  ///
  ///  By default offset is Offset.zero
  final Offset overlayOffset;

  /// If true clicking outside the overlay will make it close
  final bool dismissible;

  /// If true the background will be blurred
  ///
  /// Default to true
  final bool blur;

  const ZwapSimpleTutorialWidget({
    Key? key,
    required this.focusWidgetKey,
    required this.child,
    this.focusWidgetWrapper,
    this.width,
    this.height,
    this.backgroundColor,
    this.showClose = true,
    this.onClose,
    this.dismissible = false,
    this.overlayOffset = Offset.zero,
    this.cta,
    this.blur = true,
  }) : super(key: key);

  @override
  State<ZwapSimpleTutorialWidget> createState() => _ZwapSimpleTutorialWidgetState();
}

class _ZwapSimpleTutorialWidgetState extends State<ZwapSimpleTutorialWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late Size _focusWidgetSize;
  late Offset _focusWidgetOffset;

  GlobalKey get _focusWidgetKey => widget.focusWidgetKey;

  @override
  void initState() {
    super.initState();

    _focusWidgetOffset = _focusWidgetKey.globalOffset ?? Offset.zero;
    _focusWidgetSize = _focusWidgetKey.globalPaintBounds?.size ?? Size.zero;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    final double _topOffset = _focusWidgetOffset.dy + _focusWidgetSize.height;
    final double _leftOffset = _focusWidgetOffset.dx + (_focusWidgetSize.width - (widget.width ?? 0)) / 2;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            GestureDetector(
              onTap: widget.dismissible ? widget.onClose : null,
              child: widget.blur
                  ? ZwapTutorialAnimatedBackgroundBlur(
                      duration: const Duration(milliseconds: 300),
                      sigma: 10,
                    )
                  : Container(color: ZwapColors.whiteTransparent),
            ),
            Positioned(
              top: _focusWidgetOffset.dy - 0.005 * _focusWidgetSize.height,
              left: _focusWidgetOffset.dx - 0.005 * _focusWidgetSize.width,
              child: _focusWidgetKey.currentWidget != null
                  ? Transform.scale(
                      scale: 1.05,
                      child: IgnorePointer(
                        ignoring: true,
                        child: Builder(
                          builder: widget.focusWidgetWrapper != null
                              ? (context) => widget.focusWidgetWrapper!(
                                  context, Builder(builder: (_focusWidgetKey.currentWidget as ZwapTutorialOverlayFocusWidget).childBuilder))
                              : (_focusWidgetKey.currentWidget as ZwapTutorialOverlayFocusWidget).childBuilder,
                        ),
                      ),
                    )
                  : Container(),
            ),
            Positioned(
              top: _topOffset + widget.overlayOffset.dy,
              left: _leftOffset + widget.overlayOffset.dx,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Opacity(opacity: _animationController.value, child: child),
                child: _StepWidget(
                  cta: widget.cta,
                  color: widget.backgroundColor ?? ZwapColors.shades0,
                  height: widget.height,
                  width: widget.width,
                  showClose: widget.showClose,
                  onClose: widget.onClose,
                  step: widget.child,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
