/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/base.dart';

/// The custom app bar to show in the application
class CustomAppBar extends PreferredSize {

  /// The custom child inside this custom app bar
  final Widget child;

  CustomAppBar({Key? key,
    required this.child,
  }): super(key: key,
      child: child,
      preferredSize: Size.fromHeight(60)
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignColors.scaffoldColor,
      alignment: Alignment.topLeft,
      child: child,
    );
  }
}