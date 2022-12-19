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
  final bool showClose;

  /// Called when the close icon is pressed
  final Function()? onClose;

  const ZwapComplexTutorialWidget({
    Key? key,
    required this.focusWidgetKey,
    required this.child,
    this.focusWidgetWrapper,
    this.width,
    this.height,
    this.backgroundColor,
    this.showBack = true,
    this.showEnd = false,
    this.onBack,
    this.onForward,
    this.onClose,
    this.showClose = false,
    this.overlayOffset = Offset.zero,
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

    if (widget.width == null) WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final double _topOffset = _focusWidgetOffset.dy + _focusWidgetSize.height;
    final double _leftOffset = _focusWidgetOffset.dx + (_focusWidgetSize.width - (widget.width ?? _stepWidgetKey.globalPaintBounds?.width ?? 0)) / 2;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            GestureDetector(
              onTap: widget.showClose ? widget.onClose : null,
              child: ZwapTutorialAnimatedBackgroundBlur(
                duration: const Duration(milliseconds: 300),
                sigma: 10,
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
                                  context, Builder(builder: (_focusWidgetKey.currentWidget as ZwapTutorialOverlayFocusWidget).childBuilder))
                              : (_focusWidgetKey.currentWidget as ZwapTutorialOverlayFocusWidget).childBuilder,
                        ),
                      ),
                    )
                  : Container(),
            ),
            Positioned(
              top: _topOffset,
              left: _leftOffset,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Opacity(opacity: _animationController.value, child: child),
                child: _MultipleStepWidget(
                  key: _stepWidgetKey,
                  showBack: widget.showBack,
                  showEnd: widget.showEnd,
                  onBack: widget.onBack,
                  onForward: widget.onForward,
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
