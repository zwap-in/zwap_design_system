/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';

/// Custom loading spinner
class ZwapLoader extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignColors.scaffoldColor,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}