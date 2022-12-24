import 'dart:async';

import 'package:flutter/material.dart';

class EdgeNotifierScrollController extends ScrollController {
  bool _canNotify = true;

  final Function()? onEndReached;
  final Function()? onStartReached;

  /// If provided EndNotifierScrollController will wait until this duration is passed before call the callback again
  final Duration? delayDuration;

  EdgeNotifierScrollController({
    this.onEndReached,
    this.onStartReached,
    this.delayDuration,
    String? debugLabel,
    double initialScrollOffset = 0,
    bool keepScrollOffset = true,
  }) : super(
          debugLabel: debugLabel,
          initialScrollOffset: initialScrollOffset,
          keepScrollOffset: keepScrollOffset,
        ) {
    super.addListener(_notifyOnEndReached);
  }

  /// If scroll controller is at end calls [onEndReached]
  void _notifyOnEndReached() {
    if (!(hasClients && _canNotify)) return;

    if (position.atEdge) {
      if (offset != 0 && onEndReached != null)
        onEndReached!();
      else if (onStartReached != null) onStartReached!();

      if (delayDuration != null) {
        _canNotify = false;
        Future.delayed(delayDuration!, () => _canNotify = true);
      }
    }
  }
}
