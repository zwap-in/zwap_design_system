import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zwap_design_system/assembled/widgets/cards/meetings/scheduled/scheduledCard.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

void main(){
  runApp(MyApp());
}

class Prova extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    print(LocalizationClass.of(context).dynamicValue("viewProfileButton"));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Flutter'),
      ),
      body: VerticalScroll(
        childComponent: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
                child: Text(LocalizationClass.of(context).dynamicValue("viewProfileButton"))
            ),
          ],
        ),
      ),
    );
  }


}



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size){
      Generic _generic = Generic(maxWith: size.maxWidth.toInt());

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
        title: 'Welcome to Flutter',
        home: DeviceInherit(
          deviceType: _generic.deviceType(),
          child: Prova(),
        ),
      );
    });
  }
}