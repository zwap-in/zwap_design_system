/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/design/colors.dart';

/// Custom widget to render a checkbox
class CustomCheckbox extends StatelessWidget {

  /// Is this checkbox done?. Default = false
  final bool isDone;

  /// The custom done color. Default = DesignColors.greenPrimary
  final Color doneColor;

  /// The custom missing color. Default = DesignColors.greyPrimary
  final Color missingColor;

  /// The custom padding inside the container. Default = const EdgeInsets.only(top: 10, left: 29, bottom: 10, right: 5)
  final EdgeInsets circlePaddingContainer;

  /// The default done icon without checked status
  final Icon _doneIcon = Icon(
    Icons.check,
    size: 20.0,
    color: Colors.white,
  );

  CustomCheckbox({Key? key,
    this.isDone = false,
    this.doneColor = DesignColors.greenPrimary,
    this.missingColor = DesignColors.greyPrimary,
    this.circlePaddingContainer = const EdgeInsets.only(top: 10, left: 29, bottom: 10, right: 5)
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.circlePaddingContainer,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: this.isDone ? this.doneColor : this.missingColor
        ),
        child: this._doneIcon,
      ),
    );
  }

}