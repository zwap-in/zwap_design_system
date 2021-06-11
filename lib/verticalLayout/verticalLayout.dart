/// IMPORTING THIRD PARTY LIBRARIES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Widget to rendering any widget inside a scrollable container
class VerticalLayout extends StatelessWidget {

  /// The child component to show inside this layout
  final Widget childComponent;

  VerticalLayout({Key? key,
    required this.childComponent
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: this.childComponent,
    );
  }
}
