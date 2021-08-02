/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:zwap_utils/zwap_utils.dart';


/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/inputs/inputs.dart';
import 'package:zwap_design_system/base/labelWidget/zwapLabelWidget.dart';
import 'package:zwap_design_system/base/dropDowns/dropdowns.dart';

import 'models.dart';

/// Handle state for the dynamic question component with the provider
class ZwapQuestionState extends ChangeNotifier{

  /// Custom body data in base of the answers
  final Map<String, dynamic> bodyData = {};

  /// The list of the profile questions to render dynamic question inside the component
  final List<ProfileQuestions> profileQuestions;

  ZwapQuestionState({required this.profileQuestions});

  /// Handle changes inside this component
  void handleChanges(String key, dynamic newData){
    this.bodyData[key] = newData;
    notifyListeners();
  }

  /// It builds a question mapping with dropDown state
  Map<String, ZwapDropDownState> questionsMapping(){
    Map<String, ZwapDropDownState> questionsMapping = {};
    this.profileQuestions.forEach((element) {
      if(element.questionOne.questionType == QuestionType.InputDropdown){
        questionsMapping[element.questionOne.questionTitleValue] = ZwapDropDownState();
      }
      if(element.questionTwo != null && element.questionTwo!.questionType == QuestionType.InputDropdown){
        questionsMapping[element.questionTwo!.questionTitleValue] = ZwapDropDownState();
      }
    });
    return questionsMapping;
  }

  /// It gets the body values
  Map<String, dynamic> getBodyValues(){
    Map<String, dynamic> tmp = {};
    this.questionsMapping().forEach((key, value) {
      tmp[key] = value.dropdownValue;
    });
    this.bodyData.addAll(tmp);
    return this.bodyData;
  }

  /// It adds multi provider as many as question dropdowns
  List<SingleChildWidget> getMultiProviders(){
    List<SingleChildWidget> multiProviders = [];
    Map<String, ZwapDropDownState> mappings = this.questionsMapping();
    mappings.forEach((key, value) {
      multiProviders.add(
        ChangeNotifierProvider<ZwapDropDownState>(
          create: (_) => value,
        )
      );
    });
    return multiProviders;
  }

}

/// Custom widget to display the edit profile card
class ZwapQuestion extends StatelessWidget{

  /// Check if the current dynamic question has a validator function or not
  bool _hasValidator(QuestionElement questionElement){
    return questionElement.questionType != QuestionType.InputDropdown && questionElement.regexValidate != null;
  }

  /// Validate input
  bool validateInput(dynamic value, QuestionElement questionElement){
      if(this._hasValidator(questionElement)){
        return Utils.validateRegex(questionElement.regexValidate!, value);
      }
      return true;
  }

  /// Define a const padding inside this form input
  EdgeInsets _constPadding(){
    return EdgeInsets.symmetric(horizontal: 10);
  }

  /// Retrieve the question question element and the type of the widget to insert the data into this form based on the question type
  Widget _getQuestionType(QuestionElement questionElement, ZwapQuestionState provider){
    TextEditingController controller = TextEditingController();
    controller.addListener(() {
      provider.handleChanges(questionElement.questionTitleValue, controller.text);
    });
    bool hasValidator = this._hasValidator(questionElement);
    switch(questionElement.questionType){
      case QuestionType.InputNumber:
        return Padding(
          padding: this._constPadding(),
          child: ZwapInput(
            hasValidatorIcon: hasValidator,
            handleValidation: (dynamic value) => hasValidator ? this.validateInput(value, questionElement) : null,
            placeholderText: questionElement.questionPlaceholder,
            inputType: ZwapInputType.inputNumber,
            controller: controller,
          ),
        );
      case QuestionType.InputDropdown:
        return Padding(
          padding: this._constPadding(),
          child: ChangeNotifierProvider<ZwapDropDownState>(
            create: (_) => provider.questionsMapping()[questionElement.questionTitleValue]!,
            builder: (builder, child){
              return ZwapDropDown(
                values: questionElement.questionOptions!,
                defaultValue: questionElement.questionDefaultValue,
              );
            }
          ),
        );
      case QuestionType.InputArea:
        return Padding(
          padding: this._constPadding(),
          child: ZwapInput(
            hasValidatorIcon: hasValidator,
            handleValidation: (dynamic value) => hasValidator ? this.validateInput(value, questionElement) : null,
            inputType: ZwapInputType.inputArea,
            maxLines: 3,
            placeholderText: questionElement.questionPlaceholder,
            controller: controller,
          ),
        );
      default:
        return Padding(
          padding: this._constPadding(),
          child: ZwapInput(
            hasValidatorIcon: hasValidator,
            handleValidation: (dynamic value) => hasValidator ? this.validateInput(value, questionElement) : null,
            inputType: ZwapInputType.inputArea,
            placeholderText: questionElement.questionPlaceholder,
            controller: controller,
          ),
        );
    }
  }

  /// It plots the widget for current question inside the iterate loop
  Widget _getCurrentQuestion(ProfileQuestions profileQuestions, ZwapQuestionState provider){
    List<Widget> tmp = [];
    Widget questionOne = Expanded(
      child: ZwapLabelWidget(labelText: profileQuestions.questionOne.questionTitle,
          paddingInside: this._constPadding(),
          childComponent: this._getQuestionType(profileQuestions.questionOne, provider)),
    );
    tmp.add(questionOne);
    if(profileQuestions.questionTwo != null){
      Widget questionTwo = Expanded(
        child: ZwapLabelWidget(labelText: profileQuestions.questionTwo!.questionTitle,
            paddingInside: this._constPadding(),
            childComponent: this._getQuestionType(profileQuestions.questionTwo!, provider)),
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
    ZwapQuestionState provider = context.read<ZwapQuestionState>();
    return MultiProvider(
      providers: provider.getMultiProviders(),
      child: Column(
        children: [
          for (var i = 0; i < provider.profileQuestions.length; i++) this._getCurrentQuestion(provider.profileQuestions[i], provider),
        ],
      ),
    );
  }

}