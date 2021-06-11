/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:zwap_design_system/design/colors.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/design/text.dart';

/// custom dropdown widget to select some element from a list
class CustomDropDown extends StatefulWidget {

  /// The custom values to display inside this widget
  final List<String> values;

  /// The default value of this dropdown
  final String? defaultValue;

  /// The icon size of this custom dropdown. Default = 42
  final double iconSize;

  /// The elevation size of the text of this custom DropDown. Default = 16
  final int elevationSize;

  /// The border radius of this custom dropdown. Default = 4
  final double radiusDropdown;

  /// The custom border color of this custom dropdown. Default = DesignColors.greyPrimary
  final Color borderColor;

  /// The dropdown icon. Default = const Icon(Icons.arrow_drop_down)
  final Icon dropDownIcon;

  /// The padding of the container inside. Default = const EdgeInsets.symmetric(horizontal: 20, vertical: 5)
  final EdgeInsets paddingDropDownContainer;

  /// The BoxDecoration of this dropdown widget
  final BoxDecoration? boxDecoration;

  CustomDropDown({Key? key,
    required this.values,
    this.defaultValue,
    this.elevationSize = 16,
    this.iconSize = 42,
    this.radiusDropdown = 4,
    this.borderColor = DesignColors.greyPrimary,
    this.paddingDropDownContainer = const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    this.boxDecoration,
    this.dropDownIcon = const Icon(Icons.arrow_drop_down)}) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

/// Description: the state for this current widget
class _CustomDropDownState extends State<CustomDropDown> {

  /// The default value to display
  String? _dropdownValue;

  /// The default value for box decoration
  final BoxDecoration _boxDecoration = BoxDecoration(color: Colors.white, border: Border.all(color: DesignColors.greyPrimary), borderRadius: BorderRadius.circular(4));


  /// Description: Changing the value selected for this dropdown widget
  /// @Params
  ///   - String? value: the value to replace inside the selected value
  void _onChangeValue (String? value){
    setState(() {
      this._dropdownValue = value!;
    });
  }

  TextStyle dropDownTextStyle = TextDesign.defaultNormalTextStyle.apply(fontSizeDelta: 5);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: widget.boxDecoration ?? this._boxDecoration,
        child: Padding(
          padding: widget.paddingDropDownContainer,
          child: DropdownButton<String>(
            value: this._dropdownValue ?? widget.values.first,
            icon: widget.dropDownIcon,
            iconSize: widget.iconSize,
            underline: SizedBox(),
            elevation: widget.elevationSize,
            isExpanded: true,
            onChanged: (String? value) => this._onChangeValue(value),
            items: widget.values.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        )
    );
  }
}
