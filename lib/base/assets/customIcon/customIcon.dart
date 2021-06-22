/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {

  /// The icon inside this custom icon
  final IconData icon;

  /// The callBack pressed function
  final Function() callBackPressedFunction;

  final Color? iconColor;

  CustomIcon({Key? key,
    required this.icon,
    required this.callBackPressedFunction,
    this.iconColor
  }): super(key: key);


  Widget build(BuildContext context) {
    return IconButton(
      // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
        icon: Icon(this.icon),
        padding: EdgeInsets.zero,
        color: this.iconColor,
        iconSize: 18,
        alignment: Alignment.center,
        onPressed: () => this.callBackPressedFunction()
    );
  }
}