/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';

/// Custom widget to display a blue header inside any card
class ZwapHeader extends StatelessWidget{

  /// The children of the stack inside this blue header
  final List<Widget> childrenStack;

  /// The custom height of the blue header
  final double headerHeight;

  /// The stack alignment inside this stack header
  final AlignmentDirectional stackAlignment;

  ZwapHeader({Key? key,
    required this.childrenStack,
    required this.headerHeight,
    this.stackAlignment = AlignmentDirectional.topStart
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Container(
        color: DesignColors.blueHeader,
        height: this.headerHeight,
      )
    ];
    children.addAll(this.childrenStack);
    return Stack(
      alignment: this.stackAlignment,
      children: children,
    );
  }


}