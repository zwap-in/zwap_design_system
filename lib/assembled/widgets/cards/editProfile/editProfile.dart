/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The edit profile card
class EditProfile extends StatelessWidget{

  /// The profile data to edit
  final List<ProfileQuestions> profileQuestions;

  /// The callBack function to handle change value
  final Function(String key, dynamic value) handleChangeValue;

  EditProfile({Key? key,
    required this.profileQuestions,
    required this.handleChangeValue
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
        childComponent: Padding(
          padding: EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              BlueHeader(
                  childrenStack: [
                    FractionalTranslation(
                      translation: const Offset(0.0, 0.5),
                      child: PickImage(),
                    )
                  ],
                  headerHeight: 80,
                  stackAlignment: AlignmentDirectional.center,
              ),
              Padding(
                padding: EdgeInsets.only(top: 80),
                child: DynamicQuestion(
                    profileQuestions: this.profileQuestions,
                    handleChangeValue: (String key, dynamic value) => this.handleChangeValue(key, value)
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 90),
                child: BottomButtons(
                  rightButtonIcon: Icons.group_add_sharp,
                  continueButtonCallBackFunction: () {  },
                  continueButtonText: Utils.translatedText('saveButton'),
                  backButtonText: Utils.translatedText('cancelButton'),
                  backButtonCallBackFunction: () {  },
                ),
              )
            ],
          ),
        )
    );
  }
}