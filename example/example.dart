import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

void main(){
  runApp(MyApp());
}



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size){
      Generic _generic = Generic(maxWith: size.maxWidth.toInt());

      Map<String, String> badges = {
        "shetech": "https://zwap.in/api/media/planting_CUcz4YN.png"
      };

      User _user = User(
          firstName: "Marco",
          lastName: "Rossi",
          customData: {
            "role": "CEO",
            "company": "zwap",
            "iceBreaker": "OK",
            "profileEfficiency": "0.96",
            "badges": badges,
            "city": "Roma",
            "invited_by": "Luigi Adornetto"
          },
          profileBio: "Bio uno",
          targetsData: [
            TargetData(
                targetName: "CIao",
                targetImage: "https://zwap.in/api/media/planting_CUcz4YN.png"
            ),
            TargetData(
                targetName: "CIaso",
                targetImage: "https://zwap.in/api/media/planting_CUcz4YN.png"
            ),
            TargetData(
                targetName: "CIwao",
                targetImage: "https://zwap.in/api/media/planting_CUcz4YN.png"
            ),
            TargetData(
                targetName: "CIdeao",
                targetImage: "https://zwap.in/api/media/planting_CUcz4YN.png"
            ),
          ],
          interests: [
            InterestData(
                category: "Uno",
                interests: ["dede", "eede", "www", "swsw"]
            ),
            InterestData(
                category: "Unod",
                interests: ["dedde", "eeded", "wwaw", "saswsw"]
            ),
            InterestData(
                category: "Unso",
                interests: ["deddde", "eesade", "wwssw", "sffwsw"]
            )
          ]
      );

      List<User> finals = [_user, _user, _user, _user, _user, _user];

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
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Welcome to Flutter'),
            ),
            body: VerticalScroll(
              childComponent: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child:                   ProfileCard(profileData: _user,
                    shareProfile: () => {},
                    activateNotifications: () => {},
                    editCustomInfo: () => {},
                    editStaticInfo: () => {},
                    showInviter: () => {},
                  ),),
                  Flexible(
                    child: Column(
                      children: [
                        FindCommon(userName: "Marco", cardWidth: 350),
                        SuggestedColumn(cardWidth: 350, users: finals, viewProfile: (){})
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}