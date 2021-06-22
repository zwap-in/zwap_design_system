import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:zwap_design_system/zwap_design_system.dart';

/// The profile header inside any profile card
class ProfileHeader extends StatelessWidget{

  /// The image asset inside the profile header
  final String imageAsset;

  /// The profile url to share
  final String profileUrl;

  ProfileHeader({Key? key,
    required this.imageAsset,
    required this.profileUrl,
  }): super(key: key);

  /// The custom callBack function to share the profile url
  void _shareProfile(){
    print("SHARE");
  }

  /// The custom callBack function to activate the notifications on the profile
  void _activateAlert(){
    print("BELL");
  }

  /// The custom callBack function to ask an intro to this profile
  void _askIntro(){
    print("INTRO");
  }

  @override
  Widget build(BuildContext context) {
    return BlueHeader(
      headerHeight: 150,
      childrenStack: [
        FractionalTranslation(
          translation: const Offset(1.0, 1.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: AvatarCircle(
              imagePath: this.imageAsset,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 50),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomIcon(
                            icon: FontAwesomeIcons.share,
                            callBackPressedFunction: () => this._shareProfile()
                        ),
                        CustomIcon(
                            icon: FontAwesomeIcons.bell,
                            callBackPressedFunction: () => this._activateAlert()
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Container(
                        width: 150,
                        child: BaseButton(
                          iconButton: Icons.group_add_sharp,
                          buttonText: LocalizationClass.of(context).dynamicValue('askIntro'),
                          onPressedCallback: () => this._askIntro(),
                          buttonTypeStyle: ButtonTypeStyle.pinkyButton,
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }


}