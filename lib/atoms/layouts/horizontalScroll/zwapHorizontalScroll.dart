/// IMPORTING THIRD PARTY LIBRARIES
import 'package:flutter/material.dart';

/// Widget to rendering any horizontal scroll which has inside a custom component
class ZwapHorizontalScroll extends StatelessWidget {

  /// The child component to render inside this horizontal scroll
  final Widget child;

  /// The scroll controller to handle the horizontal scroll externally
  final ScrollController? scrollController;

  ZwapHorizontalScroll({Key? key,
    required this.child,
    this.scrollController
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: this.child,
      controller: this.scrollController,
    );
  }
}
