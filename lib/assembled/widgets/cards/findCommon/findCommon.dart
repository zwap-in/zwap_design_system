/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';


/// Custom widget to show an email input with title and subtitle
class FindCommon extends StatelessWidget{

  /// The custom name to display inside this component
  final String userName;

  /// The email placeholder inside this widget. Default = test.email@gmail.com
  final String emailPlaceholder;

  /// The card width
  final double cardWidth;

  FindCommon({Key? key,
    required this.userName,
    required this.cardWidth,
    this.emailPlaceholder = "test.email@gmail.com",
  }): super(key: key);

  bool func(){
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        cardWidth: this.cardWidth,
        childComponent: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: BaseText(
                  texts: ["${Utils.getIt<LocalizationClass>().dynamicValue("findPeopleKnows")} ${this.userName}"],
                  baseTextsType: [BaseTextType.title],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: BaseText(
                  texts: [Utils.getIt<LocalizationClass>().dynamicValue("commonPeople")],
                  baseTextsType: [BaseTextType.subTitle],
                  textsColor: [DesignColors.greyPrimary],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: BaseInput(
                  buttonText: Utils.getIt<LocalizationClass>().dynamicValue('continueButton'),
                  changeValue: (value) {  },
                  validateValue: (value) => this.func(),
                  inputType: InputType.inputButton,
                  placeholderText: '',
                  baseInputButtonCallBack: () => {},
                ),
              )
            ],
          ),
        )
    );
  }


}