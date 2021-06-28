/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Custom widget to display the edit profile card
class DynamicQuestion extends StatelessWidget{

  /// The profile data to edit
  final List<ProfileQuestions> profileQuestions;

  /// Custom callBack function to handle change value in edit profile
  final Function(String key, dynamic newValue) handleChangeValue;

  DynamicQuestion({Key? key,
    required this.profileQuestions,
    required this.handleChangeValue
  }): super(key: key);

  /// Validate input
  bool validateInput(dynamic value, QuestionElement questionElement){
      if(questionElement.questionType != QuestionType.InputDropdown && questionElement.regexValidate != null){
        return Utils.validateRegex(questionElement.regexValidate!, value);
      }
      return true;
  }

  /// Define a const padding inside this form input
  EdgeInsets _constPadding(){
    return EdgeInsets.symmetric(horizontal: 10);
  }

  /// Retrieve the question type and the type of the widget to insert the data into this form
  Widget _getQuestionType(QuestionElement questionElement){
    switch(questionElement.questionType){
      case QuestionType.InputNumber:
        return Padding(
          padding: this._constPadding(),
          child: BaseInput(
            placeholderText: questionElement.questionPlaceholder,
            changeValue: (dynamic value){
              this.handleChangeValue(questionElement.questionTitleValue, value);
            },
            validateValue: (dynamic value) => this.validateInput(value, questionElement),
            inputType: InputType.inputNumber,
          ),
        );
      case QuestionType.InputDropdown:
        return Padding(
          padding: this._constPadding(),
          child: CustomDropDown(
            values: questionElement.questionOptions!,
            defaultValue: questionElement.questionDefaultValue,
            handleChange: (String value) => this.handleChangeValue(questionElement.questionTitleValue, value),
          ),
        );
      case QuestionType.InputArea:
        return Padding(
          padding: this._constPadding(),
          child: BaseInput(
            changeValue: (dynamic value) => this.handleChangeValue(questionElement.questionTitleValue, value),
            inputType: InputType.inputArea,
            maxLines: 3,
            validateValue: (dynamic value) => this.validateInput(value, questionElement),
            placeholderText: questionElement.questionPlaceholder,
          ),
        );
      default:
        return Padding(
          padding: this._constPadding(),
          child: BaseInput(
            changeValue: (value) => this.handleChangeValue(questionElement.questionTitleValue, value),
            inputType: InputType.inputArea,
            validateValue: (dynamic value) => this.validateInput(value, questionElement),
            placeholderText: questionElement.questionPlaceholder,
          ),
        );
    }
  }

  /// Retrieve current question inside the edit profile form
  Widget _getCurrentQuestion(ProfileQuestions profileQuestions){
    List<Widget> tmp = [];
    Widget questionOne = Expanded(
      child: LabelWidget(labelText: profileQuestions.questionOne.questionTitle,
          paddingInside: this._constPadding(),
          childComponent: this._getQuestionType(profileQuestions.questionOne)),
    );
    tmp.add(questionOne);
    if(profileQuestions.questionTwo != null){
      Widget questionTwo = Expanded(
        child: LabelWidget(labelText: profileQuestions.questionTwo!.questionTitle,
            paddingInside: this._constPadding(),
            childComponent: this._getQuestionType(profileQuestions.questionTwo!)),
      );
      tmp.add(questionTwo);
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
      child: Row(children: tmp),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < this.profileQuestions.length; i++) this._getCurrentQuestion(this.profileQuestions[i]),
      ],
    );
  }

}