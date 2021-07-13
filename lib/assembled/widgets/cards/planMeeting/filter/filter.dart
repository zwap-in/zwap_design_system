/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// Dynamic filter in base of the current filter type
class NetworkFilter extends StatelessWidget{

  /// The network filter type
  final NetworkFilterElement networkFilter;

  /// Current value selected for the current filter
  final String currentValue;

  /// Changing value callBack for the current filter
  final Function(String value) changeValueCallBack;

  NetworkFilter({Key? key,
    required this.networkFilter,
    required this.currentValue,
    required this.changeValueCallBack
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    switch(this.networkFilter.filterType){
      case FilterType.inputText:
        return BaseInput(
          placeholderText: this.networkFilter.placeholder,
          changeValue: (dynamic value) => this.changeValueCallBack(value),
          inputType: InputType.inputText,
          validateValue: (value) {
            return true;
          },
        );
      case FilterType.inputDropDown:
        return CustomDropDown(
            values: this.networkFilter.filtersOptions,
            handleChange: (String value) => this.changeValueCallBack(value)
        );
      case FilterType.buttonSide:
        List<Widget> children = [];
        this.networkFilter.filtersOptions.forEach((element) {
          children.add(
            BaseButton(
                buttonText: element,
                buttonTypeStyle: element == currentValue ? ButtonTypeStyle.pinkyButton : ButtonTypeStyle.greyButton,
                onPressedCallback: () => this.changeValueCallBack(element)
            )
          );
        });
        return Row(
          children: children,
        );
    }
  }



}