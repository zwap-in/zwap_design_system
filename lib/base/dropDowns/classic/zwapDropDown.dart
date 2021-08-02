/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';
import 'package:zwap_design_system/base/text/zwapText.dart';

/// The dropdown type
enum DropDownType{
  rowDropDown,
  classicDropDown
}

/// custom dropdown widget to select some element from a list
class ZwapDropDownState extends ChangeNotifier {

  /// The default value to display
  String? dropdownValue;

  /// Selecting new value from the dropdown widget
  void onChangeValue (String? value){
    this.dropdownValue = value!;
    notifyListeners();
  }

}

/// Description: the state for this current widget
class ZwapDropDown extends StatelessWidget {

  /// The custom values to display inside this widget
  final List<String> values;

  /// The default value of this dropdown
  final String? defaultValue;

  /// The dropdown type
  final DropDownType dropDownType;

  /// The dropdown widget in case of DropDownType.rowDropDown
  final Widget Function(dynamic value)? dropDownWidget;

  ZwapDropDown({Key? key,
    required this.values,
    this.defaultValue,
    this.dropDownType = DropDownType.classicDropDown,
    this.dropDownWidget
  }) : super(key: key){
    if(this.dropDownType == DropDownType.rowDropDown){
      assert(this.dropDownWidget != null, "On Row Dropdown dropDownWidget must be not null");
    }
    else{
      assert(this.dropDownWidget == null, "On classic Dropdown dropDown widget must be null");
    }
  }

  /// Plotting the classic element inside the standard dropdown
  Widget plotClassicElement(dynamic value){
    return ZwapText(
      textAlignment: Alignment.centerLeft,
      texts: [value],
      baseTextsType: [ZwapTextType.normal],
    );
  }

  /// Plotting the dropdown elements in base of the dropdown type
  Widget plotDropDownElement(dynamic value){
    switch(this.dropDownType){
      case DropDownType.classicDropDown:
        return this.plotClassicElement(value);
      case DropDownType.rowDropDown:
        return Row(
          children: [
            Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: this.dropDownWidget!(value),
                ),
              flex: 0,
            ),
            Expanded(
              child: this.plotClassicElement(value),
            )
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: DesignColors.greyPrimary), borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<ZwapDropDownState>(
            builder: (builder, provider, child){
              return SizedBox(
                width: 150,
                child: DropdownButton<String>(
                  value: provider.dropdownValue ?? this.values.first,
                  iconSize: 42,
                  underline: SizedBox(),
                  elevation: 16,
                  isExpanded: true,
                  onChanged: (String? value) => provider.onChangeValue(value),
                  items: this.values.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: this.plotDropDownElement(value),
                    );
                  }).toList(),
                ),
              );
            }
          ),
        )
    );
  }
}
