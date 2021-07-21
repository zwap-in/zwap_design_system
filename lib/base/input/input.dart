/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The custom input style in base of the current type
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

/// Custom input state
class BaseInputState extends ChangeNotifier{

  /// Bool validator to handle if the user is writing
  bool isWriting = false;

  /// Bool validator to check if the user wrote everything correctly
  bool isValid = false;

  TextEditingController controller;

  /// Handle the validation with a custom callBack
  final Function(dynamic value) handleValidation;

  BaseInputState({required this.handleValidation, required this.controller});

  /// Changing the state inside when user starts to write
  void changeState(bool value){
    if (!isWriting){
      isWriting = true;
      Future.delayed(Duration(seconds: 2)).whenComplete((){
        isWriting = false;
      });
    }
  }

  /// Validate the user's input
  void validateCallBack(dynamic value){
    this.isValid = this.handleValidation(value);
    notifyListeners();
  }

}


/// Custom widget to rendering custom input
class BaseInput extends StatelessWidget {

  /// The placeholder text to show in the input text
  final String placeholderText;

  /// The callback function on change value on the input text
  final Function(dynamic value) changeValue;

  /// The custom input type
  final InputType inputType;

  /// The max lines to rendering in the input text multi lines
  final int? maxLines;

  /// Boolean flag to show or not the validation icon
  final bool hasValidatorIcon;

  /// The callback function to validate the data in input
  final bool Function(dynamic value)? validateValue;

  /// The button text inside
  final String? buttonText;

  /// Custom function callBack to handle click on custom input with type == InputButton
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

  /// It retrieves the input style
  TextStyle _getTextInputStyle(){
    return TextStyle(
      fontFamily: "",
      fontSize: 13,
      color: DesignColors.blackPrimary
    );
  }

  /// It retrieves the suffix icon
  Widget? _getSuffixIcon(BaseInputState provider){
    if(provider.isWriting && !provider.isValid){
      return SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(),
      );
    }
    if(provider.isValid){
      return Icon(
        Icons.done,
        color: DesignColors.greenPrimary,
        size: 15,
      );
    }
    return null;
  }


  /// The input field decoration for the search input
  InputDecoration _searchInputFieldDecoration(BaseInputState provider){
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DesignColors.greyPrimary, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: DesignColors.greyPrimary, width: 1.0),
      ),
      prefixIcon: Icon(Icons.search, size: 21),
      suffix: this._getSuffixIcon(provider)
    );
  }


  /// The field decoration for any text field
  InputDecoration _getTextFieldDecoration(String hintText, BaseInputState provider){
    return new InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderRadius: this.inputType == InputType.inputButton ? BorderRadius.circular(ConstantsValue.radiusValue) : const BorderRadius.all(Radius.circular(4.0)),
        borderSide: BorderSide(color: DesignColors.greyPrimary, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: this.inputType == InputType.inputButton ? BorderRadius.circular(ConstantsValue.radiusValue) : const BorderRadius.all(Radius.circular(4.0)),
        borderSide: BorderSide(color: DesignColors.greyPrimary,  width: 1.0),
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: DesignColors.greyPrimary
      ),
      suffix: this.inputType == InputType.inputButton ? null : this._getSuffixIcon(provider)
    );
  }

  /// It retrieves the input type in base of the params
  TextInputType _getInputType(){
    switch(this.inputType){
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

  /// It retrieves the text field inside this custom input field
  Widget _getTextInputField(BaseInputState provider){
    return TextField(
        controller: provider.controller,
        keyboardType: this._getInputType(),
        maxLines: this.maxLines ?? 1,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: DesignColors.bluePrimary,
        obscureText: this.inputType == InputType.inputPassword,
        textAlign: TextAlign.start,
        style: this._getTextInputStyle(),
        onEditingComplete: () => provider.changeState(false),
        onChanged: (dynamic value) => {
          provider.validateCallBack(value),
          provider.changeState(true),
          this.changeValue(value)
        },
        decoration: this.inputType == InputType.inputSearch ? this._searchInputFieldDecoration(provider) :
        this._getTextFieldDecoration(this.placeholderText, provider)
    );
  }

  /// It retrieves the button inside this custom input
  Widget _getBaseButton(){
    return Container(
      transform: Matrix4.translationValues(-5.0, 0.0, 0.0),
      child: BaseButton(
          buttonText: this.buttonText!,
          buttonTypeStyle: ButtonTypeStyle.baseInputButton,
          onPressedCallback: () => this.baseInputButtonCallBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Consumer<BaseInputState>(
            builder: (builder, provider, child){
              return Flexible(child: this._getTextInputField(provider));
            }
          ),
          this.inputType == InputType.inputButton ?
          Flexible(child: SizedBox(
            child: this._getBaseButton(),
            height: 48,
          )) : Container()
        ],
      ),
    );
  }
}
