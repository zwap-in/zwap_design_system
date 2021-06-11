/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/buttons/baseButton/baseButton.dart';
import 'package:zwap_design_system/buttons/styles.dart';

/// The custom date picker
class CustomDatePicker extends StatefulWidget {

  CustomDatePicker({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {

  /// The selected date inside the date picker with init state as datetime now
  DateTime _selectDate = DateTime.now();

  /// The continue button style instance
  final ContinueButtonStyles _continueButtonStyles = ContinueButtonStyles();

  /// Choosing the date inside the date picker
  Future<void> _chooseDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: this._selectDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100)
    );
    if (picked != null && picked != this._selectDate)
      setState(() {
        this._selectDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return BaseButton(
        buttonText: "",
        buttonTextStyle: this._continueButtonStyles.getTextStyle(),
        onPressedCallback: () => this._chooseDate(context),
        buttonStyle: this._continueButtonStyles.getButtonStyle()
    );
  }

}