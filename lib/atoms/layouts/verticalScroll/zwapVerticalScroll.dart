/// IMPORTING THIRD PARTY LIBRARIES
import 'package:flutter/material.dart';

/// Widget to rendering any vertical scroll which has inside a custom component
class ZwapVerticalScroll extends StatelessWidget {

  /// The child component to render inside this vertical scroll
  final Widget child;

  /// The scroll controller to handle the vertical scroll externally
  final ScrollController? scrollController;

  ZwapVerticalScroll({Key? key,
    required this.child,
    this.scrollController
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: this.child,
      controller: this.scrollController,
    );
  }
}
