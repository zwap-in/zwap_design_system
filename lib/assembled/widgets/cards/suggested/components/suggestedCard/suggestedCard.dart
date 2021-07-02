/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';


/// Custom card to retrieve info about any suggested profile
class SuggestedCard extends StatelessWidget{

  /// The profile data about any suggested user
  final User profileData;

  /// Custom callBack to go to view the profile suggested
  final Function() viewProfile;

  /// Flag to show this custom component inside a card
  final bool isCard;

  SuggestedCard({Key? key,
    required this.profileData,
    required this.viewProfile,
    this.isCard = true,
  }): super(key: key);

  /// The user's role
  String get _role => this.profileData.customData['role'] != null ? this.profileData.customData['role'] : "";

  /// The user's company
  String get _company => this.profileData.customData['company'] != null ? "@${this.profileData.customData['company']}" : "";

  /// The user's profile pic
  String get _profilePic => this.profileData.customData['profilePic'] != null ? this.profileData.customData['profilePic'] : "";

  Widget _container(Widget child){
    return this.isCard ? CustomCard(
      childComponent: child,
    ): Container(
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return this._container(Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Flexible(
            child: AvatarCircle(imagePath: this._profilePic),
            flex: 0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  texts: ["${this.profileData.firstName} ${this.profileData.lastName}"],
                  baseTextsType: [BaseTextType.title],
                ),
                BaseText(
                  texts: ["${this._role} ${this._company}"],
                  baseTextsType: [BaseTextType.normal],
                  textsColor: [DesignColors.greyPrimary],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: BaseButton(
                    buttonText: Utils.getIt<LocalizationClass>().dynamicValue("viewProfileButton"),
                    buttonTypeStyle: ButtonTypeStyle.pinkyButton,
                    onPressedCallback: () => this.viewProfile(),
                  ),
                )
              ],
            ),
            flex: 0,
          )
        ],
      ),
    ));
  }

}