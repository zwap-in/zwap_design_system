/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The profile header inside any profile card
class ProfileHeader extends StatelessWidget{

  /// The image asset inside the profile header
  final String imageAsset;

  /// Custom callBack function to share the profile from the profile card
  final Function() shareProfile;

  /// Custom callBack to activate the notifications on this current profile
  final Function() activateNotifications;

  /// Is an external profile?
  final bool isCurrentProfile;

  /// Ask intro callBack if the profile is external
  final Function()? askIntro;

  ProfileHeader({Key? key,
    required this.imageAsset,
    required this.shareProfile,
    required this.activateNotifications,
    this.isCurrentProfile = true,
    this.askIntro
  }): super(key: key){
    if(this.isCurrentProfile){
      assert(this.askIntro == null, "Ask intro callBack must be null on current profile");
    }
    else{
      assert(this.askIntro != null, "Ask intro callBack must be not null on external profile");
    }
  }

  @override
  Widget build(BuildContext context) {

    int _deviceType = Utils.getIt<Generic>().deviceType();

    double horizontalPadding = 0.1 * _deviceType;

    return BlueHeader(
      headerHeight: 150,
      childrenStack: [
        FractionalTranslation(
          translation: Offset(horizontalPadding, 0.8),
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
                            callBackPressedFunction: () => this.shareProfile()
                        ),
                        CustomIcon(
                            icon: FontAwesomeIcons.bell,
                            callBackPressedFunction: () => this.activateNotifications()
                        ),
                      ],
                    ),
                  ),
                  !this.isCurrentProfile ? Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Container(
                        width: 150,
                        child: BaseButton(
                          iconButton: Icons.group_add_sharp,
                          buttonText: Utils.getIt<LocalizationClass>().dynamicValue('askIntro'),
                          onPressedCallback: () => this.askIntro!(),
                          buttonTypeStyle: ButtonTypeStyle.pinkyButton,
                        ),
                      )
                  ) : Container()
                ],
              ),
            ),
          ),
        )
      ],
    );
  }


}