/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The custom app bar to show in the application
class CustomAppBar extends PreferredSize {

  /// The custom child inside this custom app bar
  final Widget child;

  /// The custom height of the app bar
  final double height;

  /// The custom color app bar
  final Color? colorAppBar;

  /// The final alignment of the app nav bar. Default = Alignment.topLeft
  final Alignment alignment;

  CustomAppBar({Key? key,
    required this.child,
    required this.height,
    this.colorAppBar,
    this.alignment = Alignment.topLeft
  }): super(key: key,
      child: child,
      preferredSize: Size.fromHeight(height)
  );

  @override
  Widget build(BuildContext context) {

    /// The default app bar theme
    Color colorAppBarTheme = this.colorAppBar ?? Colors.white;

    return Container(
      color: colorAppBarTheme,
      alignment: this.alignment,
      child: child,
    );
  }
}