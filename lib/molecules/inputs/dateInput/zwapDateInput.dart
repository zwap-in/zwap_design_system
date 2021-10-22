/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import '../classicInput/zwapInput.dart';

import 'picker/zwapDatePicker.dart';

/// The provider state to handle this component
class ZwapDateInput extends StatefulWidget{

  /// The placeholder text inside this input widget
  final String placeholderText;

  /// The title text for this input date picker widget
  final String titleText;
  
  ZwapDateInput({Key? key,
    required this.placeholderText, 
    required this.titleText
  }): super(key: key);

  _ZwapDateInputState createState() => _ZwapDateInputState();
}

/// Component to handle the input date picker
class _ZwapDateInputState extends State<ZwapDateInput>{

  /// Is this input opened
  bool _isOpen = false;

  /// The text editing controller
  final TextEditingController textEditingController = TextEditingController();

  /// It opens or close the input widget
  void openClose(int? year){
    setState(() {
      if(year != null){
        this.textEditingController.value = TextEditingValue(text: year.toString());
      }
      this._isOpen = !this._isOpen;
    });
  }

  Widget build(BuildContext context){
    return Stack(
      children: [
        InkWell(
          onTap: () => this.openClose(null),
          child: ZwapInput(
            controller: this.textEditingController,
            inputName: widget.titleText,
            placeholder: widget.placeholderText,
            enableInput: false,
            suffixIcon: Icons.lock_clock,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: this._isOpen ? SizedBox(
            height: 400,
            child: ZwapDatePicker(
              minYear: 1900,
              onSelectYear: (int year) => this.openClose(year),
              maxYear: DateTime.now().year,
            ),
          ) : Container(),
        )
      ],
    );
  }

}