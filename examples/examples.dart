/// IMPORTING THIRD PARTY PACKAGES
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taastrap/taastrap.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

class Prova extends ImagePickerState{

  @override
  Future getImage() async{
    await super.getImage();
  }
}

class Taa extends CustomBottomMenuState{

  @override
  void changeIndex(int newIndex){
    super.changeIndex(newIndex);
    print("TAA");
  }
}


class DemoApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    Map<Tab, Widget> children = {};

    Map<Widget, Map<String, int>> tmp = {};
    User tmpUser = User(
      firstName: "Marco",
      lastName: "Rossi",
      profileBio: "Marco rossi è un bravo ragazzo",
      interests: [],
      targetsData: [],
      customData: {
        "role": "CEO",
        "company": "Zwap"
      }
    );
    SneakUser tmpSneak = SneakUser(userInfo: tmpUser, saveUser: (){});
    SneakUser tmpSneakOne = SneakUser(userInfo: tmpUser, saveUser: (){});
    SneakUser tmpSneakTwo = SneakUser(userInfo: tmpUser, saveUser: (){});
    SneakUser tmpSneakThree = SneakUser(userInfo: tmpUser, saveUser: (){});
    SneakUser tmpSneakFour = SneakUser(userInfo: tmpUser, saveUser: (){});
    SneakUser tmpSneakFive = SneakUser(userInfo: tmpUser, saveUser: (){});
    tmp[tmpSneak] = {'xl': 6, 'lg': 6, 'md': 6, 'sm': 6, 'xs': 12};
    tmp[tmpSneakOne] = {'xl': 6, 'lg': 6, 'md': 6, 'sm': 6, 'xs': 12};
    tmp[tmpSneakTwo] = {'xl': 6, 'lg': 6, 'md': 6, 'sm': 6, 'xs': 12};
    tmp[tmpSneakThree] = {'xl': 6, 'lg': 6, 'md': 6, 'sm': 6, 'xs': 12};
    tmp[tmpSneakFour] = {'xl': 6, 'lg': 6, 'md': 6, 'sm': 6, 'xs': 12};
    tmp[tmpSneakFive] = {'xl': 6, 'lg': 6, 'md': 6, 'sm': 6, 'xs': 12};

    children[Tab(
      child: BaseText(
        texts: ["Prova"],
        baseTextsType: [BaseTextType.normalBold],
        textAlignment: Alignment.center,
      ),
    )] = VerticalScroll(
      childComponent: ResponsiveRow(
        children: tmp,
      ),
    );

    children[Tab(
      child: BaseText(
        texts: ["Prova"],
        baseTextsType: [BaseTextType.normalBold],
        textAlignment: Alignment.center,
      ),
    )] = Icon(Icons.directions_car, size: 350,);
    
    return CustomTabBar(tabElements: children, appBar: CustomAppBar(
      child: Row(
        children: [
          Expanded(
            child: CustomIcon(
              callBackPressedFunction: (){},
              icon: Icons.settings,
            ),
          )
        ],
      ),
    ),
      customBottomMenu: ChangeNotifierProvider(
        create: (context) => CustomBottomMenuState(),
        child: Consumer<CustomBottomMenuState>(
          builder: (context, provider, child) {
            return CustomBottomMenu(bottomNavigationBarItems: [
              BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: "Ciao"),
              BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: "Ciao"),
              BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: "Ciao"),

            ], provider: provider);
          },
        ),
      ),
    );
  }
}

class ProvaTaa extends StatelessWidget{

  final int deviceType;

  ProvaTaa({Key? key,
    required this.deviceType

  });

  @override
  Widget build(BuildContext context) {
    return DeviceInherit(deviceType: this.deviceType, child: DemoApp(),);
  }



}


class MyApp extends StatelessWidget {

  MyApp({Key? key,
  }): super(key: key);

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
        home: ProvaTaa(deviceType: _generic.deviceType()),
      );
    });
  }
}



/// The main function to start the application
main() async{
  runApp(MyApp());
}

