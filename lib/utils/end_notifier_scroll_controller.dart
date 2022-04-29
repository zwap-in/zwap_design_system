import 'dart:async';

import 'package:flutter/material.dart';

class EndNotifierScrollController extends ScrollController {
  bool _canNotify = true;

  final Function() onEndReached;

  /// If provided EndNotifierScrollControler will wait until this duration is passed before call the callback again
  final Duration? delayDuration;

  EndNotifierScrollController({
    required this.onEndReached,
    this.delayDuration,
    String? debugLabel,
    double initialScrollOffset = 0,
    bool keepScrollOffset = true,
  }) : super(
          debugLabel: debugLabel,
          initialScrollOffset: initialScrollOffset,
          keepScrollOffset: keepScrollOffset,
        ) {
    super.addListener(_notifyOnEndReaced);
  }

  /// If scroll controller is at end calls [onEndReached]
  void _notifyOnEndReaced() {
    if (!(hasClients && _canNotify)) return;

    if (position.atEdge && offset != 0) {
      onEndReached();
      if (delayDuration != null) {
        _canNotify = false;
        Future.delayed(delayDuration!, () => _canNotify = true);
      }
    }
  }
}
