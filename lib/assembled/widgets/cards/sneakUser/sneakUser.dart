/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

import 'components/sneakHeader/sneakHeader.dart';

/// Custom card to show sneak peak info about user profile
class SneakUser extends StatelessWidget{

  /// The custom user to show info
  final User userInfo;

  /// Callback function to save in the bookmarks the user
  final Function() saveUser;

  /// Callback function to view the profile
  final Function() viewProfile;

  SneakUser({Key? key,
    required this.userInfo,
    required this.saveUser,
    required this.viewProfile,
  }): super(key: key);

  /// Retrieve the data from the custom data of the user to show
  dynamic _getCustomDataValue(String key){
    return this.userInfo.customData[key] ?? "";
  }

  @override
  Widget build(BuildContext context) {

    /// The device type in base of the current responsive sizes
    int _deviceType = DeviceInherit.of(context).deviceType;

    /// The optional role of the user
    String _role = this._getCustomDataValue("role");

    /// The optional company of the user
    String _company = this._getCustomDataValue("company");

    return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: InkWell(
        onTap: () => this.viewProfile(),
        child: CustomCard(
          cardWidth: _deviceType == 1 ? 500 : (_deviceType == 2 ? 300 : (_deviceType == 3 ? 290 : 350)),
          childComponent: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SneakUserHeader(imageAsset: this._getCustomDataValue("profilePic"), savingUser: () => this.saveUser(),),
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 5),
                child: BaseText(
                  texts: ["${this.userInfo.firstName} ${this.userInfo.lastName}"],
                  baseTextsType: [BaseTextType.title],
                ),
              ),
              _role != "" || _company != "" ? Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 10),
                child: BaseText(
                  texts: ["$_role ${_company != "" ? '@'+ _company: ''}"],
                  baseTextsType: [BaseTextType.normal],
                ),
              ) : Container(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: BaseText(
                  texts: ["${this.userInfo.profileBio}"],
                  baseTextsType: [BaseTextType.normal],
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: BaseButton(
                    buttonText: LocalizationClass.of(context).dynamicValue("viewProfileButton"),
                    buttonTypeStyle: ButtonTypeStyle.pinkyButton,
                    onPressedCallback: () => this.viewProfile(),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

}