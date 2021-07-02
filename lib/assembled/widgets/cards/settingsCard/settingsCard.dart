/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The settings state
class SettingsState extends ChangeNotifier{

  /// The custom values inside this settings card
  final Map<String, dynamic> customValues = {};

  /// Changing custom values inside this state
  void changeValues(String key, dynamic value){
    this.customValues[key] = value;
    notifyListeners();
  }
}

/// Custom widget to display the settings inside a card
class SettingsCard extends StatelessWidget{

  /// The settings list to display inside this card dynamically
  final List<SettingElement> settingsList;

  final Function(String socialType) onSocialClick;


  SettingsCard({Key? key,
    required this.settingsList,
    required this.onSocialClick
  }): super(key: key);


  /// It retrieves the right element to insert into this settings card
  Widget _retrieveRightElement(SettingElement element, SettingsState provider){
    switch(element.settingsType){
      case SettingsType.SettingsInputText:
        return BaseInput(
            placeholderText: "",
            changeValue: (dynamic value) => provider.changeValues(element.settingsTitleValue, value),
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
                  buttonText: Utils.getIt<LocalizationClass>().dynamicValue("connectToGoogle"),
                  imagePath: "assets/images/socials/google.png",
                  buttonTypeStyle: ButtonTypeStyle.socialButtonGoogle,
                  onPressedCallback: () => this.onSocialClick("google")
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: BaseButton(
                  buttonText: Utils.getIt<LocalizationClass>().dynamicValue("connectToLinkedin"),
                  imagePath: "assets/images/socials/linkedin.png",
                  buttonTypeStyle: ButtonTypeStyle.socialButtonLinkedin,
                  onPressedCallback: () => this.onSocialClick("linkedin")
              ),
            )
          ],
        );
      case SettingsType.SettingsSwitch:
        return CustomSwitch(
          onChange: (bool value) => provider.changeValues(element.settingsTitleValue, value),
        );
      case SettingsType.SettingsInputNumber:
        return BaseInput(
            placeholderText: "",
            changeValue: (dynamic value) => provider.changeValues(element.settingsTitleValue, value),
            inputType: InputType.inputNumber,
            validateValue: (dynamic value) {
              return Utils.validateRegex(element.regexValidate!, value);
            }
        );
      case SettingsType.SettingsDropDown:
        return CustomDropDown(
          handleChange: (String value) => provider.changeValues(element.settingsTitleValue, value),
          values: element.settingsOptions!,
        );
      case SettingsType.SettingsInputPassword:
        return BaseInput(
            placeholderText: "",
            changeValue: (dynamic value) => provider.changeValues(element.settingsTitleValue, value),
            inputType: InputType.inputPassword,
            validateValue: (dynamic value) {
              return Utils.validateRegex(element.regexValidate!, value);
            }
        );
    }
  }

  /// It retrieve the line setting
  Widget _retrieveSetting(SettingElement settingElement, SettingsState provider){
    return LineSettings(
        title: settingElement.settingsTitle,
        subTitle: settingElement.settingsSubTitle,
        rightElement: this._retrieveRightElement(settingElement, provider)
    );
  }

  /// Iterate each settings to display all the settings inside this card
  List<Widget> _settingsListForm(SettingsState provider){
    List<Widget> finals = [];
    this.settingsList.forEach((SettingElement value) {
      finals.add(this._retrieveSetting(value, provider));
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {

    int _deviceType = Utils.getIt<Generic>().deviceType();

    return CustomCard(
        childComponent: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0 * _deviceType, vertical: 40),
          child: ProviderCustomer<SettingsState>(
            childWidget: (SettingsState provider){
              return Column(
                children: this._settingsListForm(provider),
              );
            }
          ),
        )
    );
  }

}