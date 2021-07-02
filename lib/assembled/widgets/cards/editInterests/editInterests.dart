/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';


/// Edit interests screen state
class EditInterestsState extends ChangeNotifier{

  /// Want talk value string
  String wantTalkValue = "";

  /// Looking for other value string
  String lookingForValue = "";

  /// Changing the want talk value state
  void changeWantTalk(String value){
    this.wantTalkValue = value;
    notifyListeners();
  }

  /// Change looking for value state
  void changeLookingFor(String value){
    this.lookingForValue = value;
    notifyListeners();
  }

}


/// Edit interests component
class EditInterests extends StatelessWidget{

  /// CallBack function for back button
  final Function() backButtonCallBack;

  /// CallBack function for continue button
  final Function() continueButtonCallBack;

  EditInterests({Key? key,
    required this.backButtonCallBack,
    required this.continueButtonCallBack
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    Utils.getIt.registerFactory(() => EditInterestsState());
    return BaseComplete(
        childrenWidget: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: BaseText(
              texts: [Utils.getIt<LocalizationClass>().dynamicValue("editInterestsTitle")],
              baseTextsType: [BaseTextType.title],
              textsColor: [DesignColors.pinkyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: BaseText(
              texts: [Utils.getIt<LocalizationClass>().dynamicValue("editInterestsSubTitle")],
              baseTextsType: [BaseTextType.subTitle],
              textsColor: [DesignColors.greyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: InputTag(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: BaseText(
              texts: [Utils.getIt<LocalizationClass>().dynamicValue("wantTalkTitle")],
              baseTextsType: [BaseTextType.title],
              textsColor: [DesignColors.pinkyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ProviderCustomer<EditInterestsState>(
              childWidget: (EditInterestsState provider){
                return BaseInput(
                  inputType: InputType.inputArea,
                  maxLines: 5,
                  placeholderText: Utils.getIt<LocalizationClass>().dynamicValue("wantTalkExamplePlaceholder"),
                  changeValue: (value) => provider.changeWantTalk(value),
                  validateValue: (value) {
                    return true;
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: BaseText(
              texts: [Utils.getIt<LocalizationClass>().dynamicValue("lookingForTitle")],
              baseTextsType: [BaseTextType.title],
              textsColor: [DesignColors.pinkyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ProviderCustomer<EditInterestsState>(
              childWidget: (EditInterestsState provider){
                return BaseInput(
                  inputType: InputType.inputArea,
                  maxLines: 5,
                  placeholderText: Utils.getIt<LocalizationClass>().dynamicValue("lookingForExamplePlaceholder"),
                  changeValue: (value) => provider.changeLookingFor(value),
                  validateValue: (value) {
                    return true;
                  },
                );
              },
            ),
          ),
        ],
        backButtonCallBack: () => this.backButtonCallBack(),
        continueButtonCallBack: () => this.continueButtonCallBack()
    );
  }



}