/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL COMPONENTS
import 'delegates/zwapSliverGridDelegate.dart';

/// The grid view for a list of widgets
class ZwapGridView<T> extends StatelessWidget{

  /// The list of widgets to rendering inside this view
  final List<T> children;

  /// Final elements per row
  final int maxElementsPerRow;

  /// The function to get the child widget from the list of children elements
  final Widget Function(T element) getChildWidget;

  /// The max height for this grid view
  final double maxHeight;

  /// The controller for this grid view scroll
  final ScrollController? controller;

  /// An optionally max width for this grid view element
  final double? maxWidth;

  ZwapGridView({Key? key,
    required this.children,
    required this.maxElementsPerRow,
    required this.maxHeight,
    required this.getChildWidget,
    this.controller,
    this.maxWidth
  }): super(key: key);

  Widget build(BuildContext context) {
    return GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: children.length,
        shrinkWrap: true,
        controller: this.controller,
        gridDelegate: new ZwapSliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
          crossAxisCount: this.maxElementsPerRow,
          height: this.maxHeight,
          width: this.maxWidth,
        ),
        itemBuilder: (context, index){
          T itemData = children[index];
          return this.getChildWidget(itemData);
        }
    );
  }


}