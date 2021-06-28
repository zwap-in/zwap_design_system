/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The switch state extended to customize the change state and send the data to the custom callBack function
class ExtendSwitchState extends CustomSwitchState{

  /// The bool value for the switch component
  bool value;

  /// The setting element
  final String customTitleValue;

  /// The handle change callBack function
  Function(String key, dynamic value) handleChange;

  ExtendSwitchState({
    required this.value,
    required this.customTitleValue,
    required this.handleChange
  }) : super(value: value);

  /// Change the state inside this switch
  void changeState(bool value){
    this.handleChange(this.customTitleValue, value);
    super.changeState(value);
  }

}


/// Custom widget to display the settings inside a card
class SettingsCard extends StatelessWidget{

  /// The settings list to display inside this card dynamically
  final List<SettingElement> settingsList;

  /// The callBack function to handle the change inside the settings form
  final Function(String key, dynamic value) callBackChange;


  SettingsCard({Key? key,
    required this.settingsList,
    required this.callBackChange,
  }): super(key: key);


  /// It retrieves the right element to insert into this settings card
  Widget _retrieveRightElement(SettingElement element, BuildContext context){
    switch(element.settingsType){
      case SettingsType.SettingsInputText:
        return BaseInput(
            placeholderText: "",
            changeValue: (dynamic value) => this.callBackChange(element.settingsTitleValue, value),
            inputType: InputType.inputText,
            validateValue: (dynamic value) {
              return Utils.validateRegex(element.regexValidate!, value);
            }
        );
      case SettingsType.SettingsSocial:
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: BaseButton(
                  buttonText: LocalizationClass.of(context).dynamicValue("connectToGoogle"),
                  imagePath: "assets/images/socials/google.png",
                  buttonTypeStyle: ButtonTypeStyle.socialButtonGoogle,
                  onPressedCallback: () => this.callBackChange("social_google", true)
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: BaseButton(
                  buttonText: LocalizationClass.of(context).dynamicValue("connectToLinkedin"),
                  imagePath: "assets/images/socials/linkedin.png",
                  buttonTypeStyle: ButtonTypeStyle.socialButtonLinkedin,
                  onPressedCallback: () => this.callBackChange("social_linkedin", true)
              ),
            )
          ],
        );
      case SettingsType.SettingsSwitch:
        return ChangeNotifierProvider<ExtendSwitchState>(
          create: (context) => ExtendSwitchState(
              value: false,
              customTitleValue: element.settingsTitleValue,
              handleChange: this.callBackChange
          ),
          child: Consumer<ExtendSwitchState>(
            builder: (context, provider, child){
              return CustomSwitch(provider: provider);
            }
          )
        );
      case SettingsType.SettingsInputNumber:
        return BaseInput(
            placeholderText: "",
            changeValue: (dynamic value) => this.callBackChange(element.settingsTitleValue, value),
            inputType: InputType.inputNumber,
            validateValue: (dynamic value) {
              return Utils.validateRegex(element.regexValidate!, value);
            }
        );
      case SettingsType.SettingsDropDown:
        return CustomDropDown(
          handleChange: (String value) => this.callBackChange(element.settingsTitleValue, value),
          values: element.settingsOptions!,
        );
      case SettingsType.SettingsInputPassword:
        return BaseInput(
            placeholderText: "",
            changeValue: (dynamic value) => this.callBackChange(element.settingsTitleValue, value),
            inputType: InputType.inputPassword,
            validateValue: (dynamic value) {
              return Utils.validateRegex(element.regexValidate!, value);
            }
        );
    }
  }

  /// It retrieve the line setting
  Widget _retrieveSetting(SettingElement settingElement, BuildContext context){
    return LineSettings(
        title: settingElement.settingsTitle,
        subTitle: settingElement.settingsSubTitle,
        rightElement: this._retrieveRightElement(settingElement, context)
    );
  }

  /// Iterate each settings to display all the settings inside this card
  List<Widget> _settingsListForm(BuildContext context){
    List<Widget> finals = [];
    this.settingsList.forEach((SettingElement value) {
      finals.add(this._retrieveSetting(value, context));
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {

    int _deviceType = DeviceInherit.of(context).deviceType;

    return CustomCard(
        childComponent: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0 * _deviceType, vertical: 40),
          child: Column(
            children: this._settingsListForm(context),
          ),
        )
    );
  }

}