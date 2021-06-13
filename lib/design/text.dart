/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// IMPORTING LOCAL PACKAGES
import 'colors.dart';

/// Define the standard design style for any text
class TextDesign{

  /// This is the classic text style for any bold text
  static final TextStyle defaultMediumTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontFamily: "SFUITextMedium",
      fontSize: 0,
  );

  /// This is the classic text style for any normal text
  static final TextStyle defaultNormalTextStyle = TextStyle(
      fontFamily: "SFUITextRegular",
      fontWeight: FontWeight.w500,
      fontSize: 0
  );

  /// This is the classic text style for any bold text
  static final TextStyle defaultBoldTextStyle = TextStyle(
      fontFamily: "SFUITextBold",
      fontWeight: FontWeight.w500,
      fontSize: 0
  );

  /// This is the classic text style for any normal text
  static final TextStyle defaultSemiBoldTextStyle = TextStyle(
      fontFamily: "SFUITextSemiBold",
      fontWeight: FontWeight.w500,
      fontSize: 0
  );


  /// The text style for the selected button text
  static TextStyle selectedButtonText = TextDesign.defaultBoldTextStyle.apply(
      fontSizeDelta: 18,
      color: DesignColors.bluePrimary
  );

  /// The text style for the unSelected button text
  static TextStyle unSelectedButtonText = TextDesign.defaultBoldTextStyle.apply(
      fontSizeDelta: 18,
      color: DesignColors.greyPrimary
  );

  /// The text style for the default black title text
  static TextStyle defaultBlackTextTitle = TextDesign.defaultBoldTextStyle.apply(
    fontSizeDelta: 18,
    color: DesignColors.blackPrimary
  );

  /// The text style for any default black text
  static TextStyle defaultTextBlack = TextDesign.defaultNormalTextStyle.apply(
    fontSizeDelta: 15,
    color: DesignColors.blackPrimary
  );

  /// The text style for any default pinky text style
  static TextStyle defaultPinkTitleText = TextDesign.defaultBoldTextStyle.apply(
    fontSizeDelta: 18,
    color: DesignColors.pinkyPrimary
  );

  /// The text style for any default grey text
  static TextStyle greyTextStyle = TextDesign.defaultNormalTextStyle.apply(
    color: DesignColors.greyPrimary,
    fontSizeDelta: 15
  );

  /// The text style for the blue light color
  static TextStyle blueLightTextStyle = TextDesign.defaultNormalTextStyle.apply(
    fontSizeDelta: 15,
    color: DesignColors.blueTextCard,
  );

  /// The text style for any white text
  static TextStyle defaultWhiteTextStyle = TextDesign.defaultNormalTextStyle.apply(
    fontSizeDelta: 15,
    color: Colors.white
  );


}