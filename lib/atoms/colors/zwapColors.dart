/// IMPORTING THIRD PARTY PACKAGES
import 'dart:ui';

import 'package:collection/collection.dart';

/// The zwap standard colors
class ZwapColors {
  static Color get neutral50 => Color(0xFFF9FAFC);

  static Color get neutral100 => Color(0xFFF1F5F9);

  static Color get neutral200 => Color(0xFFE2E8F0);

  static Color get neutral300 => Color(0xFFD1D8E1);

  static Color get neutral400 => Color(0xFF94A3B8);

  static Color get neutral500 => Color(0xFF64748B);

  static Color get neutral600 => Color(0xFF475569);

  static Color get neutral700 => Color(0xFF334155);

  static Color get neutral800 => Color(0xFF1E293B);

  static Color get neutral900 => Color(0xFF0F172A);

  static Color get primary50 => Color(0xFFF2F5FF);

  static Color get primary100 => Color(0xFFE6EBFF);

  static Color get primary200 => Color(0xFFC4CCFF);

  static Color get primary300 => Color(0xFF929BF7);

  static Color get primary400 => Color(0xFF7788FA);

  static Color get primary700 => Color(0xFF3E4FF7);

  static Color get primary800 => Color(0xFF0F1FFF);

  static Color get primary900 => Color(0xFF0004D3);

  static Color get secondary200 => Color(0xFFFDEBCD);

  static Color get secondary300 => Color(0xFFFDDBA2);

  static Color get secondary400 => Color(0xFFFDD38B);

  static Color get secondary700 => Color(0xFFFDCA73);

  static Color get secondary800 => Color(0xFFFDB438);

  static Color get success200 => Color(0xFFBDF5D5);

  static Color get success300 => Color(0xFF64E8BC);

  static Color get success400 => Color(0xFF04D1A5);

  static Color get success700 => Color(0xFF00B890);

  static Color get success800 => Color(0xFF006D4E);

  static Color get warning200 => Color(0xFFFFD67D);

  static Color get warning300 => Color(0xFFFFBE4D);

  static Color get warning400 => Color(0xFFFF7E0D);

  static Color get warning700 => Color(0xFFFF3047);

  static Color get warning800 => Color(0xFFB00014);

  static Color get error50 => Color(0xFFFFF2F4);

  static Color get error200 => Color(0xFFFFDBE0);

  static Color get error300 => Color(0xFFFF8F9E);

  static Color get error400 => Color(0xFFFF7385);

  static Color get error700 => Color(0xFFFF3047);

  static Color get error800 => Color(0xFFB52232);

  static Color get shades0 => Color(0xFFFFFFFF);

  static Color get shades100 => Color(0xFF000000);

  /// It retrieves a random color from this predefined list
  static Color getRandomColor() {
    List<Color> colors = [
      ZwapColors.secondary200,
      ZwapColors.primary200,
      ZwapColors.success200,
      ZwapColors.error200,
      ZwapColors.neutral200
    ];
    return colors.sample(1).first;
  }
}
