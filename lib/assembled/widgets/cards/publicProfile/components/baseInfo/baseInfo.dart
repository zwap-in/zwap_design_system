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

  BaseInfo({Key? key,
    required this.customData,
    this.isCurrentProfile = true,
  }): super(key: key);

  /// Go to edit profile data
  void _callBackFunction(){
    /// TODO check if is current profile
  }

  /// It retrieves the custom data
  String _getCustomData(String key, String keyPlaceholder){
    return this.customData[key] ?? keyPlaceholder;
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
            child:  IconText(text: cityData, icon: Icons.location_on_sharp, canClick: cityData == LocalizationClass.of(context).dynamicValue("cityPlaceholder"), ),
          ),
          flex: 0,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 1),
            child: IconText(text: roleData, icon: Icons.group_add, canClick: roleData == LocalizationClass.of(context).dynamicValue("rolePlaceholder"), ),
          ),
          flex: 0,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 1),
            child: IconText(text: companyData, icon: Icons.group_add, canClick: companyData == LocalizationClass.of(context).dynamicValue("companyPlaceholder"), ),
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
            child: BaseText(
              texts: [this._getCustomData("nMeetings", "0"), " meetings"],
              baseTextsType: [BaseTextType.normal, BaseTextType.normal],
              textsColor: [DesignColors.bluePrimary, DesignColors.blackPrimary],
            ),
          ),
          flex: 0,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 1),
            child: IconText(text: "", icon: FontAwesomeIcons.linkedinIn),
          ),
          flex: 0,
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 5),
            child: IconText(text: "", icon: FontAwesomeIcons.twitter),
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
                child: IconText(text: "${LocalizationClass.of(context).dynamicValue("invitedByPlaceholder")} ${this.customData['invited_by']}", icon: Icons.insert_invitation,),
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