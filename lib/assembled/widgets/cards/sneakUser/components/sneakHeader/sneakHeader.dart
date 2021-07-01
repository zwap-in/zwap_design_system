/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The profile header inside any profile card
class SneakUserHeader extends StatelessWidget{

  /// The image asset inside the profile header
  final String imageAsset;

  /// Callback function to save any user in the bookmarks
  final Function()? savingUser;

  SneakUserHeader({Key? key,
    required this.imageAsset,
    required this.savingUser
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlueHeader(
      headerHeight: 150,
      childrenStack: [
        FractionalTranslation(
          translation: const Offset(0.0, 0.5),
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: AvatarCircle(
              imagePath: this.imageAsset,
            ),
          ),
        ),
        this.savingUser != null ?
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: CustomIcon(
                        icon: FontAwesomeIcons.heart,
                        iconColor: DesignColors.pinkyPrimary,
                        callBackPressedFunction: () => this.savingUser!()
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) : Container()
      ],
    );
  }


}