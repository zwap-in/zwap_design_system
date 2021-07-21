/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// custom dropdown widget to select some element from a list
class CustomDropDownState extends ChangeNotifier {

  /// The default value to display
  String? dropdownValue;

  /// Selecting new value from the dropdown widget
  void onChangeValue (String? value){
    this.dropdownValue = value!;
    notifyListeners();
  }

}

/// Description: the state for this current widget
class CustomDropDown extends StatelessWidget {

  /// The custom values to display inside this widget
  final List<String> values;

  /// The handle change callback to save the data selected
  final Function(String value) handleChange;

  /// The default value of this dropdown
  final String? defaultValue;

  CustomDropDown({Key? key,
    required this.values,
    required this.handleChange,
    this.defaultValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: DesignColors.greyPrimary), borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Consumer<CustomDropDownState>(
            builder: (builder, provider, child){
              return DropdownButton<String>(
                value: provider.dropdownValue ?? this.values.first,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 42,
                underline: SizedBox(),
                elevation: 16,
                isExpanded: true,
                onChanged: (String? value) => provider.onChangeValue(value),
                items: this.values.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: BaseText(
                      textAlignment: Alignment.centerLeft,
                      texts: [value],
                      baseTextsType: [BaseTextType.normal],
                    ),
                  );
                }).toList(),
              );
            }
          ),
        )
    );
  }
}
