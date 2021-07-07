/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The referral card state
class ReferralCardState extends ChangeNotifier{

  /// The email input to share zwap
  String email = "";

  /// Changing email inside this input
  void changeEmail(String email){
    this.email = email;
    notifyListeners();
  }

}

/// The referral card to share Zwap
class ReferralCard extends StatelessWidget{

  /// The callBack to send email to invite any person on Zwap
  final Function() sendEmailCallback;

  /// The referral url to copy and share
  final String referralUrl;

  ReferralCard({Key? key,
    required this.sendEmailCallback,
    required this.referralUrl
  }): super(key: key);  
  
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      childComponent: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 5),
              child: BaseText(
                texts: [Utils.translatedText("buildZwapWithUs")],
                baseTextsType: [BaseTextType.title],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 20),
              child: BaseText(
                texts: [Utils.translatedText("buildZwapWithUsSubTitle")],
                baseTextsType: [BaseTextType.subTitle],
                textsColor: [DesignColors.greyPrimary],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Consumer<ReferralCardState>(
                      builder: (builder, provider, child){
                        return BaseInput(
                          inputType: InputType.inputText,
                          placeholderText: "",
                          changeValue: (dynamic value) => provider.changeEmail(value),
                          validateValue: (dynamic value) => Utils.validateRegex(Constants.emailRegex, value),
                        );
                      }
                  ),
                  BaseButton(
                      buttonText: Utils.translatedText("sendInvite"),
                      buttonTypeStyle: ButtonTypeStyle.continueButton,
                      onPressedCallback: () => this.sendEmailCallback()
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: DesignColors.blackPrimary,
                        width: 1
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: BaseText(
                        texts: [this.referralUrl],
                        baseTextsType: [BaseTextType.normal],
                      ),
                    ),
                  ),
                  BaseButton(
                      buttonText: Utils.translatedText("copyInviteButton"),
                      buttonTypeStyle: ButtonTypeStyle.continueButton,
                      onPressedCallback: () => Utils.copy(this.referralUrl)
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}