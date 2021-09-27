/// IMPORTING THIRD PARTY LIBRARIES
import 'package:flutter/material.dart';

/// Widget to rendering any horizontal scroll which has inside a custom component
class ZwapHorizontalScroll extends StatelessWidget {

  /// The child component to render inside this horizontal scroll
  final Widget child;

  ZwapHorizontalScroll({Key? key,
    required this.child
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: this.child,
    );
  }
}
