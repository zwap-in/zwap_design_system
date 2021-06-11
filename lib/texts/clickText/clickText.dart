/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';

/// IMPORTING LOCAL PACKAGE
import 'package:zwap_design_system/texts/baseText/baseText.dart';
import 'package:zwap_design_system/design/colors.dart';

/// Custom widget to show a text with a click gesture
class ClickText extends StatelessWidget{

  /// The callBack function to handle click on text
  final Function() clickFunction;

  /// The text inside this widget
  final BaseText baseText;

  ClickText({
    Key? key,
    required this.clickFunction,
    required this.baseText,
  }): super(key: key);

  /// Retrieve the base text to display inside this component with the correct style
  BaseText _getBaseText(){
    TextStyle clickTextStyle = this.baseText.textStyle.apply(color: DesignColors.googleBlue);
    return BaseText(
        text: this.baseText.text,
        textStyle: clickTextStyle,
        alignment: this.baseText.alignment,
        textAlign: this.baseText.textAlign,
        paddingContainer: this.baseText.paddingContainer,
      );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => this.clickFunction(),
      child: this._getBaseText(),
    );
  }


}