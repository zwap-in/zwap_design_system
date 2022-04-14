part of zwap_tutorial_overlay_entry;

class _ZwapTutorialOverlayWrapper extends StatefulWidget {
  late final _ZwapTutorialOverlayWrapperState _privateState;

  final Widget Function(BuildContext) builder;
  final Duration fadeDuration;

  _ZwapTutorialOverlayWrapper({
    required this.builder,
    this.fadeDuration = const Duration(milliseconds: 350),
    Key? key,
  }) : super(key: key);

  void hide() => _privateState._hide();

  @override
  State<_ZwapTutorialOverlayWrapper> createState() => _privateState = _ZwapTutorialOverlayWrapperState();
}

class _ZwapTutorialOverlayWrapperState extends State<_ZwapTutorialOverlayWrapper> {
  late double _opacity;
  @override
  void initState() {
    super.initState();
    _opacity = 1;
  }

  void _hide() => setState(() => _opacity = 0);

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
