/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

}