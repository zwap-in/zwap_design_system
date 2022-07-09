part of zwap_tutorial_overlay;

class _MultipleStepWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Color color;

  final ZwapTutorialStepContent step;

  /// Is showClose is true the step can be dismissed clicking outside the tutorial widget
  final bool showClose;

  /// Is true a "back" button will be shown
  final bool showBack;

  /// If true an "end" button will be shown instead of the "forward" button
  final bool showEnd;

  /// Called when the close icon is pressed
  final Function()? onClose;

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
    required this.showClose,
    required this.showBack,
    required this.showEnd,
    this.onClose,
    this.onBack,
    this.onForward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ZwapMessageClipper(),
      child: Container(
        constraints: BoxConstraints(minWidth: 150),
        width: width,
        height: height,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15), boxShadow: [ZwapShadow.levelOne]),
        padding: const EdgeInsets.only(top: 30, bottom: 32, left: 18, right: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showClose)
              Align(
                alignment: Alignment.centerRight,
                child: ZwapButton(
                  buttonChild: ZwapButtonChild.icon(icon: Icons.close_rounded, iconSize: 15),
                  width: 24,
                  height: 24,
                  decorations: ZwapButtonDecorations.quaternary(internalPadding: EdgeInsets.zero),
                  onTap: onClose,
                ),
              ),
            step._isCustomChild
                ? Builder(builder: step._customChild!)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (step._leading != null) step._leading!,
                      SizedBox(height: 4),
                      ZwapText(
                        text: step._title!,
                        zwapTextType: ZwapTextType.bigBodyBold,
                        textColor: ZwapColors.neutral700,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      if (step._subtitle != null)
                        ZwapText(
                          text: step._subtitle!,
                          zwapTextType: ZwapTextType.mediumBodyRegular,
                          textColor: ZwapColors.neutral500,
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (showBack)
                  ZwapButton(
                    buttonChild: ZwapButtonChild.icon(icon: Icons.arrow_back, iconSize: 15),
                    width: 32,
                    height: 32,
                    decorations: ZwapButtonDecorations.quaternary(internalPadding: EdgeInsets.zero),
                    onTap: onBack,
                  ),
                ZwapButton(
                  buttonChild: ZwapButtonChild.text(text: showEnd ? "Fine" : "Avanti"), //TODO: trova un modo per internazionalizzare
                  width: 75,
                  height: 32,
                  decorations: ZwapButtonDecorations.quaternary(internalPadding: EdgeInsets.zero),
                  onTap: onForward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
