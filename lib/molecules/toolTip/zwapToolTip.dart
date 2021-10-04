/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// The toolTip component to rendering a toolTip message on hovering a component
class ZwapToolTip extends StatelessWidget{

  /// The toolTip message string
  final String toolTipMessage;

  /// The child widget for this toolTip component
  final Widget childWidget;

  ZwapToolTip({Key? key,
    required this.toolTipMessage,
    required this.childWidget
  }): super(key: key);

  Widget build(BuildContext context){
    return Tooltip(
      message: this.toolTipMessage,
      child: this.childWidget,
    );
  }

}