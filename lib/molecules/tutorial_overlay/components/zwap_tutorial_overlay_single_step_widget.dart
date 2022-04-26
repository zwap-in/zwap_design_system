part of zwap_tutorial_overlay;

class _StepWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final Color color;

  final ZwapTutorialStepContent step;

  final bool showClose;
  final Function()? onClose;

  final ZwapButton? cta;

  const _StepWidget({
    Key? key,
    this.width,
    this.height,
    required this.color,
    required this.step,
    required this.showClose,
    this.onClose,
    this.cta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ZwapMessageClipper(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15), boxShadow: [ZwapShadow.levelOne]),
        padding: EdgeInsets.only(top: 20, bottom: cta == null ? 32 : 14, left: 18, right: 18),
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
                      if (cta != null) ...[
                        SizedBox(height: 8),
                        cta!,
                      ]
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
