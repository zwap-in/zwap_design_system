import 'package:flutter/cupertino.dart';
import 'package:zwap_design_system/assembled/widgets/cards/baseComplete/baseComplete.dart';
import 'package:zwap_design_system/base/base.dart';
import 'package:zwap_design_system/translations/translations.dart';

class EditInterests extends StatelessWidget{

  final Function() backButtonCallBack;

  final Function() continueButtonCallBack;

  EditInterests({Key? key,
    required this.backButtonCallBack,
    required this.continueButtonCallBack
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseComplete(
        childrenWidget: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: BaseText(
              texts: [],
              baseTextsType: [BaseTextType.title],
              textsColor: [DesignColors.pinkyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 30),
            child: BaseText(
              texts: [],
              baseTextsType: [BaseTextType.subTitle],
              textsColor: [DesignColors.greyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: BaseText(
              texts: [],
              baseTextsType: [BaseTextType.title],
              textsColor: [DesignColors.pinkyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: BaseInput(
              inputType: InputType.inputArea,
              maxLines: 5,
              placeholderText: LocalizationClass.of(context).dynamicValue("wantTalkExamplePlaceholder"),
              changeValue: (value) => {},
              validateValue: (value) {
                return true;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: BaseText(
              texts: [],
              baseTextsType: [BaseTextType.title],
              textsColor: [DesignColors.pinkyPrimary],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: BaseInput(
              inputType: InputType.inputArea,
              maxLines: 5,
              placeholderText: LocalizationClass.of(context).dynamicValue("lookingForExamplePlaceholder"),
              changeValue: (value) => {},
              validateValue: (value) {
                return true;
              },
            ),
          ),
        ],
        backButtonCallBack: () => this.backButtonCallBack(),
        continueButtonCallBack: () => this.continueButtonCallBack()
    );
  }



}