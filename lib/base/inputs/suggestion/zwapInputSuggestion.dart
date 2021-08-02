/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/inputs/classic/zwapInput.dart';

/// Custom widget to display custom input with suggestion elements
class ZwapInputSuggestion extends StatelessWidget{

  /// The suggested list
  final List<String> suggestion;

  /// Text editing controller to handle this input text
  final TextEditingController controller;

  ZwapInputSuggestion({Key? key,
    required this.suggestion,
    required this.controller,
  }): super(key: key);

  Widget _getInputText(BuildContext context, TextEditingController controller, FocusNode focusNode, VoidCallback onFieldSubmitted){
    return ZwapInput(
      inputType: ZwapInputType.inputText,
      placeholderText: '',
      controller: controller,
      focusNode: focusNode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      fieldViewBuilder: _getInputText,
      displayStringForOption: (String value) => value,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return this.suggestion.where((String element) =>
            element.toLowerCase().contains(textEditingValue.text.toLowerCase())
        ).toList();
      },
      onSelected: (String selection) {

      },
    );
  }
}