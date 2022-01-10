/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zwap_utils/zwap_utils.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/atoms/constants/zwapConstants.dart';
import 'package:zwap_design_system/atoms/colors/zwapColors.dart';
import 'package:zwap_design_system/atoms/typography/zwapTypography.dart';
import 'package:zwap_design_system/atoms/text/text.dart';

/// The possibles input statuses
enum ZwapInputStatus {
  defaultStatus,
  errorStatus,
  successStatus,
  disabled,
  disabledFilled,
}

/// Custom component for a standard input with a predefined Zwap style
class ZwapInput extends StatefulWidget {

  /// Text controller for handling the value from external of this component
  final TextEditingController controller;

  /// The input type for this custom component
  final TextInputType textInputType;

  /// The max lines to rendering in the input text multi lines
  final int maxLines;

  /// The input status
  final ZwapInputStatus zwapInputStatus;

  /// Enable input or not
  final bool enableInput;

  /// The input name to display inside the component as a placeholder or a label text
  final String? inputName;

  /// The placeholder for this input
  final String? placeholder;

  /// Handle the validation with a custom callBack
  final TupleType<bool, String> Function(dynamic value)? handleValidation;

  /// It handles the changes inside this input text field
  final Function(String newValue)? onChanged;

  /// Custom internal padding for this input
  final EdgeInsets? internalPadding;

  /// Optionally prefix icon
  final IconData? prefixIcon;

  /// Optionally suffix icon
  final IconData? suffixIcon;

  /// The on key callBack function
  final Function(String value)? keyCallBackFunction;

  /// The optional autofill hints inside the input text
  final String? autofillHints;

  /// The hint text to display bottom the input
  final String? hintText;

  final FocusNode? focusNode;

  final String? prefixText;

  final bool isErrorHint;

  ZwapInput({Key? key,
    required this.controller,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
    this.zwapInputStatus = ZwapInputStatus.defaultStatus,
    this.enableInput = true,
    this.internalPadding,
    this.onChanged,
    this.inputName,
    this.placeholder,
    this.handleValidation,
    this.prefixIcon,
    this.suffixIcon,
    this.keyCallBackFunction,
    this.hintText,
    this.autofillHints,
    this.focusNode,
    this.prefixText,
    this.isErrorHint = true
  }) : super(key: key);

  _ZwapInputState createState() => _ZwapInputState(status: this.zwapInputStatus, controller: this.controller);
}

/// It handles the input state
class _ZwapInputState extends State<ZwapInput> {

  /// The input status type
  late ZwapInputStatus status;

  /// The input value controller
  late TextEditingController controller;

  /// The error message
  String _errorMessage = "";

  /// It handles the controller callBack value
  void _handleController(){
    if(widget.handleValidation != null){
      TupleType<bool, String> validation = widget.handleValidation!(this.controller.text);
      if(!validation.a){
        this._changeInputStatus(ZwapInputStatus.errorStatus, validation.b);
      }
      else{
        this._changeInputStatus(ZwapInputStatus.successStatus, "");
      }
    }
  }

  _ZwapInputState({required this.status, required this.controller});

  /// It changes the input status
  void _changeInputStatus(ZwapInputStatus newStatus, String? errorMessage) {
    setState(() {
      this.status = widget.zwapInputStatus;
      this._errorMessage = errorMessage != null ? errorMessage : "";
    });
  }

  /// It retrieves the borderColor in base of the current status
  InputBorder _getInputBorder(ZwapInputStatus status) {
    OutlineInputBorder inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.buttonRadius)),
        borderSide: BorderSide(
            color: ZwapColors.neutral300,
            width: 1,
            style: BorderStyle.solid
        )
    );
    return inputBorder;
  }

  /// It retrieves the borderColor in base of the current status
  InputBorder _getFocusedBorder(ZwapInputStatus status) {
    OutlineInputBorder inputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(ZwapRadius.buttonRadius)),
        borderSide: BorderSide(
            color: ZwapColors.primary300,
            width: 1,
            style: BorderStyle.solid
        )
    );
    return inputBorder;
  }

  /// The field decoration for any text field
  InputDecoration _getTextFieldDecoration() {
    return new InputDecoration(
        enabledBorder: this._getInputBorder(this.status),
        focusedBorder: this._getFocusedBorder(status),
        contentPadding: widget.internalPadding,
        prefixText: widget.prefixText,
        hoverColor: ZwapColors.neutral300,
        hintText: widget.placeholder,
        hintStyle: getTextStyle(ZwapTextType.bodyRegular).apply(color: ZwapColors.neutral400),
        prefixIcon: widget.prefixIcon != null ? Icon(
          widget.prefixIcon,
          color: ZwapColors.neutral400,
          size: 24,
        ) : null,
        suffixIcon: widget.suffixIcon != null ? Icon(
          widget.suffixIcon,
          color: ZwapColors.neutral700,
          size: 24,
        ): null
    );
  }

  /// It gets the input field
  Widget _getInputWidget(){
    return TextField(
        controller: this.controller,
        scrollPadding: EdgeInsets.zero,
        enabled: widget.enableInput,
        keyboardType: widget.textInputType,
        maxLines: widget.maxLines,
        autofillHints: widget.autofillHints != null ? [widget.autofillHints!] : null,
        onChanged: widget.onChanged != null ? (String newValue) => widget.onChanged!(newValue) : null,
        onSubmitted: widget.keyCallBackFunction,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: ZwapColors.shades100,
        obscureText: widget.textInputType == TextInputType.visiblePassword,
        textAlign: TextAlign.start,
        focusNode: widget.focusNode,
        style: getTextStyle(ZwapTextType.bodyRegular).apply(color: ZwapColors.neutral700),
        decoration: this._getTextFieldDecoration()
    );
  }

  /// It gets the label for this input
  Widget _getLabelInput(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 2.5),
          child: ZwapText(
            text: widget.inputName!,
            zwapTextType: ZwapTextType.bodySemiBold,
            textColor: ZwapColors.neutral600,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 2.5),
          child: this._getInputWidget(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: this._errorMessage != "" ? 2.5 : 0),
          child: widget.inputName != null ? this._getLabelInput(): this._getInputWidget(),
        ),
        widget.hintText != null ? Padding(
          padding: EdgeInsets.only(top: 2.5),
          child: ZwapText(
            textColor: widget.isErrorHint ? ZwapColors.error400 : ZwapColors.success400,
            zwapTextType: ZwapTextType.bodyRegular,
            text: widget.hintText!,
          ),
        ) : Container()
      ],
    );
  }
}
