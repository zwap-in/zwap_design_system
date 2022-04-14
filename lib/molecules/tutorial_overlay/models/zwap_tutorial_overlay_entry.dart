library zwap_tutorial_overlay_entry;

import 'package:flutter/material.dart';

part '../components/zwap_tutorial_overlay_wrapper.dart';

class ZwapTutorialOverlayEntry extends OverlayEntry {
  late final GlobalKey? _wrapperKey;

  final bool fadeOut;
  final Duration fadeOutDuration;

  @override
  void remove() async {
    if (fadeOut) {
      (_wrapperKey?.currentWidget as _ZwapTutorialOverlayWrapper?)?.hide();
      await Future.delayed(fadeOutDuration);
    }
    super.remove();
  }

  ZwapTutorialOverlayEntry({
    required GlobalKey uniqueKey,
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
