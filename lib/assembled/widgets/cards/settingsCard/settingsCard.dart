/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taastrap/taastrap.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom widget to display the settings inside a card
class SettingsCard extends StatelessWidget{

  /// The settings list to display inside this card dynamically
  final List<SettingElement> settingsList;

  /// The callBack function to handle any social connections
  final Function(String name)? socialConnect;

  SettingsCard({Key? key,
    required this.settingsList,
    this.socialConnect,
  }): super(key: key);


  /// It retrieves the right element to insert into this settings card
  Widget _retrieveRightElement(SettingElement element, BuildContext context){
    switch(element.settingsType){
      case SettingsType.SettingsInputText:
        return BaseInput(
            placeholderText: "",
            changeValue: (dynamic value) {},
            inputType: InputType.inputText,
            validateValue: (dynamic value) {
              return true;
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
                  onPressedCallback: () => this.socialConnect!("google")
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: BaseButton(
                  buttonText: LocalizationClass.of(context).dynamicValue("connectToLinkedin"),
                  imagePath: "assets/images/socials/linkedin.png",
                  buttonTypeStyle: ButtonTypeStyle.socialButtonLinkedin,
                  onPressedCallback: () => this.socialConnect!("linkedin")
              ),
            )
          ],
        );
      case SettingsType.SettingsSwitch:
        return ChangeNotifierProvider<CustomSwitchState>(
          create: (context) => CustomSwitchState(value: false),
          child: Consumer<CustomSwitchState>(
            builder: (context, provider, child){
              return CustomSwitch(provider: provider);
            }
          )
        );
      case SettingsType.SettingsInputNumber:
        return BaseInput(
            placeholderText: "",
            changeValue: (dynamic value) {},
            inputType: InputType.inputNumber,
            validateValue: (dynamic value) {
              return true;
            }
        );
      case SettingsType.SettingsDropDown:
        return CustomDropDown(
          handleChange: (String value) {  },
          values: element.settingsOptions!,
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

    List<Widget> _children = this._settingsListForm(context);
    _children.add(
        BottomButtons(
            continueButtonText: LocalizationClass.of(context).dynamicValue("saveButton"),
            rightButtonIcon: Icons.group_add_sharp,
            continueButtonCallBackFunction: () => {}
        )
    );

    return CustomCard(
        childComponent: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0 * _deviceType, vertical: 40),
          child: Column(
            children: _children,
          ),
        )
    );
  }

}