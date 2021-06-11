/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Custom loading spinner
class LoadingSpinner extends StatelessWidget{

  /// The background color of the container of the spinner
  final Color backgroundContainerSpinner;

  LoadingSpinner({Key? key,
    this.backgroundContainerSpinner = Colors.white
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: this.backgroundContainerSpinner,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }



}