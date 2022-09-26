part of zwap_tutorial_overlay;

class ZwapTutorialOverlayEntry extends OverlayEntry {
  late final GlobalKey<_ZwapTutorialOverlayWrapperState>? _wrapperKey;

  final bool fadeOut;
  final Duration fadeOutDuration;

  @override
  void remove() async {
    if (fadeOut) {
      _wrapperKey?.currentState?.hide();
      await Future.delayed(fadeOutDuration);
    }
    super.remove();
  }

  ZwapTutorialOverlayEntry({
    required GlobalKey<_ZwapTutorialOverlayWrapperState> uniqueKey,
    this.fadeOut = true,
    this.fadeOutDuration = const Duration(milliseconds: 350),
    required WidgetBuilder builder,
    bool maintainState = false,
    bool opaque = false,
  }) : super(
          builder: fadeOut
              ? (_) => _ZwapTutorialOverlayWrapper(
                    key: uniqueKey,
                    builder: builder,
                    fadeDuration: fadeOutDuration,
                  )
              : builder,
          maintainState: maintainState,
          opaque: opaque,
        ) {
    _wrapperKey = uniqueKey;
  }
}
