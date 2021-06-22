/// IMPORTING THIRD PARTY LIBRARIES
import 'package:flutter/material.dart';

/// Widget to rendering any vertical scroll which has inside a custom component
class VerticalScroll extends StatelessWidget {

  /// The child component to render inside this vertical scroll
  final Widget childComponent;

  VerticalScroll({Key? key,
    required this.childComponent
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: this.childComponent,
    );
  }
}
