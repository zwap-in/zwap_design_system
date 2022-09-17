/// IMPORTING THIRD PARTY PACKAGES
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// The zwap standard colors
class ZwapColors {
  static const Color neutral50 = Color(0xFFF9FAFC);

  static const Color neutral100 = Color(0xFFF1F5F9);

  static const Color neutral200 = Color(0xFFE2E8F0);

  static const Color neutral300 = Color(0xFFD1D8E1);

  static const Color neutral400 = Color(0xFF94A3B8);

  static const Color neutral500 = Color(0xFF64748B);

  static const Color neutral600 = Color(0xFF475569);

  static const Color neutral700 = Color(0xFF334155);

  static const Color neutral800 = Color(0xFF1E293B);

  static const Color neutral900 = Color(0xFF0F172A);

  static const Color primary50 = Color(0xFFF2F5FF);

  static const Color primary100 = Color(0xFFE6EBFF);

  static const Color primary200 = Color(0xFFC4CCFF);

  static const Color primary300 = Color(0xFF929BF7);

  static const Color primary400 = Color(0xFF7788FA);

  static const Color primary700 = Color(0xFF3E4FF7);

  static const Color primary800 = Color(0xFF0F1FFF);

  static const Color primary900 = Color(0xFF0004D3);

  static const Color secondary200 = Color(0xFFFDEBCD);

  static const Color secondary300 = Color(0xFFFDDBA2);

  static const Color secondary400 = Color(0xFFFDD38B);

  static const Color secondary700 = Color(0xFFFDCA73);

  static const Color secondary800 = Color(0xFFFDB438);

  static const Color success200 = Color(0xFFBDF5D5);

  static const Color success300 = Color(0xFF64E8BC);

  static const Color success400 = Color(0xFF04D1A5);

  static const Color success700 = Color(0xFF00B890);

  static const Color success800 = Color(0xFF006D4E);

  static const Color warning200 = Color(0xFFFFD67D);

  static const Color warning300 = Color(0xFFFFBE4D);

  static const Color warning400 = Color(0xFFFF7E0D);

  static const Color warning700 = Color(0xFFFF3047);

  static const Color warning800 = Color(0xFFB00014);

  static const Color error25 = Color(0xFFfff9f9);

  static const Color error50 = Color(0xFFFFF2F4);

  static const Color error100 = Color(0xFFffff2f4);

  static const Color error200 = Color(0xFFFFDBE0);

  static const Color error300 = Color(0xFFFF8F9E);

  static const Color error400 = Color(0xFFFF7385);

  static const Color error500 = Color(0xFFFF3047);

  static const Color error700 = Color(0xFFFF3047);

  static const Color error800 = Color(0xFFB52232);

  static const Color shades0 = Color(0xFFFFFFFF);

  static const Color shades100 = Color(0xFF000000);

  static const Color primary900Dark = Color(0xFF000152);

  static const Color primary700Dark = Color(0xFF020481);

  static const Color neutral300Dark = Color(0xFF8080A8);

  static const Color primary500 = Color(0xffe5ebff);

  static const Color primary600 = Color(0xffdfe3ff);

  static const Color transparent = Color(0x00000000);

  static const Color whiteTransparent = Color(0x000ffffff);

  static const Color text65 = Color(0xff595A8F);

  /// It retrieves a random color from this predefined list
  static Color getRandomColor({bool is200 = false}) {
    late List<Color> colors;
    if (is200) {
      colors = [
        ZwapColors.secondary200,
        ZwapColors.primary200,
        ZwapColors.success200,
        ZwapColors.error200,
        ZwapColors.neutral200,
      ];
    } else {
      colors = [
        ZwapColors.secondary800,
        ZwapColors.primary800,
        ZwapColors.success800,
        ZwapColors.error800,
        ZwapColors.neutral800,
      ];
    }
    return colors.sample(1).first;
  }

  static Color mappingRandomColor(Color randomColor) {
    Map<Color, Color> randomMapping = {
      ZwapColors.secondary200: ZwapColors.secondary800,
      ZwapColors.primary200: ZwapColors.primary800,
      ZwapColors.success200: ZwapColors.success800,
      ZwapColors.error200: ZwapColors.error800,
      ZwapColors.neutral200: ZwapColors.neutral800
    };
    return randomMapping[randomColor]!;
  }

  /// Return the [200] color for the [800]
  static Color getLigthColorFrom(Color randomColor) {
    Map<Color, Color> randomMapping = {
      ZwapColors.secondary200: ZwapColors.secondary800,
      ZwapColors.primary200: ZwapColors.primary800,
      ZwapColors.success200: ZwapColors.success800,
      ZwapColors.error200: ZwapColors.error800,
      ZwapColors.neutral200: ZwapColors.neutral800
    };
    return randomMapping[randomColor]!;
  }

  static const LinearGradient buttonGrad =
      LinearGradient(colors: [Color(0xffF8606B), Color(0xffF32478)], begin: Alignment.topLeft, end: Alignment.bottomRight);

  static const LinearGradient buttonGradHover = LinearGradient(
      colors: [Color.fromARGB(255, 243, 76, 87), Color.fromARGB(255, 236, 22, 108)], begin: Alignment.topLeft, end: Alignment.bottomCenter);
}
