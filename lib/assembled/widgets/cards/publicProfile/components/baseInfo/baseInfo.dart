/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom widget to display base info of any profile
class BaseInfo extends StatelessWidget{

  /// The custom data to pass to this component
  final Map<String, dynamic> customData;

  /// A boolean flag to check if the user to show is the current logged user
  final bool isCurrentProfile;

  /// The callBack function to edit custom data
  final Function()? editCustomData;

  /// The callBack function to show the inviter
  final Function()? showInviter;

  BaseInfo({Key? key,
    required this.customData,
    this.isCurrentProfile = true,
    this.editCustomData,
    this.showInviter
  }): super(key: key){
    if(this.isCurrentProfile){
      assert(this.editCustomData != null, "Edit custom data callBack function could not be null on currentProfile flag");
    }
    else{
      assert(this.editCustomData == null, "Edit custom data callBack function must be null on currentProfile flag");
    }
    if(this.customData.containsKey("invited_by")){
      assert(this.showInviter != null, "Show inviter function callBack must be not null on invited by not null");
    }
    else{
      assert(this.showInviter == null, "Show inviter function callBack must be null on invited by null");
    }
  }

  /// It retrieves the custom data
  String _getCustomData(String key, String keyPlaceholder){
    return this.customData[key] ?? keyPlaceholder;
  }

  /// It checks if its possible to click on that text
  bool _canClickItem(String dynamicKey, dynamic dynamicData, BuildContext context){
    return this.isCurrentProfile && dynamicData == LocalizationClass.of(context).dynamicValue(dynamicKey);
  }


  Widget _getCityCompanyResponsive(BuildContext context){
    String cityData = this._getCustomData("city", LocalizationClass.of(context).dynamicValue("cityPlaceholder"));
    String roleData = this._getCustomData("role", LocalizationClass.of(context).dynamicValue("rolePlaceholder"));
    String companyData = this._getCustomData("company", LocalizationClass.of(context).dynamicValue("companyPlaceholder"));
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 5),
            child:  IconText(text: BaseText(
              texts: [cityData],
              baseTextsType: [BaseTextType.normal],
            ), icon: Icons.location_on_sharp,
                canClick: _canClickItem("cityPlaceholder", cityData, context) , callBackFunction: _canClickItem("cityPlaceholder", cityData, context) ? () => this.editCustomData!() : null),
          ),
          flex: 0,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 1),
            child: IconText(text: BaseText(
              texts: [roleData],
              baseTextsType: [BaseTextType.normal],
            ), icon: Icons.business, canClick: _canClickItem("rolePlaceholder", roleData, context) , callBackFunction: _canClickItem("rolePlaceholder", roleData, context) ? () => this.editCustomData!() : null ),
          ),
          flex: 0,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 1),
            child: IconText(text: BaseText(
              texts: [companyData],
              baseTextsType: [BaseTextType.normal],
            ), icon: Icons.alternate_email, canClick: _canClickItem("companyPlaceholder", companyData, context) , callBackFunction: _canClickItem("companyPlaceholder", companyData, context) ? () => this.editCustomData!() : null ),
          ),
          flex: 0,
        ),
      ],
    );
  }

  Widget _getSocialMeetingInfo(BuildContext context){
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 5),
            child: IconText(text: BaseText(
              texts: ["0", " Meeting"],
              baseTextsType: [BaseTextType.normal, BaseTextType.normal],
              textsColor: [DesignColors.bluePrimary, DesignColors.blackPrimary],
            ), icon: Icons.video_call, iconColor: DesignColors.bluePrimary,),
          ),
          flex: 0,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 1),
            child: IconText(text: BaseText(
              texts: [""],
              baseTextsType: [BaseTextType.normal, ],
            ), icon: FontAwesomeIcons.linkedinIn, iconColor: DesignColors.linkedinColor,),
          ),
          flex: 0,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 5),
            child: IconText(text: BaseText(
              texts: [""],
              baseTextsType: [BaseTextType.normal, ],
            ), icon: FontAwesomeIcons.twitter, iconColor: DesignColors.twitterColor,),
          ),
          flex: 0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: this._getCityCompanyResponsive(context),
        ),
        this.customData.containsKey("invited_by") ?
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [
              Flexible(
                child: IconText(text: BaseText(
                  texts: ["${LocalizationClass.of(context).dynamicValue("invitedByPlaceholder")}", " ${this.customData['invited_by']}"],
                  baseTextsType: [BaseTextType.normal, BaseTextType.normalBold],
                  textsColor: [DesignColors.blackPrimary, DesignColors.bluePrimary],
                  hasClick: [false, true],
                  callBacksClick: [null, () => this.showInviter!()],
                ), icon: FontAwesomeIcons.globe,),
                flex: 0,
              ),
            ],
          ),
        ) : Container(),
        Padding(
          padding: EdgeInsets.only(top: 5, bottom: 20),
          child: this._getSocialMeetingInfo(context)
        ),
      ],
    );
  }

}