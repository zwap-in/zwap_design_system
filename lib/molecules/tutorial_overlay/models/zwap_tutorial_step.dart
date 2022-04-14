part of zwap_tutorial_overlay;

class ZwapTutorialStep {
  final ZwapTutorialStepContent content;

  /// Called each time this step is disposed
  ///
  /// ! Called even if showClose is false
  final Function()? onClose;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  /// If true a close icon will be showed and user can finish the tutorial in this step
  final bool showClose;

  /// The translate offset of the overlay, if zero the overlay if in the bottom center of the focus widget
  ///
  ///  By default offset is Offset.zero
  final Offset overlayOffset;

  ZwapTutorialStep({
    required this.content,
    this.onClose,
    this.width,
    this.height,
    this.backgroundColor,
    this.showClose = false,
    this.overlayOffset = Offset.zero,
  });
}
