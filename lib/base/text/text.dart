/// IMPORTING THE THIRD PARTY LIBRARIES
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/base.dart';

/// The types of the text
enum BaseTextType{
  title,
  subTitle,
  normal,
  normalBold,
}

/// Component to show a base text
class BaseText extends StatelessWidget{

  /// The baseTextType to retrieve the current text style
  final List<BaseTextType> baseTextsType;

  /// The custom text to display
  final List<String> texts;

  /// The list of the click conditions on these texts
  final List<bool?>? hasClick;

  /// callBackClick just on BaseTextType.clickable
  final List<Function()?>? callBacksClick;

  /// The color of the texts
  final List<Color?>? textsColor;

  /// color on Hover elements
  final List<Color?>? hoverColors;

  /// The text alignment
  final Alignment textAlignment;

  BaseText({Key? key,
    required this.texts,
    required this.baseTextsType,
    this.callBacksClick,
    this.hasClick,
    this.textsColor,
    this.hoverColors,
    this.textAlignment = Alignment.topLeft
  }) : super(key: key){
    assert(this.texts.length != 0, "Texts list could not be null");
    assert(this.texts.length == this.baseTextsType.length, "Texts length must be equal to baseTextsType length");
    if(this.hasClick != null){
      assert(this.hasClick!.length <= this.texts.length, "The click text length must be equal to texts length");
    }
    if(this.callBacksClick != null){
      if(this.textsColor != null){
        assert(this.textsColor!.length <= this.texts.length, "The callBack clicks length must be equal to texts length");
      }
      for(int i = 0; i < this.callBacksClick!.length; i++){
        if(this.callBacksClick![i] != null){
          assert(this.hasClick![i]! == true, "Callback click must have the has click equal to true");
        }
        else{
          assert(this.hasClick![i] == null || this.hasClick![i]! == false, "callBack click null must have the has click equal to false or null");
        }
      }
    }
    if(this.textsColor != null){
      assert(this.textsColor!.length <= this.texts.length, "The texts color length must be equal to texts length");
    }
    if(this.hoverColors != null){
      assert(this.hoverColors!.length <= this.texts.length, "The texts hover color length must be equal to texts length");
    }
  }

  /// It retrieves the color in base of some conditions
  Color _retrieveTheColor(int i){
    if(this.textsColor != null){
      if(this.textsColor!.length != 0 && this.textsColor!.length >= i+1){
        return this.textsColor![i]!;
      }
    }
    else{
      if(this.hasClick != null && this.hasClick![i]!){
        return DesignColors.bluePrimary;
      }
    }
    return DesignColors.blackPrimary;
  }

  /// The title text style
  TextStyle _titleStyle(int i){
    return TextStyle(
        fontFamily: "SFUITextBold",
        fontSize: 21,
        color: this._retrieveTheColor(i)
    );
  }

  /// The subTitle text style
  TextStyle _subTitleStyle(int i){
    return TextStyle(
        fontFamily: "SFUITextMedium",
        fontSize: 18,
        color: this._retrieveTheColor(i),
    );
  }

  /// The normal text style
  TextStyle _normalTitleText(int i){
    return TextStyle(
        fontFamily: "SFUITextRegular",
        fontSize: 15,
        color: this._retrieveTheColor(i)
    );
  }

  TextStyle _normalBoldText(int i){
    return TextStyle(
      fontFamily: "SFUITextMedium",
      fontSize: 18,
      color: this._retrieveTheColor(i)
    );
  }

  /// The text element inside this widget
  TextSpan _text(int i){
    return TextSpan(
      text: this.texts[i],
      recognizer: (this.hasClick == null ||  this.hasClick![i]! == false) ? null : (TapGestureRecognizer()..onTap = () =>  this.callBacksClick![i]!()),
      style: this.baseTextsType[i] == BaseTextType.title ? this._titleStyle(i) :
      (this.baseTextsType[i] == BaseTextType.subTitle ? this._subTitleStyle(i) : (this.baseTextsType[i] == BaseTextType.normalBold ? this._normalBoldText(i) : this._normalTitleText(i))),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> _children = [];
    this.texts.asMap().keys.forEach((int index) {
      _children.add(
          this._text(index)
      );
    });
    return Align(
      alignment: this.textAlignment,
      child: RichText(
        textAlign: this.textAlignment == Alignment.center ? TextAlign.center : TextAlign.left,
        text: TextSpan(
            text: "",
            children: _children
        ),
      ),
    );
  }

}