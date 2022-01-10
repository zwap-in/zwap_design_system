/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/typography/zwapTypography.dart';
import 'package:zwap_design_system/atoms/text/text.dart';

/// custom dropdown widget to select some element from a list
class ZwapSelect extends StatefulWidget {

  /// The custom values to display inside this widget
  final List<String> values;

  /// It handles the selected value with a callBack function
  final Function(String key) callBackFunction;

  /// The default value of this dropdown
  final String? defaultValue;

  ZwapSelect({Key? key,
    required this.values,
    required this.callBackFunction,
    this.defaultValue,

  }) : super(key: key);

  _ZwapSelectState createState() => _ZwapSelectState();

}

/// Description: the state for this current widget
class _ZwapSelectState extends State<ZwapSelect> {

  /// The value to display
  String? _dropdownValue;

  /// Is this select opened
  bool _isOpen = false;

  /// Is this select hoovered
  bool _isHover = false;

  @override
  void initState(){
    super.initState();
    this._dropdownValue = widget.defaultValue;
  }

  /// Selecting new value from the dropdown widget
  void onChangeValue(String? value) {
    if(value != null){
      widget.callBackFunction(value);
    }
    setState(() {
      this._dropdownValue = value!;
      this._isOpen = false;
    });
  }

  /// It opens the dropdown
  void openDropDown() {
    setState(() {
      this._isOpen = true;
    });
  }

  /// It hoovers the dropdown button
  void hoverButton(bool value) {
    setState(() {
      this._isHover = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (bool value) => this.hoverButton(value),
      onTap: () => this.openDropDown(),
      child: Container(
          decoration: BoxDecoration(
              color: ZwapColors.shades0,
              border: Border.all(
                  color: this._isHover
                      ? ZwapColors.primary300
                      : ZwapColors.neutral300),
              borderRadius: BorderRadius.circular(4)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: 150,
              child: DropdownButton<String>(
                value: this._dropdownValue ?? widget.values.first,
                iconSize: 25,
                focusColor: ZwapColors.neutral300,
                icon: Icon(
                  !this._isOpen
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_up_rounded,
                  color: Color(0xFF323232),
                ),
                underline: SizedBox(),
                elevation: 5,
                isExpanded: true,
                onChanged: (String? value) => this.onChangeValue(value),
                items:
                widget.values.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: ZwapText(
                            text: value,
                            zwapTextType: ZwapTextType.bodyRegular,
                            textColor: ZwapColors.shades100,
                          ),
                          fit: FlexFit.tight,
                          flex: 0,
                        ),
                        Flexible(
                          child: Container(),
                          fit: FlexFit.tight,
                          flex: 0,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          )),
    );
  }
}
