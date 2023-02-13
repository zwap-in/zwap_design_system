part of zwap_tutorial_overlay;

class ZwapComplexTutorialWidget extends StatefulWidget {
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

  /// Called when "back" button is pressed
  final Function()? onBack;

  /// Is true a "back" button will be shown
  final bool showBack;

  /// If true an "end" button will be shown instead of the "forward" button
  final bool showEnd;

  /// Called when "forward" (or "end" if showEnd is true) button is pressed
  final Function()? onForward;

  /// The translate offset of the overlay, if zero the overlay if in the bottom center of the focus widget
  ///
  ///  By default offset is Offset.zero
  final Offset overlayOffset;

  /// If true a close icon will be shown and user can finish the tutorial in this step
  ///
  /// Is showClose is true the step can be dismissed clicking outside the tutorial widget
  final bool showSkip;

  /// Called when the close icon is pressed
  final Function()? onClose;

  /// If not null, the related widget will be used as constraints for the blurred region
  final GlobalKey? blurRegion;

  /// The index of the current step
  final int index;

  /// The total flow steps count
  final int stepsCount;

  final DecorationDirection decorationDirection;
  final double decorationTranslation;

  const ZwapComplexTutorialWidget({
    Key? key,
    required this.focusWidgetKey,
    required this.child,
    required this.index,
    required this.stepsCount,
    this.focusWidgetWrapper,
    this.width,
    this.height,
    this.backgroundColor,
    this.showBack = true,
    this.showEnd = false,
    this.onBack,
    this.onForward,
    this.onClose,
    this.showSkip = false,
    this.overlayOffset = Offset.zero,
    this.blurRegion,
    this.decorationDirection = DecorationDirection.top,
    this.decorationTranslation = 0,
  }) : super(key: key);

  @override
  State<ZwapComplexTutorialWidget> createState() => _ZwapComplexTutorialWidgetState();
}

class _ZwapComplexTutorialWidgetState extends State<ZwapComplexTutorialWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  final GlobalKey _stepWidgetKey = GlobalKey();

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

    if (widget.width == null) {
      Future.delayed(const Duration(milliseconds: 50), () => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    late double _topOffset;
    late double _leftOffset;

    final Rect _stepWidgetSize = _stepWidgetKey.globalPaintBounds ?? Rect.zero;

    switch (widget.decorationDirection) {
      case DecorationDirection.top:
        _topOffset = _focusWidgetOffset.dy - _stepWidgetSize.height;
        _leftOffset = _focusWidgetOffset.dx + (_focusWidgetSize.width - (_stepWidgetSize.width)) / 2;
        break;
      case DecorationDirection.right:
        _topOffset = _focusWidgetOffset.dy;
        _leftOffset = _focusWidgetOffset.dx + _stepWidgetSize.height + 12;
        break;
      case DecorationDirection.bottom:
        _topOffset = _focusWidgetOffset.dy + _focusWidgetSize.height;
        _leftOffset = _focusWidgetOffset.dx + (_focusWidgetSize.width - (_stepWidgetSize.width)) / 2;
        break;
      case DecorationDirection.left:
        _topOffset = _focusWidgetOffset.dy;
        _leftOffset = _focusWidgetOffset.dx - _stepWidgetSize.height - 12;
        break;
    }

    _leftOffset = min(MediaQuery.of(context).size.width - 30 - (widget.width ?? 300), max(16, _leftOffset));
    _topOffset = min(MediaQuery.of(context).size.height - 15 - (widget.height ?? 300), max(16, _topOffset));

    Rect? _blurRegion;

    if (widget.blurRegion != null) {
      _blurRegion = widget.blurRegion!.globalPaintBounds;
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            if (_blurRegion == null)
              Positioned(
                child: GestureDetector(
                  onTap: widget.showSkip ? widget.onClose : null,
                  child: ZwapTutorialAnimatedBackgroundBlur(
                    duration: const Duration(milliseconds: 300),
                    sigma: 10,
                  ),
                ),
              )
            else
              Positioned.fromRect(
                rect: _blurRegion,
                child: GestureDetector(
                  onTap: widget.showSkip ? widget.onClose : null,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(color: ZwapColors.transparent),
                    child: ZwapTutorialAnimatedBackgroundBlur(
                      duration: const Duration(milliseconds: 300),
                      sigma: 10,
                      color: ZwapColors.neutral200.withOpacity(0.2),
                    ),
                  ),
                ),
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
                                    context,
                                    Builder(
                                      builder: (_focusWidgetKey.currentWidget as ZwapTutorialOverlayFocusWidget).childBuilder,
                                    ),
                                  )
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
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 100),
                  opacity: _stepWidgetKey.currentWidget != null ? 1 : 0,
                  child: _MultipleStepWidget(
                    key: _stepWidgetKey,
                    showBack: widget.showBack,
                    showEnd: widget.showEnd,
                    onBack: widget.onBack,
                    onForward: widget.onForward,
                    color: widget.backgroundColor ?? ZwapColors.shades100.withOpacity(.7),
                    height: widget.height,
                    width: widget.width,
                    showSkip: widget.showSkip,
                    onSkip: widget.onClose,
                    step: widget.child,
                    index: widget.index,
                    stepsCount: widget.stepsCount,
                    decorationDirection: widget.decorationDirection,
                    decorationTranslation: widget.decorationTranslation,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
