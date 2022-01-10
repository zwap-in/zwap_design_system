/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/atoms.dart';

import 'picker/zwapDatePicker.dart';

/// The provider state to handle this component
class ZwapDateInput extends StatefulWidget{

  /// The placeholder text inside this input widget
  final String placeholderText;

  /// The text editing controller
  final TextEditingController textEditingController;

  /// The title text for this input date picker widget
  final String? titleText;

  ZwapDateInput({Key? key,
    required this.placeholderText,
    required this.textEditingController,
    this.titleText
  }): super(key: key);

  _ZwapDateInputState createState() => _ZwapDateInputState();
}

/// Component to handle the input date picker
class _ZwapDateInputState extends State<ZwapDateInput>{

  /// The focus node for the input field
  final FocusNode _focusNode = FocusNode();

  /// The layer linked to the input field
  final LayerLink _layerLink = LayerLink();

  /// The overlay on the input field
  late OverlayEntry _overlayEntry;

  /// It opens or close the input widget
  void openClose(int? year){
    this._focusNode.unfocus();
    this._overlayEntry.remove();
    setState(() {
      if(year != null){
        widget.textEditingController.value = TextEditingValue(text: year.toString());
      }
    });
  }

  @override
  void initState() {
    this._focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry(false);
        Overlay.of(context)?.insert(this._overlayEntry);

      } else {
        if(!this._overlayEntry.mounted){
          this._overlayEntry.remove();
        }
      }
    });
    super.initState();
  }


  /// It creates the overlay menu
  OverlayEntry _createOverlayEntry(bool isLoading) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    return OverlayEntry(
        builder: (context) => Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: this._layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
                elevation: 4.0,
                child: SizedBox(
                  height: 350,
                  child: ZwapDatePicker(
                    minYear: 1900,
                    onSelectYear: (int year) => this.openClose(year),
                    maxYear: DateTime.now().year,
                  ),
                )
            ),
          ),
        )
    );
  }

  Widget build(BuildContext context){
    return CompositedTransformTarget(
      link: this._layerLink,
      child: ZwapInput(
        controller: widget.textEditingController,
        inputName: widget.titleText,
        placeholder: widget.placeholderText,
        enableInput: true,
        focusNode: this._focusNode,
        suffixIcon: Icons.lock_clock,
      ),
    );
  }

}