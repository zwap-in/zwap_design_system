/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

class MyApp extends StatelessWidget {

  MyApp({Key? key,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size){

      return MaterialApp(
        localizationsDelegates: [
          const LocalizationClassDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('it', ''),
        ],
        home: Container(),
      );
    });
  }
}



/// The main function to start the application
main() async{
  runApp(MyApp());
}

