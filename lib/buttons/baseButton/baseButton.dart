/// IMPORTING THE THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/icons/customIcon.dart';
import 'package:zwap_design_system/texts/baseText/baseText.dart';

/// This is the base structure for each button
class BaseButton extends StatelessWidget{

  /// The text displayed on the button
  final String buttonText;

  /// The style of the text displayed on the button
  final TextStyle buttonTextStyle;

  /// The callback function triggered on click on the button
  final Function() onPressedCallback;

  /// The custom style of the button
  final ButtonStyle buttonStyle;

  /// The optional image inside the button as an icon
  final String? imagePath;

  /// Is the imagePath an internal asset?. Default = false
  final bool isInternalAsset;

  /// The padding inside the button elements. Default = const EdgeInsets.all(8)
  final EdgeInsets paddingButton;

  /// The order to display the icon and text inside the button. Default = 0
  final int orderKind;

  /// The flex size of the icon container. Default = 0
  final int flexIcon;

  /// The flex size of the text container. Default = 0
  final int flexText;

  /// The text align inside this button. Default = TextAlign.start
  final TextAlign textAlign;

  /// The image width. Default = 20
  final double imageWidth;

  /// The image height. Default = 20
  final double imageHeight;

  BaseButton({Key? key,
      required this.buttonText,
      required this.buttonTextStyle,
      required this.onPressedCallback,
      required this.buttonStyle,
      this.imagePath,
      this.isInternalAsset = false,
      this.orderKind = 0,
      this.flexIcon = 0,
      this.flexText = 0,
      this.imageWidth = 20,
      this.imageHeight = 20,
      this.paddingButton = const EdgeInsets.all(8),
      this.textAlign = TextAlign.start,
      }) : super(key: key);

  /// The default paddingRight size between icon and text
  final double paddingRight = 10.0;

  /// It returns the icon inside this button
  Widget iconWidget(){
    return imagePath != null?
    Flexible(
      child: CustomIcon(
        imageWidth: this.imageWidth,
        imageHeight: this.imageHeight,
        assetPathUrl: this.imagePath!,
        isInternal: this.isInternalAsset,
        paddingContainer: EdgeInsets.zero,
      ),
      flex: this.flexIcon,
    ) : Container();
  }

  /// It returns the text inside this button
  Widget textWidget(){
    return Flexible(
      child: BaseText(
        text: this.buttonText,
        textStyle: this.buttonTextStyle,
        textAlign: this.textAlign,
        paddingContainer: this.orderKind == 0 ? EdgeInsets.only(left: this.imagePath != null ? this.paddingRight : 0) :
        EdgeInsets.only(right: this.imagePath != null ? this.paddingRight : 0),
      ),
      flex: this.flexText,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        child: TextButton(
          child: Padding(
            padding: this.paddingButton,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: this.orderKind == 0 ? [this.iconWidget(), this.textWidget()] : [this.textWidget(), this.iconWidget()],
            ),
          ),
          style: this.buttonStyle,
          onPressed: () => {
            this.onPressedCallback()
          },
        ),
    );
  }

}