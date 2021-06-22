/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom widget to render a circle checkbox
class CustomCheckbox extends StatelessWidget {

  /// Is this checkbox done?. Default = false
  final bool isDone;

  CustomCheckbox({Key? key,
    this.isDone = false,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: this.isDone ? DesignColors.greenPrimary : DesignColors.greyPrimary
      ),
      child: Icon(
        Icons.check,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

}