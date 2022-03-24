part of percent;

class ZwapSimplePercent extends StatefulWidget {
  /// The value to show in the percent indicator
  ///
  /// The widget automatically response to this variable changes with animations
  ///
  /// Between 0 and 1
  final double value;

  /// This will override the decoration radius if greater than 0.
  final double radius;
  final ZwapPercentWidgetPercentContent insidePercentContent;
  final ZwapPercentIndicatorDecorations decorations;

  const ZwapSimplePercent({
    this.value = 0.5,
    this.radius = 0,
    this.insidePercentContent = const ZwapPercentWidgetPercentContent.percent(),
    this.decorations = const ZwapPercentIndicatorDecorations.success(),
    Key? key,
  }) : super(key: key);

  @override
  State<ZwapSimplePercent> createState() => _ZwapSimplePercentState();
}

class _ZwapSimplePercentState extends State<ZwapSimplePercent> {
  late double _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ZwapSimplePercent oldWidget) {
    if (widget.value != _value) setState(() => _value = widget.value);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      percent: widget.value,
      radius: widget.radius > 0 ? widget.radius : widget.decorations.radius,
      animation: true,
      lineWidth: widget.decorations.lineWidth,
      backgroundWidth: widget.decorations.backgoundLineWidth,
      backgroundColor: widget.decorations.backgroundColor,
      fillColor: Colors.transparent,
      progressColor: widget.decorations.valueColor,
      circularStrokeCap: CircularStrokeCap.round,
      center: Center(
        child: widget.insidePercentContent._showPercent
            ? widget.insidePercentContent.percentTextStyle == null
                ? ZwapText(
                    text: "${_value * 100}%",
                    zwapTextType: ZwapTextType.mediumBodyBold,
                    textColor: ZwapColors.neutral600,
                    textAlign: TextAlign.center,
                  )
                : ZwapText.customStyle(
                    text: "${_value * 100}%",
                    customTextStyle: widget.insidePercentContent.percentTextStyle,
                    textAlign: TextAlign.center,
                  )
            : widget.insidePercentContent._customWidget!,
      ),
    );
  }
}
