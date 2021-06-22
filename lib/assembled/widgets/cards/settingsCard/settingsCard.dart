/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom widget to display the settings inside a card
class SettingsCard extends StatelessWidget{

  /// The settings list to display inside this card dynamically
  final List<SettingElement> settingsList;

  SettingsCard({Key? key,
    required this.settingsList
  }): super(key: key);


  /// It retrieves the right element to insert into this settings card
  Widget _retrieveRightElement(SettingElement element){
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
      case SettingsType.SettingsSocialGoogle:
        return BaseButton(
            buttonText: "",
            imagePath: "",
            buttonTypeStyle: ButtonTypeStyle.socialButtonGoogle,
            onPressedCallback: () => {}
        );
      case SettingsType.SettingsSocialLinkedin:
        return BaseButton(
            buttonText: "",
            imagePath: "",
            buttonTypeStyle: ButtonTypeStyle.socialButtonLinkedin,
            onPressedCallback: () => {}
        );
      case SettingsType.SettingsSwitch:
        return CustomSwitch(
          changeValue: (bool value) => {},
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
  Widget _retrieveSetting(SettingElement settingElement){
    return LineSettings(
        title: settingElement.settingsTitle,
        subTitle: settingElement.settingsSubTitle,
        rightElement: this._retrieveRightElement(settingElement)
    );
  }

  /// Iterate each settings to display all the settings inside this card
  List<Widget> _settingsListForm(){
    List<Widget> finals = [];
    this.settingsList.forEach((SettingElement value) {
      finals.add(this._retrieveSetting(value));
    });
    return finals;
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _children = this._settingsListForm();
    _children.add(
        BottomButtons(
            continueButtonText: LocalizationClass.of(context).dynamicValue("saveButton"),
            rightButtonIcon: Icons.group_add_sharp,
            continueButtonCallBackFunction: () => {}
        )
    );

    return CustomCard(
        childComponent: Padding(
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
          child: Column(
            children: _children,
          ),
        )
    );
  }

}