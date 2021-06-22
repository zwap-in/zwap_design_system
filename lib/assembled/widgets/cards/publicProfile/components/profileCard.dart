/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

import 'profileHeader/profileHeader.dart';
import 'badges/badges.dart';
import 'interests/interests.dart';
import 'targets/targets.dart';
import 'iceBreaker/iceBreaker.dart';
import 'baseInfo/baseInfo.dart';


/// Custom widget to render any profile info inside a custom card
class ProfileCard extends StatelessWidget{

  final User profileData;

  /// A boolean flag to check if the user to show is the current logged user. Default = true
  final bool isCurrentProfile;

  ProfileCard({Key? key,
    required this.profileData,
    this.isCurrentProfile = true,
  }): super(key: key);

  /// It builds the targets mapping info to pass to the targets component
  Map<String, Map<String, dynamic>> _getTargetsInfo(){
    Map<String, Map<String, dynamic>> info = {};
    this.profileData.targetsData.forEach((TargetData element) {
      info[element.targetName] = {
        'imagePath': element.targetImage,
        'internalInfo': false
      };
    });
    return info;
  }

  /// It builds the badges mapping info to pass to the badges component
  Map<String, Map<String, dynamic>> _getBadgesInfo(){
    Map<String, Map<String, dynamic>> info = {};
    Map<String, String>? tmpMap = this.profileData.customData["badges"];
    if(tmpMap != null){
      tmpMap.keys.forEach((String element) {
        info[element] = {
          'imagePath': this.profileData.customData['badges']![element],
          'internalInfo': false
        };
      });
    }
    return info;
  }

  /// It build the interests list info to pass to the interests component
  List<String> _getInterestsInfo(){
    List<String> info = [];
    this.profileData.interests.forEach((InterestData element) {
      element.interests.forEach((String tmp) {
        info.add(tmp);
      });
    });
    return info;
  }

  String? _profileEfficiency(){
    return this.profileData.customData['profileEfficiency'];
  }


  @override
  Widget build(BuildContext context) {

    Map<String, Map<String, dynamic>> _finalBadges = this._getBadgesInfo();

    /// The default padding inside each widget inside the columns
    EdgeInsets _defaultPadding = EdgeInsets.only(top: 15, bottom: 15, right: 5, left: 5);

    return CustomCard(
      childComponent: Column(
        children: [
          ProfileHeader(profileUrl: '', imageAsset: '',),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 15, right: 10, left: 10),
                  child: BaseText(
                    texts: ["${this.profileData.firstName} ${this.profileData.lastName}"],
                    baseTextsType: [BaseTextType.title],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10, left: 10, top: 15, bottom: 15),
                  child: BaseText(
                    texts: ["${this.profileData.profileBio}"],
                    baseTextsType: [BaseTextType.normalBold],
                  ),
                ),
                BaseInfo(customData: this.profileData.customData),
                DeviceInherit.of(context).deviceType < 3 ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: ProfileEfficiency(percent: this._profileEfficiency() != null ?
                  int.tryParse(this._profileEfficiency()!)!.toDouble() : 0
                  , cardWidth: 350,),
                ) : Container(),
                Padding(
                  padding: _defaultPadding,
                  child:  InterestsWidget(interestsList: this._getInterestsInfo()),
                ),
                Padding(
                  padding: _defaultPadding,
                  child: IceBreaker(iceBreakerValue: this.profileData.customData['iceBreaker']!),
                ),
                Padding(
                  padding: _defaultPadding,
                  child: TargetsWidget(targetsMappingInfo: this._getTargetsInfo()),
                ),
                _finalBadges.keys.length > 0 ? Padding(
                  padding: _defaultPadding,
                  child: BadgesWidget(badgesMappingInfo:_finalBadges),
                ) : Container()
              ],
            ),
          )
        ],
      ),
    );
  }

}