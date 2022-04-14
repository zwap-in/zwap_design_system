import 'package:flutter/material.dart';

class ZwapTutorialOverlayFocusWidget extends StatelessWidget {
  final Widget Function(BuildContext) childBuilder;

  const ZwapTutorialOverlayFocusWidget({required this.childBuilder, required Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: childBuilder);
  }
}
