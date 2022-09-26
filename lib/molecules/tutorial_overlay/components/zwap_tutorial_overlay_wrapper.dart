part of zwap_tutorial_overlay;

class _ZwapTutorialOverlayWrapper extends StatefulWidget {
  final Widget Function(BuildContext) builder;
  final Duration fadeDuration;

  _ZwapTutorialOverlayWrapper({
    required this.builder,
    this.fadeDuration = const Duration(milliseconds: 350),
    Key? key,
  }) : super(key: key);

  @override
  State<_ZwapTutorialOverlayWrapper> createState() => _ZwapTutorialOverlayWrapperState();
}

class _ZwapTutorialOverlayWrapperState extends State<_ZwapTutorialOverlayWrapper> {
  late double _opacity;
  @override
  void initState() {
    super.initState();
    _opacity = 1;
  }

  void hide() => setState(() => _opacity = 0);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: widget.fadeDuration,
      curve: Curves.decelerate,
      opacity: _opacity,
      child: Builder(builder: widget.builder),
    );
  }
}
