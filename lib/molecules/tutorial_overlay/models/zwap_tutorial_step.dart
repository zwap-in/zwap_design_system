part of zwap_tutorial_overlay;

class ZwapTutorialStep {
  final ZwapTutorialStepContent content;

  /// Called each time this step is disposed
  final Function()? onClose;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  /// If true the user can go to the previous step
  final bool showBack;

  /// If true the user can skip (actually close)
  final bool showSkip;

  /// The translate offset of the overlay, if zero the overlay if in the bottom center of the focus widget
  ///
  ///  By default offset is Offset.zero
  final Offset overlayOffset;

  /// If provided used to wrap the focus widget copy
  final Widget Function(BuildContext, Widget)? focusWidgetWrapper;

  final DecorationDirection decorationDirection;
  final double decorationTranslation;

  ZwapTutorialStep({
    required this.content,
    this.onClose,
    this.width,
    this.height,
    this.focusWidgetWrapper,
    this.backgroundColor,
    this.overlayOffset = Offset.zero,
    this.showBack = false,
    this.showSkip = false,
    this.decorationDirection = DecorationDirection.bottom,
    this.decorationTranslation = 0,
  });
}
