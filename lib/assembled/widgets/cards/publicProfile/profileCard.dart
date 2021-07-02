/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

import 'components/profileCard.dart';


/// Custom widget to render any profile info inside a custom card
class ProfileCard extends StatelessWidget{

  /// The user data
  final User profileData;

  /// A boolean flag to check if the user to show is the current logged user. Default = true
  final bool isCurrentProfile;

  /// The callBack function to share the profile url
  final Function() shareProfile;

  /// The callBack function to activate the notifications on the profile
  final Function() activateNotifications;

  /// The callBack function to ask some intro
  final Function()? askIntro;

  /// The callBack function to edit custom info
  final Function()? editCustomInfo;

  /// The callBack function to edit static info
  final Function()? editStaticInfo;

  /// The callBack function to show the inviter
  final Function()? showInviter;

  ProfileCard({Key? key,
    required this.profileData,
    required this.shareProfile,
    required this.activateNotifications,
    this.isCurrentProfile = true,
    this.askIntro,
    this.editCustomInfo,
    this.editStaticInfo,
    this.showInviter
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

  String? get _profileEfficiency => this.profileData.customData['profileEfficiency'];

  double get _profileEfficiencyValue => 0.0;

  String? get _iceBreaker => this.profileData.customData['iceBreaker'];

  /// It retrieves the header info
  Widget _headerInfo(){
    return Column(
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
        BaseInfo(customData: this.profileData.customData,
          editCustomData: this.editCustomInfo != null ? () => this.editCustomInfo!() : null,
          showInviter: this.profileData.customData.containsKey("invited_by") ? () => this.showInviter!() : null,
        ),
      ],
    );
  }

  /// It retrieves the static info
  Widget _bottomStaticInfo(){

    Map<String, Map<String, dynamic>> _finalBadges = this._getBadgesInfo();

    /// The default padding inside each widget inside the columns
    EdgeInsets _defaultPadding = EdgeInsets.only(top: 15, bottom: 15, right: 5, left: 5);

    return Column(
      children: [
        Padding(
          padding: _defaultPadding,
          child:  InterestsWidget(interestsList: this._getInterestsInfo()),
        ),
        this._iceBreaker != null ?
        Padding(
          padding: _defaultPadding,
          child: IceBreaker(iceBreakerValue: this._iceBreaker!),
        ) : Container(),
        Padding(
          padding: _defaultPadding,
          child: TargetsWidget(targetsMappingInfo: this._getTargetsInfo()),
        ),
        _finalBadges.keys.length > 0 ? Padding(
          padding: _defaultPadding,
          child: BadgesWidget(badgesMappingInfo:_finalBadges),
        ) : Container()
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    int _deviceType = Utils.getIt<Generic>().deviceType();

    return CustomCard(
      childComponent: Column(
        children: [
          ProfileHeader(
            imageAsset: '',
            askIntro: this.askIntro != null ? () => this.askIntro!() : null,
            shareProfile: () => this.shareProfile(),
            activateNotifications: () => this.activateNotifications(),
            isCurrentProfile: this.isCurrentProfile,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _deviceType * 20),
            child: Column(
              children: [
                this._headerInfo(),
                Utils.getIt<Generic>().deviceType() < 3 ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: ProfileEfficiency(percent: this._profileEfficiencyValue),
                ) : Container(),
                this._bottomStaticInfo()
              ],
            ),
          )
        ],
      ),
    );
  }

}