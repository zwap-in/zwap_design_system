part of zwap_tutorial_overlay;

class _MultipleStepWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Color color;

  /// The current step index, this combined with [stepsCount] will
  /// be used to render the current step indicator widget
  final int index;

  /// The steps count, this combined with [index] will
  /// be used to render the current step indicator widget
  final int stepsCount;

  final ZwapTutorialStepContent step;

  /// Is showSkip is true the multiple step flow can be skipped
  final bool showSkip;

  /// Is true a "back" button will be shown
  final bool showBack;

  /// If true an "end" button will be shown instead of the "forward" button
  final bool showEnd;

  /// Called when the close icon is pressed
  final Function()? onSkip;

  /// Called when "back" button is pressed
  final Function()? onBack;

  /// Called when "forward" (or "end" if showEnd is true) button is pressed
  final Function()? onForward;

  const _MultipleStepWidget({
    Key? key,
    this.width,
    this.height,
    required this.color,
    required this.step,
    required this.showSkip,
    required this.showBack,
    required this.showEnd,
    required this.index,
    required this.stepsCount,
    this.onSkip,
    this.onBack,
    this.onForward,
  })  : assert(!(showSkip && showBack), "Cannot showing both skip and back buttons, choose one"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ZwapMessageClipper(),
      child: Container(
        width: width ?? 300,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            step._isCustomChild
                ? Builder(builder: step._customChild!)
                : Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (step._leading != null) step._leading!,
                        SizedBox(height: 4),
                        ZwapText(
                          text: step._title!,
                          zwapTextType: ZwapTextType.bigBodySemibold,
                          textColor: ZwapColors.shades0,
                        ),
                        SizedBox(height: 4),
                        if (step._subtitle != null)
                          ZwapText(
                            text: step._subtitle!,
                            zwapTextType: ZwapTextType.mediumBodyRegular,
                            textColor: ZwapColors.shades0,
                          ),
                      ],
                    ),
                  ),
            const SizedBox(height: 16),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  _CurrentStepWidget(
                    index: index,
                    count: stepsCount,
                  ),
                  Spacer(),
                  if (showBack || showSkip) ...[
                    ZwapButton(
                      width: showBack ? 74 : 60,
                      height: 24,
                      buttonChild: ZwapButtonChild.text(text: showBack ? 'Indietro' : 'Salta'),
                      decorations: ZwapButtonDecorations.quaternary(
                          internalPadding: EdgeInsets.zero, contentColor: ZwapColors.shades0, backgroundColor: ZwapColors.whiteTransparent),
                      onTap: showBack ? onBack : onSkip,
                    ),
                    const SizedBox(width: 12),
                  ],
                  ZwapButton(
                    width: 60,
                    height: 24,
                    buttonChild: ZwapButtonChild.text(text: showEnd ? "Fine" : "Avanti"), //TODO: trova un modo per internazionalizzare
                    decorations: ZwapButtonDecorations.tertiary(
                        internalPadding: EdgeInsets.zero, contentColor: ZwapColors.primary900Dark, backgroundColor: ZwapColors.shades0),
                    onTap: onForward,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentStepWidget extends StatelessWidget {
  final int index;
  final int count;

  const _CurrentStepWidget({
    required this.index,
    required this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget _activeIndicator() => Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: ZwapColors.shades0,
            borderRadius: BorderRadius.circular(100),
          ),
        );

    Widget _indicator() => Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: ZwapColors.shades0.withOpacity(.2),
            borderRadius: BorderRadius.circular(100),
          ),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
          count,
          (i) => [
                if (i != 0) const SizedBox(width: 4),
                i == index ? _activeIndicator() : _indicator(),
              ]).reduce((v, e) => [...v, ...e]),
    );
  }
}
