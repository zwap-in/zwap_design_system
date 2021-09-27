/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// Component to rendering the progress loader in case of any waiting situation
class ZwapWaiting extends StatelessWidget{

  Widget build(BuildContext context){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

}