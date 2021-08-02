/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zwap_design_system/base/buttons/buttons.dart';
/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/theme/theme.dart';

/// The custom input style in base of the current type
enum ZwapInputType{
  inputText,
  inputNumber,
  inputSearch,
  inputArea,
  inputEmail,
  inputPassword,
  inputPhone,
  inputAddress,
  inputUrl,
  inputButton,
}

/// Custom input state
class ZwapInput extends StatefulWidget{
  
  /// The placeholder text to show in the input text
  final String placeholderText;

  /// The custom input type
  final ZwapInputType inputType;

  /// Text controller for handling the value inside without a provider
  final TextEditingController controller;

  /// Boolean flag to show or not the validation icon
  final bool hasValidatorIcon;

  /// The max lines to rendering in the input text multi lines
  final int? maxLines;

  /// The button text inside
  final String? buttonText;

  /// Custom function callBack to handle click on custom input with type == InputButton
  final Function()? baseInputButtonCallBack;

  /// Handle the validation with a custom callBack
  final Function(dynamic value)? handleValidation;

  final FocusNode? focusNode;


  ZwapInput({Key? key,
    required this.placeholderText,
    required this.inputType,
    required this.controller,
    this.hasValidatorIcon = false,
    this.maxLines,
    this.buttonText,
    this.baseInputButtonCallBack,
    this.handleValidation,
    this.focusNode
  }) : super(key: key){
    if(this.inputType == ZwapInputType.inputButton){
      assert(this.buttonText != null, "Button text could not be null on input type == InputButton");
      assert(this.baseInputButtonCallBack != null , "Base input callback function could not be null on input type == InputButton ");
    }
    else{
      assert(this.buttonText == null, "Button text must be null on input type != InputButton");
      assert(this.baseInputButtonCallBack == null , "Base input callback function must be null on input type != InputButton ");
    }
  }
  
  _ZwapInputState createState() => _ZwapInputState();

}


/// Custom widget to rendering custom input
class _ZwapInputState extends State<ZwapInput> {

  /// Bool validator to handle if the user is writing
  bool _isWriting = false;

  /// Bool validator to check if the user wrote everything correctly
  bool _isValid = false;
  
  /// It retrieves the input style
  TextStyle _getTextInputStyle(){
    return TextStyle(
      fontFamily: "",
      fontSize: 13,
      color: DesignColors.blackPrimary
    );
  }

  /// Changing the state inside when user starts to write
  void changeState(bool value){
    if (!_isWriting){
      setState(() {
        this._isWriting = true;
        Future.delayed(Duration(seconds: 2)).whenComplete((){
          this._isWriting = false;
        });
      });
    }
  }

  /// Validate the user's input
  void validateCallBack(dynamic value){
    if(widget.handleValidation != null){
      setState(() {
        this._isValid = widget.handleValidation!(value);
      });
    }
  }


  /// It retrieves the suffix icon
  Widget? _getSuffixIcon(){
    if(widget.hasValidatorIcon){
      if(this._isWriting && !this._isValid){
        return SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(),
        );
      }
      if(this._isValid){
        return Icon(
          Icons.done,
          color: DesignColors.greenPrimary,
          size: 15,
        );
      }
    }
    return null;
  }


  /// The input field decoration for the search input
  InputDecoration _searchInputFieldDecoration(){
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DesignColors.greyPrimary, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DesignColors.greyPrimary, width: 1.0),
      ),
      prefixIcon: Icon(Icons.search, size: 21),
      suffix: this._getSuffixIcon()
    );
  }


  /// The field decoration for any text field
  InputDecoration _getTextFieldDecoration(String hintText){
    return new InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderRadius: widget.inputType == ZwapInputType.inputButton ? BorderRadius.circular(ConstantsValue.radiusValue) : const BorderRadius.all(Radius.circular(4.0)),
        borderSide: BorderSide(color: DesignColors.greyPrimary, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: widget.inputType == ZwapInputType.inputButton ? BorderRadius.circular(ConstantsValue.radiusValue) : const BorderRadius.all(Radius.circular(4.0)),
        borderSide: BorderSide(color: DesignColors.greyPrimary,  width: 1.0),
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: DesignColors.greyPrimary
      ),
      suffix: widget.inputType == ZwapInputType.inputButton ? null : this._getSuffixIcon()
    );
  }

  /// It retrieves the input type in base of the params
  TextInputType _getInputType(){
    switch(widget.inputType){
      case ZwapInputType.inputAddress:
        return TextInputType.streetAddress;
      case ZwapInputType.inputArea:
        return TextInputType.multiline;
      case ZwapInputType.inputNumber:
        return TextInputType.number;
      case ZwapInputType.inputText:
        return TextInputType.text;
      case ZwapInputType.inputSearch:
        return TextInputType.text;
      case ZwapInputType.inputEmail:
        return TextInputType.emailAddress;
      case ZwapInputType.inputPassword:
        return TextInputType.text;
      case ZwapInputType.inputPhone:
        return TextInputType.phone;
      case ZwapInputType.inputUrl:
        return TextInputType.url;
      case ZwapInputType.inputButton:
        return TextInputType.text;
    }
  }

  /// It retrieves the text field inside this custom input field
  Widget _getTextInputField(){
    return TextField(
        controller: widget.controller,
        keyboardType: this._getInputType(),
        maxLines: widget.maxLines ?? 1,
        focusNode: widget.focusNode,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: DesignColors.bluePrimary,
        obscureText: widget.inputType == ZwapInputType.inputPassword,
        textAlign: TextAlign.start,
        style: this._getTextInputStyle(),
        onEditingComplete: () => this.changeState(false),
        onChanged: (dynamic value) => {
          this.validateCallBack(value),
          this.changeState(true),
        },
        decoration: widget.inputType == ZwapInputType.inputSearch ? this._searchInputFieldDecoration() :
        this._getTextFieldDecoration(widget.placeholderText)
    );
  }

  /// It retrieves the button inside this custom input
  Widget _getBaseButton(){
    return Container(
      transform: Matrix4.translationValues(-5.0, 0.0, 0.0),
      child: ZwapButton(
          buttonText: widget.buttonText!,
          buttonTypeStyle: ZwapButtonType.baseInputButton,
          onPressedCallback: () => widget.baseInputButtonCallBack,
      ),
    );
  }

  Widget buttonInput(){
    return Row(
      children: [
        Flexible(
            child: this._getTextInputField()
        ),
        Flexible(
            child: SizedBox(
              child: this._getBaseButton(),
              height: 48,
          )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.inputType == ZwapInputType.inputButton ? this.buttonInput() : this._getTextInputField(),
    );
  }
}
