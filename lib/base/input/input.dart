/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

enum InputType{
  inputText,
  inputNumber,
  inputSearch,
  inputArea,
  inputEmail,
  inputPassword,
  inputPhone,
  inputAddress,
  inputUrl,
  inputButton
}

class BaseInput extends StatefulWidget{

  /// The placeholder text to show in the input text
  final String placeholderText;

  /// The callback function on change value on the input text
  final Function(dynamic value) changeValue;

  /// The callback function to validate the data in input
  final bool Function(dynamic value) validateValue;

  /// The custom input type
  final InputType inputType;

  /// The max lines to rendering in the input text multi lines
  final int? maxLines;

  final String? buttonText;

  final bool hasValidatorIcon;

  final Function()? baseInputButtonCallBack;


  BaseInput({Key? key,
    required this.placeholderText,
    required this.changeValue,
    required this.inputType,
    required this.validateValue,
    this.maxLines,
    this.hasValidatorIcon = false,
    this.buttonText,
    this.baseInputButtonCallBack
  }) : super(key: key){
    if(this.inputType == InputType.inputButton){
      assert(this.buttonText != null, "Button text could not be null on input type == InputButton");
      assert(this.baseInputButtonCallBack != null , "Base input callback function could not be null on input type == InputButton ");
    }
    else{
      assert(this.buttonText == null, "Button text must be null on input type != InputButton");
      assert(this.baseInputButtonCallBack == null , "Base input callback function must be null on input type != InputButton ");
    }
  }

  _BaseInputState createState() => _BaseInputState();
}


/// Custom widget to rendering custom input
class _BaseInputState extends State<BaseInput> {

  bool _isWriting = false;
  bool _isValid = false;

  TextStyle _getTextInputStyle(){
    return TextStyle(
      fontFamily: "",
      fontSize: 13,
      color: DesignColors.blackPrimary
    );
  }

  Widget? _getSuffixIcon(){
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
        borderRadius: widget.inputType == InputType.inputButton ? BorderRadius.circular(ConstantsValue.radiusValue) : const BorderRadius.all(Radius.circular(4.0)),
        borderSide: BorderSide(color: DesignColors.greyPrimary, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: widget.inputType == InputType.inputButton ? BorderRadius.circular(ConstantsValue.radiusValue) : const BorderRadius.all(Radius.circular(4.0)),
        borderSide: BorderSide(color: DesignColors.greyPrimary,  width: 1.0),
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: DesignColors.greyPrimary
      ),
      suffix: widget.inputType == InputType.inputButton ? null : this._getSuffixIcon()
    );
  }

  TextInputType _getInputType(){
    switch(widget.inputType){
      case InputType.inputAddress:
        return TextInputType.streetAddress;
      case InputType.inputArea:
        return TextInputType.multiline;
      case InputType.inputNumber:
        return TextInputType.number;
      case InputType.inputText:
        return TextInputType.text;
      case InputType.inputSearch:
        return TextInputType.text;
      case InputType.inputEmail:
        return TextInputType.emailAddress;
      case InputType.inputPassword:
        return TextInputType.text;
      case InputType.inputPhone:
        return TextInputType.phone;
      case InputType.inputUrl:
        return TextInputType.url;
      case InputType.inputButton:
        return TextInputType.text;
    }
  }

  void _changeState(bool value){
    if (!_isWriting){
      _isWriting = true;
      setState((){});
      Future.delayed(Duration(seconds: 2)).whenComplete((){
        _isWriting = false;
        setState((){});
      });
    }
  }

  void _validateCallBack(dynamic value){
    if(!widget.validateValue(value)){
      setState(() {
        this._isValid = false;
      });
    }
    else{
      setState(() {
        this._isValid = true;
      });
    }
  }

  Widget _getTextInputField(){
    return TextField(
        keyboardType: this._getInputType(),
        maxLines: widget.maxLines ?? 1,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: DesignColors.bluePrimary,
        obscureText: widget.inputType == InputType.inputPassword,
        textAlign: TextAlign.start,
        style: this._getTextInputStyle(),
        onEditingComplete: () => this._changeState(false),
        onChanged: (dynamic value) => {
          this._validateCallBack(value),
          this._changeState(true),
          widget.changeValue(value)
        },
        decoration: widget.inputType == InputType.inputSearch ? this._searchInputFieldDecoration() : this._getTextFieldDecoration(widget.placeholderText)
    );
  }

  Widget _getBaseButton(){
    return Container(
      transform: Matrix4.translationValues(-5.0, 0.0, 0.0),
      child: BaseButton(
          buttonText: widget.buttonText!,
          buttonTypeStyle: ButtonTypeStyle.baseInputButton,
          onPressedCallback: () => widget.baseInputButtonCallBack,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(child: this._getTextInputField()),
          widget.inputType == InputType.inputButton ?
          Flexible(child: SizedBox(
            child: this._getBaseButton(),
            height: 48,
          )) : Container()
        ],
      ),
    );
  }
}
