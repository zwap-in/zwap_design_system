/// IMPORTING THIRD PARTY LIBRARIES
import 'package:flutter/material.dart';

/// Widget to rendering any vertical scroll which has inside a custom component
class ZwapVerticalScroll extends StatelessWidget {

  /// The child component to render inside this vertical scroll
  final Widget child;

  ZwapVerticalScroll({Key? key,
    required this.child
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: this.child,
    );
  }
}
