/// IMPORTING THIRD PARTY PACKAGES
import 'dart:ui';

/// IMPORTING LOCAL PACKAGES
import '../colors/zwapColors.dart';

/// Static class to get an hover colors mapping
class ZwapHover {

  /// Static colors hover colors mapping
  static Map<Color, Color> get hoverColorsMapping => {
        ZwapColors.primary700: ZwapColors.primary800,
        ZwapColors.neutral50: ZwapColors.neutral200,
        ZwapColors.neutral100: ZwapColors.neutral300,
        ZwapColors.error50: ZwapColors.error200
  };
}
